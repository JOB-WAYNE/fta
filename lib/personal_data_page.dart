import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

import 'get_started_page.dart';
import 'home_page.dart';

// ================= MODEL =================
class Denomination {
  final int id;
  final String name;

  Denomination({required this.id, required this.name});

  factory Denomination.fromJson(Map<String, dynamic> json) {
    return Denomination(
      id: json["id"],
      name: json["name"],
    );
  }
}

// ===========================================================
//                      PERSONAL DATA PAGE
// ===========================================================
class PersonalDataPage extends StatefulWidget {
  const PersonalDataPage({super.key});

  @override
  State<PersonalDataPage> createState() => _PersonalDataPageState();
}

class _PersonalDataPageState extends State<PersonalDataPage> {
  final _formKey = GlobalKey<FormState>();

  String? memberType;
  String? gender;
  bool phoneOwner = false;

  Denomination? selectedDenomination;
  List<Denomination> denominations = [];

  final Uri _privacyPolicyUrl = Uri.parse("");

  static const Color maroon = Color(0xFF800000);
  static const Color greenBlue = Color(0xFF008080);

  @override
  void initState() {
    super.initState();
    fetchDenominations();
  }

  // ================= FETCH DENOMINATIONS =================
  Future<void> fetchDenominations() async {
    try {
      final response = await http.get(
        Uri.parse("https://ftsadmin.lakeatts.co.ke/fts/denominations/all"),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          denominations = data.map((e) => Denomination.fromJson(e)).toList();
          selectedDenomination = null;
        });
      } else {
        debugPrint("Failed to fetch denominations. Status: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Denomination fetch error: $e");
    }
  }

  Future<void> _launchPrivacyPolicy() async {
    if (!await launchUrl(_privacyPolicyUrl, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $_privacyPolicyUrl');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, // IMPORTANT
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text(
          'PERSONAL DATA',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            color: maroon,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: maroon),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => GetStartedPage()),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10),

              // ===== ICONS =====
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 55,
                    height: 55,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: maroon, width: 3),
                    ),
                    child: const Icon(Icons.person, size: 30, color: maroon),
                  ),
                  //const SizedBox(width: 10),
                  //const Icon(Icons.assignment_rounded, size: 60, color: maroon),
                ],
              ),

              const SizedBox(height: 10),

              // ===== DENOMINATION DROPDOWN =====
              buildDenominationDropdown(),

              // ===== TEXT FIELDS =====
              buildTextField('Place of Worship'),
              buildTextField('Name'),
              buildTextField('Other Contacts (Optional)'),
              buildTextField('Email'),
              buildTextField('P.O.Box'),
              buildTextField('Residence'),

              const SizedBox(height: 10),

              // ===== MEMBER TYPE =====
              buildDropdown(
                'Member Type',
                memberType,
                ['Regular', 'Guest', 'Youth', 'Elder'],
                    (value) => setState(() => memberType = value),
              ),

              const SizedBox(height: 10),

              // ===== GENDER =====
              buildDropdown(
                'Gender',
                gender,
                ['Male', 'Female', 'Other'],
                    (value) => setState(() => gender = value),
              ),

              // ===== PHONE OWNER =====
              Transform.scale(
                scale: 0.9,
                child: CheckboxListTile(
                  value: phoneOwner,
                  title: const Text(
                    'Phone Owner',
                    style: TextStyle(
                      color: greenBlue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  controlAffinity: ListTileControlAffinity.leading,
                  activeColor: greenBlue,
                  onChanged: (bool? value) {
                    setState(() => phoneOwner = value ?? false);
                  },
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                'If you proceed you agree to the',
                style: TextStyle(
                    color: maroon, fontSize: 14, fontWeight: FontWeight.bold),
              ),

              GestureDetector(
                onTap: _launchPrivacyPolicy,
                child: const Text(
                  'Data Privacy Policy',
                  style: TextStyle(
                    color: greenBlue,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: 160,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => HomePage()),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: maroon,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    'Proceed',
                    style: TextStyle(
                        fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ===========================================================
  //                     UI WIDGET HELPERS
  // ===========================================================

  Widget buildTextField(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: SizedBox(
        width: 300,
        child: TextFormField(
          decoration: InputDecoration(
            labelText: label,
            labelStyle:
            const TextStyle(color: greenBlue, fontWeight: FontWeight.bold),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: greenBlue),
            ),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: greenBlue),
            ),
          ),
          cursorColor: greenBlue,
          style: const TextStyle(
            color: greenBlue,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget buildDropdown(String label, String? initialValue,
      List<String> items, ValueChanged<String?> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: SizedBox(
        width: 300,
        child: DropdownButtonFormField<String>(
          value: initialValue,
          menuMaxHeight: 300,
          dropdownColor: Colors.white,
          decoration: InputDecoration(
            labelText: label,
            labelStyle:
            const TextStyle(color: greenBlue, fontWeight: FontWeight.bold),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: greenBlue),
            ),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: greenBlue),
            ),
          ),
          items: items
              .map((item) => DropdownMenuItem(
            value: item,
            child: Text(
              item,
              style: const TextStyle(
                  color: greenBlue, fontWeight: FontWeight.bold),
            ),
          ))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  // ================= DENOMINATION DROPDOWN =================
  Widget buildDenominationDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: SizedBox(
        width: 300,
        child: DropdownButtonFormField<Denomination>(
          value: selectedDenomination,
          menuMaxHeight: 300,
          dropdownColor: Colors.white,
          icon: const Icon(Icons.arrow_drop_down, color: greenBlue, size: 30),
          decoration: const InputDecoration(
            labelText: "Denomination",
            labelStyle:
            TextStyle(color: greenBlue, fontWeight: FontWeight.bold),
            focusedBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: greenBlue)),
            enabledBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: greenBlue)),
          ),
          hint: denominations.isEmpty
              ? const Text(
            "Loading...",
            style:
            TextStyle(color: greenBlue, fontWeight: FontWeight.bold),
          )
              : null,
          items: denominations.isNotEmpty
              ? denominations
              .map((den) => DropdownMenuItem(
            value: den,
            child: Text(
              den.name,
              style: const TextStyle(
                color: greenBlue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ))
              .toList()
              : [
            const DropdownMenuItem(
              value: null,
              child: Text(
                "No denominations found",
                style: TextStyle(
                    color: Colors.grey, fontWeight: FontWeight.bold),
              ),
            )
          ],
          onChanged: denominations.isNotEmpty
              ? (value) {
            setState(() => selectedDenomination = value);
          }
              : null,
        ),
      ),
    );
  }
}

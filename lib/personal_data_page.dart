import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'get_started_page.dart';
import 'home_page.dart';

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

  final Uri _privacyPolicyUrl = Uri.parse("");

  Future<void> _launchPrivacyPolicy() async {
    if (!await launchUrl(_privacyPolicyUrl, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $_privacyPolicyUrl');
    }
  }

  // ✅ Colors
  static const Color maroon = Color(0xFF800000);
  static const Color greenBlue = Color(0xFF008080);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              MaterialPageRoute(builder: (context) => const GetStartedPage()),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10),

              // ✅ Person Icon with maroon edges, white inside
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white, // inside white
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: maroon,
                        width: 4, // maroon outline
                      ),
                    ),
                    child: const Icon(
                      Icons.person,
                      size: 50,
                      color: maroon,
                    ),
                  ),
                  const SizedBox(width: 15),
                  const Icon(
                    Icons.assignment_rounded,
                    size: 100,
                    color: maroon,
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // ✅ Input Fields
              buildTextField('Denomination'),
              buildTextField('Place of Worship'),
              buildTextField('Name'),
              buildTextField('Other Contacts (Optional)'),
              buildTextField('Email'),
              buildTextField('P.O.Box'),
              buildTextField('Residence'),

              // ✅ Member Type Dropdown
              DropdownButtonFormField<String>(
                value: memberType,
                decoration: const InputDecoration(
                  labelText: 'Member Type',
                  labelStyle: TextStyle(color: greenBlue, fontWeight: FontWeight.bold),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: greenBlue),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: greenBlue),
                  ),
                ),
                items: ['Regular', 'Guest', 'Youth', 'Elder']
                    .map((type) => DropdownMenuItem(
                  value: type,
                  child: Text(
                    type,
                    style: const TextStyle(color: greenBlue, fontWeight: FontWeight.bold),
                  ),
                ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    memberType = value;
                  });
                },
              ),

              const SizedBox(height: 12),

              // ✅ Gender Dropdown
              DropdownButtonFormField<String>(
                value: gender,
                decoration: const InputDecoration(
                  labelText: 'Gender',
                  labelStyle: TextStyle(color: greenBlue, fontWeight: FontWeight.bold),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: greenBlue),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: greenBlue),
                  ),
                ),
                items: ['Male', 'Female', 'Other']
                    .map((g) => DropdownMenuItem(
                  value: g,
                  child: Text(
                    g,
                    style: const TextStyle(color: greenBlue, fontWeight: FontWeight.bold),
                  ),
                ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    gender = value;
                  });
                },
              ),

              // ✅ Checkbox
              CheckboxListTile(
                value: phoneOwner,
                title: const Text(
                  'Phone Owner',
                  style: TextStyle(color: greenBlue, fontWeight: FontWeight.bold),
                ),
                controlAffinity: ListTileControlAffinity.leading,
                activeColor: greenBlue,
                onChanged: (bool? value) {
                  setState(() {
                    phoneOwner = value ?? false;
                  });
                },
              ),

              const SizedBox(height: 20),

              // ✅ Terms text
              const Text(
                'If you proceed you agree to the',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: maroon,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              GestureDetector(
                onTap: _launchPrivacyPolicy,
                child: const Text(
                  'Data Privacy Policy',
                  style: TextStyle(
                    color: greenBlue,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),

              const SizedBox(height: 25),

              // ✅ Smaller Proceed Button
              SizedBox(
                width: 150, // made slightly smaller
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
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    'Proceed',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ✅ Custom Text Field Builder
  Widget buildTextField(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: greenBlue, fontWeight: FontWeight.bold),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: greenBlue),
          ),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: greenBlue),
          ),
        ),
        cursorColor: greenBlue,
        style: const TextStyle(color: greenBlue, fontWeight: FontWeight.bold),
      ),
    );
  }
}

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
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 5),

              // Smaller Icons - Compact Layout
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 55,
                    height: 55,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: maroon,
                        width: 3,
                      ),
                    ),
                    child: const Icon(
                      Icons.person,
                      size: 30,
                      color: maroon,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Icon(
                    Icons.assignment_rounded,
                    size: 60,
                    color: maroon,
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // Input Fields (Narrow + Compact)
              buildTextField('Denomination'),
              buildTextField('Place of Worship'),
              buildTextField('Name'),
              buildTextField('Other Contacts (Optional)'),
              buildTextField('Email'),
              buildTextField('P.O.Box'),
              buildTextField('Residence'),

              const SizedBox(height: 8),

              // Member Type Dropdown
              buildDropdown(
                'Member Type',
                memberType,
                ['Regular', 'Guest', 'Youth', 'Elder'],
                    (value) {
                  setState(() {
                    memberType = value;
                  });
                },
              ),

              const SizedBox(height: 8),

              // Gender Dropdown
              buildDropdown(
                'Gender',
                gender,
                ['Male', 'Female', 'Other'],
                    (value) {
                  setState(() {
                    gender = value;
                  });
                },
              ),

              // Checkbox (Compact)
              Transform.scale(
                scale: 0.9,
                child: CheckboxListTile(
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
              ),

              const SizedBox(height: 10),

              // Terms text
              const Text(
                'If you proceed you agree to the',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: maroon,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              GestureDetector(
                onTap: _launchPrivacyPolicy,
                child: const Text(
                  'Data Privacy Policy',
                  style: TextStyle(
                    color: greenBlue,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),

              const SizedBox(height: 15),

              // Smaller Proceed Button
              SizedBox(
                width: 140,
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
                      fontSize: 14,
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

  // Narrow Text Field (Reduced vertical padding)
  Widget buildTextField(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 300),
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
            contentPadding: const EdgeInsets.symmetric(vertical: 8),
          ),
          cursorColor: greenBlue,
          style: const TextStyle(color: greenBlue, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  // Narrow Dropdown Builder
  Widget buildDropdown(String label, String? value, List<String> items, ValueChanged<String?> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 300),
        child: DropdownButtonFormField<String>(
          value: value,
          decoration: InputDecoration(
            labelText: label,
            labelStyle: const TextStyle(color: greenBlue, fontWeight: FontWeight.bold),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: greenBlue),
            ),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: greenBlue),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 8),
          ),
          items: items
              .map((item) => DropdownMenuItem(
            value: item,
            child: Text(
              item,
              style: const TextStyle(color: greenBlue, fontWeight: FontWeight.bold),
            ),
          ))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

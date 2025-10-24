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
  static const Color green = Colors.green;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text(
          'PERSONAL DATA',
          style: TextStyle(
            fontWeight: FontWeight.bold,
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

              
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.person, size: 80, color: maroon),
                  SizedBox(width: 15),
                  Icon(Icons.assignment_rounded, size: 100, color: maroon),
                ],
              ),

              const SizedBox(height: 20),

              
              buildTextField('Denomination'),
              buildTextField('Place of Worship'),
              buildTextField('Name'),
              buildTextField('Other Contacts (Optional)'),
              buildTextField('Email'),
              buildTextField('P.O.Box'),
              buildTextField('Residence'),

              
              DropdownButtonFormField<String>(
                initialValue: memberType,
                decoration: const InputDecoration(
                  labelText: 'Member Type',
                  labelStyle: TextStyle(color: green),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: green),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: green),
                  ),
                ),
                items: ['Regular', 'Guest', 'Youth', 'Elder']
                    .map((type) => DropdownMenuItem(
                          value: type,
                          child: Text(type, style: const TextStyle(color: green)),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    memberType = value;
                  });
                },
              ),

              const SizedBox(height: 12),

              
              DropdownButtonFormField<String>(
                initialValue: gender,
                decoration: const InputDecoration(
                  labelText: 'Gender',
                  labelStyle: TextStyle(color: green),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: green),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: green),
                  ),
                ),
                items: ['Male', 'Female', 'Other']
                    .map((g) => DropdownMenuItem(
                          value: g,
                          child: Text(g, style: const TextStyle(color: green)),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    gender = value;
                  });
                },
              ),

              
              CheckboxListTile(
                value: phoneOwner,
                title: const Text(
                  'Phone Owner',
                  style: TextStyle(color: green),
                ),
                controlAffinity: ListTileControlAffinity.leading,
                activeColor: green,
                onChanged: (bool? value) {
                  setState(() {
                    phoneOwner = value ?? false;
                  });
                },
              ),

              const SizedBox(height: 20),

              
              const Text(
                'If you proceed you agree to the',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: maroon,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),

              
              GestureDetector(
                onTap: _launchPrivacyPolicy,
                child: const Text(
                  'Data Privacy Policy',
                  style: TextStyle(
                    color: green,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),

              const SizedBox(height: 25),

              
              SizedBox(
                width: 180,
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

  
  Widget buildTextField(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: green),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: green),
          ),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: green),
          ),
        ),
        cursorColor: green,
        style: const TextStyle(color: green),
      ),
    );
  }
}

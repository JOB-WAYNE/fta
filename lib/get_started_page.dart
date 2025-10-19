import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'personal_data_page.dart'; // ✅ Import your next page

class GetStartedPage extends StatefulWidget {
  const GetStartedPage({super.key});

  @override
  State<GetStartedPage> createState() => _GetStartedPageState();
}

class _GetStartedPageState extends State<GetStartedPage> {
  static const Color maroon = Color(0xFF800000);
  static const Color greenBlue = Color(0xFF008080);

  bool isHovered = false;

  final TextEditingController seg1 = TextEditingController();
  final TextEditingController seg2 = TextEditingController();
  final TextEditingController seg3 = TextEditingController();

  final FocusNode node1 = FocusNode();
  final FocusNode node2 = FocusNode();
  final FocusNode node3 = FocusNode();

  // 🧩 Helper for Country Input
  Widget buildTextField(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: greenBlue),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: greenBlue),
          ),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: greenBlue),
          ),
        ),
        cursorColor: greenBlue,
        style: const TextStyle(color: greenBlue),
      ),
    );
  }

  // 📞 Phone Number Input (3 segments)
  Widget buildPhoneInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: greenBlue, width: 2),
              ),
            ),
            child: const Text(
              '+254',
              style: TextStyle(
                color: greenBlue,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // ✅ First segment allows 4 digits
                buildPhoneSegment(seg1, node1, node2, maxLength: 4),
                const SizedBox(width: 12),
                buildPhoneSegment(seg2, node2, node3),
                const SizedBox(width: 12),
                buildPhoneSegment(seg3, node3, null),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 🧱 Phone Number Segment Widget
  Widget buildPhoneSegment(
    TextEditingController controller,
    FocusNode current,
    FocusNode? next, {
    int maxLength = 3,
  }) {
    return Expanded(
      child: TextField(
        controller: controller,
        focusNode: current,
        keyboardType: TextInputType.number,
        cursorColor: greenBlue,
        maxLength: maxLength,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: greenBlue,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(maxLength),
        ],
        decoration: const InputDecoration(
          counterText: '',
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: greenBlue, width: 2),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: greenBlue, width: 2),
          ),
        ),
        onChanged: (value) {
          if (value.length == maxLength && next != null) {
            FocusScope.of(context).requestFocus(next);
          }
        },
      ),
    );
  }

  // 🧭 Main UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 🔙 Back button
              Align(
                alignment: Alignment.topLeft,
                child: TextButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back, color: Colors.black54),
                  label: const Text(
                    'Back',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 16,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(50, 30),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // 👆 Icon
              const Center(
                child: Icon(
                  Icons.touch_app_rounded,
                  color: maroon,
                  size: 80,
                ),
              ),

              const SizedBox(height: 10),

              // 🟢 + 🔴 Combined "GET STARTED" vertically closer
              RichText(
                textAlign: TextAlign.center,
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: 'GET\n',
                      style: TextStyle(
                        color: greenBlue,
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                        height: 0.8,
                      ),
                    ),
                    TextSpan(
                      text: 'STARTED',
                      style: TextStyle(
                        color: maroon,
                        fontSize: 60,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                        height: 0.8,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                'Select country,',
                style: TextStyle(
                  color: greenBlue,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Enter phone number',
                style: TextStyle(
                  color: greenBlue,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),

              const SizedBox(height: 16),

              // 🌍 Country input (full width)
              buildTextField('Country'),

              // 📱 Phone input (shorter from the right)
              Align(
                alignment: Alignment.centerLeft,
                child: FractionallySizedBox(
                  widthFactor: 0.85, // 👈 85% width of the screen
                  child: buildPhoneInput(),
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                'If you proceed you agree to the',
                style: TextStyle(
                  color: maroon,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MouseRegion(
                    onEnter: (_) => setState(() => isHovered = true),
                    onExit: (_) => setState(() => isHovered = false),
                    child: GestureDetector(
                      onTap: () {},
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        transform: Matrix4.translationValues(0, isHovered ? -3 : 0, 0),
                        child: const Text(
                          'Terms of service ',
                          style: TextStyle(
                            color: greenBlue,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Text(
                    'of F.T.S System',
                    style: TextStyle(
                      color: maroon,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              const Spacer(),

              Center(
                child: SizedBox(
                  width: 180,
                  child: OutlinedButton(
                    onPressed: () {
                      final phoneNumber = '+254${seg1.text}${seg2.text}${seg3.text}';
                      debugPrint('Full phone: $phoneNumber');

                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const PersonalDataPage()),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: maroon, width: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: Colors.grey[200],
                    ),
                    child: const Text(
                      'Proceed',
                      style: TextStyle(
                        color: maroon,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
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
}

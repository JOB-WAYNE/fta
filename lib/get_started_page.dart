// get_started_page.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dio/dio.dart'; // Add Dio
import 'main.dart';           // For HomePage
import 'custom_opt_page.dart';  // OTP Page

class GetStartedPage extends StatefulWidget {
  const GetStartedPage({super.key});

  @override
  State<GetStartedPage> createState() => _GetStartedPageState();
}

class _GetStartedPageState extends State<GetStartedPage> {
  static const Color maroon = Color(0xFF800000);
  static const Color greenBlue = Color(0xFF008080);

  final TextEditingController seg1 = TextEditingController();
  final TextEditingController seg2 = TextEditingController();
  final TextEditingController seg3 = TextEditingController();

  final FocusNode node1 = FocusNode();
  final FocusNode node2 = FocusNode();
  final FocusNode node3 = FocusNode();

  final Dio dio = Dio();

  // Fetch dynamic config
  Future<Map<String, String>> fetchConfig() async {
    final res = await dio.get(
      "https://ftscomms.lakeatts.co.ke:8443/ftscomms/campaigns/bootstrap",
      queryParameters: {"name": "Stranger-Validation"},
    );
    return {
      "senderId": res.data["senderId"],
      "templateId": res.data["templateId"],
      "providerId": res.data["providerId"],
      "campaignId": res.data["campaignId"],
    };
  }

  // Send metadata API
  Future<String> sendMetadata(String phone, Map<String, String> config) async {
    final body = {
      "channel": "sms",
      "to_address": phone,
      "senderId": config["senderId"],
      "providerAccountId": config["providerId"],
      "campaignId": config["campaignId"],
      "templateId": config["templateId"],
      "priority": "normal",
      "variables": {
        "validation": "password reset",
        "OTP": "X",
        "passcode_duration": 10,
        "time_measure": "minutes"
      },
      "metadata": {"name": "Grace"}
    };

    final res = await dio.post(
      "https://ftscomms.lakeatts.co.ke:8443/ftscomms/outbound-messages",
      data: body,
    );

    return res.data["id"]; // messageId
  }

  // Trigger OTP dispatch
  Future<void> triggerDispatch() async {
    await dio.post(
      "https://ftscomms.lakeatts.co.ke:8443/ftscomms/queue/dispatch-next?workerId=worker-1",
    );
  }

  // Proceed button action
  void proceed() async {
    final phoneNumber = '+254${seg1.text}${seg2.text}${seg3.text}';

    // Validation
    if (seg1.text.length != 3 || seg2.text.length != 3 || seg3.text.length != 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter a complete phone number"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      // 1️⃣ Fetch dynamic config
      final config = await fetchConfig();

      // 2️⃣ Send metadata and get messageId
      final messageId = await sendMetadata(phoneNumber, config);

      // 3️⃣ Trigger dispatch automatically
      await triggerDispatch();

      // 4️⃣ Navigate to OTP page
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => VerifyScreen(
            //phoneNumber: phoneNumber,
            messageId: messageId,
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error sending metadata: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Country field
  Widget buildTextField(String label) {
    return Align(
      alignment: Alignment.center,
      child: FractionallySizedBox(
        widthFactor: 0.75,
        child: SizedBox(
          height: 45,
          child: TextFormField(
            decoration: const InputDecoration(
              labelText: 'Country',
              labelStyle: TextStyle(color: greenBlue),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: greenBlue),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: greenBlue),
              ),
              contentPadding: EdgeInsets.symmetric(vertical: 8),
            ),
            cursorColor: greenBlue,
            style: const TextStyle(color: greenBlue),
          ),
        ),
      ),
    );
  }

  // Phone number segment
  Widget buildPhoneSegment(
      TextEditingController controller,
      FocusNode current,
      FocusNode? next, {
        int maxLength = 3,
      }) {
    return SizedBox(
      width: 40,
      height: 40,
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
          contentPadding: EdgeInsets.symmetric(vertical: 8),
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

  // Phone input row
  Widget buildPhoneInput() {
    return Align(
      alignment: Alignment.center,
      child: FractionallySizedBox(
        widthFactor: 0.75,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.only(bottom: 4, right: 8),
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
              const SizedBox(width: 10),
              Row(
                children: [
                  buildPhoneSegment(seg1, node1, node2),
                  const SizedBox(width: 8),
                  buildPhoneSegment(seg2, node2, node3),
                  const SizedBox(width: 8),
                  buildPhoneSegment(seg3, node3, null),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Back button
              Align(
                alignment: Alignment.topLeft,
                child: TextButton.icon(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const HomePage()),
                          (route) => false,
                    );
                  },
                  icon: const Icon(Icons.arrow_back, color: Colors.black54),
                  label: const Text(
                    'Back',
                    style: TextStyle(color: Colors.black54, fontSize: 16),
                  ),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(50, 30),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ),

              const SizedBox(height: 30),
              const Icon(Icons.touch_app_rounded, color: maroon, size: 80),
              const SizedBox(height: 20),

              // Title
              RichText(
                textAlign: TextAlign.center,
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: 'GET\n',
                      style: TextStyle(
                        color: greenBlue,
                        fontSize: 40,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2,
                        height: 0.8,
                      ),
                    ),
                    TextSpan(
                      text: 'STARTED',
                      style: TextStyle(
                        color: maroon,
                        fontSize: 64,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                        height: 0.9,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 15),
              const Text(
                'Select country,',
                style: TextStyle(
                  color: greenBlue,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Enter phone number',
                style: TextStyle(
                  color: greenBlue,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),

              const SizedBox(height: 25),
              buildTextField('Country'),
              buildPhoneInput(),

              const SizedBox(height: 50),
              const Text(
                'If you proceed you agree to the',
                style: TextStyle(
                  color: maroon,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: const Text(
                      'Terms of service ',
                      style: TextStyle(
                        color: greenBlue,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Text(
                    'of F.T.S System',
                    style: TextStyle(
                      color: maroon,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              const Spacer(),

              // PROCEED BUTTON — NOW INTEGRATED WITH API
              Center(
                child: Container(
                  color: Colors.grey[200],
                  child: SizedBox(
                    width: 160,
                    child: FilledButton.icon(
                      onPressed: proceed, // API call integrated
                      icon: const Icon(Icons.arrow_forward, color: maroon),
                      label: const Text(
                        'Proceed',
                        style: TextStyle(
                          color: maroon,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.grey[200],
                        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                          side: const BorderSide(color: maroon, width: 2),
                        ),
                        elevation: 0,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

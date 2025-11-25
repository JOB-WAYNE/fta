import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sms_autofill/sms_autofill.dart';
import 'personal_data_page.dart';

class VerifyScreen extends StatefulWidget {
  final String messageId;

  const VerifyScreen({super.key, required this.messageId});

  @override
  State<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> with CodeAutoFill {
  static const Color greenBlue = Color(0xFF008080);

  final int otpLength = 6;
  String enteredOtp = '';
  bool isLoading = false;

  final TextEditingController _otpController = TextEditingController();
  final FocusNode _otpFocusNode = FocusNode();

  static const String commsUrl = "https://ftscomms.lakeatts.co.ke:8443/ftscomms";

  @override
  void initState() {
    super.initState();
    listenForCode();

    // Delay to focus OTP field
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) FocusScope.of(context).requestFocus(_otpFocusNode);
    });

    _otpController.addListener(() {
      if (mounted) {
        setState(() {
          enteredOtp = _otpController.text;
        });
      }
    });
  }

  @override
  void codeUpdated() {
    if (code != null) {
      _otpController.text = code!;
      if (code!.length == otpLength) {
        verifyOtp();
      }
    }
  }

  @override
  void dispose() {
    cancel();
    _otpController.dispose();
    _otpFocusNode.dispose();
    super.dispose();
  }

  Future<void> verifyOtp() async {
    if (enteredOtp.length < otpLength) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter the 6-digit code")),
      );
      return;
    }

    if (!mounted) return;
    FocusScope.of(context).requestFocus(_otpFocusNode);

    if (isLoading) return;
    if (!mounted) return;
    setState(() => isLoading = true);

    try {
      final url = Uri.parse('$commsUrl/outbound-messages/verify-otp');

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "messageId": widget.messageId,
          "otp": enteredOtp,
        }),
      );

      if (!mounted) return;
      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['ok'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Phone verified successfully!"),
            backgroundColor: Colors.green,
          ),
        );

        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const PersonalDataPage()),
        );
      } else {
        _showError(data['reason'] ?? "Invalid OTP");
      }
    } catch (e) {
      if (!mounted) return;
      _showError("Network error. Try again.");
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
    _otpController.clear();

    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) FocusScope.of(context).requestFocus(_otpFocusNode);
    });
  }

  Widget buildOtpBox(int index) {
    return Container(
      width: 45,
      height: 55,
      margin: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black87, width: 1.4),
        borderRadius: BorderRadius.circular(8),
      ),
      alignment: Alignment.center,
      child: Text(
        index < enteredOtp.length ? enteredOtp[index] : "",
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () {
            if (mounted) Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 30),
            const Icon(Icons.verified_user_rounded, size: 90, color: greenBlue),
            const SizedBox(height: 20),
            const Text(
              "Verify Phone Number",
              style: TextStyle(
                  fontSize: 28, fontWeight: FontWeight.bold, color: greenBlue),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            const Text(
              "Enter the 6-digit code we sent",
              style: TextStyle(fontSize: 18, color: Colors.black87),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(otpLength, buildOtpBox),
            ),
            const SizedBox(height: 20),

            TextField(
              controller: _otpController,
              focusNode: _otpFocusNode,
              keyboardType: TextInputType.number,
              maxLength: otpLength,
              autofocus: true,
              style: const TextStyle(color: Colors.transparent),
              cursorColor: Colors.transparent,
              decoration: const InputDecoration(
                counterText: "",
                border: InputBorder.none,
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton.icon(
              onPressed: isLoading ? null : verifyOtp,
              icon: const Icon(Icons.verified),
              label: isLoading
                  ? const Text("Verifying...")
                  : const Text("Verify OTP"),
              style: ElevatedButton.styleFrom(
                backgroundColor: greenBlue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

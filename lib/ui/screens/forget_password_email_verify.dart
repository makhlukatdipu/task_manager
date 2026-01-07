import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/ui/screens/forget_password_verify_otp_screen.dart';
import 'package:task_manager/ui/widgets/screen_background.dart';

import '../../providers/network_provider.dart';

class ForgetPasswordEmailVerify extends StatefulWidget {
  const ForgetPasswordEmailVerify({super.key});

  @override
  State<ForgetPasswordEmailVerify> createState() => _ForgetPasswordEmailVerifyState();
}

class _ForgetPasswordEmailVerifyState extends State<ForgetPasswordEmailVerify> {
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 150),

                Text(
                  'Your Email Address',
                  style: Theme.of(context).textTheme.titleLarge,
                ),

                const SizedBox(height: 8),

                Text(
                  'A 6 digits OTP will be sent to your email address',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(color: Colors.grey),
                ),

                const SizedBox(height: 10),

                TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(hintText: 'Email'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },

                    ),

                const SizedBox(height: 20),

                // FilledButton(
                //   onPressed: () {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //         builder: (context) => ForgetPasswordVerifyOtpScreen(),
                //       ),
                //     );
                //   },
                //   child: Icon(Icons.arrow_circle_right_outlined),
                // ),
                SizedBox(
                  width: double.infinity,
                  child: _isLoading
                      ? const CircularProgressIndicator()  // ← লোডিং হলে স্পিনার
                      : FilledButton(
                    onPressed: _sendOtp,  // ← আলাদা ফাংশনে নিয়ে গেলাম
                    child: const Text('Send OTP'),  // ← টেক্সট দিলাম
                  ),
                ),

                const SizedBox(height: 30),

                Center(
                  child: Column(
                    children: [
                      RichText(
                        text: TextSpan(
                          text: "Already have an account? ",
                          children: [
                            TextSpan(
                              text: 'Sign In',
                              style: TextStyle(color: Colors.green),
                            ),
                          ],
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }



  Future<void> _sendOtp() async {

    if (!_formKey.currentState!.validate()) return;

    FocusScope.of(context).unfocus();

    final networkProvider = Provider.of<NetworkProvider>(context, listen: false);

    final email = _emailController.text.trim();

    final result = await networkProvider.verifyEmailForPasswordRecovery(email: email);

    if (result['success'] == true && mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ForgetPasswordVerifyOtpScreen(email: email),
        ),
      );
    }

  }
}

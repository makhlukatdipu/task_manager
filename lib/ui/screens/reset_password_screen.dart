import 'package:flutter/material.dart';

import '../widgets/screen_background.dart';
class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 150),

                Text(
                  'Set Password',
                  style: Theme.of(context).textTheme.titleLarge,
                ),

                const SizedBox(height: 8),

                Text(
                  'Password should be more then 6 letters and combination of numbers and spacial characters',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(color: Colors.grey),
                ),

                const SizedBox(height: 10),

                TextFormField(decoration: InputDecoration(hintText: 'Password')),
                const SizedBox(height: 10),

                TextFormField(decoration: InputDecoration(hintText: 'Conform Password')),

                const SizedBox(height: 20),

                FilledButton(
                  onPressed: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => ForgetPasswordVerifyOtpScreen(),
                    //   ),
                    // );
                  },
                  child: Icon(Icons.arrow_circle_right_outlined),
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
}

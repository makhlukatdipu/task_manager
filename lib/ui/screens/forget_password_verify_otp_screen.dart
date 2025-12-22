import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:task_manager/ui/screens/reset_password_screen.dart';

import '../widgets/screen_background.dart';
class ForgetPasswordVerifyOtpScreen extends StatefulWidget {
  const ForgetPasswordVerifyOtpScreen({super.key});

  @override
  State<ForgetPasswordVerifyOtpScreen> createState() => _ForgetPasswordVerifyOtpScreenState();
}

class _ForgetPasswordVerifyOtpScreenState extends State<ForgetPasswordVerifyOtpScreen> {
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
              
                  const SizedBox(height: 150,),
              
                  Text('PIN Verification',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
              
                  const SizedBox(height: 8,),
              
                  Text('A 6 digits OTP sent to your email address',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.grey),
                  ),
              
                  const SizedBox(height: 10,),
              
                  PinCodeTextField(
                    length: 6,
                    keyboardType: TextInputType.number,
                    obscureText: false,
                    animationType: AnimationType.fade,
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(8),
                      fieldHeight: 50,
                      fieldWidth: 40,
                      activeFillColor: Colors.white,
                      inactiveColor: Colors.grey.shade300,
                      selectedColor: Colors.green
                    ),
                    animationDuration: Duration(milliseconds: 300),
                    backgroundColor: Colors.transparent,
                    appContext: context,
                  ),
                  const SizedBox(height: 20,),
              
                  FilledButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> ResetPasswordScreen()));
                    },
                    child: Text('Verify')
                  ),
              
                  const SizedBox(height: 30,),
              
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
          )),
    );
  }
}

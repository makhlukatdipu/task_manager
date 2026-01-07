import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/ui/screens/reset_password_screen.dart';

import '../../providers/network_provider.dart';
import '../widgets/screen_background.dart';
class ForgetPasswordVerifyOtpScreen extends StatefulWidget {
  final String email;
  const ForgetPasswordVerifyOtpScreen({super.key, required this.email});

  @override
  State<ForgetPasswordVerifyOtpScreen> createState() => _ForgetPasswordVerifyOtpScreenState();
}

class _ForgetPasswordVerifyOtpScreenState extends State<ForgetPasswordVerifyOtpScreen> {

  final TextEditingController _otpController = TextEditingController();
  bool _isLoading = false;

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
                    controller: _otpController,
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

                  SizedBox(
                    width: double.infinity,
                    child: _isLoading
                        ? const CircularProgressIndicator()
                        : FilledButton(
                      onPressed: _verifyOtp,
                      child: const Text('Verify'),
                    ),
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

  Future<void> _verifyOtp() async {
    if (_otpController.text.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a valid 6-digit OTP')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final networkProvider =
    Provider.of<NetworkProvider>(context, listen: false);

    final result = await networkProvider.verifyOTPForPasswordRecovery(
      email: widget.email,
      otp: _otpController.text.trim(),
    );

    setState(() {
      _isLoading = false;
    });

    if (result['success'] == true && mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResetPasswordScreen(
            email: widget.email,
            otp: _otpController.text.trim(),
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['error'] ?? 'OTP verification failed')),
      );
    }
  }

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

}

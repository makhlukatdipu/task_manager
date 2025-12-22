import 'package:flutter/material.dart';
import 'package:task_manager/data/services/api_caller.dart';
import 'package:task_manager/data/utils/urls.dart';
import 'package:task_manager/ui/screens/login_page.dart';

import '../widgets/screen_background.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _singUpInProgress = false;


  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: SingleChildScrollView(
            child: Form(
              key:  _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
              
                  Text(
                    'Join With Us',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
              
                  const SizedBox(height: 10),
              
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(hintText: 'Email'),
                    validator: (String? value){
                      
                      final emailRegularExp = RegExp( r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');
                      
                      if (value == null || value.isEmpty){
                        return 'Please enter your email';
                      }
                      else if(!emailRegularExp.hasMatch(value)){
                        return 'Please enter valid email';
                      }
                      return null;
                    },
                  ),
              
                  const SizedBox(height: 10),
              
                  TextFormField(
                    controller: _firstNameController,
                    decoration: InputDecoration(hintText: 'First Name'),
                    validator: (String? value){
                      if (value == null || value.isEmpty){
                        return 'Please enter your first name';
                      }
                      else if(value.trim().length < 2){
                        return 'First name must be at least 2 character';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
              
                  TextFormField(
                    controller: _lastNameController,
                    decoration: InputDecoration(hintText: 'Last Name'),
                    validator: (String? value){
                      if (value == null || value.isEmpty){
                        return 'Please enter your Last name';
                      }
                      else if(value.trim().length < 2){
                        return 'Last name must be at least 2 character';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
              
                  TextFormField(
                    controller: _mobileController,
                    decoration: InputDecoration(hintText: 'Mobile'),
                    validator: (String? value){
                      if (value == null || value.isEmpty){
                        return 'Please enter your mobile number';
                      }
                      else if(value.trim().length != 11){
                        return 'Enter valid phon number';
                      }
                      // else if(![013,014,015,016,017,018,019].toString().contains(value)){
                      //   return 'Enter valid phon number';
                      // }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
              
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(hintText: 'Password'),
                    validator: (String? value){
                      if (value == null || value.isEmpty){
                        return 'Please enter your mobile number';
                      }
                      else if ( value.length <=6){
                        return 'Enter password more then 6 character';
                      }
                      return null;
                    },
                  ),

                  // const SizedBox(height: 10),
                  //
                  // TextFormField(
                  //   controller: _conformPassController,
                  //   decoration: InputDecoration(hintText: 'Conform Password'),
                  //   validator: (String? value){
                  //     if (value == null || value.isEmpty){
                  //       return 'Please enter your mobile number';
                  //     }
                  //     else if ( value.length <=6){
                  //       return 'Enter password more then 6 character';
                  //     }
                  //     return null;
                  //   },
                  // ),

                  const SizedBox(height: 20),
              
                  Visibility(
                    visible: !_singUpInProgress,
                    replacement: Center(child: CircularProgressIndicator()),
                    child: FilledButton(
                      onPressed: () {

                        if(_formKey.currentState!.validate()){

                          _signUp();

                        }
                      },
                      child: Icon(Icons.arrow_circle_right_outlined),
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
      ),
    );
  }

  Future<void> _signUp()async{
    setState(() {
      _singUpInProgress = true;
    });

    Map<String, dynamic> requestBody = {
      "email":_emailController.text,
      "firstName":_firstNameController.text,
      "lastName":_lastNameController.text,
      "mobile":_mobileController.text,
      "password":_passwordController.text,
    };

    final ApiResponse response = await ApiCaller.postRequest(
      url: Urls.registrationUrl,
      body: requestBody,
    );

    setState(() {
      _singUpInProgress = false;
    });

    if(response.isSuccess){
      _clearTextField();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Sign up Success..!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          )
      );
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginPage()));

    }else{
      String errorMessage = 'Sign up failed';

      if (response.responseData['data']?['code'] == 11000) {
        errorMessage = 'This email is already registered';
      }
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          )
      );
    }
  }

  _clearTextField(){
    _emailController.clear();
    _firstNameController.clear();
    _lastNameController.clear();
    _mobileController.clear();
    _passwordController.clear();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _mobileController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}

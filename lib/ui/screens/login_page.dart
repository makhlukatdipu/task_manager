import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/data/services/api_caller.dart';
import 'package:task_manager/data/utils/urls.dart';
import 'package:task_manager/ui/screens/forget_password_email_verify.dart';
import 'package:task_manager/ui/screens/main_nav_bar_holder_screen.dart';
import 'package:task_manager/ui/screens/sign_up_screen.dart';
import 'package:task_manager/ui/widgets/screen_background.dart';

import '../../data/models/user_model.dart';
import '../controller/auth_controller.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}



class _LoginPageState extends State<LoginPage> {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool singInProgress = false;

  @override
  Widget build(BuildContext context) {
    void _onTabSignUp(){
      Navigator.push(context, MaterialPageRoute(builder: (context)=> SignUpScreen()));
    }
    return Scaffold(
      body: ScreenBackground(
        child: Padding(
          padding: EdgeInsets.all(25),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                 const SizedBox(height: 150,),

                  Text('Get Started With',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),

                 const SizedBox(height: 25,),

                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      hintText: 'Email',
                    ),
                    validator: (String? value){

                      final emailRegularExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

                      if (value == null || value.isEmpty){
                        return 'Please enter your email';
                      }
                      else if(!emailRegularExp.hasMatch(value)){
                        return 'Please enter valid email';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 10,),

                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Password',
                    ),
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
                  const SizedBox(height: 20,),

                  FilledButton(
                    onPressed: () {
                      if(_formKey.currentState!.validate()){
                        _signIn();
                      }
                    },
                    child: Icon(Icons.arrow_circle_right_outlined),
                  ),

                  const SizedBox(height: 40,),

                  Center(
                    child: Column(
                      children: [
                        TextButton(onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>ForgetPasswordEmailVerify()));
                        }, child: Text('Forget Password ?')),
                        RichText(
                          text: TextSpan(
                            text: "Don't have an account? ",
                            children: [
                              TextSpan(
                                text: 'Sign Up',
                                style: TextStyle(color: Colors.green),
                                recognizer: TapGestureRecognizer()..onTap = _onTabSignUp,
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

  Future<void> _signIn()async{

    setState(() {
      singInProgress = true;
    });

    Map<String,dynamic> responseBody = {
      "email": _emailController.text,
      "password" : _passwordController.text,
    };

    final ApiResponse response = await ApiCaller.postRequest(
        url: Urls.logInUrl,
      body: responseBody,
    );
    setState(() {
      singInProgress = false;
    });
//print(response.responseData['data']);
    if(response.isSuccess){

      UserModel model = UserModel.fromJson(response.responseData['data']);
       String accessToken = response.responseData['token'];
     await AuthController.saveUserData(model, accessToken);
      _clearTextField();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login Success..!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
      );
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>MainNavBarHolderScreen()));

    }else{
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response.responseData['data']?? 'Invalid email & password'),
          backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
        )
      );
    }
  }

  _clearTextField(){
    _emailController.clear();
    _passwordController.clear();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}

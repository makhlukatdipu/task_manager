import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/ui/controller/auth_controller.dart';
import 'package:task_manager/ui/screens/login_page.dart';
import 'package:task_manager/ui/utils/assets_paths.dart';
import 'package:task_manager/ui/widgets/screen_background.dart';

import '../../providers/auth_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _moveToNextScreen();
  }

  Future _moveToNextScreen() async {
    await Future.delayed(Duration(seconds: 3));
    // await AuthController.getUserData();
    //final bool isLoggedIn = await AuthController.isUserLoggedIn();

    final authProvider = Provider.of<AuthProvider>(context,listen: false);

    await authProvider.loadUserData();


    if(authProvider.isLoggedIn){
      Navigator.pushReplacementNamed(context, '/NavBar');
    }else{
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
        child: Center(
            child:
            //SvgPicture.asset(AssetPaths.logoImage)
            Image.asset(
              AssetPaths.logo,
              width: 250,
              height: 250,
            )
        ),
      ),
    );
  }
}

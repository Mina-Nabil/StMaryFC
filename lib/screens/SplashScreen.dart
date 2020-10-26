import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:StMaryFA/providers/Auth.dart';
import 'package:StMaryFA/screens/HomeScreen.dart';
import 'package:StMaryFA/screens/LoginScreen.dart';


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {


  void initState() {
    Future.delayed(Duration(milliseconds: 2000)).then((_) {
      if(Provider.of<Auth>(context, listen: false).isLoggedIn()) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body:  Center(child: Image.asset('assets/icons/logo.jpeg',fit: BoxFit.contain,)),
    );
  }
}
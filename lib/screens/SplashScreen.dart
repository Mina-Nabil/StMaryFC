import 'package:StMaryFA/providers/UsersProvider.dart';
import 'package:StMaryFA/widgets/AcademyHeader.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
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
    Future.delayed(Duration(milliseconds: 2000)).then((_) async {
      if (await Provider.of<Auth>(context, listen: false).isLoggedIn()) {
        Navigator.pushReplacement(
          context,
           MaterialPageRoute(
             builder: (context) => MultiProvider(
               providers: [
                 ChangeNotifierProvider.value(value: UsersProvider())
               ],
               child: HomeScreen(),
             )
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          new PageTransition(type: PageTransitionType.fade, duration: Duration(milliseconds: 1800), child: LoginScreen()),
        );
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Center(
          child: AcademyHeader()),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:StMaryFA/screens/SplashScreen.dart';
import 'providers/Auth.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: Auth()),
      ],
      child: MaterialApp(
        title: 'StMaryFA',

        theme: ThemeData(
          primaryColor: Colors.orange,
          backgroundColor: Colors.white,
          fontFamily: "Oxygen",
          
          //This adds swipe back option on both android and iOS
          pageTransitionsTheme: PageTransitionsTheme(builders: {
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          }),

          // This makes the visual density adapt to the platform that you run
          // the app on. For desktop platforms, the controls will be smaller and
          // closer together (more dense) than on mobile platforms.
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: SplashScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

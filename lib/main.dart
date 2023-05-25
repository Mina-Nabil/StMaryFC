import 'package:StMaryFA/providers/CategoriesProvider.dart';
import 'package:StMaryFA/providers/GroupsProvider.dart';
import 'package:StMaryFA/providers/UsersProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:StMaryFA/screens/SplashScreen.dart';
import 'providers/Auth.dart';
import 'providers/EventsProvider.dart';

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
        ChangeNotifierProvider.value(value: UsersProvider()),
        ChangeNotifierProvider.value(value: GroupsProvider()),
        ChangeNotifierProvider.value(value: EventsProvider()),
        ChangeNotifierProvider.value(value: CategoriesProvider()),
      ],
      child: MaterialApp(
        title: 'StMaryFA',
        theme: ThemeData(
          primaryColor: Colors.orange,
          colorScheme: ColorScheme(
            brightness: Brightness.light,
            primary: Colors.orange,
            onPrimary: Colors.white,
            background: Colors.white,
            error: Colors.red,
            onBackground: Colors.black,
            onError: Colors.yellow,
            onSecondary: Colors.black,
            onSurface: Colors.black,
            secondary: Colors.amber,
            surface: Colors.orange,
          ),

          appBarTheme: AppBarTheme(
              actionsIconTheme: IconThemeData(color: Colors.white),
              iconTheme: IconThemeData(color: Colors.white),
              centerTitle: true,
              //headline6 is used for appbar title per flutter standards
              titleTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),

          iconTheme: IconThemeData(color: Colors.orange),
          fontFamily: "Oxygen",

          inputDecorationTheme: InputDecorationTheme(
              contentPadding: EdgeInsets.symmetric(horizontal: 5),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(width: 0.2, color: Color.fromRGBO(79, 50, 0, 1), style: BorderStyle.solid),
              ),
              filled: true,
              fillColor: Color.fromRGBO(254, 250, 241, 1),
              hintStyle: TextStyle(color: Colors.grey)),

          textTheme: TextTheme(
            bodyMedium: TextStyle(color: Colors.black, fontSize: 20),
          ),

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

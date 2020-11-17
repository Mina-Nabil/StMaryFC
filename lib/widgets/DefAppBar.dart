import 'package:StMaryFA/screens/SettingsScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DefAppBar {
  static AppBar getBar(context, defTitle, {isAdd = true}) {
    List<Widget> actionsList = [];

    if (isAdd)
      actionsList.add(IconButton(
        icon: FaIcon(CupertinoIcons.settings),
        onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => SettingsScreen())),
      ));

    return AppBar(
      brightness: Brightness.dark,
      title: Text(defTitle, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
      iconTheme: IconThemeData(color: Colors.white),
      actions: actionsList,
    );
  }
}

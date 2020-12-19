import 'package:StMaryFA/screens/AddUsersScreen.dart';
import 'package:StMaryFA/screens/FAScreen.dart';
import 'package:StMaryFA/screens/GroupsScreen.dart';
import 'package:StMaryFA/widgets/DefAppBar.dart';
import 'package:StMaryFA/widgets/DefDrawer.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  int selectedIndex = 0;

  PageController _controller = new PageController(initialPage: 0);

  void changeIndex(index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FAScreen(
      appBar: DefAppBar.getBar(context, "Settings", isAdd: false),
      body: PageView(
          controller: _controller,
          onPageChanged: (i) => changeIndex(i),
          children: [
            GroupsScreen(),
            UserScreen(),
          ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (i) => _controller.animateToPage(i, duration: Duration(milliseconds: 200), curve: Curves.linear),
        items: [
          BottomNavigationBarItem(icon: Icon(FontAwesomeIcons.solidFutbol), label: "Groups"),
          BottomNavigationBarItem(icon: Icon(Icons.person_add_alt_1), label: "User"),
        ],
      ),
    );
  }
}

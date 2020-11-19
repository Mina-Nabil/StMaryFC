import 'package:StMaryFA/screens/AddUsersScreen.dart';
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
    return Container(
      color: Colors.orangeAccent[100],
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: DefAppBar.getBar(context, "Settings", isAdd: false),
        drawer: DefDrawer(),
        body: Container(
          padding: EdgeInsets.only(top: 30, left: 20, right: 20, bottom: 30),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: PageView(
            controller: _controller,
            onPageChanged: (i) => changeIndex(i),
            children: [
              GroupsScreen(),
              AddUsersScreen(),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: selectedIndex,
          onTap: (i) => _controller.animateToPage(i, duration: Duration(milliseconds: 200), curve: Curves.linear),
          items: [
            BottomNavigationBarItem(icon: Icon(FontAwesomeIcons.solidFutbol), label: "Groups"),
            BottomNavigationBarItem(icon: Icon(Icons.person_add_alt_1), label: "User"),
          ],
        ),
      ),
    );
  }
}

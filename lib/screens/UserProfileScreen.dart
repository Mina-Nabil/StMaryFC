import 'package:StMaryFA/models/User.dart';
import 'package:StMaryFA/providers/UsersProvider.dart';
import 'package:StMaryFA/screens/AddUsersScreen.dart';
import 'package:StMaryFA/screens/FAScreen.dart';
import 'package:StMaryFA/screens/OverviewScreen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class UserProfileScreen extends StatefulWidget {
  final int userID;

  UserProfileScreen(this.userID);
  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  int selectedIndex = 0;
  bool userLoaded = false;
  User user;

  PageController _controller = new PageController(initialPage: 0);

  void changeIndex(index) {
    setState(() {
      selectedIndex = index;
    });
  }

  void goTo(index) {
    _controller.animateToPage(index, duration: new Duration(milliseconds: 300), curve: Curves.linear);
  }

  void setUserLoaded() {
    setState(() {
      userLoaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero).then((value) async {
      user = await Provider.of<UsersProvider>(context, listen: false).getUserById(widget.userID);
      setUserLoaded();
    });
  }

  @override
  Widget build(BuildContext context) {
    return (userLoaded)
        ? FAScreen(
            appBar: AppBar(title: Text(user.userName)),
            body: PageView(
              controller: _controller,
              onPageChanged: (i) => changeIndex(i),
              children: [
                UserScreen.view(user),
                OverviewScreen(user), //overview screen
              ],
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: selectedIndex,
              onTap: (i) => _controller.animateToPage(i, duration: Duration(milliseconds: 200), curve: Curves.linear),
              items: [
                BottomNavigationBarItem(icon: Icon(FontAwesomeIcons.info), label: "Info"),
                BottomNavigationBarItem(icon: Icon(Icons.notes), label: "History"),
              ],
            ),
          )
        : FAScreen.loading();
  }
}

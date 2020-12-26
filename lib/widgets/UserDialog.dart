import 'package:StMaryFA/models/User.dart';
import 'package:StMaryFA/screens/UserProfileScreen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../global.dart';

class UserDialog extends StatelessWidget {

  UserDialog(this.user);

  final AttendanceUser user;

  @override
  Widget build(BuildContext context) {
    return new AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          title: FittedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundImage: user.imageLink.isNotEmpty ? Image.network(user.imageLink).image : null,
                  child: user.imageLink.isEmpty
                  ? FittedBox(child: Text(Utils.getInitials(user.userName), style: TextStyle(fontSize: 36, fontFamily: "Anton", color: Colors.white)))
                  : null,
                ),
                SizedBox(width: 10,),
                Text(user.userName),
              ],
            ),
          ),
          content: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                  FittedBox(child: Text(user.groupName, style: TextStyle(fontSize: 20),)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(Icons.info, color: Colors.orange,),
                        onPressed: () {
                          Navigator.pop(context); //pop side dialog first
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => UserProfileScreen(user.id)),
                          );
                        }
                      ),
                      IconButton(icon: Icon(FontAwesomeIcons.dollarSign, color: Colors.orange,), onPressed: null),
                      IconButton(icon: Icon(Icons.call, color: Colors.orange), onPressed: null),
                    ],
                  ),
              ],
            ),
          ),
        );
  }
}

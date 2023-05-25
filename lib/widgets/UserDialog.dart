import 'package:StMaryFA/models/User.dart';
import 'package:StMaryFA/providers/UsersProvider.dart';
import 'package:StMaryFA/screens/UserPaymentsScreen.dart';
import 'package:StMaryFA/screens/UserProfileScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

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
                      IconButton(
                        icon: Icon(Icons.list, color: Colors.orange,),
                        onPressed: () {
                          Navigator.pop(context); //pop side dialog first
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) =>UserPaymentsScreen(user.id, user.userName, goToHistory: true )),
                          );
                        }
                      ),
                      IconButton(
                        icon: Icon(FontAwesomeIcons.dollarSign, color: Colors.orange,), 
                        onPressed: () {
                          Navigator.pop(context); //pop side dialog first
                          Navigator.push(context, MaterialPageRoute(builder: (context) => UserPaymentsScreen(user.id, user.userName,)),);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.call, color: Colors.orange),
                        onPressed: () async {
                          User user = await Provider.of<UsersProvider>(context, listen: false).getUserById(this.user.id);
                          if(user.mobileNum != null && user.mobileNum.isNotEmpty) {
                            launch("tel://${user.mobileNum}");
                          } else {
                            showCupertinoDialog(
                              context: context,
                              builder: (BuildContext context) => new CupertinoAlertDialog(
                              title: Text("Failed"),
                              content: Text("There is no mobile number found for ${user.userName}"),
                              actions: [
                                CupertinoDialogAction(
                                  child: Text("OK", style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),),
                                  onPressed: () => Navigator.of(context).pop(),
                                )
                              ],
                            ));
                          }
                        }
                      ),
                    ],
                  ),
              ],
            ),
          ),
        );
  }
}

import 'package:StMaryFA/models/User.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../global.dart';

class UserCard extends StatelessWidget {
  UserCard({@required this.user, @required this.selected});

  final AttendanceUser user;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: Color.fromRGBO(79, 50, 0, 0.2),
        ),
        color: user.isAttended || selected ? Color.fromRGBO(253, 241, 217, 1) : Colors.white,
      ),
      child: SizedBox(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              child: CircleAvatar(
                radius: MediaQuery.of(context).size.width / 8,
                backgroundImage: user.imageLink.isNotEmpty ? Image.network(user.imageLink,
                        width: MediaQuery.of(context).size.width / 4,
                        height: MediaQuery.of(context).size.width / 4,
                        cacheWidth: MediaQuery.of(context).size.width ~/ 4,
                        cacheHeight: MediaQuery.of(context).size.width ~/ 4,).image : null,
                child: user.imageLink.isEmpty
                    ? FittedBox(child: Text(Utils.getInitials(user.userName), style: TextStyle(fontSize: 36, fontFamily: "Anton", color: Colors.white)))
                    : null,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: FittedBox(
                child: Text(
                  user.userName,
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(1.0),
                  child: Text("${user.groupName}", style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w300)),
                ),
                Container(
                    margin: EdgeInsets.only(right: 1),
                    child: FaIcon(
                      FontAwesomeIcons.dollarSign,
                      size: 12,
                      color: user.monthlyPayments > 0 ? Colors.green : user.isAttended ? Colors.red : Colors.grey[300],
                    )),
                Container(
                    margin: EdgeInsets.only(right: 1),
                    child: FaIcon(
                      FontAwesomeIcons.checkCircle,
                      size: 12,
                      color: user.isAttended ? Colors.green : Colors.grey[300],
                    ))
              ],
            ),
          ],
        ),
      ),
    );
  }
}

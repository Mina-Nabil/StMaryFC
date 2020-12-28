import 'package:StMaryFA/models/User.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../global.dart';

class UserCard extends StatelessWidget {
  final double selectedHighlightWidth = 2;

  UserCard({@required this.user, @required this.selected});

  final AttendanceUser user;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      margin: EdgeInsets.all(user.isAttended || selected ? 0 : selectedHighlightWidth),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: user.isAttended || selected ? Colors.orange : Color.fromRGBO(79, 50, 0, 0.2),
          width: user.isAttended || selected ? selectedHighlightWidth : 1,
        ),
        color: Colors.white,
      ),
      child: SizedBox(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              decoration: BoxDecoration(color: user.isAttended || selected ? Colors.orange : Colors.transparent, shape: BoxShape.circle),     
              padding: EdgeInsets.all(selectedHighlightWidth),
              child: CircleAvatar(
                backgroundColor: Color.fromRGBO(96,160,250, 1.0),
                radius: MediaQuery.of(context).size.width / 8,
                backgroundImage: user.imageLink.isNotEmpty
                    ? Image.network(
                        user.imageLink,
                        width: MediaQuery.of(context).size.width / 4,
                        height: MediaQuery.of(context).size.width / 4,
                        cacheWidth: MediaQuery.of(context).size.width ~/ 4,
                        cacheHeight: MediaQuery.of(context).size.width ~/ 4,
                      ).image
                    : null,
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
                  style: TextStyle(color: user.isAttended || selected ? Colors.orange : Colors.black, fontSize: 18, fontWeight: user.isAttended || selected ? FontWeight.bold : FontWeight.normal),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(1.0),
                  child: Text("${user.groupName}",
                      style: TextStyle(color: user.isAttended || selected ? Colors.orange : Colors.black, fontSize: 14, fontWeight: user.isAttended || selected ? FontWeight.w500 : FontWeight.w300)),
                ),
                Container(
                    margin: EdgeInsets.only(right: 1),
                    child: FaIcon(
                      FontAwesomeIcons.dollarSign,
                      size: 12,
                      color: user.monthlyPayments > 0
                          ? Colors.green
                          : user.isAttended
                              ? Colors.red
                              : Colors.grey[300],
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

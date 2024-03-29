import 'package:StMaryFA/providers/Auth.dart';
import 'package:StMaryFA/screens/AddUsersScreen.dart';
import 'package:StMaryFA/screens/FAScreen.dart';
import 'package:StMaryFA/widgets/EditLoginInfo.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../global.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FAScreen(
      appBar: AppBar(title: Text(Utils.capitalize(Provider.of<Auth>(context).userName))),
      body: Column(
        children: [
          Expanded(child: UserScreen.view(Provider.of<Auth>(context).currentUser, extra: EditLoginInfo(),)),
        ],
      ) ,
    );
  }
}

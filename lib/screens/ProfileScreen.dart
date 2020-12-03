import 'package:StMaryFA/providers/Auth.dart';
import 'package:StMaryFA/screens/FAScreen.dart';
import 'package:StMaryFA/widgets/DefAppBar.dart';
import 'package:StMaryFA/widgets/DefDrawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../global.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FAScreen(
      appBar: DefAppBar.getBar(context, Utils.capitalize(Provider.of<Auth>(context).userName), isAdd: false),
      drawer: DefDrawer(),
    );
  }
}

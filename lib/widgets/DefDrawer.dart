import 'package:StMaryFA/widgets/SideMenu.dart';
import 'package:flutter/material.dart';

class DefDrawer extends StatelessWidget {
  final double drawerWidthRatio = 0.8;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * drawerWidthRatio,
      child: Drawer(child: SafeArea(child: SideMenu())),
    );
  }
}

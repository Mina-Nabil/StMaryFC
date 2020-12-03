
import 'package:flutter/material.dart';

class FAScreen extends StatelessWidget {

  FAScreen({
    this.appBar,
    this.drawer,
    this.body,
    this.bottomNavigationBar,
  });

  final PreferredSizeWidget appBar;
  final Widget drawer;
  final Widget body;
  final Widget bottomNavigationBar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orangeAccent[100],
      appBar: appBar,
      drawer: drawer,
      body: Container(
        padding: EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 20),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: body,
      ),
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}

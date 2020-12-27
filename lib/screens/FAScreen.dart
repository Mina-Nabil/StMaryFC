
import 'package:StMaryFA/widgets/DefAppBar.dart';
import 'package:flutter/material.dart';

class FAScreen extends StatelessWidget {

  FAScreen({
    this.appBar,
    this.drawer,
    this.body,
    this.bottomNavigationBar,
  });

  FAScreen.loading() 
    : appBar = null,
      drawer = null,
      body = Center(child: CircularProgressIndicator()),
      bottomNavigationBar = null;

  FAScreen.error()
    : appBar = DefAppBar.getBar(null, "", isAdd: false),
      drawer = null,
      body = Center(child: Text("Something went wrong.\nPlease check internet connection and try again.",)),
      bottomNavigationBar = null;

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
        padding: EdgeInsets.all(15),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: body,
      ),
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}

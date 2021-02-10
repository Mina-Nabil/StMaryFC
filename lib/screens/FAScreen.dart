
import 'package:flutter/material.dart';

class FAScreen extends StatelessWidget {

  FAScreen({
    this.appBar,
    this.drawer,
    this.body,
    this.bottomNavigationBar,
    this.padding = const EdgeInsets.all(15),
  });

  FAScreen.loading() 
    : appBar = null,
      drawer = null,
      body =  Center(
                child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white),backgroundColor: Colors.orange,)
              ),
      bottomNavigationBar = null,
      padding = null;

  FAScreen.error()
    : appBar = AppBar(),
      drawer = null,
      body = Center(child: Text("Something went wrong.\nPlease check internet connection and try again.",)),
      bottomNavigationBar = null,
      padding = null;

  final PreferredSizeWidget appBar;
  final Widget drawer;
  final Widget body;
  final Widget bottomNavigationBar;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orangeAccent[100],
      appBar: appBar,
      drawer: drawer,
      body: SafeArea(
              child: Container(
          padding: padding,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: body,
        ),
      ),
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}

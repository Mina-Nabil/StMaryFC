import 'dart:async';

import 'package:StMaryFA/global.dart';
import 'package:StMaryFA/screens/HomeScreen.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DashBoard extends StatefulWidget {
  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {

  final int timeoutDuration = 15;

  bool isConnected = true;
  bool isLoading = true;
  WebViewController controller;
  Timer loadingTimer;

  void showFailedConnectivity() {
    setState(() {
      isLoading = false;
    });
    showCupertinoDialog(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext context) => new CupertinoAlertDialog(
              title: Text("Unable to connect"),
              content: Text("Please check internet connection"),
              actions: [
                CupertinoDialogAction(
                  child: Text("Ok"),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => HomeScreen()),
                    );
                  },
                )
              ],
            ));
  }

  void startTimer() {}

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero).then((value) async {
      var connectivityResult = await (Connectivity().checkConnectivity());
      isConnected = !(connectivityResult == ConnectivityResult.none);
      if (connectivityResult == ConnectivityResult.none) {
        showFailedConnectivity();
      }
    });
  }

  final _key = UniqueKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size(0, 0),
          child: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent, // status bar color,
            systemOverlayStyle: SystemUiOverlayStyle.dark,
          )),
      body: Stack(
        children: [
          WebView(
            key: _key,
            initialUrl: Server.address + 'home',
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (c) {
              loadingTimer = new Timer(Duration(seconds: timeoutDuration), showFailedConnectivity);
              isLoading = true;
            },
            onPageStarted: (string) {
              setState(() {
                if (!loadingTimer.isActive) {
                  loadingTimer = new Timer(Duration(seconds: timeoutDuration), showFailedConnectivity);
                }
                isLoading = true;
              });
            },
            onPageFinished: (string) {
              setState(() {
                isLoading = false;
                loadingTimer.cancel();
              });
            },
          ),
          if (isLoading) Container(color: Colors.white, child: Center(child: CircularProgressIndicator()))
        ],
      ),
    );
  }
}

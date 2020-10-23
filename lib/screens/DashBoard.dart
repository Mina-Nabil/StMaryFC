import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DashBoard extends StatefulWidget {
  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  
  //final Completer<WebViewController> _controller = Completer<WebViewController>();
  final _key = UniqueKey();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
                preferredSize: Size(0, 0),
                child: AppBar(
                  elevation: 0,
                  backgroundColor: Colors.transparent, // status bar color,
                  brightness:  Brightness.light ,
                )),
      body: WebView(
        key: _key,
        initialUrl: 'https://stmaryfa.msquare.app/home',
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}

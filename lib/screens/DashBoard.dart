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
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      body: WebView(
        key: _key,
        initialUrl: 'https://stmaryfa.msquare.app/home',
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}

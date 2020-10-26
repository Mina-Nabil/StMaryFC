
import 'dart:convert';

import 'package:flutter/material.dart';
import "package:http/http.dart" as http;

class Auth with ChangeNotifier {
  String _token = "";
  String _userName = "";

  bool isLoggedIn() {
    return _token.isNotEmpty;
  }

  Future<bool> logIn (String email, String password, String deviceName) async {

    const String url = "https://stmaryfa.msquare.app/api/login";

    var bodyEncoded = {
                        "email": email,
                        "password":password,
                        "deviceName": deviceName,
                      };
print(bodyEncoded);

    final response = await http.post(url,
      body: bodyEncoded,
      headers: {"Accept": "application/json"},
    );

    

   dynamic body = jsonDecode(response.body);
    print(json.decode(response.body));


    if(body["status"] != null && body["status"] == true) {
      _token  = body["message"]["token"];
      print("Sign in Done");
      print(_token);
      return true;
    } else {
      print("Sign in Failed");
      return false;
    }
  }

  void logout () {
    _token = "";
    _userName = "";
  }

  Future<void> getCurrentUserName () async {
  
    print(_token);

    final response = await http.get(
      "https://stmaryfa.msquare.app/api/current/user",
      headers: {
        'Authorization': "Bearer $_token",
        "Accept": "application/json"},
    );

    dynamic body = jsonDecode(response.body);

    if(body["status"] == null || body["status"] == false)
    {print("getCurrentUserName Failed.");}

    String userName = body["message"]["USER_NAME"];
    // Make first char cap
    _userName = '${userName[0].toUpperCase()}${userName.substring(1)}';

    notifyListeners();
  }

  String get userName { return _userName;}
}
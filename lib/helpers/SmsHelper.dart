import 'dart:convert';

import '../global.dart';
import "package:http/http.dart" as http;

class SmsHelper {
  static Future<String> sendSms(int id, String msg) async {
    String sendMessageUrl = Server.address + "api/send/sms";
    String errorMsg = "";
    try {
      var response = await http.post(sendMessageUrl,
          headers: {'Authorization': "Bearer ${await Server.token}", "Accept": "application/json"},
          body: {"userID": id.toString(), "msg": msg});

      dynamic body = jsonDecode(response.body);
      print(body);
      if (body["status"] != null && body["status"] == true) {
        return "";
      } else {
        errorMsg = "Something went wrong.";
      }
    } catch (error) {
      print(error);
      errorMsg = "Something went wrong.";
    }
    return errorMsg;
  }
}

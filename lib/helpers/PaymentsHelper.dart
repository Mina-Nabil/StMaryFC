import 'dart:convert';
import 'package:StMaryFA/models/Payment.dart';

import '../global.dart';
import "package:http/http.dart" as http;
class PaymentsHelper {

  static Future<List<Payment>> getUserPayments (int id) async {

    List<Payment> payments = [];

    String getUserPaymentsApiUrl =  Server.address + "api/get/user/payments/";
    try {
      var response = await http.get(
        getUserPaymentsApiUrl+"$id", 
        headers:  {'Authorization': "Bearer ${await Server.token}", "Accept": "application/json"}
      );

      dynamic body = jsonDecode(response.body);
      if (body["message"] != null && body["message"] is Iterable) {
        for (var payment in body["message"]) {
          payments.add(Payment.fromJson(payment));
        }
      }
    } catch(error) {
        throw(error);
    }
    return payments;
  }

  static Future<List<Payment>> getUserEventPayments (int id) async {

    List<EventPayment> payments = [];

    String getUserPaymentsApiUrl =  Server.address + "api/get/user/event/payments/";
    try {
      var response = await http.get(
        getUserPaymentsApiUrl+"$id", 
        headers:  {'Authorization': "Bearer ${await Server.token}", "Accept": "application/json"}
      );

      dynamic body = jsonDecode(response.body);

      if(body["status"] != null && body["status"]) {
        if (body["message"] != null && body["message"] is Iterable) {
          for (var payment in body["message"]) {
            payments.add(EventPayment.fromJson(payment));
          }
        }
      }
    } catch(error) {
        throw(error);
    }
    return payments;
  }

  static Future<String> addPayment (int id, double amount, String note, int type, {String date, int eventId}) async {

    if(type == 1) {
      assert(date != null);
    }
    if(type == 2) {
      assert(eventId != null);
    }
    String getUserPaymentsApiUrl =  Server.address + "api/add/payment";
    String errorMsg = "";
    try {
      var response = await http.post(
        getUserPaymentsApiUrl,
        headers:  {'Authorization': "Bearer ${await Server.token}", "Accept": "application/json"},
        body: type == 1 ? 
        {
          "userID": id.toString(),
          "amount": amount.toString(),
          "note":note,
          "date": date,
          "type": type.toString(),
        } : {
          "userID": id.toString(),
          "amount": amount.toString(),
          "note":note,
          "type": type.toString(),
          "eventID": eventId.toString(),
        }
      );

      dynamic body = jsonDecode(response.body);

      if(body["status"] != null && body["status"] == true) {
        return "";
      } else {
        errorMsg = "Something went wrong.";
      }

    } catch (error) {
      errorMsg = "Something went wrong.";
    }
    return errorMsg;
  }
}

import 'dart:convert';
import 'package:StMaryFA/models/Payment.dart';

import '../global.dart';
import "package:http/http.dart" as http;
class PaymentsHelper {

  static Future<List<Payment>> getUserPayments (int id) async {

    List<Payment> payments = [];

    String getUserPaymentsApiUrl =  Server.address + "api/get/user/payments/";

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

    return payments;
  }

  static Future<String> addPayment (int id, double amount, String date, String note) async {

    String getUserPaymentsApiUrl =  Server.address + "api/add/payment";

    var response = await http.post(
      getUserPaymentsApiUrl,
      headers:  {'Authorization': "Bearer ${await Server.token}", "Accept": "application/json"},
      body: {
        "userID": id.toString(),
        "amount": amount.toString(),
        "date": date,
        "note":note,
      }
    );

    dynamic body = jsonDecode(response.body);

    if(body["status"] != null && body["status"] == true) {
      return "";
    } else {
      return "Something went wrong.";
    }
  }
}

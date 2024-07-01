import 'dart:convert';
import 'package:StMaryFA/models/Payment.dart';
import 'package:flutter/cupertino.dart';

import '../global.dart';
import "package:http/http.dart" as http;

class PaymentsHelper {
  static Future<List<Payment>> getUserPayments(int id) async {
    List<Payment> payments = [];

    String getUserPaymentsApiUrl = Server.address + "api/get/user/payments/";
    try {
      var response = await http.get(getUserPaymentsApiUrl + "$id",
          headers: {'Authorization': "Bearer ${await Server.token}", "Accept": "application/json"});

      dynamic body = jsonDecode(response.body);
      if (body["message"] != null && body["message"] is Iterable) {
        for (var payment in body["message"]) {
          payments.add(Payment.fromJson(payment));
        }
      }
    } catch (error) {
      throw (error);
    }
    return payments;
  }

  static Future<List<Payment>> getUserEventPayments(int id) async {
    List<EventPayment> payments = [];

    String getUserPaymentsApiUrl = Server.address + "api/get/user/event/payments/";
    try {
      var response = await http.get(getUserPaymentsApiUrl + "$id",
          headers: {'Authorization': "Bearer ${await Server.token}", "Accept": "application/json"});

      dynamic body = jsonDecode(response.body);

      if (body["status"] != null && body["status"]) {
        if (body["message"] != null && body["message"] is Iterable) {
          for (var payment in body["message"]) {
            payments.add(EventPayment.fromJson(payment));
          }
        }
      }
    } catch (error) {
      throw (error);
    }
    return payments;
  }

  static Future<String> addPayment(int id, double amount, String note, int type, {int eventId, bool isSettlment}) async {
    print(isSettlment);
    if (type == 2) {
      assert(eventId != null);
    }
    String getUserPaymentsApiUrl = Server.address + "api/add/payment";
    String errorMsg = "";
    try {
      var response = await http.post(getUserPaymentsApiUrl,
          headers: {'Authorization': "Bearer ${await Server.token}", "Accept": "application/json"},
          body: type == 1
              ? {
                  "userID": id.toString(),
                  "amount": amount.toString(),
                  "note": note,
                  "type": type.toString(),
                  "isSettlment": isSettlment ? 1.toString() : 0.toString(),
                }
              : {
                  "userID": id.toString(),
                  "amount": amount.toString(),
                  "note": note,
                  "type": type.toString(),
                  "eventID": eventId.toString(),
                  "eventState": 3,
                });

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

  static Future<String> sendBalanceReminder(int id) async {
    String getUserPaymentsApiUrl = Server.address + "api/send/reminder";
    String errorMsg = "";
    try {
      var response = await http.post(getUserPaymentsApiUrl, headers: {
        'Authorization': "Bearer ${await Server.token}",
        "Accept": "application/json"
      }, body: {
        "userID": id.toString(),
      });

      dynamic body = jsonDecode(response.body);
      print(body);
      if (body["status"] != null && body["status"] == true) {
        return "";
      } else if (body["message"]) {
        errorMsg = body["message"];
      } else {
        errorMsg = "Server issue.";
      }
    } catch (error) {
      print(error);
      errorMsg = "Something went wrong.";
    }
    return errorMsg;
  }

  static Future<String> sendLastUpdate(int id) async {
    String getUserPaymentsApiUrl = Server.address + "api/send/last/update";
    String errorMsg = "";
    try {
      var response = await http.post(getUserPaymentsApiUrl, headers: {
        'Authorization': "Bearer ${await Server.token}",
        "Accept": "application/json"
      }, body: {
        "userID": id.toString(),
      });

      dynamic body = jsonDecode(response.body);
      print(body);
      if (body["status"] != null && body["status"] == true) {
        return "";
      } else if (body["message"]) {
        errorMsg = body["message"];
      } else {
        errorMsg = "Server issue.";
      }
    } catch (error) {
      print(error);
      errorMsg = "Something went wrong.";
    }
    return errorMsg;
  }

  static Future<Map<String, String>> getReminderMessage(int id) async {
    String getUserPaymentsApiUrl = Server.address + "api/get/balance/reminder";
    String errorMsg = "";
    try {
      var response = await http.post(getUserPaymentsApiUrl, headers: {
        'Authorization': "Bearer ${await Server.token}",
        "Accept": "application/json"
      }, body: {
        "userID": id.toString(),
      });

      dynamic body = jsonDecode(response.body);
      print("Get Last Update Message Response");
      if (body["status"] != null && body["status"] == true) {
        print(body);
        Map<String, String> ret = new Map<String, String>();
        print( ret.length);
        ret["number"] = body["message"]["number"];
        ret["reminder_message"] = body["message"]["reminder_message"];
        print(ret);
        return ret;
      } else if (body["message"]) {
        errorMsg = body["message"];
      } else {
        errorMsg = "Server issue.";
      }
    } catch (error) {
      print(error);
      errorMsg = "Something went wrong.";
      throw error;
    }
  }

  static Future<Map<String, String>> getLastUpdateMessage(int id) async {
    String getUserPaymentsApiUrl = Server.address + "api/get/last/update";
    String errorMsg = "";
    try {
      var response = await http.post(getUserPaymentsApiUrl, headers: {
        'Authorization': "Bearer ${await Server.token}",
        "Accept": "application/json"
      }, body: {
        "userID": id.toString(),
      });

      dynamic body = jsonDecode(response.body);
      print("Get Last Update Message Response");
      if (body["status"] != null && body["status"] == true) {
        print(body);
        Map<String, String> ret = new Map<String, String>();
        print( ret.length);
        ret["number"] = body["message"]["number"];
        ret["update_message"] = body["message"]["update_message"];
        print(ret);
        return ret;
      } else if (body["message"]) {
        errorMsg = body["message"];
      } else {
        errorMsg = "Server issue.";
      }
    } catch (error) {
      print(error);
      errorMsg = "Something went wrong.";
      throw error;
    }
  }

  static Future<Map<String, String>> getUpdateMessage(int id, int user_id) async {
    String getUserPaymentsApiUrl = Server.address + "api/get/update";
    String errorMsg = "";
    try {
      var response = await http.post(getUserPaymentsApiUrl, headers: {
        'Authorization': "Bearer ${await Server.token}",
        "Accept": "application/json"
      }, body: {
        "userID": user_id.toString(),
        "balanceID": id.toString(),
      });

      dynamic body = jsonDecode(response.body);
      print("Get Last Update Message Response");
      if (body["status"] != null && body["status"] == true) {
        print(body);
        Map<String, String> ret = new Map<String, String>();
        print( ret.length);
        ret["number"] = body["message"]["number"];
        ret["update_message"] = body["message"]["update_message"];
        print(ret);
        return ret;
      } else if (body["message"]) {
        errorMsg = body["message"];
      } else {
        errorMsg = "Server issue.";
      }
    } catch (error) {
      print(error);
      errorMsg = "Something went wrong.";
      throw error;
    }
  }

  static Future<bool> deleteUserPayment(paymentID) async {
    String url = Server.address + "api/delete/payment";
    try {
      var response = await http.post(url, headers: {
        'Authorization': "Bearer ${await Server.token}",
        "Accept": "application/json"
      }, body: {
        "paymentID": paymentID.toString(),
      });

      dynamic body = jsonDecode(response.body);
      print(body);
      if (body["status"] != null && body["status"] == true) {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      return false;
    }
  }

  static Future<bool> deleteEventPayment(paymentID) async {
    String url = Server.address + "api/delete/event/payment";
    try {
      var response = await http.post(url, headers: {
        'Authorization': "Bearer ${await Server.token}",
        "Accept": "application/json"
      }, body: {
        "paymentID": paymentID.toString(),
      });

      dynamic body = jsonDecode(response.body);

      if (body["status"] != null && body["status"] == true) {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      return false;
    }
  }
}

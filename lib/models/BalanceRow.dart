import 'package:StMaryFA/models/User.dart';

class BalanceRow {
  int id; 
  DateTime date;
  int amount;
  int newBalance;
  String title;
  bool isSettlment;
  String desc;
  User collectedBy;

  BalanceRow.fromJson(dynamic json) {
    id = json["id"];
    date =  DateTime.tryParse(json["created_at"]) ?? DateTime.now();
    title = json["title"];
    isSettlment = json["is_settlment"] == 1 ? true : false;
    desc = json["desc"];
    amount = json["value"];
    newBalance = json["new_balance"];
    collectedBy = (json['collected_by_user'] is Map<String, dynamic>) ? User.fromJson(json['collected_by_user']) : User.system();
  }
}

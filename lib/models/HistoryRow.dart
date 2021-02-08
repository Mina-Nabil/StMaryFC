class HistoryRow {
  String month;
  String year;
  String attended;
  String paid;

  HistoryRow.fromJson(dynamic json) {
    month = json["Month"];
    year = json["Year"].toString();
    attended = json["A"] != null ? json["A"].toString() : "0";
    paid = json["P"] != null ? json["P"].toString() : "0";
  }
}

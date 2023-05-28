class HistoryRow {
  String month;
  String year;
  String attended;
  String paid;
  String due;

  HistoryRow.fromJson(dynamic json) {
    month = json["Month"];
    year = json["Year"].toString();
    attended = json["A"] != null ? json["A"].toString() : "0";
    paid = json["P"] != null ? json["P"].toString() : "0";
    due = json["D"] != null ? json["D"].toString() : "N/A";
  }

  @override
  String toString() {
    return "Month: " + this.month + " Year: " + this.year + " A: " + this.attended + " P: " + this.paid + " D: " + this.due;
  }
}

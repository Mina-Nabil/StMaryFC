class HistoryRow {
  String month;
  String year;
  int attended;
  double paid;

  HistoryRow.fromJson(dynamic json) {
    month = json["Month"];
    year = json["Year"];
    try {
      attended = int.parse(json["A"]);
    } catch (e) {
      attended = 0;
    }
    try {
      paid = double.parse(json["P"]);
    } catch (e) {
      paid = 0;
    }
  }
}

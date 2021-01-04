class Event {
  int id;
  String name;
  String date;
  int price;
  String comment;

  Event.fromJson(json) {
    this.id = json['id'];
    this.name = json['EVNT_NAME'];
    this.date = json['EVNT_DATE'];
    this.price = json['EVNT_PRCE'];
    this.comment = json['EVNT_CMNT'];
  }
}

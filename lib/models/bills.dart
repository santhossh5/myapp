class Bills {
  int? billId;
  String cusId;
  String date;
  double amt;

  Bills({this.billId, required this.cusId, required this.date, required this.amt});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'cusId': cusId,
      'date': date,
      'amount': amt,
    };
    if (billId != null) {
      map['billId'] = billId;
    }
    return map;
  }

  // Extract a Customer object from a Map object
  Bills.fromMap(Map<String, dynamic> map)
      : cusId = map['cusId'],
        billId = map['billID'],
        date = map['date'],
        amt = double.parse(map['amount'].toString());
}

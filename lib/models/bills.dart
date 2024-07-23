class Bills {
  String? billId;
  String cusId;
  String date;
  bool status;
  double amt;

  Bills(
      {this.billId,
      required this.cusId,
      required this.date,
      required this.status,
      required this.amt});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'cusId': cusId,
      'date': date,
      'amount': amt,
      'status' : status,
    };
    if (billId != null) {
      map['billId'] = billId;
    }
    return map;
  }

  // Extract a Customer object from a Map object
  Bills.fromMap(Map<String, dynamic> map)
      : cusId = map['cusId'],
        billId = map['billId'],
        date = map['date'],
        status = map['status'],
        amt = double.parse(map['amount'].toString());
}

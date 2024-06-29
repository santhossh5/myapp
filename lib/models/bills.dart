class Bills {
  int? billId;
  int cusId;
  String date;
  int amt;

  Bills({this.billId, required this.cusId, required this.date, required this.amt});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'customerId': cusId,
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
      : cusId = map['customerId'],
        billId = map['billID'],
        date = map['date'],
        amt = map['amount'].toInt();
}

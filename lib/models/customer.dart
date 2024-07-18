class Customer {
  String? cusId;
  String name;
  String area;
  String street;
  double package;

  Customer(
      {this.cusId,
      required this.name,
      required this.street,
      required this.area,
      required this.package});

  // Convert a Customer object into a Map object
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'name': name,
      'street': street,
      'area': area,
      'package': package,
    };
    if (cusId != null) {
      map['id'] = cusId;
    }
    return map;
  }

  // Extract a Customer object from a Map object
  Customer.fromMap(Map<String, dynamic> map)
      : cusId = map['id'],
        name = map['name'],
        area = map['area'],
        street = map['street'],
        package = double.parse(map['package'].toString());
}

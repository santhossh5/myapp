class Worker {
  String? workerId;
  String name;
  String role;
  String password;
  //String street;

  Worker({
    this.workerId,
    required this.name,
    required this.password,
    required this.role,
    //required this.street
  });

  // Convert a Customer object into a Map object
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'name': name,
      'password': password,
      'role' : role,
      //'street': street,
    };
    if (workerId != null) {
      map['id'] = workerId;
    }
    return map;
  }

  // Extract a Customer object from a Map object
  Worker.fromMap(Map<String, dynamic> map)
      : workerId = map['id'],
        password = map['password'],
        role = map['role'],
        name = map['name'];
  //street = map['street'];
}

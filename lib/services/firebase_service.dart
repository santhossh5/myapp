import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/models/customer.dart';

const String Customers_collection = "customers";
const String Bills_collection = "Bills";

class FirebaseService {
  final _firestore = FirebaseFirestore.instance;

  late final CollectionReference _customer;
  late final CollectionReference _bill;

  FirebaseService() {
    _customer =
        _firestore.collection(Customers_collection).withConverter<Customer>(
            fromFirestore: (snapshots, _) => Customer.fromMap(
                  snapshots.data()!,
                ),
            toFirestore: (customer, _) => customer.toMap());
  }

  void addCustomer(Customer customer) async {
    _customer.add(customer);
  }
}

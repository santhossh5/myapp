import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/models/bills.dart';
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
    _bill = _firestore.collection(Bills_collection).withConverter<Bills>(
        fromFirestore: (snapshots, _) => Bills.fromMap(
              snapshots.data()!,
            ),
        toFirestore: (bill, _) => bill.toMap());
  }

  Future<void> addCustomer(Customer customer) async {
    try {
      await _customer.add(customer);
    } catch (e) {
      print("Error adding customer: $e");
    }
  }

  Future<int> getNextCustomerId() async {
    try {
      QuerySnapshot querySnapshot =
          await _customer.orderBy('id', descending: true).limit(1).get();
      if (querySnapshot.size > 0) {
        // Get the highest customer ID and increment it by 1
        return querySnapshot.docs.first.get('id') + 1;
      } else {
        // If no customers exist, start with ID 1
        return 1;
      }
    } catch (e) {
      print("Error getting next customer ID: $e");
      return 0; // Return 0 if there is an error
    }
  }

  Future<List<Customer>> getCustomers() async {
    try {
      QuerySnapshot<Customer> querySnapshot =
          await _customer.get() as QuerySnapshot<Customer>;
      return querySnapshot.docs.map((doc) => doc.data()!).toList();
    } catch (e) {
      print("Error getting customers: $e");
      return [];
    }
  }

  Future<List<Customer>> getCustomersByStreet(String street) async {
    try {
      QuerySnapshot<Customer> querySnapshot = await _customer
          .where('street', isEqualTo: street)
          .get() as QuerySnapshot<Customer>;
      return querySnapshot.docs.map((doc) => doc.data()!).toList();
    } catch (e) {
      print("Error getting customers by street: $e");
      return [];
    }
  }

  Future<void> addBill(int billid, int cusid, double val) async {
    try {
      Bills bill =
          Bills(billId: billid, cusId: cusid, date: '2024-6-28', amt: val);
      print(bill);
      await _bill.add(bill);
    } catch (e) {
      print("Error adding customer: $e");
    }
  }

  Future<int> getNextBillId() async {
    try {
      QuerySnapshot querySnapshot =
          await _bill.orderBy('billId', descending: true).limit(1).get();
      if (querySnapshot.size > 0) {
        // Get the highest customer ID and increment it by 1
        return querySnapshot.docs.first.get('billId') + 1;
      } else {
        // If no customers exist, start with ID 1
        return 1;
      }
    } catch (e) {
      print("Error getting next customer ID: $e");
      return 0; // Return 0 if there is an error
    }
  }

  Future<List<Bills>> getBillsByCusId(int id) async {
    try {
      QuerySnapshot<Bills> querySnapshot = await _bill
          .where('cusId', isEqualTo: id)
          .get() as QuerySnapshot<Bills>;
      return querySnapshot.docs.map((doc) => doc.data()!).toList();
    } catch (e) {
      print("Error adding customer: $e");
      return [];
    }
  }

  Future<void> deleteCustomer(int id) async {
    try {
      QuerySnapshot<Customer> querySnapshot = await _customer
          .where('id', isEqualTo: id)
          .get() as QuerySnapshot<Customer>;
      await querySnapshot.docs.first.reference.delete();
      QuerySnapshot<Bills> billsSnapshot = await _bill
          .where('cusId', isEqualTo: id)
          .get() as QuerySnapshot<Bills>;
      for (DocumentSnapshot<Bills> billDoc in billsSnapshot.docs) {
        await billDoc.reference.delete();
      }
    } catch (e) {
      print("Error deleting customer: $e");
    }
  }

  Future<void> updateCustomer(Customer customer) async {
    try {
      QuerySnapshot<Customer> querySnapshot = await _customer
          .where('id', isEqualTo: customer.cusId)
          .get() as QuerySnapshot<Customer>;
      if (querySnapshot.size > 0) {
        await querySnapshot.docs.first.reference.set(customer);
      } else {
        print("Customer with id ${customer.cusId} not found.");
      }
    } catch (e) {
      print("Error updating customer: $e");
    }
  }
}

// import 'dart:io';
// import 'package:myapp/models/bills.dart';
// import 'package:myapp/models/customer.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:sqflite/sqflite.dart';
// import 'dart:async';
// import 'package:path/path.dart';

// class DatabaseService {
//   static DatabaseService instance = DatabaseService._constructor();

//   DatabaseService._constructor();

//   Database? _db;

//   final String _tablename = 'customer';
//   final String _billsTable = 'bills';
//   final String _id = 'cusId';
//   final String _name = 'name';
//   final String _street = 'street';
//   final String _area = 'area';
//   final String _package = 'package';

//   Future<Database> get database async {
//     if (_db != null) return _db!;
//     _db = await getdatabase();
//     return _db!;
//   }

//   Future<Database> getdatabase() async {
//     final path = await getDatabasesPath();
//     String databasepath = join(path, 'myapp_db.db');
//     //print(databasepath);
//     final database = await openDatabase(
//       databasepath,
//       version: 1,
//       onCreate: (db, version) {
//         db.execute('''
//       CREATE TABLE $_tablename (
//        $_id INTEGER PRIMARY KEY AUTOINCREMENT, 
//        $_name TEXT NOT NULL,
//        $_area TEXT NOT NULL,
//        $_street TEXT NOT NULL,
//        $_package TEXT NOT NULL
//       )''');
//         db.execute('''
//         CREATE TABLE $_billsTable (
//           billid INTEGER PRIMARY KEY AUTOINCREMENT, 
//           customerId INTEGER NOT NULL,
//           date DATE NOT NULL,
//           amount REAL NOT NULL,
//           FOREIGN KEY (customerId) REFERENCES $_tablename ($_id)
//         )
//         ''');
//       },
//     );
//     return database;
//   }

//   void addCustomer(Customer customer) async {
//     Database db = await this.database;
//     await db.insert(_tablename, customer.toMap());
//     //print(getCustomers());
//     getCustomers();
//   }

//   void addBills(int id, int val) async {
//     Database db = await this.database;
//     Bills bill = Bills(cusId: id, date: '2024-6-28', amt: val);
//     await db.insert(_billsTable, bill.toMap());

//     var data = await db.query(_billsTable);
//     print('bills_table: $data');
//   }

//   Future<Customer?> getCustomerById(int id) async {
//     Database db = await this.database;
//     var data = await db.query(
//       _tablename,
//       where: '$_id = ?',
//       whereArgs: [
//         id,
//       ],
//     );
//     return data.isNotEmpty ? Customer.fromMap(data.first) : null;
//   }

//   Future<List<Bills>> getBillsByCusId(int cusId) async {
//     Database db = await this.database;
//     var data = await db.query(
//       _billsTable,
//       where: 'customerId = ?',
//       whereArgs: [
//         cusId,
//       ],
//     );

//     int count = data.length;
//     List<Bills> billList = List<Bills>.empty(growable: true);

//     for (int i = 0; i < count; i++) {
//       billList.add(Bills.fromMap(data[i]));
//     }

//     return billList;
//   }

//   Future<List<Customer>> getCustomers() async {
//     Database db = await this.database;
//     var data = await db.query(_tablename);

//     int count = data.length; // Count the number of map entries in db table

//     List<Customer> customerList = List<Customer>.empty(growable: true);
//     // For loop to create a 'Note List' from a 'Map List'
//     print("customer: $data");
//     for (int i = 0; i < count; i++) {
//       customerList.add(Customer.fromMap(data[i]));
//     }

//     return customerList;
//   }

//   Future<List<Customer>> getCustomersByStreet(String st) async {
//     Database db = await this.database;
//     var data = await db.query(
//       _tablename,
//       where: "street = ?",
//       whereArgs: [
//         st,
//       ],
//     );
//     int count = data.length;
//     List<Customer> customerList = List<Customer>.empty(growable: true);

//     for (int i = 0; i < count; i++) {
//       customerList.add(Customer.fromMap(data[i]));
//     }

//     return customerList;
//   }

//   void deleteCustomer(int Id) async {
//     Database db = await this.database;
//     await db.delete(
//       _tablename,
//       where: "cusId = ?",
//       whereArgs: [
//         Id,
//       ],
//     );
//     await db.delete(
//       _billsTable,
//       where: "cusId = ?",
//       whereArgs: [
//         Id,
//       ],
//     );
//   }

//   void addColumnToDatabase() async {
//     Database db = await this.database;
//     await db.execute(
//         '''ALTER TABLE $_tablename ADD COLUMN $_area TEXT NOT NULL DEFAULT ''
//         ''');
//   }

//   Future<void> removeDatabase() async {
//     final path = await getDatabasesPath();
//     String databasePath = join(path, 'myapp_db.db');
//     print(databasePath);
//     await deleteDatabase(databasePath);
//     _db = null; // Reset the _db variable so it can be reinitialized
//   }
// }
/*
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/models/bills.dart';
import 'package:myapp/models/customer.dart';

const String Customers_collection = "customers";
const String Bills_collection = "Bills";

class FirebaseService {
  final _firestore = FirebaseFirestore.instance;

  late final CollectionReference<Customer> _customerCollection;
  late final CollectionReference<Bills> _billCollection;

  FirebaseService() {
    _customerCollection = _firestore.collection(Customers_collection).withConverter<Customer>(
      fromFirestore: (snapshots, _) => Customer.fromMap(snapshots.data()!),
      toFirestore: (customer, _) => customer.toMap(),
    );

    _billCollection = _firestore.collection(Bills_collection).withConverter<Bills>(
      fromFirestore: (snapshots, _) => Bills.fromMap(snapshots.data()!),
      toFirestore: (bill, _) => bill.toMap(),
    );
  }

  Future<void> addCustomer(Customer customer) async {
    try {
      await _customerCollection.doc(customer.cusId).set(customer);
    } catch (e) {
      print("Error adding customer: $e");
    }
  }

  Future<void> addBill(Bills bill) async {
    try {
      await _billCollection.add(bill);
    } catch (e) {
      print("Error adding bill: $e");
    }
  }

  Future<Customer?> getCustomerById(String id) async {
    try {
      DocumentSnapshot<Customer> snapshot = await _customerCollection.doc(id).get();
      return snapshot.data();
    } catch (e) {
      print("Error getting customer: $e");
      return null;
    }
  }

  Future<List<Bills>> getBillsByCusId(String cusId) async {
    try {
      QuerySnapshot<Bills> querySnapshot = await _billCollection.where('customerId', isEqualTo: cusId).get();
      return querySnapshot.docs.map((doc) => doc.data()!).toList();
    } catch (e) {
      print("Error getting bills: $e");
      return [];
    }
  }

  Future<List<Customer>> getCustomers() async {
    try {
      QuerySnapshot<Customer> querySnapshot = await _customerCollection.get();
      return querySnapshot.docs.map((doc) => doc.data()!).toList();
    } catch (e) {
      print("Error getting customers: $e");
      return [];
    }
  }

  Future<List<Customer>> getCustomersByStreet(String street) async {
    try {
      QuerySnapshot<Customer> querySnapshot = await _customerCollection.where('street', isEqualTo: street).get();
      return querySnapshot.docs.map((doc) => doc.data()!).toList();
    } catch (e) {
      print("Error getting customers by street: $e");
      return [];
    }
  }

  Future<void> deleteCustomer(String id) async {
    try {
      await _customerCollection.doc(id).delete();
      QuerySnapshot<Bills> billsSnapshot = await _billCollection.where('customerId', isEqualTo: id).get();
      for (DocumentSnapshot<Bills> billDoc in billsSnapshot.docs) {
        await billDoc.reference.delete();
      }
    } catch (e) {
      print("Error deleting customer: $e");
    }
  }
}
*/
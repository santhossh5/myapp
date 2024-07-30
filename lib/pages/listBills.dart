import 'package:flutter/material.dart';
import 'package:myapp/models/customer.dart';
import 'package:myapp/models/bills.dart';
//import 'package:myapp/services/database_service.dart';
import 'package:myapp/services/firebase_service.dart';

class Listbills extends StatefulWidget {
  Listbills({super.key, required this.customer});
  Customer customer;

  @override
  State<Listbills> createState() => _ListbillsState(customer);
}

class _ListbillsState extends State<Listbills> {
  //final DatabaseService _databaseService = DatabaseService.instance;
  FirebaseService _firebaseService = FirebaseService();
  _ListbillsState(this.customer);
  Customer customer;
  List<Bills> bills = [];
  @override
  void initState() {
    super.initState();
    getbills();
  }

  void getbills() async {
    List<Bills> fetchedBills =
        await _firebaseService.getBillsByCusId(widget.customer.cusId!);
    setState(() {
      bills = fetchedBills;
    });
    print(bills.length);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        title: const Text('Bills'),
      ),
      body: ListView.builder(
          itemCount: bills.length,
          itemBuilder: (context, index) {
            Bills bill = bills[index];
            return Card(
              elevation: 5,
              margin: EdgeInsets.all(7),
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              child: Column(
                children: [
                  Text('BILL ID ${bill.billId}'),
                  Text('Date ${bill.date}'),
                  Text(
                    'Amount: ${bill.amt}',
                    style: TextStyle(fontSize: 20),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Bill staus:",
                        style: TextStyle(fontSize: 15),
                      ),
                      (bill.status)
                          ? (Text(
                              "PAID",
                              style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold),
                            ))
                          : (Text(
                              "UNPAID",
                              style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold),
                            )),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromARGB(255, 4, 116, 82)),
                          onPressed: () async {
                            _firebaseService.changeBillStatus(bill).then((_) {
                              setState(() {
                                getbills();
                              });
                            });
                          },
                          child: Text(
                            'Bill',
                            style: TextStyle(color: Colors.white),
                          )),
                      IconButton(
                          style: IconButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.red,
                              fixedSize: Size(70, 40)),
                          onPressed: () async {
                            _firebaseService.deleteBill(bill.billId!).then((_){
                            setState(() {
                              getbills();
                            });});
                          },
                          icon: Icon(Icons.delete))
                    ],
                  ),
                ],
              ),
            );
          }),
    );
  }
}

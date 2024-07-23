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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        title: const Text('Bills'),
      ),
      body: FutureBuilder(
          future: _firebaseService.getBillsByCusId(customer.cusId!),
          builder: (context, snapshot) {
            return ListView.builder(
                itemCount: snapshot.data?.length ?? 0,
                itemBuilder: (context, index) {
                  Bills bill = snapshot.data![index];
                  return Card(
                    elevation: 5,
                    margin: EdgeInsets.all(7),
                    color:
                        Theme.of(context).colorScheme.surfaceContainerHighest,
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
                          children: [
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Color.fromARGB(255, 4, 116, 82)),
                                onPressed: () async {
                                  _firebaseService.changeBillStatus(bill).then((_) {
                                    setState(() {
                                      bill.status = true;
                                    });
                                  });
                                },
                                child: Text(
                                  'Bill',
                                  style: TextStyle(color: Colors.white),
                                )),
                                IconButton(onPressed: ()async{
                                  
                                }, icon: Icon(Icons.delete))
                          ],
                        ),
                      ],
                    ),
                  );
                });
          }),
    );
  }
}

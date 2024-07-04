import 'package:flutter/material.dart';
import 'package:myapp/models/customer.dart';
import 'package:myapp/models/bills.dart';
//import 'package:myapp/services/database_service.dart';
import 'package:myapp/services/firebase_service.dart';

class Listbills extends StatefulWidget {
  Listbills({required this.customer});
  Customer customer;

  @override
  State<Listbills> createState() => _ListbillsState(customer);
}

class _ListbillsState extends State<Listbills> {
  //final DatabaseService _databaseService = DatabaseService.instance;
  _ListbillsState(this.customer);
  Customer customer;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        title: const Text('Bills'),
      ),
      // body: FutureBuilder(
      //     future: _databaseService.getBillsByCusId(customer.cusId!),
      //     builder: (context, snapshot) {
      //       return ListView.builder(
      //           itemCount: snapshot.data?.length ?? 0,
      //           itemBuilder: (context, index) {
      //             Bills bill = snapshot.data![index];
      //             return Card(
      //               elevation: 5,
      //               margin: EdgeInsets.all(7),
      //               color:
      //                   Theme.of(context).colorScheme.surfaceContainerHighest,
      //               child: Column(
      //                 children: [
      //                   Text('Date ${bill.date}'),
      //                   Text(
      //                     'Amount: ${bill.amt}',
      //                     style: TextStyle(fontSize: 20),
      //                   ),
      //                   ElevatedButton(
      //                     style: ElevatedButton.styleFrom(backgroundColor: Color.fromARGB(255, 4, 116, 82)),
      //                     onPressed: () {}, child: Text('Bill',style: TextStyle(color: Colors.white),)),
      //                 ],
      //               ),
      //             );
      //           });
      //     }),
    );
  }
}

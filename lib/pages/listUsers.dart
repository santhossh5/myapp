import 'package:flutter/material.dart';
import 'package:myapp/models/customer.dart';
import 'package:myapp/pages/addUser.dart';
import 'package:myapp/pages/listBills.dart';
import 'package:myapp/services/database_service.dart';

class listUsers extends StatefulWidget {
  const listUsers({super.key, required this.street});
  final String? street;

  @override
  State<listUsers> createState() => _listUsersState(this.street);
}

class _listUsersState extends State<listUsers> {
  final DatabaseService? _databaseService = DatabaseService.instance;
  String? street;
  _listUsersState(this.street);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          title: const Text("Detail Page"),
        ),
        body: FutureBuilder(
            future: _databaseService!.getCustomersByStreet(street!),
            builder: (context, snapshot) {
              return ListView.builder(
                  itemCount: snapshot.data?.length ?? 0,
                  itemBuilder: (context, index) {
                    Customer customer = snapshot.data![index];
                    return Card(
                      elevation: 5,
                      margin: EdgeInsets.all(7),
                      color:
                          Theme.of(context).colorScheme.surfaceContainerHighest,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Customer ID: ${customer.cusId}'),
                                Text(
                                  customer.name,
                                  style: TextStyle(fontSize: 25),
                                ),
                                Text(
                                  customer.area,
                                  style: TextStyle(fontSize: 15),
                                ),
                                Text(customer.package),
                                ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    Listbills(customer: customer,)));
                                      });
                                    },
                                    child: Text('Bills')),
                                ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        _databaseService.addBills(
                                            customer.cusId!, 111);
                                      });
                                    },
                                    child: Text('Add Bills')),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              IconButton(
                                  onPressed: () {
                                    setState(() {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  Adduser(customer, "Edit")));
                                    });
                                  },
                                  icon: Icon(Icons.edit)),
                              IconButton(
                                  onPressed: () async {
                                    showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                              title: Text(
                                                  'Are you sure to delete the customer?'),
                                              actions: [
                                                TextButton(
                                                    style: TextButton.styleFrom(
                                                        backgroundColor:
                                                            Colors.red),
                                                    onPressed: () {
                                                      setState(() {
                                                        _databaseService
                                                            .deleteCustomer(
                                                                customer
                                                                    .cusId!);
                                                        Navigator.of(context)
                                                            .pop();
                                                      });
                                                    },
                                                    child: Text(
                                                      'Delete',
                                                      style: TextStyle(
                                                          fontSize: 17,
                                                          color: Colors.white),
                                                    )),
                                              ],
                                            ));
                                  },
                                  color: Colors.red,
                                  icon: const Icon(Icons.delete)),
                            ],
                          ),
                        ],
                        //tileColor: Theme.of(context).colorScheme.secondaryContainer,
                        //title: Text(customer.name),

                        //subtitle: Text(
                        //'${customer.package} \n ${customer.area}\n ${customer.street}'),

                        //isThreeLine: true,
                      ),
                    );
                  });
            })
            );
  }
}

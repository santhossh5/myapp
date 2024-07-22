import 'package:flutter/material.dart';
import 'package:myapp/models/customer.dart';
import 'package:myapp/pages/addUser.dart';
import 'package:myapp/pages/addWorker.dart';
//import 'package:myapp/services/database_service.dart';
import 'package:myapp/services/firebase_service.dart';

class myHome extends StatefulWidget {
  const myHome({super.key});

  @override
  State<myHome> createState() => _myHomeState();
}

class _myHomeState extends State<myHome> {
  //DatabaseService _databaseService = DatabaseService.instance;
  FirebaseService _firebaseService = FirebaseService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        centerTitle: true,
        title: const Text("Home"),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: 100,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/selectstreet');
              },
              style: ElevatedButton.styleFrom(fixedSize: const Size(200, 50)),
              child: const Text(
                "Details",
                style: TextStyle(fontSize: 20),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
                onPressed: () {
                  Customer? customer;
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Adduser(customer, "Add")));
                },
                style: ElevatedButton.styleFrom(fixedSize: const Size(200, 50)),
                child: const Text(
                  "Add User",
                  style: TextStyle(fontSize: 20),
                )),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => WorkerList()));
                },
                style: ElevatedButton.styleFrom(fixedSize: Size(200, 50)),
                child: Text(
                  "Worker Detail",
                  style: TextStyle(fontSize: 20),
                )),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(onPressed: () {
              
            }, child: Text("Report"))
          ],
        ),
      ),
    );
  }
}

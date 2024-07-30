import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myapp/models/customer.dart';
import 'package:myapp/models/worker.dart';
import 'package:myapp/pages/addUser.dart';
import 'package:myapp/pages/addWorker.dart';
import 'package:myapp/pages/loginPage.dart';
import 'package:myapp/pages/report.dart';
import 'package:myapp/pages/showUser.dart';
//import 'package:myapp/services/database_service.dart';
//import 'package:myapp/services/firebase_service.dart';

class myHome extends StatefulWidget {
  const myHome({super.key, required this.worker});
  final Worker worker;

  @override
  State<myHome> createState() => _myHomeState(worker: worker);
}

class _myHomeState extends State<myHome> {
  _myHomeState({required this.worker});
  Worker worker;
  //DatabaseService _databaseService = DatabaseService.instance;
  //FirebaseService _firebaseService = FirebaseService();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          centerTitle: true,
          title: const Text("Home"),
        ),
        drawer: Drawer(
          backgroundColor: Color.fromARGB(255, 220, 222, 223),
          child: ListView(
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.grey.shade300,
                        child: Icon(
                          Icons.person,
                          size: 50,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ),
                    SizedBox(
                        width:
                            10), // Add some space between the avatar and the text
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome,',
                          style: TextStyle(
                            color: const Color.fromARGB(255, 211, 209, 209),
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          worker.name, // Replace with actual user name
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimaryContainer,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Role - ${worker.role}', // Replace with actual user email
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimaryContainer,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              mylisttile(Icons.list_sharp, "Customers", selectStreet()),
              Divider(
                height: 3,
              ),
              if(worker.role == 'Admin') ...[
                mylisttile(Icons.person_add_alt_1_rounded, "Add Customer",
                  Adduser(null, "Add")),
                Divider(
                height: 3,
              ),
              mylisttile(Icons.person_3_rounded, "Worker Detail", WorkerList()),
              Divider(
                height: 3,
              ),],
              mylisttile(Icons.dashboard_sharp, "Report", Report()),
              Divider(
                height: 3,
              ),
              mylisttile(Icons.logout, "Logout", LoginPage())
            ],
          ),
        ),
        body: body(),
      ),
    );
  }

  Widget body() {
    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Center(
              child: Container(
                padding: const EdgeInsets.all(16.0),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 121, 225, 252),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  "Date: ${DateFormat('dd-MM-yyyy').format(DateTime.now())}",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.amberAccent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    height: 170,
                    child: Center(
                      child: Text(
                        "Today",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.lightGreen,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    height: 170,
                    child: Center(
                      child: Text(
                        "This Month",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
    );
  }

  Widget mylisttile(IconData icon, String text, Widget page) {
    return ListTile(
        leading: Icon(icon),
        onTap: () {
          if (text == 'Logout') {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
                (route) => false);
          } else {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => page));
          }
        },
        //style: ElevatedButton.styleFrom(fixedSize: Size(200, 50)),
        title: Text(
          text,
          style: TextStyle(fontSize: 20),
        ));
  }
}

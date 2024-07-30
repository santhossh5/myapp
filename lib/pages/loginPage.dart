import 'package:flutter/material.dart';
import 'package:myapp/pages/homePage.dart';
import 'package:myapp/services/firebase_service.dart';
import 'package:myapp/models/worker.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController namecontroller = new TextEditingController();
  TextEditingController passwordcontroller = new TextEditingController();
  FirebaseService _firebaseService = new FirebaseService();
  final _formkey = GlobalKey<FormState>();
  List<Worker> workers = [];

  @override
  void initState() {
    super.initState();
    getworkers();
  }

  void getworkers() async {
    workers = await _firebaseService.getWorkers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Form(
          key: _formkey,
          child: ListView(
            padding: EdgeInsets.all(8.0),
            shrinkWrap: true, // Makes the ListView take the space it needs
            children: [
              TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please enter the Name";
                  }
                  return null;
                },
                controller: namecontroller,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  //border: OutlineInputBorder(),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please enter the Password";
                  }
                  return null;
                },
                controller: passwordcontroller,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  //border: OutlineInputBorder(),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              ElevatedButton(
                  onPressed: () {
                    setState(() {
                      if (_formkey.currentState!.validate()) {
                        btn_clidked();
                      }
                    });
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Theme.of(context).colorScheme.primaryContainer,
                      fixedSize: Size(50, 60)),
                  child: Text("Login"))
            ],
          ),
        ),
      ),
    );
  }

  void btn_clidked() {
    String name = namecontroller.text;
    String password = passwordcontroller.text;
    // if (name == "admin" && password == "admin") {
    //   Navigator.push(
    //       context, MaterialPageRoute(builder: (context) => myHome()));
    //   return;
    // }
    Worker? isValid = workers.firstWhere(
      (worker) => worker.name == name && worker.password == password,
      orElse: () => Worker(
          name: '',
          role: '',
          password: ''), // Return an empty Worker instance if not found
    );
    if (isValid.name.isNotEmpty && isValid.password.isNotEmpty) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => myHome(
                    worker: isValid,
                  )));
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Invalid Credentials"),
            content:
                Text("The name or password is incorrect. Please try again."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("Close"),
              ),
            ],
          );
        },
      );
    }
  }
}

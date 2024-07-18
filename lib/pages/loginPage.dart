import 'package:flutter/material.dart';
import 'package:myapp/pages/homePage.dart';
import 'package:myapp/services/firebase_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController namecontroller = new TextEditingController();
  TextEditingController passwordcontroller = new TextEditingController();
  final _formkey = GlobalKey<FormState>();

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
              TextButton(
                onPressed: () {},
                child: Text("data"),
              ),
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
                  border: OutlineInputBorder(),
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
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
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
    Navigator.push(context, MaterialPageRoute(builder: (context) => myHome()));
  }
}

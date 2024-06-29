import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myapp/models/areatostreet.dart';
import 'package:myapp/models/customer.dart';
import 'package:myapp/services/database_service.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class Adduser extends StatefulWidget {
  final Customer? customer;
  final String? appbarTitle;
  Adduser(this.customer, this.appbarTitle);
  @override
  State<Adduser> createState() =>
      _AdduserState(this.customer, this.appbarTitle);
}

class _AdduserState extends State<Adduser> {
  _AdduserState(this.customer, this.appbarTitle);
  Customer? customer;
  String? appbarTitle;
  DatabaseService _databaseService = DatabaseService.instance;
  final _formkey = GlobalKey<FormState>();
  TextEditingController namecontroller = TextEditingController();
  String? streetcontroller;
  TextEditingController packagecontroller = TextEditingController();
  String? areacontroller;
  List<String> areaNames = areas();
  List<String> streetNames = [];
  int aError = 0, sError = 0;

  @override
  Widget build(BuildContext context) {
    if (appbarTitle == "Edit") {
      namecontroller.text = customer!.name;
      areacontroller = customer!.area;
      streetNames = streets(areacontroller!);
      streetcontroller = customer!.street;
      packagecontroller.text = customer!.package;
    }
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          title: Text("$appbarTitle User"),
        ),
        body: Form(
          key: _formkey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
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
                    border: OutlineInputBorder(),
                  ),
                ),
                Padding(padding: EdgeInsets.all(6)),
                Text('Select the Area:'),
                if (aError == 1)
                  Text(
                    'required!',
                    style: TextStyle(color: Colors.red),
                  ),
                DropdownMenu(
                  initialSelection: areacontroller,
                  expandedInsets: EdgeInsets.all(1),
                  //errorText: 'please select',
                  dropdownMenuEntries:
                      areaNames.map<DropdownMenuEntry<String>>((String a) {
                    return DropdownMenuEntry(value: a, label: a);
                  }).toList(),
                  onSelected: (value) {
                    setState(() {
                      if (areacontroller != value) {
                        streetcontroller = null;
                      }
                      areacontroller = value;
                      streetNames = streets(value!);
                      aError = 0;
                    });
                  },
                ),
                Padding(padding: EdgeInsets.all(5)),
                Text('Select the Street:'),
                if (sError == 1)
                  Text(
                    'required!',
                    style: TextStyle(color: Colors.red),
                  ),
                DropdownMenu(
                  initialSelection: streetcontroller,
                  expandedInsets: EdgeInsets.all(1),
                  dropdownMenuEntries:
                      streetNames.map<DropdownMenuEntry<String>>((String a) {
                    return DropdownMenuEntry(value: a, label: a);
                  }).toList(),
                  onSelected: (value) {
                    setState(() {
                      streetcontroller = value;
                      sError = 0;
                    });
                  },
                ),
                Padding(padding: EdgeInsets.all(10)),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter the Package";
                    }
                    return null;
                  },
                  controller: packagecontroller,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    labelText: "Package",
                    border: OutlineInputBorder(),
                  ),
                ),
                Row(
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          setState(() {
                            Navigator.pop(context);
                          });
                        },
                        child: Text("Cancel")),
                    ElevatedButton(
                        onPressed: () {
                          setState(() {
                            if (_formkey.currentState!.validate()) {
                              btn_clicked();
                            }
                          });
                        },
                        style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.black,
                            backgroundColor:
                                Theme.of(context).colorScheme.primaryContainer),
                        child: Text("save")),
                  ],
                )
              ],
            ),
          ),
        ));
  }

  void btn_clicked() {
    setState(() {
      if (areacontroller != null && streetcontroller != null) {
        if (customer == null) {
          customer = Customer(
            name: namecontroller.text,
            area: areacontroller!,
            street: streetcontroller!,
            package: packagecontroller.text,
          );
        } else {
          customer!.name = namecontroller.text;
          customer!.area = areacontroller!;
          customer!.street = streetcontroller!;
          customer!.package = packagecontroller.text;
        }

        _databaseService.addCustomer(customer!);

        Navigator.pop(context);
      } else {
        if (areacontroller == null) aError = 1;
        if (streetcontroller == null) sError = 1;
      }
    });
  }
}

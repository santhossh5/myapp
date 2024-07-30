import 'package:flutter/material.dart';
import 'package:myapp/models/areatostreet.dart';
import 'package:myapp/pages/listUsers.dart';

class selectStreet extends StatefulWidget {
  const selectStreet({super.key});

  @override
  State<selectStreet> createState() => _selectStreetState();
}

class _selectStreetState extends State<selectStreet> {
  String? areacontroller;
  String? streetcontroller;
  List<String> areaNames = areas();
  List<String> streetNames = [];
  int aError = 0, sError = 0;
  int error = 0;
  @override
  Widget build(BuildContext context) {
    streetNames = streets(areacontroller);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          title: const Text("Select address"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownMenu(
                label: Text("Area"),
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
              if (sError == 1)
                Text(
                  'required!',
                  style: TextStyle(color: Colors.red),
                ),
              DropdownMenu(
                label: Text("Street"),
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
              ElevatedButton(
                  onPressed: () {
                    if (streetcontroller != null) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  listUsers(street: streetcontroller)));
                    } else {
                      setState(() {
                        error = 1;
                      });
                    }
                  },
                  child: const Text("show"))
            ],
          ),
        ));
  }
}

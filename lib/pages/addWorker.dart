import 'package:flutter/material.dart';
import 'package:myapp/models/worker.dart';
import 'package:myapp/services/firebase_service.dart';

class WorkerList extends StatefulWidget {
  const WorkerList({super.key});

  @override
  State<WorkerList> createState() => _WorkerListState();
}

class _WorkerListState extends State<WorkerList> {
  TextEditingController searchController = TextEditingController();
  FirebaseService _firebaseService = FirebaseService();
  final _formkey = GlobalKey<FormState>();
  List<Worker> workers = [];
  List<Worker> filteredWorkers = [];

  @override
  void initState() {
    super.initState();
    fetchWorkers();
  }

  Future<void> fetchWorkers() async {
    workers = await _firebaseService.getWorkers();
    setState(() {
      filteredWorkers = workers;
    });
  }

  void filterWorkers(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredWorkers = workers;
      } else {
        filteredWorkers = workers
            .where((worker) =>
                worker.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  void addWorker(String name, String password, String role) {
    setState(() {
      Worker worker = Worker(name: name, password: password, role: role);
      _firebaseService.addWorker(worker);
      workers.add(worker);
      filteredWorkers = workers;
    });
  }

  void editWorker(Worker worker) {
    _firebaseService.updateWorker(worker).then((_) {
      fetchWorkers();
    });
  }

  void showAddWorkerDialog() {
    String newName = '';
    String newPassword = '';
    String newRole = 'Worker';
    List<String> roles = ['Admin', 'Worker'];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: AlertDialog(
            title: Text("Add New Worker"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    onChanged: (value) {
                      newName = value;
                    },
                    decoration: InputDecoration(
                      labelText: "Name",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    onChanged: (value) {
                      newPassword = value;
                    },
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Password",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownButtonFormField<String>(
                    value: newRole,
                    decoration: InputDecoration(
                      labelText: "Role",
                      border: OutlineInputBorder(),
                    ),
                    items: roles.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      setState(() {
                        newRole = value!;
                      });
                    },
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("Cancel"),
              ),
              TextButton(
                onPressed: () {
                  if (newName.isNotEmpty &&
                      newPassword.isNotEmpty &&
                      newRole.isNotEmpty) {
                    addWorker(newName, newPassword, newRole);
                  }
                  Navigator.of(context).pop();
                },
                style: TextButton.styleFrom(
                  backgroundColor:
                      Theme.of(context).colorScheme.primaryContainer,
                ),
                child: Text(
                  "Add",
                  
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void tapWorker(Worker selectedWorker) {
    TextEditingController nameController =
        TextEditingController(text: selectedWorker.name);
    TextEditingController passwordController =
        TextEditingController(text: selectedWorker.password);
    String role = selectedWorker.role;
    List<String> roles = ['Admin', 'Worker'];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: AlertDialog(
            title: Text("Edit Worker"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: "Name",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Password",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownButtonFormField<String>(
                    value: role,
                    decoration: InputDecoration(
                      labelText: "Role",
                      border: OutlineInputBorder(),
                    ),
                    items: roles.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      setState(() {
                        role = value!;
                      });
                    },
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("Cancel"),
              ),
              TextButton(
                onPressed: () {
                  selectedWorker.name = nameController.text;
                  selectedWorker.password = passwordController.text;
                  selectedWorker.role = role;
                  if (selectedWorker.name.isNotEmpty &&
                      selectedWorker.password.isNotEmpty &&
                      selectedWorker.role.isNotEmpty) {
                    editWorker(selectedWorker);
                  }
                  Navigator.of(context).pop();
                },
                style: TextButton.styleFrom(
                  backgroundColor:
                      Theme.of(context).colorScheme.primaryContainer,
                ),
                child: Text(
                  "Save",
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                    _firebaseService.deleteWorker(selectedWorker).then((_) {
                      fetchWorkers();
                    });
                  });
                },
                style: TextButton.styleFrom(backgroundColor: Colors.red),
                child: Text(
                  "Delete",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        title: Text("Worker Details"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController,
                    onChanged: filterWorkers,
                    decoration: InputDecoration(
                      labelText: "Search",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: showAddWorkerDialog,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Theme.of(context).colorScheme.primaryContainer,
                  ),
                  child: Icon(Icons.add),
                ),
              ],
            ),
          ),
          ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(child: Text("Name")),
                Expanded(child: Text("Role")),
                Expanded(child: Text("Password")),
              ],
            ),
          ),
          Divider(),
          Expanded(
            child: ListView.builder(
              itemCount: filteredWorkers.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(child: Text(filteredWorkers[index].name)),
                      Expanded(child: Text(filteredWorkers[index].role)),
                      Expanded(child: Text(filteredWorkers[index].password)),
                    ],
                  ),
                  onTap: () => tapWorker(filteredWorkers[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

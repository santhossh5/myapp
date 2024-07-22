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
  FirebaseService _firebaseService = new FirebaseService();
  final _formkey = GlobalKey<FormState>();
  List<Worker> workers = []; // Example worker list
  List<Worker> filteredWorkers = [];

  @override
  void initState() {
    super.initState();
    fetchWorkers();
    filteredWorkers = workers;
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

  void addWorker(String name, String password) {
    // Add worker to the list (in a real app, you would also save to a database)
    setState(() {
      Worker worker = new Worker(name: name, password: password);
      _firebaseService.addWorker(worker);
      workers.add(worker);
      filteredWorkers = workers;
    });
  }

  void editWorker(Worker worker) {
    setState(() {
      _firebaseService.updateWorker(worker).then((_) {
        fetchWorkers();
      });
    });
  }

  void showAddWorkerDialog() {
    String newName = '';
    String newPassword = '';
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Add New Worker"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) {
                  newName = value;
                },
                decoration: InputDecoration(labelText: "Name"),
              ),
              TextField(
                onChanged: (value) {
                  newPassword = value;
                },
                obscureText: true,
                decoration: InputDecoration(labelText: "Password"),
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
                if (newName.isNotEmpty && newPassword.isNotEmpty) {
                  addWorker(newName, newPassword);
                }
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                  backgroundColor:
                      Theme.of(context).colorScheme.primaryContainer),
              child: Text("Add"),
            ),
          ],
        );
      },
    );
  }

  void tapWorker(Worker selectedWorker) {
    TextEditingController namecontroller =
        new TextEditingController(text: selectedWorker.name);
    TextEditingController passwordcontroller =
        new TextEditingController(text: selectedWorker.password);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Add New Worker"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: namecontroller,
                decoration: InputDecoration(labelText: "Name"),
              ),
              TextField(
                controller: passwordcontroller,
                obscureText: true,
                decoration: InputDecoration(labelText: "Password"),
              ),
            ],
          ),
          actions: [
            TextButton(
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                    _firebaseService.deleteWorker(selectedWorker).then((_){
                      fetchWorkers();
                    });
                  });
                },
                style: TextButton.styleFrom(backgroundColor: Colors.red),
                child: Text(
                  "Delete",
                  style: TextStyle(color: Colors.white),
                )),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                selectedWorker.name = namecontroller.text;
                selectedWorker.password = passwordcontroller.text;
                if (selectedWorker.name.isNotEmpty &&
                    selectedWorker.password.isNotEmpty) {
                  editWorker(selectedWorker);
                }
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                  backgroundColor:
                      Theme.of(context).colorScheme.primaryContainer),
              child: Text("Save"),
            ),
          ],
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
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  style: IconButton.styleFrom(
                      backgroundColor:
                          Theme.of(context).colorScheme.primaryContainer),
                  onPressed: showAddWorkerDialog,
                ),
              ],
            ),
          ),
          ListTile(
            title: Text("Name"),
            trailing: Text(
              "Password",
              style: TextStyle(fontSize: 15),
            ),
          ),
          Divider(
            indent: 10,
            endIndent: 10,
            height: 5,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredWorkers.length,
              itemBuilder: (context, index) {
                return ListTile(
                    title: Text("${filteredWorkers[index].name}"),
                    trailing: Text(
                      "${filteredWorkers[index].password}",
                      style: TextStyle(fontSize: 15),
                    ),
                    onTap: () => tapWorker(filteredWorkers[index]));
              },
            ),
          ),
        ],
      ),
    );
  }
}

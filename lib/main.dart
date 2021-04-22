import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
        accentColor: Colors.orange,
        primaryColor: Colors.blue[100],
        brightness: Brightness.light),
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List todos = List();
  String input = "";
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  createTodos() {
    DocumentReference documentReference =
        firestore.collection("MyTodos").doc(input);
    //Map
    Map<String, String> todos = {"todoTitle": input};
    documentReference.set(todos).whenComplete(() => print("$input created"));
  }

  @override
  void initState() {
/*     super.initState();
    todos.add("Item1");
    todos.add("Item2");
    todos.add("Item3"); */
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My To-do list'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  title: Text("Add Todo"),
                  content: TextField(onChanged: (String value) {
                    input = value;
                  }),
                  actions: <Widget>[
                    FlatButton(
                        onPressed: () {
                          setState(() {
                            if (input != "") {
                              todos.add(input);
                              input = "";
                            }
                          });
                          Navigator.of(context).pop();
                        },
                        child: Text("Add"))
                  ],
                );
              });
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: ListView.builder(
        itemCount: todos.length,
        itemBuilder: (BuildContext context, int index) {
          return Dismissible(
            key: Key(todos[index]),
            child: Card(
              elevation: 4,
              margin: EdgeInsets.all(8),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              child: ListTile(
                title: Text(todos[index]),
                trailing: IconButton(
                  icon: Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                  onPressed: () {
                    setState(() {
                      todos.removeAt(index);
                    });
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

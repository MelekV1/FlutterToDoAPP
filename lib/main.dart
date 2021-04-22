import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primaryColor: Colors.blue[50],
      brightness: Brightness.light,
    ),
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  //List todos = List();
  String input = "";
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  createTodos() {
    DocumentReference documentReference =
        firestore.collection("MyTodos").doc(input);
    //Map
    Map<String, String> todos = {"todoTitle": input};
    documentReference.set(todos).whenComplete(() => print("$input created"));
  }

  deleteTodos(item) {
    DocumentReference documentReference =
        firestore.collection("MyTodos").doc(item);
    documentReference.delete().whenComplete(() => print("$input deleted"));
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
        backgroundColor: Colors.blueGrey,
        appBar: AppBar(
          title: Center(
              child: Text(
            'My Todo list',
            style: TextStyle(
              fontFamily: 'Pacifico-Regular',
            ),
          )),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.red,
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
                            createTodos();
                            /*  setState(() {
                            if (input != "") {
                              todos.add(input);
                              input = "";
                            }
                          }); */
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
        body: StreamBuilder(
            stream: firestore.collection("MyTodos").snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshots) {
              return ListView.builder(
                itemCount: snapshots.data.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot documentSnapshot =
                      snapshots.data.docs[index];
                  //print(documentSnapshot["todoTitle"]);
                  return Dismissible(
                    onDismissed: (direction) {
                      deleteTodos(documentSnapshot["todoTitle"]);
                    },
                    key: Key(documentSnapshot["todoTitle"]),
                    child: Card(
                      elevation: 4,
                      margin: EdgeInsets.all(8),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      child: ListTile(
                        title: Text(documentSnapshot["todoTitle"]),
                        trailing: IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            setState(() {
                              deleteTodos(documentSnapshot["todoTitle"]);
                              //todos.removeAt(index);
                            });
                          },
                        ),
                      ),
                    ),
                  );
                },
              );
            }));
  }
}

import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: const MyHomePage(title: 'API HANDLING'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<List<User>> getUserData() async {
    var response =
        await http.get(Uri.https('jsonplaceholder.typicode.com', 'posts'));
    var jsonData = jsonDecode(response.body);

    List<User> users = [];
    for (var u in jsonData) {
      User user = User(u['title'], u['body']);
      users.add(user);
    }
    return users;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Container(
          color: Colors.blueGrey,
          child: Card(
            child: FutureBuilder<List<User>>(
              future: getUserData(),
              builder: (context, snapshot) {
                if (snapshot.data == null) {
                  return Container(
                    child: const Center(
                      child: Text('Loading...'),
                    ),
                  );
                } else {
                  return ListView.builder(
                    padding: EdgeInsets.all(5),
                    itemCount: snapshot.data!.length,
                    itemBuilder: ((context, i) {
                      return Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: ListTile(
                          contentPadding: EdgeInsets.all(4),
                          leading: const Icon(Icons.add_a_photo,
                              color: Colors.blueGrey, size: 40),
                          tileColor: Colors.teal.shade100,
                          title: Text(
                            snapshot.data![i].titles ?? "Title",
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            snapshot.data![i].bodys ?? "body",
                            style: const TextStyle(
                              fontSize: 10,
                            ),
                          ),
                        ),
                      );
                    }),
                  );
                }
              },
            ),
          ),
        )
        // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}

class User {
  final titles, bodys;

  User(this.titles, this.bodys);
}

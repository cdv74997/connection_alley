import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connection_alley/widgets/text_box.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FriendsPage extends StatefulWidget {
  const FriendsPage({super.key});

  @override 
  State<FriendsPage> createState() => _FriendsPageState();
}


class _FriendsPageState extends State<FriendsPage> {
  // user
  final currentUser = FirebaseAuth.instance.currentUser!;
  // all users
  //final usersCollection = FirebaseFirestore.instance.collection("Users");

  List<Map<String, dynamic>> _mockUsers = [
    {"id": 1, "name": "test1", "email": 'test1@email.com'},
    {"id": 2, "name": "name2", "email": 'test2@email.com'},
    {"id": 3, "name": "ab", "email": 'test3@email.com'},
    {"id": 4, "name": "abc", "email": 'test4@email.com'},
    {"id": 5, "name": "tab", "email": 'test5@email.com'},
    {"id": 6, "name": "test6", "email": 'test6@email.com'},
    {"id": 7, "name": "test7", "email": 'test7@email.com'},
    {"id": 8, "name": "test8", "email": 'test8@email.com'},
    {"id": 9, "name": "test9", "email": 'test9@email.com'},
    {"id": 10, "name": "test10", "email": 'test10@email.com'},
    {"id": 11, "name": "test11", "email": 'test11@email.com'},
  ];

  List<Map<String, dynamic>> _foundUsers = [];
  @override
  initState() {
    _foundUsers = _mockUsers;
    super.initState();
  }

  void _runFilter(String enteredKeyword){
    List<Map<String, dynamic>> results = [];
    if (enteredKeyword.isEmpty) {
      results = _mockUsers;
    }
    else {
      results = _mockUsers.where((user) => user["name"].toLowerCase().contains(enteredKeyword.toLowerCase())).
      toList();
    }

    setState((){
      _foundUsers = results;
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text("Friends Page"),
        ),
        body:  Padding(padding: const EdgeInsets.all(14.0),
        child: Column(children: [
          const SizedBox( height: 20,), 
          TextField (onChanged: (value) => _runFilter(value),
          decoration: InputDecoration( 
            labelText: "Search friends", suffixIcon: Icon(Icons.search)),),
            const SizedBox (height: 20,),
          Expanded (
            child: ListView.builder(
            itemCount: _foundUsers.length,
            itemBuilder: (context, index) => Card(
              key: ValueKey(_foundUsers[index]["id"]),
              color: Colors.green,
              elevation: 4,
              margin: const EdgeInsets.symmetric(vertical: 4),
              child: ListTile(
                leading: Text(
                  _mockUsers[index]["id"].toString(),
                  style: const TextStyle(fontSize: 24, color: Colors.white),),
                  title: Text(_foundUsers[index]['name'],
                  style: TextStyle(color: Colors.white)), 
                  subtitle: Text('${_foundUsers[index]["email"]}',
                  style: TextStyle(color: Colors.white)),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.message),
                        onPressed: () {
                          // Logic here to message a friend
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.person),
                        onPressed: () {
                          // Logic here to view profile
                        },
                      ),
                    ],
                  ),
              ), 
              
              ),
            ),
          )
        ]),
      ));
    }
}
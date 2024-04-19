import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connection_alley/widgets/user.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SearchUserView extends StatefulWidget {
  @override
  _SearchUserViewState createState() => _SearchUserViewState();
}

class _SearchUserViewState extends State<SearchUserView> {
  final user = FirebaseAuth.instance.currentUser!;
  String searchText = '';

  // Function to handle searching for users
  void searchUsers(String query) {
    // Implement the search functionality here
    // You can use the query parameter to search for users
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Users'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchText = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search for users...',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("Users")
                  .orderBy("username", descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final filteredUsers = snapshot.data!.docs.where((user) {
                    final userData = user.data() as Map<String, dynamic>;
                    final email = userData['email'];
                    final bio = userData['bio'] as String;
                    final username = userData['username'] as String;
                    return username.contains(searchText);
                  }).toList();

                  return ListView.builder(
                    itemCount: filteredUsers.length,
                    itemBuilder: (context, index) {
                      // Replace with user widget
                      final user = filteredUsers[index];
                      return UserWidget(
                        email: user.id,
                        bio: user['bio'],
                        username: user['username'],
                      );
                    },
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

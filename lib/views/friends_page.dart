import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FriendsPage extends StatefulWidget {
  const FriendsPage({Key? key}) : super(key: key);

  @override
  State<FriendsPage> createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  late Stream<List<DocumentSnapshot>> friendsStream;

  @override
  void initState() {
    super.initState();
    friendsStream = FirebaseFirestore.instance
        .collection('Friends')
        .where('pair', arrayContains: currentUser.email)
        .snapshots()
        .map((snapshot) => snapshot.docs);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text("Friends Page"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          children: [
            SizedBox(height: 20),
            TextField(
              onChanged: _runFilter,
              decoration: InputDecoration(
                labelText: "Search friends",
                suffixIcon: Icon(Icons.search),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<List<DocumentSnapshot>>(
                stream: friendsStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text("You have no friends yet."));
                  }
                  final friends = snapshot.data!;
                  return ListView.builder(
                    itemCount: friends.length,
                    itemBuilder: (context, index) {
                      final friendData = friends[index];
                      final friendEmail = friendData['pair']
                          .firstWhere((email) => email != currentUser.email);
                      
                      return Card(
                        key: ValueKey(friends[index].id),
                        color: Colors.green,
                        elevation: 4,
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        child: ListTile(
                          leading: CircleAvatar(
                            child: Icon(Icons.person),
                          ),
                          title: Text(
                            friendEmail.split('@')[0],
                            style: TextStyle(color: Colors.white),
                          ),
                          subtitle: Text(
                            friendEmail,
                            style: TextStyle(color: Colors.white),
                          ),
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
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _runFilter(String enteredKeyword) {
    // Implement your filter logic here
  }
}

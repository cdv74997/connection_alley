
import 'package:connection_alley/views/message_backend_con.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Conversation extends StatelessWidget {
  final String recipientID;
  final String message;
  final Timestamp time;
  

  const Conversation({
    Key? key,
    required this.recipientID,
    required this.message,
    required this.time,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    return GestureDetector(
      onTap: () {
        // Add your onTap logic here
        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => MessagePage(
                              currentUserID: user.email!,
                              otherUserID: recipientID,
                            )),
                          );
        print('Tapped on conversation with recipientID: $recipientID');
      },
      child: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('Users')
            .doc(recipientID)
            .get(),
        builder: (context, userSnapshot) {
          if (userSnapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          if (userSnapshot.hasError) {
            return Text('Error: ${userSnapshot.error}');
          }
          final user = userSnapshot.data!;
          return ListTile(
            leading: CircleAvatar(
              // Use user profile picture
              
            ),
            title: Text(
              recipientID,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(message),
          );
        },
      ),
    );
  }
}

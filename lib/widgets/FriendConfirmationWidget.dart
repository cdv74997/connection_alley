import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connection_alley/views/message_backend_con.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FriendConfirmationWidget extends StatelessWidget {
  final String sender;
  final String recipient;

  const FriendConfirmationWidget({
    Key? key,
    required this.sender,
    required this.recipient,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    User? currentUser = FirebaseAuth.instance.currentUser;

    // Check if currentUser is not null
    if (currentUser != null) {
      String currentUserID = currentUser.email!;

      // Determine otherUserID based on whether currentUserID matches sender or recipient
      String otherUserID = currentUserID == sender ? recipient : sender;

      return Container(
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'You are now friends with $sender!',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MessagePage(
                          currentUserID: currentUserID,
                          otherUserID: otherUserID,
                        ),
                      ),
                    );
                  },
                  child: Text(
                    'Message',
                    style: TextStyle(
                      color: Colors.blue,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    // Implement deletion of notification
                    List<String> sortedEmails = [sender, recipient]..sort();
      String compositeKey = sortedEmails.join('-');
      // Delete the document from the "New Friends" collection
    try {
       FirebaseFirestore.instance.collection('New Friends').doc(compositeKey).delete();
    } catch (error) {
      print('Failed to delete document: $error');
    }
                  },
                  icon: Icon(
                    Icons.close,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    } else {
      // Handle the case where the current user is null (not signed in)
      return Container(
        child: Text('Current user not found!'),
      );
    }
  }
}

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connection_alley/views/single_post.dart';

class NotificationWidget extends StatelessWidget {
  final String id;
  final String recipient;
  final String postId;
  final String message;
  final Timestamp time;
  final bool read;

  const NotificationWidget({
    Key? key,
    required this.id,
    required this.postId,
    required this.read,
    required this.recipient,
    required this.message,
    required this.time,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        try {
          // Fetch the post document
          DocumentSnapshot postSnapshot =
              await FirebaseFirestore.instance.collection('User Posts').doc(postId).get();

          // Check if the document exists
          if (postSnapshot.exists) {
            // Navigate to SinglePost view with postId passed in
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SinglePost(postId: postId),
              ),
            );
          } else {
            // Show dialog if post not found
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('Post Not Found'),
                content: Text('The referenced post was not found.'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('OK'),
                  ),
                ],
              ),
            );
          }
        } catch (error) {
          // Handle any errors
          print('Error fetching post: $error');
        }
      },
      child: Container(
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Notification for: $recipient',
              style: TextStyle(
                fontWeight: read ? FontWeight.normal : FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              message,
              style: TextStyle(
                fontSize: 16,
                fontWeight: read ? FontWeight.normal : FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Time: ${time.toDate()}',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

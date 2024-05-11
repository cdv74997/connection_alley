import 'package:connection_alley/helper/helper_methods.dart';
import 'package:connection_alley/views/single_post.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connection_alley/widgets/wall_post.dart'; // Import WallPost view

class NotificationWidget extends StatelessWidget {
  final String recipient;
  final String postId;
  final String message;
  final Timestamp time;
  final bool read;

  const NotificationWidget({
    Key? key,
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
        // Fetch the post document
        

        // Update read field if it's initially false
        //if (!read) {
          //await FirebaseFirestore.instance.collection("Notifications").doc(postId).update({
           // 'read': true,
         // });
       // }

        // Navigate to WallPost view with postId passed in
        Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => SinglePost(postId: postId),
  ),
);
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

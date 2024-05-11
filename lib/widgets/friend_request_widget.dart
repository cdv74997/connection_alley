import 'package:connection_alley/helper/helper_methods.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FriendRequestWidget extends StatefulWidget {
  final String sender;
  final String recipient;
  final bool accepted;
  final Timestamp time;

  const FriendRequestWidget({
    Key? key,
    required this.sender,
    required this.recipient,
    required this.accepted,
    required this.time,
  }) : super(key: key);

  @override
  _FriendRequestWidgetState createState() => _FriendRequestWidgetState();
}

class _FriendRequestWidgetState extends State<FriendRequestWidget> {
  bool accepted = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: accepted
          ? _buildAcceptedWidget()
          : Container(
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
                    'You have a friend request from: ${widget.sender}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          _acceptFriendRequest();
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.blue, // Set button color to dark blue
                        ),
                        child: Text('Accept'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _ignoreFriendRequest();
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.grey[800], // Set button color to dark grey
                        ),
                        child: Text('Ignore'),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Time: ${widget.time.toDate()}',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildAcceptedWidget() {
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
            '${widget.sender} is now a friend',
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
                  // Implement message functionality
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
  }

  void _acceptFriendRequest() {
    setState(() {
      accepted = true;
    });
    // Add to 'Friends' database
    // Create a sorted list of sender and recipient emails
    List<String> sortedEmails = [widget.sender, widget.recipient]..sort();
    String compositeKey = sortedEmails.join('-');
    FirebaseFirestore.instance.collection('Friends').doc(compositeKey).set({
      'pair': [widget.sender, widget.recipient],
      'sender': widget.sender,
      'receiver': widget.recipient,
    });

    // Change notification message
    // You can use a snackbar or other means to notify the user.
  }

  void _ignoreFriendRequest() {
    // Implement ignore functionality
  }
}

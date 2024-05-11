import 'package:connection_alley/helper/helper_methods.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FriendRequestWidget extends StatelessWidget {
  final String sender;
  final String recipient;
  final Timestamp time;
  final bool accepted;

  const FriendRequestWidget({
    Key? key,
    required this.sender,
    required this.recipient,
    required this.time,
    required this.accepted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
            'You have a friend request from: $sender',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: () {
                  // Accept friend request functionality
                },
                child: Text('Accept'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Ignore friend request functionality
                },
                child: Text('Ignore'),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            formatDate(time),
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

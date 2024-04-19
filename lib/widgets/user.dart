import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


class UserWidget extends StatelessWidget {
  final String email;
  final String username;
  final String bio;

  const UserWidget({
    required this.email,
    required this.username,
    required this.bio,
  });
  @override
  Widget build(BuildContext context) {
    User? currentUser = FirebaseAuth.instance.currentUser;
    bool isCurrentUser = currentUser?.email == email;
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: ListTile(
        leading: CircleAvatar(
          // Replace with user profile image
          child: Icon(Icons.person),
        ),
        title: Text(username), // Replace with actual username
        subtitle: Text(bio), // Replace with actual user bio
        trailing: isCurrentUser
            ? SizedBox() 
            : Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.person),
              onPressed: () {
                // View Profile
              },
            ),
            IconButton(
              icon: Icon(Icons.message),
              onPressed: () {
                // Send Message
              },
            ),
            IconButton(
              icon: Icon(Icons.person_add),
              onPressed: () {
                // Add Friend
              },
            ),
          ],
        ),
      ),
    );
  }
}

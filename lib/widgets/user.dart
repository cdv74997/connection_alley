import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:connection_alley/views/message_backend_con.dart';
import 'package:connection_alley/widgets/public_user_profile.dart'; 


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
                  Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UserProfilePage(userId: email)),);
              },
            ),
            IconButton(
  icon: Icon(Icons.message),
  onPressed: () async {
    // Query the Users collection to find the user ID based on the email
    

    // Check if the query returned any documents
    
      // Extract the user ID from the first document
      

      // Navigate to the message page with the user IDs
      // ignore: use_build_context_synchronously
      Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => MessagePage(
                              currentUserID: currentUser!.email!,
                              otherUserID: email,
                            )),
                          );
    
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

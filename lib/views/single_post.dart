import 'package:connection_alley/helper/helper_methods.dart';
import 'package:connection_alley/widgets/wall_post.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SinglePost extends StatelessWidget {
  final String postId;

  const SinglePost({Key? key, required this.postId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('User Posts').doc(postId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(
              child: Text('Post not found!'),
            );
          }

          final postData = snapshot.data!;
          final message = postData['Message'];
          final user = postData['UserEmail'];
          final time = formatDate(postData['TimeStamp']);
          final likes = List<String>.from(postData['Likes']);

          return WallPost(
            message: message,
            user: user,
            time: time,
            postId: postId,
            likes: likes,
          );
        },
      ),
    );
  }
}

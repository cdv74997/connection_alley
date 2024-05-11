import 'package:connection_alley/helper/helper_methods.dart';
import 'package:connection_alley/views/home_view.dart';
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
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('User Posts').doc(postId).snapshots(),
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
            Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HomeView()),
    );
            return Center(
    child: CircularProgressIndicator(),
  );
            
          }

          final postData = snapshot.data!;
          return WallPost(
            postId: postId,
            user: postData['UserEmail'],
            time: formatDate(postData['TimeStamp']),
            message: postData['Message'],
            likes: List<String>.from(postData['Likes']),
          );
        },
      ),
    );
  }
}

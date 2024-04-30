import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:connection_alley/helper/helper_methods.dart';
import 'package:connection_alley/widgets/comment.dart';
import 'package:connection_alley/widgets/comment_button.dart';
import 'package:connection_alley/widgets/delete_button.dart';
import 'package:connection_alley/widgets/like_button.dart';
import 'package:connection_alley/widgets/share_button.dart'; // Import the share button widget

class WallPost extends StatefulWidget {
  final String message;
  final String user;
  final String time;
  final String postId;
  final List<String> likes;

  const WallPost({
    Key? key,
    required this.message,
    required this.user,
    required this.time,
    required this.postId,
    required this.likes,
  });

  @override
  State<WallPost> createState() => _WallPostState();
}

class _WallPostState extends State<WallPost> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  bool isLiked = false;

  final _commentTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    isLiked = widget.likes.contains(currentUser.email);
  }

  void toggleLike() {
    setState(() {
      isLiked = !isLiked;
    });

    DocumentReference postRef =
        FirebaseFirestore.instance.collection('User Posts').doc(widget.postId);

    if (isLiked) {
      postRef.update({
        'Likes': FieldValue.arrayUnion([currentUser.email])
      });
    } else {
      postRef.update({
        'Likes': FieldValue.arrayRemove([currentUser.email])
      });
    }
  }

  // add comment
  void addComment(String commentText) {
    FirebaseFirestore.instance.collection("User Posts").doc(widget.postId).collection("Comments").add({
      "CommentText": commentText,
      "CommentedBy": currentUser.email,
      "CommentTime": Timestamp.now(),
    });
  }

  // show a dialog for adding a comment
  void showCommentDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Add Comment"),
        content: TextField(
          controller: _commentTextController,
          decoration: InputDecoration(hintText: "Write a comment.."),
        ),
        actions: [
          // cancel button
          TextButton(
            onPressed: () {
              Navigator.pop(context);

              // clear controller
              _commentTextController.clear();
            },
            child: Text("Cancel"),
          ),
          // save button
          TextButton(
            onPressed: () {
              addComment(_commentTextController.text);

              // pop box
              Navigator.pop(context);

              // clear controller
              _commentTextController.clear();
            },
            child: Text("Post"),
          ),
        ],
      ),
    );
  }

  // delete a post
  void deletePost() {
    // show a dialog box foo to ask for confirmation for deleting the post
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Post"),
        content: const Text("Are you sure you want to delete this post?"),
        actions: [
          // cancel button
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),

          // delete button
          TextButton(
            onPressed: () async {
              // delete the comments from firebase first
              final commentDocs = await FirebaseFirestore.instance.collection("User Posts").doc(widget.postId).collection("Comments").get();

              for (var doc in commentDocs.docs) {
                await FirebaseFirestore.instance.collection("User Posts").doc(widget.postId).collection("Comments").doc(doc.id).delete();
              }

              // then delete the post
              FirebaseFirestore.instance.collection("User Posts").doc(widget.postId).delete().then((value) => print("post deleted")).catchError((error) => print("failed to delete post: $error"));

              // delete the dialog
              Navigator.pop(context);
            },
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(8),
      ),
      margin: EdgeInsets.only(top: 25, left: 25, right: 25),
      padding: EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // user and time
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.user,
                style: TextStyle(color: Colors.grey[900], fontWeight: FontWeight.bold),
              ),
              Text(
                widget.time,
                style: TextStyle(color: Colors.grey[900]),
              ),
            ],
          ),
          SizedBox(height: 10),
          // message
          Text(
            widget.message,
            style: TextStyle(color: Colors.black),
          ),
          SizedBox(height: 20),
          // like, comment, and share buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              LikeButton(isLiked: isLiked, onTap: toggleLike),
              CommentButton(onTap: showCommentDialog),
              ShareButton(onTap: (){}), // Add the share button here
            ],
          ),
          SizedBox(height: 10),
          // number of likes
          Text(
            widget.likes.length.toString(),
            style: TextStyle(color: Colors.grey),
          ),
          SizedBox(height: 20),
          // comments under the post
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection("User Posts").doc(widget.postId).collection("Comments").orderBy("CommentTime", descending: true).snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              return ListView(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: snapshot.data!.docs.map((doc) {
                  final commentData = doc.data() as Map<String, dynamic>;
                  return Comment(
                    text: commentData["CommentText"],
                    user: commentData["CommentedBy"],
                    time: formatDate(commentData["CommentTime"]),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}

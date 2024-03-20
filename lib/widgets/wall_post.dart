import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connection_alley/helper/helper_methods.dart';
import 'package:connection_alley/widgets/comment.dart';
import 'package:connection_alley/widgets/comment_button.dart';
import 'package:connection_alley/widgets/like_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class WallPost extends StatefulWidget {
  final String message;
  final String user;
  final String time;
  final String postId;
  final List<String> likes;

  const WallPost({
    super.key,
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

    DocumentReference postRef = FirebaseFirestore.instance.collection('User Posts').doc(widget.postId);

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
    // write the comment to firestore under the somments collection for this to post
    FirebaseFirestore.instance.collection("User Posts").doc(widget.postId).collection("Comments").add({
      "CommentText": commentText,
      "CommentedBy": currentUser.email,
      "CommentTime": Timestamp.now(), // remember to format this when displaying
    });
  }

  // show a dialog for adding a comment
  void showCommentDialog() {
    showDialog(context: context, builder: (context) => AlertDialog(
      title: Text("Add Commen"),
      content: TextField(
        controller: _commentTextController,
        decoration: InputDecoration(hintText: "Write a comment.."),
      ),
      actions: [

        // cancel button
        TextButton(onPressed: () {
        Navigator.pop(context);

        // clear controller 
        _commentTextController.clear();
        },
        child: Text("Cancel"),
        ),
        // save button
        TextButton(onPressed: () {
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

  @override 
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(8)),
      margin: EdgeInsets.only(top: 25, left: 25, right: 25),
      padding: EdgeInsets.all(25),
      child: Column(

        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          
          // wall post
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // message
              Text(widget.message),
              const SizedBox(height: 5),
              //user
              Row(
                children: [
                  Text(
                    widget.user,
                    style: TextStyle(color: Colors.grey[900])
                  ),
                  Text(
                    " . ",
                    style: TextStyle(color: Colors.grey[900])
                  ),
                  Text(
                    widget.time,
                    style: TextStyle(color: Colors.grey[900])
                  ),
                ],
              ),
              
              
              
            ],
          ),

          const SizedBox(width: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // buttons

          // like
          Column(
            children: [
              LikeButton(isLiked: isLiked, onTap: toggleLike),

              const SizedBox(height: 5),

              Text(widget.likes.length.toString(), style: TextStyle(color: Colors.grey)),
            ],
          ),

          const SizedBox(width: 10),

          // comment
          Column(
            children: [
              // comment button
              CommentButton(onTap: showCommentDialog),

              const SizedBox(height: 5),

              Text('0', style: TextStyle(color: Colors.grey)),
            ],
          ),
            ],
          ),

          const SizedBox(height: 20),

          // comments under the post
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
            .collection("User Posts")
            .doc(widget.postId)
            .collection("Comments")
            .orderBy("CommentTime", descending: true)
            .snapshots(),
            builder: (context, snapshot) {
              // show loading circle if no data yet
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              return ListView(
                shrinkWrap: true, //for nested lists
                physics: const NeverScrollableScrollPhysics(),
                children: snapshot.data!.docs.map((doc) {
                  // get comment from firebase
                  final commentData = doc.data() as Map<String, dynamic>;

                  // return comment
                  return Comment(
                    text: commentData["CommentText"], 
                    user: commentData["CommentedBy"], 
                    time: formatDate(commentData["CommentTime"]), 
                  );
                }).toList(),
              );
            },
            )
        ],
        ),
    );
  }
}
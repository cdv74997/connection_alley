import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:connection_alley/helper/helper_methods.dart';
import 'package:connection_alley/widgets/comment.dart';
import 'package:connection_alley/widgets/comment_button.dart';
import 'package:connection_alley/widgets/like_button.dart';
import 'package:connection_alley/widgets/share_button.dart';
import 'package:connection_alley/widgets/notification_widget.dart';

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

  String _truncateMessage(String message, int maxLength) {
    if (message.length <= maxLength) {
      return message;
    } else {
      return message.substring(0, maxLength) + '...';
    }
  }

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
      }).then((_) {
        // Create a notification for liking the post
        FirebaseFirestore.instance.collection('Notifications').add({
          'recipient': widget.user,
          'message': '${currentUser.email} liked your post "${widget.message}"',
          'time': Timestamp.now(),
          'read': false, // New field: read, default to false
          'postId': widget.postId, // New field: postId
        });
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
    }).then((_) {
      // Create a notification for commenting on the post
      FirebaseFirestore.instance.collection('Notifications').add({
        'recipient': widget.user,
        'message': '${currentUser.email} commented on your post, "${_truncateMessage(widget.message, 20)}"',
        'time': Timestamp.now(),
        'read': false, // New field: read, default to false
        'postId': widget.postId, // New field: postId
      });
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
          // cancel button
          TextButton(
            onPressed: () {
              Navigator.pop(context);

              // clear controller
              _commentTextController.clear();
            },
            child: Text("Cancel"),
          ),
        ],
      ),
    );
  }

  // show a dialog for editing the post
  void showEditDialog() {
    _commentTextController.text = widget.message;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Edit Post"),
        content: TextField(
          controller: _commentTextController,
          decoration: InputDecoration(hintText: "Edit your post.."),
        ),
        actions: [
          // save button
          TextButton(
            onPressed: () {
              // Update the post with the edited message
              String editedMessage = _commentTextController.text;
              FirebaseFirestore.instance.collection("User Posts").doc(widget.postId).update({
                "Message": editedMessage,
              }).then((_) {
                // Close the dialog
                Navigator.pop(context);

                // Clear controller
                _commentTextController.clear();
              }).catchError((error) {
                // Handle the error
                print("Error updating post: $error");
              });
            },
            child: Text("Save"),
          ),
          // cancel button
          TextButton(
            onPressed: () {
              Navigator.pop(context);

              // clear controller
              _commentTextController.clear();
            },
            child: Text("Cancel"),
          ),
        ],
      ),
    );
  }

  // show a confirmation dialog before deleting the post
  void showDeleteConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Delete Post"),
        content: Text("Are you sure you want to delete this post?"),
        actions: [
          // Yes button
          TextButton(
            onPressed: () {
              // Delete the post
              FirebaseFirestore.instance.collection("User Posts").doc(widget.postId).delete().then((_) {
                // Close the dialog
                Navigator.pop(context);
              }).catchError((error) {
                // Handle the error
                print("Error deleting post: $error");
              });
            },
            child: Text("Yes"),
          ),
          // No button
          TextButton(
            onPressed: () {
              // Close the dialog
              Navigator.pop(context);
            },
            child: Text("No"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String username = widget.user.split('@')[0];
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(8),
      ),
      margin: EdgeInsets.only(top: 25, left: 25, right: 25),
      padding: (widget.user != currentUser.email) ? EdgeInsets.all(25): EdgeInsets.only(left: 25, right: 25, top: 25, bottom: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Display the delete button if the current user is the author
              if (widget.user == currentUser.email) Row( 
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                
                children: [IconButton(
                  onPressed: showDeleteConfirmationDialog,
                  icon: Icon(Icons.close),
                  color: Colors.red,
                              ),
                
                ],
              ),
          // user and time
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                username,
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 12),
              ),
              Text(
                widget.time,
                style: TextStyle(color: Colors.grey[900], fontSize: 12),
              ),
              
            ],
          ),
          SizedBox(height: 10),
          // message
          Text(
            widget.message,
            style: TextStyle(color: Colors.black, fontSize: 16),
          ),
          SizedBox(height: 20),
          // like, comment, share, and delete buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              LikeButton(isLiked: isLiked, onTap: toggleLike),
              CommentButton(onTap: showCommentDialog),
              ShareButton(onTap: () {}),
              // Display the edit button if the current user is the author
              if (widget.user == currentUser.email) IconButton(
                onPressed: showEditDialog,
                icon: Icon(Icons.edit),
              ),
              
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

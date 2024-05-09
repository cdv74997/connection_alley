import 'package:connection_alley/widgets/conversation.dart';
import 'package:connection_alley/widgets/user.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:connection_alley/helper/helper_methods.dart';
import 'package:connection_alley/views/profile_page.dart';
import 'package:connection_alley/views/search_user_view.dart';
import 'package:connection_alley/views/friends_page.dart';
import 'package:connection_alley/widgets/drawer.dart';
import 'package:connection_alley/widgets/text_input.dart';
import 'package:connection_alley/widgets/wall_post.dart';
import 'package:connection_alley/widgets/notification_widget.dart';



class HomeView extends StatefulWidget {
  HomeView({Key? key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final user = FirebaseAuth.instance.currentUser!;
  final textController = TextEditingController();
  String searchText = '';
  bool showWallPosts = true;
  bool showNotifications = false;
  bool showMessages = false;
  bool showPeople = false;
  bool showFriendRequests = false;

Stream<List<QueryDocumentSnapshot>> _getMessagesStream(String userEmail) {
  return Stream.fromFuture(_getMessages(userEmail));
}

Future<List<QueryDocumentSnapshot>> _getMessages(String userEmail) async {
  // Execute both queries concurrently
  List<QuerySnapshot> snapshots = await Future.wait([
    FirebaseFirestore.instance
        .collection('messages')
        .where('recipientID', isEqualTo: userEmail)
        .orderBy('timestamp', descending: true)
        .get(),
    FirebaseFirestore.instance
        .collection('messages')
        .where('senderID', isEqualTo: userEmail)
        .orderBy('timestamp', descending: true)
        .get(),
  ]);

  // Merge the results of both queries into a single list
  List<QueryDocumentSnapshot> allMessages = [];
  for (var snapshot in snapshots) {
    allMessages.addAll(snapshot.docs);
  }

  // Sort all messages by timestamp in descending order
  allMessages.sort((a, b) {
    Timestamp timestampA = a['timestamp'];
    Timestamp timestampB = b['timestamp'];
    return timestampB.compareTo(timestampA);
  });

  // Create a map to store the most recent message for each conversation
  Map<String, QueryDocumentSnapshot> recentMessagesMap = {};

  // Iterate through the sorted messages and store the most recent message for each conversation
  for (var message in allMessages) {
    final recipientID = message['recipientID'];
    final senderID = message['senderID'];
    final conversationID = _generateConversationID(userEmail, recipientID ?? senderID ?? '');

    // Store the message if it's not already in the map
    if (!recentMessagesMap.containsKey(conversationID)) {
      recentMessagesMap[conversationID] = message;
    }
  }

  // Return the values (most recent messages) of the recentMessagesMap as a list
  return recentMessagesMap.values.toList();
}


  // sign user out
  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  String _generateConversationID(String currentUserID, String otherUserID) {
  // Sort the user IDs alphabetically to maintain consistency
  List<String> sortedUserIDs = [currentUserID, otherUserID]..sort();
  return '${sortedUserIDs[0]}-${sortedUserIDs[1]}';
}


  void goToProfilePage() {
    // pop menu drawer
    Navigator.pop(context);

    // go to profile page
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ProfilePage()),
    );
  }

  void goToFriendsPage() {
    Navigator.pop(context);

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const FriendsPage()),
    );
  }

  void postMessage() {
    // only if text is present in field
    if (textController.text.isNotEmpty) {
      FirebaseFirestore.instance.collection("User Posts").add({
        'UserEmail': user.email,
        'Message': textController.text,
        'TimeStamp': Timestamp.now(),
        'Likes': [],
      });
    }
    setState(() {
      textController.clear();
    });
  }

  void goToSearchUserView() {
    // Navigate to the search user page
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SearchUserView()),
    );
  }

  void markNotificationAsRead(DocumentSnapshot notification) {
  // Mark the notification as read
  FirebaseFirestore.instance.collection("Notifications").doc(notification.id).update({
    'read': true,
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                showWallPosts = true;
                showNotifications = false;
                showFriendRequests = false;
                showMessages = false;
                showPeople = false;
              });
            },
            icon: Icon(
              Icons.home,
              color: showWallPosts ? Colors.blue : null,
            ),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                showWallPosts = false;
                showNotifications = true;
                showFriendRequests = false;
                showMessages = false;
                showPeople = false;
              });
            },
            icon: Stack(
              children: [
                Icon(
                  Icons.notifications,
                  color: showNotifications ? Colors.blue : null,
                ),
                if (!showNotifications)
                  Positioned(
                    right: 0,
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection("Notifications")
                          .where('recipient', isEqualTo: user.email)
                          .where('read', isEqualTo: false)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Container();
                        }
                        final count = snapshot.data!.docs.length;
                        return count > 0
                            ? Container(
                                padding: EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                constraints: BoxConstraints(
                                  minWidth: 16,
                                  minHeight: 16,
                                ),
                                child: Text(
                                  count.toString(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              )
                            : Container();
                      },
                    ),
                  ),
              ],
            ),
          ),
          IconButton(
                      onPressed: () {
                        setState(() {
                          showPeople = false;
                          showMessages = false;
                          showFriendRequests = true;
                          showWallPosts = false;
                          showNotifications = false;
                        });
                      },
                      icon: Icon(Icons.group),
                      color: showFriendRequests ? Colors.blue: null,
                    ),
          IconButton(
            onPressed: () {
              setState(() {
                showPeople = false;
                showMessages = true;
                showFriendRequests = false;
                showWallPosts = false;
                showNotifications = false;
              });
            },
            icon: Icon(
              Icons.message,
              color: showMessages ? Colors.blue : null,
            ),
          ),
          IconButton(
                      onPressed: () {
                        setState(() {
                          showPeople = true;
                          showMessages = false;
                          showFriendRequests = false;
                          showWallPosts = false;
                          showNotifications = false;
                        });
                      },
                      icon: Icon(Icons.person),
                      color: showPeople ? Colors.blue: null,
                    ),
          IconButton(
            onPressed: signUserOut,
            icon: const Icon(
              Icons.logout,
            ),
          )
        ],
      ),
      drawer: MyDrawer(
        onProfileTap: goToProfilePage,
        onSignOut: signUserOut,
        onFriendsTap: goToFriendsPage,
      ),
      body: Column(
        children: [
          if (showWallPosts)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            searchText = value;
                          });
                        },
                        decoration: InputDecoration(
                          hintText: 'Search...',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: goToSearchUserView,
                      icon: Icon(Icons.person),
                    )
                  ],
                ),
              ),
            ),
          Expanded(
            child: showWallPosts
                ? StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("User Posts")
                        .orderBy("TimeStamp", descending: false)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasData) {
                        final filteredPosts = snapshot.data!.docs.where((post) {
                          final postData = post.data() as Map<String, dynamic>;
                          final message = postData['Message'] as String;
                          final user = postData['UserEmail'] as String;
                          return message.contains(searchText) ||
                              user.contains(searchText);
                        }).toList();

                        return ListView.builder(
                          itemCount: filteredPosts.length,
                          itemBuilder: (context, index) {
                            final post = filteredPosts[index];
                            return WallPost(
                              message: post['Message'],
                              user: post['UserEmail'],
                              postId: post.id,
                              likes: List<String>.from(post['Likes'] ?? []),
                              time: formatDate(post["TimeStamp"]),
                            );
                          },
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text('Error: ' + snapshot.error.toString()),
                        );
                      }
                      return Center(child: CircularProgressIndicator());
                    },
                  )
                : showNotifications? StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("Notifications")
                        .where('recipient', isEqualTo: user.email)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasData) {
                        final notifications = snapshot.data!.docs;
                        return ListView.builder(
                          itemCount: notifications.length,
                          itemBuilder: (context, index) {
                            final notification = notifications[index];
                            final data = notification.data();
                            return GestureDetector(
                              onTap: () {
                                // Mark the notification as read when tapped
                                markNotificationAsRead(notification);
                              },
                              child: NotificationWidget(
                                postId: data['postId'],
                                read: data['read'],
                                recipient: data['recipient'],
                                message: data['message'],
                                time: data['time'],
                              ),
                            );
                          },
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text('Error: ' + snapshot.error.toString()),
                        );
                      }
                      return Center(child: CircularProgressIndicator());
                    },
                  )
                  : showPeople
            ? StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("Users")
                  .orderBy("username", descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }
                if (snapshot.hasData) {
                  final filteredUsers = snapshot.data!.docs.where((user) {
                    final userData = user.data() as Map<String, dynamic>;
                    final email = userData['email'];
                    final bio = userData['bio'] as String;
                    final username = userData['username'] as String;
                    return username.contains(searchText);
                  }).toList();

                  return ListView.builder(
                    itemCount: filteredUsers.length,
                    itemBuilder: (context, index) {
                      // Replace with user widget
                      final user = filteredUsers[index];
                      return UserWidget(
                        email: user.id,
                        bio: user['bio'],
                        username: user['username'],
                      );
                    },
                  );
                }  else if (snapshot.hasError) {
                        return Center(
                          child: Text('Error: ' + snapshot.error.toString()),
                        );
                      }
              return Center(child: CircularProgressIndicator());
              },
            ) : showMessages ? StreamBuilder(
  stream: _getMessagesStream(user.email!),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return Center(child: CircularProgressIndicator());
    }
    if (snapshot.hasData) {
      final messages = snapshot.data as List<QueryDocumentSnapshot>;
      return ListView.builder(
        itemCount: messages.length,
        itemBuilder: (context, index) {
          final messageData = messages[index].data() as Map<String, dynamic>;
          if (messageData != null) {
          final recipientID = messageData['recipientID'];
          final senderID = messageData['senderID'];
          final message = messageData['message'];
          final time = messageData['timestamp'];
          String conversationID;
      if (recipientID == user.email) {
        
        conversationID = senderID;
      } else {
       
        conversationID = recipientID;
      }
          return Conversation(
            recipientID: conversationID,
            message: message, 
            time: time, // Handle null case
          );
          }
        },
      );
    } else if (snapshot.hasError) {
      return Center(
        child: Text('Error: ' + snapshot.error.toString()),
      );
    }
    return Center(child: CircularProgressIndicator());
  },
) : Container(),

          ),
Column(
  children: [
    if (showWallPosts)
      Padding(
        padding: const EdgeInsets.all(25.0),
        child: Row(
          children: [
            Expanded(
              child: MyInputField(
                controller: textController,
                hintText: "Post your connected events here.. ",
                obscureText: false,
              ),
            ),
            IconButton(
              onPressed: postMessage,
              icon: const Icon(Icons.arrow_circle_up),
            )
          ],
        ),
      ),
  ],
),
          Text(
            "Logged in as: " + user.email!,
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(
            height: 50,
          ),
        ],
      ),
    );
  }
}

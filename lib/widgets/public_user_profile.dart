import 'package:connection_alley/views/message_backend_con.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connection_alley/widgets/wall_post.dart';
import 'package:connection_alley/helper/helper_methods.dart';

class UserProfilePage extends StatefulWidget {
  final String userId;

  const UserProfilePage({Key? key, required this.userId}) : super(key: key);

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  late User user;
  bool reverserequestExists = false;
  bool requestExists = false;

  Stream<List<QueryDocumentSnapshot>> _getFriendRequestStream(String userEmail, String otherUserEmail) {
    return Stream.fromFuture(_getRequests(userEmail, otherUserEmail));
  }

  Future<List<QueryDocumentSnapshot>> _getRequests(String userEmail, String otherUserEmail) async {
    List<QuerySnapshot> snapshots = await Future.wait([
      FirebaseFirestore.instance
          .collection('Friend Requests')
          .where('recipientId', isEqualTo: userEmail)
          .where('senderId', isEqualTo: otherUserEmail)
          .get(),
      FirebaseFirestore.instance
          .collection('Friend Requests')
          .where('senderId', isEqualTo: userEmail)
          .where('recipientId', isEqualTo: otherUserEmail)
          .get(),
    ]);

    List<QueryDocumentSnapshot> allRequests = [];
    for (var snapshot in snapshots) {
      allRequests.addAll(snapshot.docs);
    }
    return allRequests;
  }

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser!;
    _updateRequestStatus();
  }

  void _updateRequestStatus() {
    FirebaseFirestore.instance
        .collection('Friend Requests')
        .where('senderId', isEqualTo: user.email)
        .where('recipientId', isEqualTo: widget.userId)
        .snapshots()
        .listen((snapshot) {
      setState(() {
        requestExists = snapshot.docs.isNotEmpty;
      });
    });

    FirebaseFirestore.instance
        .collection('Friend Requests')
        .where('senderId', isEqualTo: widget.userId)
        .where('recipientId', isEqualTo: user.email)
        .snapshots()
        .listen((snapshot) {
      setState(() {
        reverserequestExists = snapshot.docs.isNotEmpty;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance.collection('Users').doc(widget.userId).get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError || !snapshot.hasData) {
              return Center(child: Text('Error fetching user data'));
            }

            final userData = snapshot.data!.data() as Map<String, dynamic>;
            final username = userData['username'] ?? 'Username';
            final bio = userData['bio'] ?? 'Bio';

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Placeholder(
                  fallbackHeight: 100,
                ),
                Center(
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        username,
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(
                        bio,
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => MessagePage(
                              currentUserID: user.email!,
                              otherUserID: widget.userId,
                            )),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.blue,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          padding: EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: Text(
                          'Message',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('Friend Requests')
                            .where('senderId', isEqualTo: user.email)
                            .where('recipientId', isEqualTo: widget.userId)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          }
                          if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          }

                          final List<DocumentSnapshot> friendRequests = snapshot.data!.docs;
                          final requestExists = friendRequests.isNotEmpty;

                          if (requestExists) {
                            return ElevatedButton(
                              onPressed: () async {
                                try {
                                  await FirebaseFirestore.instance
                                      .collection('Friend Requests')
                                      .doc(friendRequests.first.id)
                                      .delete();
                                } catch (error) {
                                  print('Error canceling friend request: $error');
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                primary: Colors.red,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                              ),
                              child: Text(
                                'Cancel Request',
                                style: TextStyle(color: Colors.white),
                              ),
                            );
                          } else {
                            return SizedBox(height: 0);
                          }
                        },
                      ),
                      StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('Friend Requests')
                            .where('senderId', isEqualTo: widget.userId)
                            .where('recipientId', isEqualTo: user.email)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          }
                          if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          }

                          final List<DocumentSnapshot> friendRequestsr = snapshot.data!.docs;
                          final reverserequestExists = friendRequestsr.isNotEmpty;

                          if (reverserequestExists) {
                            return Row(
                              children: [
                                ElevatedButton(
                                  onPressed: () async {
                                    try {
                                      await FirebaseFirestore.instance
                                          .collection('Friend Requests')
                                          .doc(friendRequestsr.first.id)
                                          .update({'accepted': true});
                                    } catch (error) {
                                      print('Error accepting friend request: $error');
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.green,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                                  ),
                                  child: Text(
                                    'Accept',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                SizedBox(width: 8),
                                ElevatedButton(
                                  onPressed: () async {
                                    try {
                                      await FirebaseFirestore.instance
                                          .collection('Friend Requests')
                                          .doc(friendRequestsr.first.id)
                                          .delete();
                                    } catch (error) {
                                      print('Error ignoring friend request: $error');
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.red,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                                  ),
                                  child: Text(
                                    'Ignore',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            );
                          } else {
                            return StreamBuilder<List<QueryDocumentSnapshot>>(
                              stream: _getFriendRequestStream(user.email!, widget.userId),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return CircularProgressIndicator();
                                }
                                if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                }
                                final List<QueryDocumentSnapshot> requestList = snapshot.data ?? [];
                                final isRequestListEmpty = requestList.isEmpty;

                                if (isRequestListEmpty) {
                                  return ElevatedButton(
                                    onPressed: () async {
                                      try {
                                        await FirebaseFirestore.instance.collection('Friend Requests').add({
                                          'senderId': user.email,
                                          'recipientId': widget.userId,
                                          'accepted': false,
                                        });
                                      } catch (error) {
                                        print('Error sending friend request: $error');
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.green,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                                    ),
                                    child: Text(
                                      'Add Friend',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  );
                                } else {
                                  return Container();
                                }
                              },
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
                Divider(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Recent Activity',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('User Posts')
                      .where('UserEmail', isEqualTo: widget.userId)
                      .orderBy('TimeStamp', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }
                    final posts = snapshot.data?.docs ?? [];
                    if (posts.isEmpty) {
                      return Center(
                        child: Text('No posts yet'),
                      );
                    }
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: posts.length,
                      itemBuilder: (context, index) {
                        final post = posts[index];
                        final postDate = (post['TimeStamp'] as Timestamp).toDate();
                        return Column(
                          children: [
                            WallPost(
                              message: post['Message'],
                              user: post['UserEmail'],
                              time: formatDate(post['TimeStamp']),
                              postId: post.id,
                              likes: List<String>.from(post['Likes'] ?? []),
                            ),
                            Divider(),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

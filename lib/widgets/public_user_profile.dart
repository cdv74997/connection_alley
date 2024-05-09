import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connection_alley/widgets/wall_post.dart'; // Importing the WallPost widget
import 'package:connection_alley/helper/helper_methods.dart'; // Import formatDate function

class UserProfilePage extends StatelessWidget {
  final String userId;

  const UserProfilePage({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance.collection('Users').doc(userId).get(),
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
                // Banner Image (You can replace it with an actual banner)
                Placeholder(
                  fallbackHeight: 100, // Reduced vertical height
                ),
                // Profile Picture (Placeholder)
                Center(
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 10), // Reduced margin
                    width: 80, // Reduced width
                    height: 80, // Reduced height
                    decoration: BoxDecoration(
                      color: Colors.grey, // Placeholder color
                      shape: BoxShape.circle, // Rounded shape
                    ),
                  ),
                ),
                // User Info: Username and Bio
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center, // Center align username
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
                // Message and More Button
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // Implement message functionality
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.blue, // Button color
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), // Slightly rounded borders
                          padding: EdgeInsets.symmetric(vertical: 12), // Increased vertical padding
                        ),
                        child: Text(
                          'Message',
                          style: TextStyle(color: Colors.white), // Text color
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Implement more functionality
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.green, // Button color
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), // Slightly rounded borders
                          padding: EdgeInsets.symmetric(vertical: 12), // Increased vertical padding
                        ),
                        child: Text(
                          'More',
                          style: TextStyle(color: Colors.white), // Text color
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(),
                // Recent Activity: Posts
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
                      .where('UserEmail', isEqualTo: userId)
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
                        //final formattedDate = formatDate(postDate); // Format date
                        return Column(
                          children: [
                            WallPost(
                              message: post['Message'],
                              user: post['UserEmail'],
                              time: formatDate(post['TimeStamp']), // Display formatted date
                              postId: post.id,
                              likes: List<String>.from(post['Likes'] ?? []), // Replace with actual list of likes
                            ),
                            Divider(), // Add divider between posts
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

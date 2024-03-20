import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connection_alley/helper/helper_methods.dart';
import 'package:connection_alley/views/profile_page.dart';
import 'package:connection_alley/widgets/drawer.dart';
import 'package:connection_alley/widgets/text_input.dart';
import 'package:connection_alley/widgets/wall_post.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  HomeView({super.key });

  

 

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final user = FirebaseAuth.instance.currentUser!;
  final textController = TextEditingController();

   // sign user out
  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  void goToProfilePage() {
    // pop menu drawer
    Navigator.pop(context);

    // go to profile page
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ProfilePage(),),
    );
  }

  void postMessage () {
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

  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        
        title: Text("Connection-Alley"),
        backgroundColor: Colors.grey[900],
        //actions: [IconButton(onPressed: signUserOut, icon: const Icon(Icons.logout))]
        ),
      drawer: MyDrawer(onProfileTap: goToProfilePage, onSignOut: signUserOut),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance.collection("User Posts").orderBy("TimeStamp", descending: false,).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final post = snapshot.data!.docs[index];
                      return WallPost(message: post['Message'], user: post['UserEmail'], postId: post.id, likes: List<String>.from(post['Likes'] ?? []), time: formatDate(post["TimeStamp"]));
                    },
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ' + snapshot.error.toString()),
                  );
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),
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

                IconButton(onPressed: postMessage, icon: const Icon(Icons.arrow_circle_up))
              ],
            ),
          ),

          Text("Logged in as: " + user.email!, style: TextStyle(color: Colors.grey),),

          const SizedBox(
            height: 50,
          ),

          
        ]
        ),
    );
  }
}
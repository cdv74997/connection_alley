import 'dart:developer';

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
  String name = "";
  List <Map<String, dynamic>> data = [];

  addData() async {
    for (var ele in data)
    {
      FirebaseFirestore.instance.collection('Users').add(ele);
      // ignore: avoid_print
      print(ele as String);
    }
  }
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
  void initState()
  {
    super.initState();
    addData();
  }

  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Card (child: TextField(
              decoration: InputDecoration(
                hintText: "Search People or Groups",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (val)
              {
                setState(()
                {
                  name = val;
                });
              },),)
        //backgroundColor: Theme.of(context).colorScheme.background,
        //actions: [IconButton(onPressed: signUserOut, icon: const Icon(Icons.logout))]
        ),
      drawer: MyDrawer(onProfileTap: goToProfilePage, onSignOut: signUserOut),
      body: Column(
        children: [
          StreamBuilder <QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection("Users").snapshots(),
            builder: (context, snapshots)
            {
              return (snapshots.connectionState == ConnectionState.waiting)
              ? Center (child: CircularProgressIndicator(),)
              : ListView.builder (
                itemCount: snapshots.data!.docs.length,
                itemBuilder: (context, index) 
                {
                  var data = snapshots.data!.docs[index].data() as Map<String, dynamic>;

                  if (name.isEmpty) 
                  {
                    return ListTile(
                      title: Text(data['name'], maxLines: 1, overflow: TextOverflow.ellipsis,
                        style: TextStyle (
                          color: Colors.black54,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                        ),
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(data['image']),
                        ),
                      );
                  }

                  if (data['name'].toString().toLowerCase().startsWith(name.toLowerCase())) 
                  {
                    return ListTile(
                      title: Text(
                        data['name'], 
                        maxLines: 1, 
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle (
                          color: Colors.black54,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                        ),
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(data['image']),
                        ),
                      );
                  }
                  return Container();
                }
              );
          }),
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
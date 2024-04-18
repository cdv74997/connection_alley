import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connection_alley/widgets/text_box.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override 
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // user
  final currentUser = FirebaseAuth.instance.currentUser!;
  // all users
  final usersCollection = FirebaseFirestore.instance.collection("Users");
  final double coverHeight = 280;
  final double profileHeight = 144;

  // edit field
  Future<void> editField(String field) async {
    String newValue = "";
    await showDialog(context: context, builder: (context) => AlertDialog(
      backgroundColor: Colors.grey[900],
      title: Text("Edit " + field, style: const TextStyle(color: Colors.white),),
      content: TextField(autofocus: true, style: TextStyle(color: Colors.white), decoration: InputDecoration(hintText: "Enter new $field", hintStyle: TextStyle(color: Colors.grey)), onChanged: (value) {newValue = value;},),
      actions: [
        // cancel button
        TextButton(
          child: Text('Cancel', style: TextStyle(color: Colors.white),),
          onPressed: () => Navigator.pop(context),
        ),

        // save button
        TextButton(
          child: Text('Save', style: TextStyle(color: Colors.white),),
          onPressed: () => Navigator.of(context).pop(newValue),
        ),
      ],
    ),
    );

    if (newValue.trim().length > 0) {
      // only update if something is in the text field
      await usersCollection.doc(currentUser.email).update({field: newValue});

    }
  }
  @override 
  Widget build(BuildContext context) {
    final top = coverHeight - profileHeight / 2;
    final bottom = profileHeight / 2;
    final color = Theme.of(context).colorScheme.primary;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text("Profile Page"),
        
        ),
        body: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance.collection("Users").doc(currentUser.email).snapshots(),
          builder: (context, snapshot) {
            // get user data
            if (snapshot.hasData) {
              final userData = snapshot.data!.data() as Map<String, dynamic>;

              return ListView(
          children: [ Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center, 
            children: [
              Container (
                margin: EdgeInsets.only(bottom: bottom),
                child:
                  buildCoverImage()),
              Positioned( 
                top: top,
                child: buildProfileImage(),),
              Positioned( 
                bottom: 0,
                right: 4,
                child: buildEditIcon(color),),
            ]),
            const SizedBox(height: 50),
            // profile pic
            //const Icon(
              //Icons.person,
              //size: 72,
            //),
            IntrinsicHeight(child: Row (
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildButton(context, '123', 'Followers'),
                buildDivider(),
                buildButton(context, '123', 'Following'),
              ],)),
            const SizedBox(height: 10),
            // user email
            Text(
              currentUser.email!,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[700]),
            ),
            const SizedBox(height: 50),

            // user details
            Padding(
              padding: EdgeInsets.only(left: 25),
              child: Text('My Details', style: TextStyle(color: Colors.grey[600]),),
            ),

            // username
            MyTextBox(
              text: userData['username'], 
              sectionName: "username",
              onPressed: () => editField('username'),
            ),

            // bio
            MyTextBox(
              text: userData['bio'], 
              sectionName: "bio",
              onPressed: () => editField('bio'),
            ),

            // user posts
            Padding(
              padding: const EdgeInsets.only(left: 25.0),
              child: Text(
                "My Posts",
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
          ],
        );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error${snapshot.error}'),
              );
            }

            return const Center(child: CircularProgressIndicator(),);
          },
        ),
    );
  }

  Widget buildCoverImage() => Container(
    color: Colors.grey, 
    child: Image.network ('https://storage.googleapis.com/cms-storage-bucket/70760bf1e88b184bb1bc.png'),
      width: double.infinity,
      height: coverHeight,
  );

  Widget buildProfileImage() => CircleAvatar( 
    radius: profileHeight / 2, 
    backgroundColor: Colors.grey.shade800,
    backgroundImage: NetworkImage ('https://upload.wikimedia.org/wikipedia/commons/thumb/4/45/Person_icon_%28the_Noun_Project_2817719%29.svg/24px-Person_icon_%28the_Noun_Project_2817719%29.svg.png'),
  );

  Widget buildEditIcon (Color color) => buildCircle(
    color: Colors.white,
    all: 3,
    child: buildCircle(
      color: color,
      all: 8,
      child: Icon(
        Icons.edit, 
      size: 20)));

  Widget buildCircle ({
    required Widget child, 
    required double all, 
    required Color color,}) => 
    Container (
      padding: EdgeInsets.all(all), color: color, child: child,
    );
  
  Widget buildDivider() => VerticalDivider();

  Widget buildButton (BuildContext context, String value, String text) {
    return MaterialButton(
      padding: EdgeInsets.symmetric(vertical: 4),
      onPressed: () {/* does nothing */},
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      child: Column ( 
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[ 
          Text(
            value, 
            style: TextStyle(
              fontWeight: FontWeight.bold, 
              fontSize: 12)),
          SizedBox(height: 2),
          ]
          ),
      );
  }  
}

import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connection_alley/widgets/text_box.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key});

  @override 
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  final usersCollection = FirebaseFirestore.instance.collection("Users");
  final ImagePicker _picker = ImagePicker();
  late File? _imageFile;
  
  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    setState(() {
      _imageFile = File(pickedFile!.path);
    });
  }

  Future<void> _uploadImage() async {
    if (_imageFile == null) return;

    final fileName = '${currentUser.uid}.jpg';
    final destination = 'profile_pictures/$fileName';

    try {
      // Upload image to Firebase Storage
      await FirebaseStorage.instance.ref(destination).putFile(_imageFile!);

      // Get download URL
      final downloadURL = await FirebaseStorage.instance.ref(destination).getDownloadURL();

      // Update user document with profile picture URL
      await usersCollection.doc(currentUser.email).update({'profilePictureUrl': downloadURL});
    } catch (e) {
      print('Failed to upload image: $e');
    }
  }

  Future<void> editField(String field) async {
    String newValue = "";
    await showDialog(context: context, builder: (context) => AlertDialog(
      backgroundColor: Colors.grey[900],
      title: Text("Edit " + field, style: const TextStyle(color: Colors.white),),
      content: TextField(autofocus: true, style: TextStyle(color: Colors.white), decoration: InputDecoration(hintText: "Enter new $field", hintStyle: TextStyle(color: Colors.grey)), onChanged: (value) {newValue = value;},),
      actions: [
        TextButton(
          child: Text('Cancel', style: TextStyle(color: Colors.white),),
          onPressed: () => Navigator.pop(context),
        ),
        TextButton(
          child: Text('Save', style: TextStyle(color: Colors.white),),
          onPressed: () async {
            Navigator.of(context).pop(newValue);
            if (field == 'profilePictureUrl') {
              await _uploadImage();
            } else {
              if (newValue.trim().length > 0) {
                await usersCollection.doc(currentUser.email).update({field: newValue});
              }
            }
          },
        ),
      ],
    ),
    );

    setState(() {});
  }
  
  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text("Profile Page"),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection("Users").doc(currentUser.email).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final userData = snapshot.data!.data() as Map<String, dynamic>;
            final profilePictureUrl = userData['profilePictureUrl'];

            return ListView(
              children: [
                const SizedBox(height: 50),
                GestureDetector(
                  onTap: () => _pickImage(ImageSource.gallery),
                  child: CircleAvatar(
                    radius: 36,
                    backgroundImage: (profilePictureUrl != null && profilePictureUrl.isNotEmpty)
            ? NetworkImage(profilePictureUrl)
            : null,
                    child: _imageFile == null && (profilePictureUrl == null || profilePictureUrl.isEmpty)
                        ? const Icon(Icons.person, size: 72)
                        : null,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  currentUser.email!,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[700]),
                ),
                const SizedBox(height: 50),
                Padding(
                  padding: EdgeInsets.only(left: 25),
                  child: Text('My Details', style: TextStyle(color: Colors.grey[600]),),
                ),
                MyTextBox(
                  text: userData['username'], 
                  sectionName: "username",
                  onPressed: () => editField('username'),
                ),
                MyTextBox(
                  text: userData['bio'], 
                  sectionName: "bio",
                  onPressed: () => editField('bio'),
                ),
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
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}


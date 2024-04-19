import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connection_alley/services/auth_service.dart';
import 'package:connection_alley/widgets/button.dart';
import 'package:connection_alley/widgets/square_tile.dart';
import 'package:connection_alley/widgets/text_input.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterView extends StatefulWidget {
  final Function()? onTap;
  const RegisterView({super.key, required this.onTap});

  @override 
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final emailInputController = TextEditingController();
  final passwordInputController = TextEditingController();
  final confirmPasswordInputController = TextEditingController();
  void signUserUp() async {
    showDialog(context: context, builder: (context) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    });

    try {
      if (passwordInputController.text == confirmPasswordInputController.text) {
        // create the user

        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: emailInputController.text, password: passwordInputController.text);

        // after creating the user, create a new doc called Users in cloud firebase
        FirebaseFirestore.instance
            .collection("Users")
            .doc(userCredential.user!.email)
            .set({
              'username': emailInputController.text.split('@')[0],
              'bio': 'Empty bio..',
              'profilePicture': '',
            });

      } else {
        // passwords dont match
        showErrorMessage("Passwords don't match!");
      }

      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      //take away loading circle
      Navigator.pop(context);
      // show error message
      showErrorMessage(e.code);
    }
  }

  void showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.deepPurple,
          title: Center(
            child: Text(
              message,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
  }
  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[200],
      body: SafeArea(
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                const SizedBox(height: 50),
               
                // logo
                const Icon(
                  Icons.lock,
                  size: 100,
                ),
                const SizedBox(height: 50),
                // opening greeting
                Text("Create your account here!",
                    style: TextStyle(
                      color: Colors.grey[700],
                    ),),
                      
                const SizedBox(height: 25),
                  
                // email input
                MyInputField(controller: emailInputController, hintText: "Email", obscureText: false),
                const SizedBox(height: 10),
                // password input
                MyInputField(controller: passwordInputController, hintText: "Password", obscureText: true),
                const SizedBox(height: 10),
                MyInputField(controller: confirmPasswordInputController, hintText: "Confirm Password", obscureText: true),
                const SizedBox(height: 10),
                // sign in button
                MyButton(onTap: signUserUp, text: "Sign Up", color: Colors.black),
                const SizedBox(height: 25),
                // google and apple logins
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.black12,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text('Or continue with', style: TextStyle(color: Colors.grey[800]),),
                      ),
                      const Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.black12,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 50),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  
                  SquareTile(onTap: () => AuthService().signInWithGoogle() ,imagePath: 'lib/images/google.png'),

                  SizedBox(width: 25),

                  SquareTile(onTap: () {} ,imagePath: 'lib/images/apple.png'),
                ],),

                const SizedBox(height: 25),
                // register button
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have and account?",
                    style: TextStyle(
                      color: Colors.grey[700],
                    ),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text("Login", style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                                     ),
                    ),
                  ],
                ),
                  
                // forgot password?
              ],),
            ),
          ),
        
      )
    );
  }
}
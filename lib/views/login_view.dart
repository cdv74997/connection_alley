import 'package:connection_alley/services/auth_service.dart';
import 'package:connection_alley/widgets/button.dart';
import 'package:connection_alley/widgets/square_tile.dart';
import 'package:connection_alley/widgets/text_input.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginView extends StatefulWidget {
  final Function()? onTap;
  const LoginView({super.key, required this.onTap});

  
  @override
  State<LoginView> createState() => _LoginViewState(); 
}

class _LoginViewState extends State<LoginView> {

  final emailInputController = TextEditingController();
  final passwordInputController = TextEditingController();
  void signUserIn() async {
    // show loading circle
    showDialog(context: context, builder: (context) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    },
    );

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: emailInputController.text.trim(), password: passwordInputController.text.trim());
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      if (e.code == 'user-not-found') {
        wrongEmailMessage();
        //print('No user found for that email');
      } else if (e.code == 'wrong-password') {
        //print('Wrong password');
        wrongPasswordMessage();
      }
    }

    // pop the loading circle
    
  }
  
  void wrongEmailMessage() {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          title: Text('Incorrect Email'),
        );
      }
    );
  }

  void wrongPasswordMessage() {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          title: Text('Incorrect Password'),
        );
      }
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
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                
               const SizedBox(height: 25),
                // logo
                const Icon(
                  Icons.lock,
                  size: 100,
                ),
                const SizedBox(height: 50),
                // opening greeting
                Text("Profound connections start here!",
                    style: TextStyle(
                      color: Colors.grey[700],
                    ),),
                      
                const SizedBox(height: 25),
                  
                // email input
                MyInputField(controller: emailInputController, hintText: "Email", obscureText: false),
                const SizedBox(height: 10),
                // password input
                MyInputField(controller: passwordInputController, hintText: "Password", obscureText: false),
                const SizedBox(height: 10),
                // sign in button
                MyButton(onTap: signUserIn, text: "Sign in", color: Colors.blue),
                const SizedBox(height: 50),
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
                  
                  SquareTile(onTap: () => AuthService().signInWithGoogle(),imagePath: 'lib/images/google.png'),

                  const SizedBox(width: 25),

                  SquareTile(onTap: () {}, imagePath: 'lib/images/apple.png'),
                ],),

                const SizedBox(height: 25),
                // register button
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Not Yet Connected?",
                    style: TextStyle(
                      color: Colors.grey[700],
                    ),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text("Register now", style: TextStyle(
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
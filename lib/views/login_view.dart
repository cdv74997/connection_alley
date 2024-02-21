import 'package:connection_alley/widgets/button.dart';
import 'package:connection_alley/widgets/text_input.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[200],
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
              const SizedBox(height: 30),
             
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
              MyInputField(controller: passwordInputController, hintText: "Password", obscureText: true),
              const SizedBox(height: 10),
              // sign in button
              MyButton(onTap: (){}, text: "Sign in", color: Colors.blue),
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
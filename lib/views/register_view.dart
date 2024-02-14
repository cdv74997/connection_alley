import 'package:connection_alley/widgets/button.dart';
import 'package:connection_alley/widgets/text_input.dart';
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
  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[200],
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              
             
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
              MyButton(onTap: (){}, text: "Sign Up"),
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
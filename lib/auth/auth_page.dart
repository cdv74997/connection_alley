import 'package:connection_alley/auth/login_or_register.dart';
import 'package:connection_alley/views/home_view.dart';
import 'package:connection_alley/views/login_view.dart';
import 'package:connection_alley/views/register_view.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // user is logged in
          if (snapshot.hasData) {
            return HomeView();
          }

          // user is not logged it
          else {
            return const LoginOrRegister();
          }
        },
      ),
    );
  }
}
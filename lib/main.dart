import 'package:connection_alley/auth/login_or_register.dart';
import 'package:connection_alley/views/login_view.dart';
import 'package:connection_alley/views/register_view.dart';
import 'package:flutter/material.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginOrRegister(),
    );
  }

}

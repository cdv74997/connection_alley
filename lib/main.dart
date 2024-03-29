import 'package:connection_alley/auth/auth_page.dart';
import 'package:connection_alley/auth/login_or_register.dart';
import 'package:connection_alley/theme/dark_theme.dart';
import 'package:connection_alley/theme/light_theme.dart';
import 'package:connection_alley/views/login_view.dart';
import 'package:connection_alley/views/register_view.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  

  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      home: const AuthPage(),
     // home: LoginView(onTap: fun),
    );
  }

}

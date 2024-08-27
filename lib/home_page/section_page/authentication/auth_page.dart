import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_movie_app/home_page/home_page.dart';
import 'package:my_movie_app/home_page/section_page/authentication/login_or_register_page.dart';
//import 'package:flutter_authentication/pages/home_page.dart';
//import 'package:flutter_authentication/pages/login_or_register_page.dart';

class AuthPage extends StatelessWidget {
  AuthPage({super.key});
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            // user is logged in
            if (snapshot.hasData) {
              return HomePage();
            } else {
              // user is NOT logged in
              return LoginOrRegisterPage();
            }
          }),
    );
  }
}

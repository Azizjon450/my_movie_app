
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:my_movie_app/home_page/section_page/authentication/auth_page.dart';
import 'package:my_movie_app/services/firebase_options.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
   options: DefaultFirebaseOptions.currentPlatform,);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home:  AuthPage(),
    );
  }
}

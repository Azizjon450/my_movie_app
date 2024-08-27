
import 'package:connection_notifier/connection_notifier.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:my_movie_app/home_page/section_page/authentication/auth_page.dart';
import 'package:my_movie_app/services/firebase_options.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
    //return MaterialApp(
    return ConnectionNotifier(
      child: MaterialApp(
        theme: ThemeData(
          brightness: Brightness.dark,
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        home: AuthPage(),
      ),
    );
  }
}

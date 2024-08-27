import 'package:flutter/material.dart';

class NoInternetScreen extends StatefulWidget {
  const NoInternetScreen({super.key});

  @override
  State<NoInternetScreen> createState() => _NoInternetScreenState();
}

class _NoInternetScreenState extends State<NoInternetScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          children: [
            Icon(Icons.wifi_off),
            SizedBox(height: 10),
            Text(
              "No Internet Connection",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(height: 5),
            Text(
              "Please check internet or WiFi connection",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 9),
            ),
          ],
        ),
      ),
    );
  }
}

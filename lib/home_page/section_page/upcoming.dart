import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:my_movie_app/api_key/api_key.dart';
import 'package:my_movie_app/reapeated_function/slider.dart';

class Upcoming extends StatefulWidget {
  const Upcoming({super.key});

  @override
  State<Upcoming> createState() => _UpcommingState();
}

class _UpcommingState extends State<Upcoming> {
  List<Map<String, dynamic>> getUpcomminglist = [];
  Future<void> getUpcomming() async {
    var url = Uri.parse(
        'https://api.themoviedb.org/3/movie/upcoming?api_key=$apikey');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      for (var i = 0; i < json['results'].length; i++) {
        getUpcomminglist.add({
          "poster_path": json['results'][i]['poster_path'],
          "name": json['results'][i]['title'],
          "vote_average": json['results'][i]['vote_average'],
          "Date": json['results'][i]['release_date'],
          "id": json['results'][i]['id'],
        });
      }
    } else {
      //Fluttertoast();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getUpcomming(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                sliderList(getUpcomminglist, "Upcoming", "movie", 20),
                Padding(
                    padding:
                        const EdgeInsets.only(left: 10.0, top: 15, bottom: 40),
                    child: Text("Many More Coming Soon... "))
              ]);
        } else {
          return Center(child: CircularProgressIndicator(color: Colors.red));
        }
      },
    );
  }
}

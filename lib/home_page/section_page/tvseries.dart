import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:my_movie_app/api_key/api_key.dart';
import 'package:my_movie_app/reapeated_function/slider.dart';

class TvSeries extends StatefulWidget {
  const TvSeries({super.key});

  @override
  State<TvSeries> createState() => _TvSeriesState();
}

class _TvSeriesState extends State<TvSeries> {
  List<Map<String, dynamic>> popularTvSeries = [];
  List<Map<String, dynamic>> topRatedTvSeries = [];
  List<Map<String, dynamic>> onAirTvSeries = [];

  var popularTvSeriesUrl =
      'https://api.themoviedb.org/3/tv/popular?api_key=$apikey';
  var topRatedTvSeriesUrl =
      'https://api.themoviedb.org/3/tv/top_rated?api_key=$apikey';
  var onAirTvSeriesUrl =
      'https://api.themoviedb.org/3/tv/on_the_air?api_key=$apikey';

  Future<void> tvSeriesFunction() async {
    var popularTvResponse = await http.get(Uri.parse(popularTvSeriesUrl));
    if (popularTvResponse.statusCode == 200) {
      var tempData = jsonDecode(popularTvResponse.body);
      var popularTvJson = tempData['results'];
      for (var i = 0; i < popularTvJson.length; i++) {
        popularTvSeries.add({
          "name": popularTvJson[i]['name'],
          "poster_path": popularTvJson[i]['poster_path'],
          "vote_average": popularTvJson[i]['vote_average'],
          "Date": popularTvJson[i]['first_air_date'],
          "id": popularTvJson[i]['id'],
        });
      }
    } else {
      print(popularTvResponse.statusCode);
    }

    /****************************************************/

    var topRatedTvResponse = await http.get(Uri.parse(topRatedTvSeriesUrl));
    if (topRatedTvResponse.statusCode == 200) {
      var tempData = jsonDecode(topRatedTvResponse.body);
      var topRatedTvJson = tempData['results'];
      for (var i = 0; i < topRatedTvJson.length; i++) {
        topRatedTvSeries.add({
          "name": topRatedTvJson[i]['name'],
          "poster_path": topRatedTvJson[i]['poster_path'],
          "vote_average": topRatedTvJson[i]['vote_average'],
          "Date": topRatedTvJson[i]['first_air_date'],
          "id": topRatedTvJson[i]['id'],
        });
      }
    } else {
      print(topRatedTvResponse.statusCode);
    }

    /****************************************************/

    var onAirTvResponse = await http.get(Uri.parse(onAirTvSeriesUrl));
    if (onAirTvResponse.statusCode == 200) {
      var tempData = jsonDecode(onAirTvResponse.body);
      var onAirTvJson = tempData['results'];
      for (var i = 0; i < onAirTvJson.length; i++) {
        onAirTvSeries.add({
          "name": onAirTvJson[i]['name'],
          "poster_path": onAirTvJson[i]['poster_path'],
          "vote_average": onAirTvJson[i]['vote_average'],
          "Date": onAirTvJson[i]['first_air_date'],
          "id": onAirTvJson[i]['id'],
        });
      }
    } else {
      print(onAirTvResponse.statusCode);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: tvSeriesFunction(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              color: Colors.red.shade400,
            ),
          );
        } else {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              sliderList(popularTvSeries, "Popular Tv Series", "Tv", 20),
              sliderList(onAirTvSeries, "On the Air", "Tv", 20),
              sliderList(topRatedTvSeries, "Top Rated Series", "Tv", 20),
            ],
          );
        }
      },
    );
  }
}

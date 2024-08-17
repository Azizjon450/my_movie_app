import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:my_movie_app/api_key/api_key.dart';
import 'package:my_movie_app/reapeated_function/slider.dart';

class Movies extends StatefulWidget {
  const Movies({super.key});

  @override
  State<Movies> createState() => _MoviesState();
}

class _MoviesState extends State<Movies> {
  List<Map<String, dynamic>> popularMovies = [];
  List<Map<String, dynamic>> topRatedMovies = [];
  List<Map<String, dynamic>> nowPlayingMovies = [];

  String popularMoviesUrl =
      'https://api.themoviedb.org/3/movie/popular?api_key=$apikey';
  String nowPlayingMoviesUrl =
      'https://api.themoviedb.org/3/movie/now_playing?api_key=$apikey';
  String topRatedMoviesUrl =
      'https://api.themoviedb.org/3/movie/top_rated?api_key=$apikey';

    Future<void> movieList() async {
    var popularMoviesResponse = await http.get(Uri.parse(popularMoviesUrl));
    if (popularMoviesResponse.statusCode == 200) {
      var tempData = jsonDecode(popularMoviesResponse.body);
      var popularMoviesJson = tempData['results'];
      for (var i = 0; i < popularMoviesJson.length; i++) {
        popularMovies.add({
          "name": popularMoviesJson[i]['title'],
          "poster_path": popularMoviesJson[i]['poster_path'],
          "vote_average": popularMoviesJson[i]['vote_average'],
          "Date": popularMoviesJson[i]['release_date'],
          "id": popularMoviesJson[i]['id'],
        });
      }
    } else {
      print(popularMoviesResponse.statusCode);
    }

    /****************************************************/

    var topRatedMoviesResponse = await http.get(Uri.parse(topRatedMoviesUrl));
    if (topRatedMoviesResponse.statusCode == 200) {
      var tempData = jsonDecode(topRatedMoviesResponse.body);
      var topRatedMoviesJson = tempData['results'];
      for (var i = 0; i < topRatedMoviesJson.length; i++) {
        topRatedMovies.add({
          "name": topRatedMoviesJson[i]['title'],
          "poster_path": topRatedMoviesJson[i]['poster_path'],
          "vote_average": topRatedMoviesJson[i]['vote_average'],
          "Date": topRatedMoviesJson[i]['release_date'],
          "id": topRatedMoviesJson[i]['id'],
        });
      }
    } else {
    }

    /****************************************************/

    var nowPlayingMoviesResponse =
        await http.get(Uri.parse(nowPlayingMoviesUrl));
    if (nowPlayingMoviesResponse.statusCode == 200) {
      var tempData = jsonDecode(nowPlayingMoviesResponse.body);
      var nowPlayingMoviesJson = tempData['results'];
      for (var i = 0; i < nowPlayingMoviesJson.length; i++) {
        nowPlayingMovies.add({      
          "name": nowPlayingMoviesJson[i]['title'],
          "poster_path": nowPlayingMoviesJson[i]['poster_path'],
          "vote_average": nowPlayingMoviesJson[i]['vote_average'],
          "Date": nowPlayingMoviesJson[i]['release_date'],
          "id": nowPlayingMoviesJson[i]['id'],
        });
      }
    } else {
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: movieList(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              color: Colors.red,
            ),
          );
        } else {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              sliderList(popularMovies, "Popular Movies", "movie", 10),
              sliderList(nowPlayingMovies, "Now Playing Movies", "movie", 10),
              sliderList(topRatedMovies, "Top Rated Movies", "movie", 10),
            ],
          );
        }
      },
    );
  }
}

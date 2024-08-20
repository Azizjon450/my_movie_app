import 'package:flutter/material.dart';
import 'package:my_movie_app/details/movie_details.dart';
import 'package:my_movie_app/details/tv_series_details.dart';

class DescriptionChekUI extends StatefulWidget {
  var newId;
  var newType;
  DescriptionChekUI(this.newId, this.newType);

  @override
  State<DescriptionChekUI> createState() => _DescriptionChekUIState();
}

class _DescriptionChekUIState extends State<DescriptionChekUI> {
  checkType() {
    if (widget.newType == 'movie') {
      return MoviesDetails(id: widget.newId,);
    } else if (widget.newType == 'tv') {
      return TvSeriesDetails(id: widget.newId,);
    } else {
      return errorUI();
    }
  }

  @override
  Widget build(BuildContext context) {
    return checkType();
  }

  Widget errorUI() {
    return const Scaffold(
      body: Center(
        child: Text("Error"),
      ),
    );
  }
}

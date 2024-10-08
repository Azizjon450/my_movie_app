import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_movie_app/api_key/api_key.dart';
import 'package:my_movie_app/home_page/home_page.dart';
import 'package:my_movie_app/reapeated_function/favourate_share.dart';
import 'package:my_movie_app/reapeated_function/review_ui.dart';
import 'package:my_movie_app/reapeated_function/trailer_ui.dart';
import 'package:my_movie_app/reapeated_function/slider.dart';

class TvSeriesDetails extends StatefulWidget {
  var id;
  //var newId;
  TvSeriesDetails({this.id});

  @override
  State<TvSeriesDetails> createState() => _TvSeriesDetailsState();
}

class _TvSeriesDetailsState extends State<TvSeriesDetails> {
  var tvseriesdetaildata;
  List<Map<String, dynamic>> tvSeriesDetails = [];
  List<Map<String, dynamic>> TvSeriesREview = [];
  List<Map<String, dynamic>> similarserieslist = [];
  List<Map<String, dynamic>> recommendserieslist = [];
  List<Map<String, dynamic>> seriestrailerslist = [];

  Future<void> tvseriesdetailfunc() async {
    var tvseriesdetailurl = 'https://api.themoviedb.org/3/tv/' +
        widget.id.toString() +
        '?api_key=$apikey';
    var tvseriesreviewurl = 'https://api.themoviedb.org/3/tv/' +
        widget.id.toString() +
        '/reviews?api_key=$apikey';
    var similarseriesurl = 'https://api.themoviedb.org/3/tv/' +
        widget.id.toString() +
        '/similar?api_key=$apikey';
    var recommendseriesurl = 'https://api.themoviedb.org/3/tv/' +
        widget.id.toString() +
        '/recommendations?api_key=$apikey';
    var seriestrailersurl = 'https://api.themoviedb.org/3/tv/' +
        widget.id.toString() +
        '/videos?api_key=$apikey';

    var tvseriesdetailresponse = await http.get(Uri.parse(tvseriesdetailurl));
    if (tvseriesdetailresponse.statusCode == 200) {
      tvseriesdetaildata = jsonDecode(tvseriesdetailresponse.body);
      for (var i = 0; i < 1; i++) {
        tvSeriesDetails.add({
          'backdrop_path': tvseriesdetaildata['backdrop_path'],
          'title': tvseriesdetaildata['original_name'],
          'vote_average': tvseriesdetaildata['vote_average'],
          'overview': tvseriesdetaildata['overview'],
          'status': tvseriesdetaildata['status'],
          'releasedate': tvseriesdetaildata['first_air_date'],
        });
      }
      for (var i = 0; i < tvseriesdetaildata['genres'].length; i++) {
        tvSeriesDetails.add({
          'genre': tvseriesdetaildata['genres'][i]['name'],
        });
      }
      for (var i = 0; i < tvseriesdetaildata['created_by'].length; i++) {
        tvSeriesDetails.add({
          'creator': tvseriesdetaildata['created_by'][i]['name'],
          'creatorprofile': tvseriesdetaildata['created_by'][i]['profile_path'],
        });
      }
      for (var i = 0; i < tvseriesdetaildata['seasons'].length; i++) {
        tvSeriesDetails.add({
          'season': tvseriesdetaildata['seasons'][i]['name'],
          'episode_count': tvseriesdetaildata['seasons'][i]['episode_count'],
        });
      }
    } else {}
    /************************   TV Series review     ****************************/

    var tvseriesreviewresponse = await http.get(Uri.parse(tvseriesreviewurl));
    if (tvseriesreviewresponse.statusCode == 200) {
      var tvseriesreviewdata = jsonDecode(tvseriesreviewresponse.body);
      for (var i = 0; i < tvseriesreviewdata['results'].length; i++) {
        TvSeriesREview.add({
          'name': tvseriesreviewdata['results'][i]['author'],
          'review': tvseriesreviewdata['results'][i]['content'],
          "rating": tvseriesreviewdata['results'][i]['author_details']
                      ['rating'] ==
                  null
              ? "Not Rated"
              : tvseriesreviewdata['results'][i]['author_details']['rating']
                  .toString(),
          "avatarphoto": tvseriesreviewdata['results'][i]['author_details']
                      ['avatar_path'] ==
                  null
              ? "https://www.pngitem.com/pimgs/m/146-1468479_my-profile-icon-blank-profile-picture-circle-hd.png"
              : "https://image.tmdb.org/t/p/w500" +
                  tvseriesreviewdata['results'][i]['author_details']
                      ['avatar_path'],
          "creationdate":
              tvseriesreviewdata['results'][i]['created_at'].substring(0, 10),
          "fullreviewurl": tvseriesreviewdata['results'][i]['url'],
        });
      }
    } else {}
    /************************   Smilar series    ****************************/

    var similarseriesresponse = await http.get(Uri.parse(similarseriesurl));
    if (similarseriesresponse.statusCode == 200) {
      var similarseriesdata = jsonDecode(similarseriesresponse.body);
      for (var i = 0; i < similarseriesdata['results'].length; i++) {
        similarserieslist.add({
          'poster_path': similarseriesdata['results'][i]['poster_path'],
          'name': similarseriesdata['results'][i]['original_name'],
          'vote_average': similarseriesdata['results'][i]['vote_average'],
          'id': similarseriesdata['results'][i]['id'],
          'Date': similarseriesdata['results'][i]['first_air_date'],
        });
      }
    } else {}

    /************************   Recommended Series     ****************************/

    var recommendseriesresponse = await http.get(Uri.parse(recommendseriesurl));
    if (recommendseriesresponse.statusCode == 200) {
      var recommendseriesdata = jsonDecode(recommendseriesresponse.body);
      for (var i = 0; i < recommendseriesdata['results'].length; i++) {
        recommendserieslist.add({
          'poster_path': recommendseriesdata['results'][i]['poster_path'],
          'name': recommendseriesdata['results'][i]['original_name'],
          'vote_average': recommendseriesdata['results'][i]['vote_average'],
          'id': recommendseriesdata['results'][i]['id'],
          'Date': recommendseriesdata['results'][i]['first_air_date'],
        });
      }
    } else {}

    /************************   TV Series detail    ****************************/
    var tvseriestrailerresponse = await http.get(Uri.parse(seriestrailersurl));
    if (tvseriestrailerresponse.statusCode == 200) {
      var tvseriestrailerdata = jsonDecode(tvseriestrailerresponse.body);

      for (var i = 0; i < tvseriestrailerdata['results'].length; i++) {
        if (tvseriestrailerdata['results'][i]['type'] == "Trailer") {
          seriestrailerslist.add({
            'key': tvseriestrailerdata['results'][i]['key'],
          });
        }
      }
      seriestrailerslist.add({'key': 'aJ0cZTcTh90'});
    } else {}
    const Text("No Data");
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.bottom]);
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(14, 14, 14, 1),
      body: FutureBuilder(
        future: tvseriesdetailfunc(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CustomScrollView(physics: BouncingScrollPhysics(), slivers: [
              SliverAppBar(
                  automaticallyImplyLeading: false,
                  leading:
                      //circular icon button
                      IconButton(
                          onPressed: () {
                            SystemChrome.setEnabledSystemUIMode(
                                SystemUiMode.manual,
                                overlays: [SystemUiOverlay.bottom]);
                            SystemChrome.setEnabledSystemUIMode(
                                SystemUiMode.manual,
                                overlays: []);
                            SystemChrome.setPreferredOrientations([
                              DeviceOrientation.portraitUp,
                              DeviceOrientation.portraitDown,
                            ]);
                            Navigator.pop(context);
                          },
                          icon: Icon(FontAwesomeIcons.circleArrowLeft),
                          iconSize: 28,
                          color: Colors.white),
                  actions: [
                    IconButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomePage()),
                              (route) => false);
                        },
                        icon: Icon(FontAwesomeIcons.houseUser),
                        iconSize: 25,
                        color: Colors.white)
                  ],
                  backgroundColor: Color.fromRGBO(18, 18, 18, 0.5),
                  expandedHeight: MediaQuery.of(context).size.height * 0.35,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    collapseMode: CollapseMode.parallax,
                    background: FittedBox(
                      fit: BoxFit.fill,
                      child: TrailerWatch(
                        trailerytid: seriestrailerslist[0]['key'],
                      ),
                    ),
                  )),
              SliverList(
                  delegate: SliverChildListDelegate([
                addtofavoriate(
                  id: widget.id,
                  type: 'tv',
                  Details: TvSeriesDetails,
                ),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 10, top: 10),
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      child: ListView.builder(
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemCount: tvseriesdetaildata['genres']!.length,
                        itemBuilder: (context, index) {
                          return Container(
                              margin: EdgeInsets.only(right: 10),
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: Color.fromRGBO(25, 25, 25, 1),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Text(tvSeriesDetails[index + 1]['genre']
                                  .toString()));
                        },
                      ),
                    ),
                  ],
                ),
                Container(
                    padding: EdgeInsets.only(left: 10, top: 12),
                    child: Text("Series Overview : ")),

                Container(
                    padding: EdgeInsets.only(left: 10, top: 20),
                    child: Text(tvSeriesDetails[0]['overview'].toString())),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, top: 10),
                  child: ReviewUI(revdeatils: TvSeriesREview),
                ),
                Container(
                    padding: EdgeInsets.only(left: 10, top: 20),
                    child: Text(
                        "Status : " + tvSeriesDetails[0]['status'].toString())),
                //created by
                Container(
                    padding: EdgeInsets.only(left: 10, top: 20),
                    child: Text("Created By : ")),
                Container(
                    padding: EdgeInsets.only(left: 10, top: 10),
                    height: 150,
                    width: MediaQuery.of(context).size.width,
                    child: ListView.builder(
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemCount: tvseriesdetaildata['created_by'].length,
                        itemBuilder: (context, index) {
                          //generes box
                          return Container(
                              margin: EdgeInsets.only(right: 10),
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  color: Color.fromRGBO(25, 25, 25, 1),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Row(children: [
                                Column(children: [
                                  CircleAvatar(
                                      radius: 45,
                                      backgroundImage: NetworkImage(
                                          "https://image.tmdb.org/t/p/w500" +
                                              tvSeriesDetails[index]
                                                      ['creatorprofile']
                                                  .toString())),
                                  SizedBox(height: 10),
                                  Text(tvSeriesDetails[index]['creator']
                                      .toString())
                                ])
                              ]));
                        })),
                Container(
                    padding: EdgeInsets.only(left: 10, top: 20),
                    child: Text("Total Seasons : " +
                        tvseriesdetaildata['seasons'].length.toString())),
                //airdate
                Container(
                    padding: EdgeInsets.only(left: 10, top: 20),
                    child: Text("Release date : " +
                        tvSeriesDetails[0]['releasedate'].toString())),
                sliderList(similarserieslist, 'Similar Series', 'tv',
                    similarserieslist.length),
                sliderList(recommendserieslist, 'Recommended Series', 'tv',
                    recommendserieslist.length),
                Container(
                    height: 50, child: Center(child: Text("By TMDB Official")))
              ]))
            ]);
          } else {
            return Center(
              child: CircularProgressIndicator(color: Colors.red.shade400),
            );
          }
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_movie_app/api_key/api_key.dart';
import 'package:my_movie_app/details/checker.dart';

class serachbarFunc extends StatefulWidget {
  const serachbarFunc({super.key});

  @override
  State<serachbarFunc> createState() => _serachbarFuncState();
}

class _serachbarFuncState extends State<serachbarFunc> {
  List<Map<String, dynamic>> searchresult = [];
  final TextEditingController serachText = TextEditingController();
  bool showList = false;
  var vall;

  Future<void> searchListFunction(String val) async {
    var serachUrl =
        'https://api.themoviedb.org/3/search/multi?api_key=$apikey&query=$val';
    var searchResponse = await http.get(Uri.parse(serachUrl));

    if (searchResponse.statusCode == 200) {
      var tempData = jsonDecode(searchResponse.body);
      var searchJson = tempData['results'];

      for (var item in searchJson) {
        if (item['id'] != null &&
            item['poster_path'] != null &&
            item['vote_average'] != null &&
            item['media_type'] != null) {
          searchresult.add({
            'id': item['id'],
            'poster_path': item['id'],
            'vote_average': item['vote_average'],
            'media_type': item['media_type'],
            'popularity': item['popularity'],
            'overview': item['overview'],
          });

          if (searchresult.length > 20) {
            searchresult.removeRange(20, searchresult.length);
          }
        } else {
          print('Null value found');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
        showList = !showList;
      },
      child: Padding(
        padding: const EdgeInsets.only(
          left: 10,
          top: 30,
          bottom: 20,
          right: 10,
        ),
        child: Column(
          children: [
            Container(
              height: 50,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: TextField(
                controller: serachText,
                onSubmitted: (value) {
                  searchresult.clear();
                  setState(() {
                    vall = value;
                    FocusManager.instance.primaryFocus?.unfocus();
                  });
                },
                onChanged: (value) {
                  searchresult.clear();
                  setState(() {
                    vall = value;
                  });
                },
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    onPressed: () {
                      Fluttertoast.showToast(
                        webBgColor: "#000000",
                        webPosition: "center",
                        webShowClose: true,
                        msg: "Search Cleared",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 2,
                        backgroundColor: Color.fromRGBO(18, 18, 18, 1),
                        textColor: Colors.white,
                        fontSize: 16.0,
                      );
                      setState(() {
                        serachText.clear();
                        FocusManager.instance.primaryFocus?.unfocus();
                      });
                    },
                    icon: Icon(
                      Icons.arrow_back_ios_rounded,
                      color: Colors.red.withOpacity(0.6),
                    ),
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.red,
                  ),
                  hintText: "Search",
                  hintStyle: TextStyle(
                    color: Colors.white.withOpacity(0.2),
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            if (serachText.text.length > 0)
              FutureBuilder(
                future: searchListFunction(vall),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return Container(
                      height: 400,
                      child: ListView.builder(
                        itemCount: searchresult.length,
                        scrollDirection: Axis.vertical,
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DescriptionChekUI(
                                    searchresult[index]['id'],
                                    searchresult[index]['media_type'],
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              margin: EdgeInsets.only(top: 4, bottom: 4),
                              height: 180,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.4,
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      image: DecorationImage(
                                        image: NetworkImage(
                                            'https://image.tmdb.org/t/p/w500${searchresult[index]['poster_path']}'),
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          alignment: Alignment.topCenter,
                                          child: Text(
                                              '${searchresult[index]['media_type']}'),
                                        ),
                                        Container(
                                          child: Row(
                                            children: [
                                              Container(
                                                padding: EdgeInsets.all(5),
                                                height: 30,
                                                decoration: BoxDecoration(
                                                  color: Colors.red
                                                      .withOpacity(0.2),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(6),
                                                  ),
                                                ),
                                                child: Center(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                        Icons.star,
                                                        color: Colors.amber,
                                                        size: 20,
                                                      ),
                                                      SizedBox(width: 5),
                                                      Text(
                                                          '${searchresult[index]['vote_average']}')
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.2,
                                                height: 30,
                                                padding:
                                                    const EdgeInsets.all(30),
                                                decoration: BoxDecoration(
                                                  color: Colors.red
                                                      .withOpacity(0.2),
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                    Radius.circular(8),
                                                  ),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Icons
                                                          .people_outline_sharp,
                                                      color: Colors.red,
                                                      size: 10,
                                                    ),
                                                    SizedBox(width: 5),
                                                    Expanded(
                                                        child: FittedBox(
                                                      fit: BoxFit.scaleDown,
                                                      child: Text(
                                                        '${searchresult[index]['popularity']}',
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 1,
                                                        style: TextStyle(
                                                            fontSize: 12),
                                                      ),
                                                    ))
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.4,
                                          height: 85,
                                          child: Text(
                                            '${searchresult[index]['overview']}',
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(
                        color: Colors.red,
                      ),
                    );
                  }
                },
              )
          ],
        ),
      ),
    );
  }
}

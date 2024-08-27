import 'package:flutter/material.dart';
import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:my_movie_app/api_links/all_api.dart';
import 'package:my_movie_app/details/checker.dart';
import 'package:my_movie_app/home_page/section_page/movies.dart';
import 'package:my_movie_app/home_page/section_page/tvseries.dart';
import 'package:my_movie_app/home_page/section_page/soon.dart';
import 'package:my_movie_app/reapeated_function/drawer.dart';
import 'package:my_movie_app/reapeated_function/favourate_share.dart';
import 'package:my_movie_app/reapeated_function/searchbar_func.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  List<Map<String, dynamic>> trendingWeek = [];
  int head = 1;

  Future<void> trendingList(int checkPP) async {
    if (checkPP == 1) {
      var trendingWeekResponse = await http.get(Uri.parse(trendingWeekUrl));
      if (trendingWeekResponse.statusCode == 200) {
        var tempData = jsonDecode(trendingWeekResponse.body);
        var trendingWeekJson = tempData['results'];
        for (var i = 0; i < trendingWeekJson.length; i++) {
          trendingWeek.add({
            'id': trendingWeekJson[i]['id'],
            'poster_path': trendingWeekJson[i]['poster_path'],
            'media_type': trendingWeekJson[i]['media_type'],
            'indexno': i,
          });
        }
      }
    } else if (checkPP == 2) {
      var trendingDayResponse = await http.get(Uri.parse(trendingDayUrl));
      if (trendingDayResponse.statusCode == 200) {
        var tempData = jsonDecode(trendingDayResponse.body);
        var trendingWeekJson = tempData['results'];
        for (var i = 0; i < trendingWeekJson.length; i++) {
          trendingWeek.add(
            {
              'id': trendingWeekJson[i]['id'],
              'poster_path': trendingWeekJson[i]['poster_path'],
              'vote_average': trendingWeekJson[i]['vote_average'],
              'media_type': trendingWeekJson[i]['media_type'],
              'indexno': i,
            },
          );
        }
      }
    } else {}
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    TabController _tabController = TabController(length: 3, vsync: this);
    return Scaffold(
      appBar: AppBar(
        //automaticallyImplyLeading: false,
        toolbarHeight: 80,
        title: const Text(
          'MY MOVIES',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          // Padding(
          //   padding: const EdgeInsets.only(bottom: 8, top: 8, right: 8),
          //   child: serachbarFunc(),
          // ),

          Padding(
            padding: const EdgeInsets.only(bottom: 20.0, right: 20),
            child: Image.asset('assets/images/logo.png'),
          )
        ],
      ),
      drawer: drawerfunc(),
      backgroundColor: Color.fromRGBO(18, 18, 18, 0.5),
      body: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Color.fromRGBO(18, 18, 18, 0.9),
            title: //switch between the trending this week and trending today
                Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Top Movies: ',
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.8), fontSize: 16)),
                SizedBox(width: 10),
                Container(
                  height: 45,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(6)),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: DropdownButton(
                      autofocus: true,
                      underline:
                          Container(height: 0, color: Colors.transparent),
                      dropdownColor: Colors.black.withOpacity(0.6),
                      icon: Icon(
                        Icons.arrow_drop_down_sharp,
                        color: Colors.red,
                        size: 30,
                      ),
                      value: head,
                      items: const [
                        DropdownMenuItem(
                          value: 1,
                          child: Text(
                            'Weekly',
                            style: TextStyle(
                              decoration: TextDecoration.none,
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        DropdownMenuItem(
                          value: 2,
                          child: Text(
                            'Daily',
                            style: TextStyle(
                              decoration: TextDecoration.none,
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          trendingWeek.clear();
                          head = int.parse(value.toString());
                          // trendinglist(uval);
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
            centerTitle: true,
            // automaticallyImplyLeading: false,
            toolbarHeight: 60,
            pinned: true,
            expandedHeight: MediaQuery.of(context).size.height * 0.5,
            actions: [
              IconButton(
                  icon: Icon(Icons.favorite),
                  onPressed: () {
                    addtofavoriate(
                      id: 'id',
                      type: 'media_type',
                      Details: 'super',
                    );
                  }),
            ],
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.parallax,
              background: FutureBuilder(
                future: trendingList(head),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    //return carouselcontrollerimpl.CarouselSlider(
                    return CarouselSlider(
                      options: CarouselOptions(
                          viewportFraction: 1,
                          autoPlay: true,
                          autoPlayInterval: Duration(seconds: 2),
                          height: MediaQuery.of(context).size.height),
                      items: trendingWeek.map(
                        (i) {
                          return Builder(
                            builder: (BuildContext context) {
                              //Padding(padding: EdgeInsets.all(10));
                              return GestureDetector(
                                onTap: () {},
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DescriptionChekUI(
                                          i['id'],
                                          i['media_type'],
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                        // color: Colors.amber,
                                        image: DecorationImage(
                                            colorFilter: ColorFilter.mode(
                                                Colors.black.withOpacity(0.3),
                                                BlendMode.darken),
                                            image: NetworkImage(
                                                'https://image.tmdb.org/t/p/w500${i['poster_path']}'),
                                            fit: BoxFit.fill)),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              child: Text(
                                                ' # '
                                                '${i['indexno'] + 1}',
                                                style: TextStyle(
                                                    color: Colors.red
                                                        .withOpacity(0.7),
                                                    fontSize: 18),
                                              ),
                                              margin: EdgeInsets.only(
                                                  left: 10, bottom: 6),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(
                                                  right: 8, bottom: 5),
                                              width: 90,
                                              padding: EdgeInsets.all(5),
                                              decoration: BoxDecoration(
                                                color:
                                                    Colors.red.withOpacity(0.2),
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(8),
                                                ),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  //rating icon
                                                  Icon(Icons.star,
                                                      color: Colors.amber,
                                                      size: 20),
                                                  SizedBox(width: 10),
                                                  Text(
                                                    '${i['media_type']}',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ).toList(),
                    );
                  } else {
                    return Center(
                        child: CircularProgressIndicator(
                      color: Colors.red,
                    ));
                  }
                },
              ),
            ),
          ),

          /******************** Stopped here Flexeble bar *********************/

          SliverList(
            delegate: SliverChildListDelegate(
              [
                serachbarFunc(),
                SizedBox(
                  height: 60,
                  child: TabBar(
                    indicatorSize: TabBarIndicatorSize.tab,
                    physics: BouncingScrollPhysics(),
                    labelPadding: EdgeInsets.symmetric(horizontal: 25),
                    isScrollable: true,
                    controller: _tabController,
                    indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey.withOpacity(0.4),
                    ),
                    tabs: [
                      Tab(child: Text('Tv Series')),
                      Tab(child: Text('Movies')),
                      Tab(child: Text('Soon')),
                    ],
                  ),
                ),
                Container(
                  height: 1050,
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      TvSeries(),
                      Movies(),
                      Soon(),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

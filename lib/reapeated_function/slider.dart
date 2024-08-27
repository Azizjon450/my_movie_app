import 'package:flutter/material.dart';
import 'package:my_movie_app/details/movie_details.dart';
import 'package:my_movie_app/details/tv_series_details.dart';

Widget sliderList(
    List firstListName, String categoryTittle, String type, int itemCount) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: EdgeInsets.only(
          left: 10.0,
          top: 15.0,
          bottom: 40.0,
        ),
        child: Text(categoryTittle),
      ),
      Container(
        height: 250,
        child: ListView.builder(
          physics: BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemCount: itemCount,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                if (type == 'movie') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MoviesDetails(
                        id: firstListName[index]['id'],
                      ),
                    ),
                  );
                } else if (type == 'Tv') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return TvSeriesDetails(id: firstListName[index]['id']);
                    }),
                  );
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  image: DecorationImage(
                    colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.3),
                      BlendMode.darken,
                    ),
                    image: NetworkImage(
                      'https://image.tmdb.org/t/p/w500${firstListName[index]['poster_path']}',
                    ),
                  ),
                ),
                margin: EdgeInsets.only(left: 13),
                width: 170,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 2, left: 6),
                          child: Text(firstListName[index]['Date']),
                        ),
                        SizedBox(height: 10,),
                        Padding(
                          padding: EdgeInsets.only(top: 2, left: 6),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(5)),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                top: 2,
                                bottom: 2,
                                right: 5,
                                left: 5,
                              ),
                              child: Row(
                                // Row for rating
                                children: [
                                  Icon(
                                    Icons.star,
                                    color: Colors.yellow,
                                  ),
                                  const SizedBox(
                                    width: 2,
                                  ),
                                  Text(
                                    firstListName[index]['vote_average']
                                        .toString(),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        ),
      )
    ],
  );
}

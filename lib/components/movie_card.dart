import 'package:flutter/material.dart';
import 'package:moviex/api/movie_api.dart';
import 'package:moviex/model/discover.dart';
import 'package:moviex/model/genre.dart';

import '../util.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;
  final Categories categories;

  MovieCard(this.movie, this.categories);

  @override
  Widget build(BuildContext context) {
    var genreString = '';

    if (movie.genreIds.length > 2) {
      movie.genreIds = movie.genreIds.sublist(0, 2);
    }

    categories?.genres?.forEach((v) {
      genreString += movie.genreIds.contains(v.id) ? (v.name + ',') : '';
    });

    if (genreString.isNotEmpty) {
      genreString = genreString.substring(0, genreString.length - 1);
    }

    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 10),
      child: Container(
        height: 120,
        child: Stack(
          children: <Widget>[
            Positioned(
              height: 100.0,
              bottom: 0.0,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.white,
                ),
                width: (MediaQuery.of(context).size.width - 16.0),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      SizedBox(
                        width: 120,
                      ),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              movie.title,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: appSwatch[500]),
                            ),
                            SizedBox(height: 5),
                            Text(
                              genreString,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              movie.voteAverage.toString(),
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: appSwatch[500],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              height: 100,
              top: 0.0,
              width: 90.0,
              left: 15.0,
              child: Material(
                elevation: 5.0,
                borderRadius: BorderRadius.circular(10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    '${posterBaseUrl}w500/${movie.posterPath}',
                    height: 100,
                    width: 90,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:moviex/api/movie_api.dart';
import 'package:moviex/model/detailed_movie.dart';
import 'package:moviex/util.dart';

class MovieDetailsPage extends StatefulWidget {
  final int movieId;

  MovieDetailsPage(this.movieId);

  @override
  _MovieDetailsPageState createState() => _MovieDetailsPageState();
}

class _MovieDetailsPageState extends State<MovieDetailsPage> {
  DetailedMovie _detailedMovie;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDetailedMovie();
  }

  @override
  Widget build(BuildContext context) {
    var cWidth = MediaQuery.of(context).size.width - 40;

    return (_detailedMovie != null)
        ? Container(
            // color: Colors.blue,
            child: Column(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Material(
                      elevation: 8,
                      shadowColor: appSwatch[500],
                      child: Image.network(
                        '${posterBaseUrl}original/${_detailedMovie.backdropPath}',
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.cover,
                        alignment: Alignment.topCenter,
                        height: (MediaQuery.of(context).size.height * 0.5),
                      ),
                    ),
                    Positioned(
                      height: 40.0,
                      top: 40.0,
                      // width: 80.0,
                      // left: 20.0,
                      child: FlatButton(
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.arrow_back_ios,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    Positioned(
                      height: 40.0,
                      top: 40.0,
                      width: 80.0,
                      right: 20.0,
                      child: FlatButton(
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.more_horiz,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        onPressed: () => null,
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      // height: MediaQuery.of(context).size.height,
                      width: cWidth,
                      // color: Colors.red,
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: 20),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                width: 0.6 * cWidth,
                                child: Text(
                                  _detailedMovie.title,
                                  style: TextStyle(
                                    color: appSwatch[500],
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                              Container(
                                child: Center(
                                  child: Text(
                                    '3D',
                                    style: TextStyle(
                                      color: Colors.green,
                                    ),
                                  ),
                                ),
                                width: 35.0,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.green,
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              Expanded(
                                child: SizedBox(),
                              ),
                              Text(
                                _detailedMovie.voteAverage.toString(),
                                style: TextStyle(
                                  color: appSwatch[500],
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20.0),
                          Row(
                            children: <Widget>[
                              Container(
                                child: Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.access_time,
                                      color: appSwatch[500],
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      '${_detailedMovie.runtime}m',
                                      style: TextStyle(
                                        color: appSwatch[500],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(width: 30),
                              Container(
                                child: Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.favorite_border,
                                      color: appSwatch[500],
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      (_detailedMovie.voteCount >= 1000)
                                          ? '${((_detailedMovie.voteCount / 1000).toStringAsFixed(2))}k'
                                          : '${_detailedMovie.voteCount}',
                                      style: TextStyle(
                                        color: appSwatch[500],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(width: 30),
                              Container(
                                child: Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.attach_money,
                                      color: appSwatch[500],
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      (_detailedMovie.revenue >= 1000000)
                                          ? '${((_detailedMovie.revenue / 1000000).toStringAsFixed(1))}m'
                                          : '${_detailedMovie.revenue}',
                                      style: TextStyle(
                                        color: appSwatch[500],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 30.0),
                          Divider(
                            height: 1.0,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 10.0),
                          Container(
                            width: cWidth,
                            child: Text(
                              _buildGenreString(),
                              style: TextStyle(
                                color: Colors.grey,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            width: cWidth,
                            child: Text(
                              _detailedMovie.overview,
                              style: TextStyle(
                                height: 1.5,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        : Container(
            color: Colors.white,
            child: Center(
              child: CircularProgressIndicator(
                value: null,
              ),
            ),
          );
  }

  void getDetailedMovie() async {
    _detailedMovie = await MovieApi.getDetailedMovie(widget.movieId);
    setState(() {});
  }

  String _buildGenreString() {
    var s = '';
    _detailedMovie.genres.forEach((v) => s += '${v.name} /');
    return s.substring(0, s.length - 1);
  }
}

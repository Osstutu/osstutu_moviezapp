import 'package:flutter/cupertino.dart';
import 'package:moviex/model/config.dart';
import 'package:moviex/model/detailed_movie.dart';
import 'package:moviex/model/discover.dart';
import 'package:moviex/model/genre.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'network.dart';
import 'dart:convert';

const String apiKey = 'ab0d2a1c784226043ce16ce959090bf7';
//1
const String baseUrl = 'https://api.themoviedb.org/3/';
// 2
const String posterBaseUrl = 'https://image.tmdb.org/t/p/';

class MovieApi {
  static Future<Config> getConfiguration() async {
    //
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var config = preferences.getString('config');

    if (config != null) {
      return Config.fromJson(jsonDecode(config));
    }

    Network network = Network('${baseUrl}configuration?api_key=$apiKey');

    config = await network.getData();
    await preferences.setString('config', config.toString());

    return Config.fromJson(jsonDecode(config));
  }

  static Future<Categories> getCategories() async {
    Network network = Network('${baseUrl}genre/movie/list?api_key=$apiKey');

    var categories = await network.getData();

    return Categories.fromJson(jsonDecode(categories));
  }

  static Future<Discover> getDiscoveries(int genreId, int page) async {
    var url = genreId > 0
        ? '${baseUrl}discover/movie?api_key=$apiKey&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=$page&with_genres=$genreId'
        : '${baseUrl}discover/movie?api_key=$apiKey&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=$page';

    Network network = Network(url);

    var discoveries = await network.getData();

    return Discover.fromJson(jsonDecode(discoveries));
  }

  static Future<Discover> findMovie(String s) async {
    Network network = Network(
        '${baseUrl}search/movie?api_key=$apiKey&query=$s&language=en-US&include_adult=false');

    var discoveries = await network.getData();

    return Discover.fromJson(jsonDecode(discoveries));
  }

  static Future<DetailedMovie> getDetailedMovie(int movieId) async {
    Network network =
        Network('${baseUrl}movie/$movieId?api_key=$apiKey&language=en-US');

    var discoveries = await network.getData();

    return DetailedMovie.fromJson(jsonDecode(discoveries));
  }
}

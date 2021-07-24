import 'package:flutter/material.dart';
import 'package:moviex/api/movie_api.dart';
import 'package:moviex/components/custom_radio.dart';
import 'package:moviex/components/movie_card.dart';
import 'package:moviex/model/config.dart';
import 'package:moviex/model/discover.dart';
import 'package:moviex/model/genre.dart';
import 'package:moviex/util.dart';
import 'package:moviex/screens/movie_details.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<RadioModel> _categoriesRadioModel = [];
  Config _config;

  int _pageNumber = 1;
  int _currentGenre = -1;

  Discover _discovery;
  Categories _categories;

  ScrollController _scrollController = ScrollController();
  bool _showLoading = false;

  bool _showSearch = false;

  @override
  void initState() {
    super.initState();

//get Api Configuration
    getConfig();

    //init category radio model
    _categoriesRadioModel.add(RadioModel(true, 'All', _currentGenre));
    getCategoryRadioModel();

    getAllDiscovery();

    _scrollController.addListener(() {
      var triggerFetchMoreSize =
          0.9 * _scrollController.position.maxScrollExtent;

      if (_scrollController.position.pixels > triggerFetchMoreSize) {
        setState(() {
          _showLoading = true;
          _onPageEnd();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: backgroundWhite,
        child: SafeArea(
          child: Column(
            children: <Widget>[
              SizedBox(height: 20.0),
              AnimatedSwitcher(
                duration: Duration(milliseconds: 200),
                child: !_showSearch
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(width: 10),
                          Text(
                            'Discover The Movie',
                            style: TextStyle(
                              color: appSwatch[500],
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 10),
                          IconButton(
                            icon: Icon(Icons.search),
                            iconSize: 36,
                            color: appSwatch[500],
                            onPressed: () {
                              setState(() {
                                _showSearch = true;
                              });
                            },
                          )
                        ],
                      )
                    : Row(
                        children: <Widget>[
                          SizedBox(width: 15.0),
                          Flexible(
                            child: TextField(
                              textInputAction: TextInputAction.go,
                              onSubmitted: _findMovie,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Search Movie...'),
                            ),
                          ),
                          IconButton(
                            color: appSwatch[500],
                            icon: Icon(Icons.close),
                            onPressed: () {
                              setState(() {
                                _showSearch = false;
                              });
                            },
                          ),
                          SizedBox(
                            width: 15.0,
                          )
                        ],
                      ),
              ),
              SizedBox(height: 10.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: CustomRadio(
                  radioItems: _categoriesRadioModel,
                  onTap: _onNewCategoryTap,
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Expanded(
                child: (_discovery != null)
                    ? ListView.builder(
                        controller: _scrollController,
                        itemCount: !_showLoading
                            ? _discovery.results.length
                            : (_discovery.results.length + 1),
                        itemBuilder: (BuildContext context, int index) {
                          if (index == _discovery.results.length &&
                              _showLoading) {
                            return Container(
                              height: 80,
                              child: Center(
                                child: CircularProgressIndicator(
                                  value: null,
                                ),
                              ),
                            );
                          }

                          return GestureDetector(
                            onTap: () => _gotoMovieDetailsPage(context, index),
                            child: MovieCard(
                                _discovery.results[index], _categories),
                          );
                        },
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          CircularProgressIndicator(
                            value: null,
                          ),
                          SizedBox(height: 10),
                          Text('Loading...'),
                        ],
                      ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: appSwatch[500],
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.trending_up),
            title: Text('Trending'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            title: Text('Favorites'),
          ),
        ],
      ),
    );
  }

  void getConfig() async {
    _config = await MovieApi.getConfiguration();
  }

  void getCategoryRadioModel() async {
    Categories result = await MovieApi.getCategories();
    _categories = result;

    setState(() {
      result.genres.forEach((v) {
        _categoriesRadioModel.add(RadioModel(false, v.name, v.id));
      });
    });

    // print(_categoriesRadioModel.length);
  }

  void getAllDiscovery() async {
    _discovery = await MovieApi.getDiscoveries(_currentGenre, _pageNumber);
    print(_discovery.page);
    setState(() {});
  }

  void _onNewCategoryTap(int genreId) async {
    _currentGenre = genreId;
    _scrollController.animateTo(
      0.0,
      duration: Duration(milliseconds: 300),
      curve: Curves.bounceIn,
    );
    _discovery = await MovieApi.getDiscoveries(genreId, _pageNumber = 1);
    setState(() {});
  }

  void _onPageEnd() async {
    if (_pageNumber < _discovery.totalPages) {
      var newDiscovery =
          await MovieApi.getDiscoveries(_currentGenre, ++_pageNumber);
      _discovery.page = _pageNumber;
      _discovery.results.addAll(newDiscovery.results);
      _showLoading = false;
      setState(() {});
    }
  }

  void _findMovie(String searchString) async {
    var s = searchString.replaceAll(RegExp(r"\s\b|\b\s"), '%20');

    _discovery = await MovieApi.findMovie(s);
    _pageNumber = 1;

    setState(() {});
  }

  void _gotoMovieDetailsPage(BuildContext context, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          body: MovieDetailsPage(_discovery.results[index].id),
        ),
      ),
    );
  }
}

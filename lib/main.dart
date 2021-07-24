import 'package:flutter/material.dart';
import 'package:moviex/screens/home.dart';
import 'package:moviex/util.dart';

void main() => runApp(MoviexApp());

class MoviexApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: appSwatch, // todo change to appSwatch
      ),
      home: HomePage(),
    );
  }
}

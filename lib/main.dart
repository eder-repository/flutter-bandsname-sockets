import 'package:band_name/src/pages/home.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Band Name',
      initialRoute: 'home',
      routes: {'home': (_) => HomePage()},
    );
  }
}

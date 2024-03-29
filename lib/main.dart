import 'package:flutter/material.dart';
import 'package:funny_tinder_with_friends/matches.dart';
import 'package:funny_tinder_with_friends/pages/home_page.dart';

import 'model/profile_model.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Funny tinder with friends',
      theme: ThemeData(
        primaryColorBrightness: Brightness.light
      ),
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}


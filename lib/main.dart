import 'package:flutter/material.dart';

import './title_screen.dart';
import 'quiz_list.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LateralThinking',
      theme: ThemeData(
        primarySwatch: Colors.brown,
        fontFamily: 'KiwiMaru',
      ),
      home: QuizListScreen(),
    );
  }
}

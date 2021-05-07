import 'package:flutter/material.dart';

import './widgets/title_screen.dart';
import './widgets/quiz_list_screen.dart';

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

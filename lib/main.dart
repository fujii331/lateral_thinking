import 'package:flutter/material.dart';

import 'widgets/title_screen.widget.dart';
import 'widgets/quiz_list_screen.widget.dart';
import 'widgets/quiz_detail/quiz_detail_screen.widget.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LateralThinking',
      theme: ThemeData(
        fontFamily: 'KiwiMaru',
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: <TargetPlatform, PageTransitionsBuilder>{
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          },
        ),
        textTheme: ThemeData.light().textTheme.copyWith(
              bodyText1: TextStyle(
                fontSize: 17.0,
                color: Colors.black,
                fontFamily: 'NotoSerifJP',
              ),
              bodyText2: TextStyle(
                fontSize: 20.0,
                color: Colors.white,
                fontFamily: 'NotoSerifJP',
              ),
              button: TextStyle(
                fontSize: 20.0,
                // fontWeight: FontWeight.bold,
              ),
            ),
      ),
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/': (BuildContext context) => TitleScreen(),
        QuizListScreen.routeName: (BuildContext context) => QuizListScreen(),
        QuizDetailScreen.routeName: (BuildContext context) =>
            QuizDetailScreen(),
      },
    );
  }
}

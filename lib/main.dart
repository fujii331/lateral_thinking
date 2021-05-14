import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import './screens/title.screen.dart';
import './screens/quiz_list.screen.dart';
import './screens/quiz_detail_tab.screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();

  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LateralThinking',
      theme: ThemeData(
        canvasColor: Colors.grey.shade100,
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
              ),
            ),
      ),
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/': (BuildContext context) => TitleScreen(),
        QuizListScreen.routeName: (BuildContext context) => QuizListScreen(),
        QuizDetailTabScreen.routeName: (BuildContext context) =>
            QuizDetailTabScreen(),
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (ctx) => TitleScreen(),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';

import './screens/title.screen.dart';
import './screens/lecture_tab.screen.dart';
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

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  late AudioPlayer bgm;
  final AudioCache soundEffect = AudioCache();

  @override
  void initState() {
    super.initState();
    Future(() async {
      bgm = await soundEffect.loop('sounds/bgm.mp3',
          volume: 0.2, isNotification: true);
    });
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      bgm.pause();
    } else if (state == AppLifecycleState.resumed) {
      bgm.resume();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LateralThinking',
      debugShowCheckedModeBanner: false,
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
                fontSize: 15.5,
                color: Colors.black,
                fontFamily: 'NotoSerifJP',
              ),
              button: TextStyle(
                fontSize: 20.0,
              ),
              headline1: TextStyle(
                fontSize: 18.0,
                color: Colors.white,
                fontFamily: 'NotoSerifJP',
              ),
              headline2: TextStyle(
                // 質問済みリスト用 黒
                fontSize: 18.0,
                color: Colors.black,
                fontFamily: 'NotoSerifJP',
              ),
              headline3: TextStyle(
                // 質問済みリスト用 黒 小さめ
                fontSize: 16.0,
                color: Colors.black,
                fontFamily: 'NotoSerifJP',
              ),
            ),
      ),
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/': (BuildContext context) => TitleScreen(),
        LectureTabScreen.routeName: (BuildContext context) =>
            LectureTabScreen(),
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

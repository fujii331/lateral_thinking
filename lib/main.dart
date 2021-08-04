import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import './screens/title.screen.dart';
import './screens/lecture_tab.screen.dart';
import './screens/quiz_list.screen.dart';
import './screens/quiz_detail_tab.screen.dart';
import './screens/warewolf_setting.screen.dart';
import './screens/warewolf_preparation.screen.dart';
import './screens/warewolf_preparation_first.screen.dart';
import './screens/warewolf_playing.screen.dart';
import './screens/warewolf_vote.screen.dart';
import './screens/warewolf_vote_first.screen.dart';
import './screens/warewolf_discussion.screen.dart';
import './screens/warewolf_voted_confirm.screen.dart';
import './screens/warewolf_result.screen.dart';
import './screens/warewolf_summary_result.screen.dart';
import './screens/warewolf_lecture.screen.dart';

import './providers/common.provider.dart';
import './providers/warewolf.provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();

  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

useWidgetLifecycleObserver(BuildContext context) {
  return use(_WidgetObserver(
    context,
  ));
}

class _WidgetObserver extends Hook<void> {
  final BuildContext context;

  _WidgetObserver(
    this.context,
  );

  @override
  HookState<void, Hook<void>> createState() {
    return _WidgetObserverState(
      context,
    );
  }
}

class _WidgetObserverState extends HookState<void, _WidgetObserver>
    with WidgetsBindingObserver {
  final BuildContext context;

  _WidgetObserverState(
    this.context,
  );

  @override
  void build(BuildContext context) {}

  @override
  void initHook() {
    super.initHook();
    Future(() async {
      context.read(bgmProvider).state =
          await context.read(soundEffectProvider).state.loop(
                'sounds/bgm.mp3',
                isNotification: true,
                volume: 0,
              );
    });
    WidgetsBinding.instance!.addObserver(this);
  }

  void test() {
    context.read(bgmProvider).state.pause();
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
      context.read(bgmProvider).state.pause();
      context.read(subTimeStopFlgProvider).state = true;
    } else if (state == AppLifecycleState.resumed) {
      context.read(bgmProvider).state.resume();
      context.read(subTimeStopFlgProvider).state = false;
    }
    super.didChangeAppLifecycleState(state);
  }
}

class MyApp extends HookWidget {
  @override
  Widget build(BuildContext context) {
    useWidgetLifecycleObserver(
      context,
    );

    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      title: 'King of Lateral thinking',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        canvasColor: Colors.grey.shade100,
        fontFamily: 'SawarabiGothic',
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
                fontSize: 19.0,
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
        WarewolfSettingScreen.routeName: (BuildContext context) =>
            WarewolfSettingScreen(),
        WarewolfPreparationFirstScreen.routeName: (BuildContext context) =>
            WarewolfPreparationFirstScreen(),
        WarewolfPreparationScreen.routeName: (BuildContext context) =>
            WarewolfPreparationScreen(),
        WarewolfPlayingScreen.routeName: (BuildContext context) =>
            WarewolfPlayingScreen(),
        WarewolfVoteFirstScreen.routeName: (BuildContext context) =>
            WarewolfVoteFirstScreen(),
        WarewolfVoteScreen.routeName: (BuildContext context) =>
            WarewolfVoteScreen(),
        WarewolfDiscussionScreen.routeName: (BuildContext context) =>
            WarewolfDiscussionScreen(),
        WarewolfVotedConfirmScreen.routeName: (BuildContext context) =>
            WarewolfVotedConfirmScreen(),
        WarewolfResultScreen.routeName: (BuildContext context) =>
            WarewolfResultScreen(),
        WarewolfSummaryResultScreen.routeName: (BuildContext context) =>
            WarewolfSummaryResultScreen(),
        WarewolfLectureScreen.routeName: (BuildContext context) =>
            WarewolfLectureScreen(),
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (ctx) => TitleScreen(),
        );
      },
    );
  }
}

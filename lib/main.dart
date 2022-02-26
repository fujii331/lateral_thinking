import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import './screens/title.screen.dart';
import './screens/lecture_tab.screen.dart';
import './screens/quiz_list.screen.dart';
import './screens/quiz_detail_tab.screen.dart';
import './screens/werewolf_setting.screen.dart';
import './screens/werewolf_preparation.screen.dart';
import './screens/werewolf_preparation_first.screen.dart';
import './screens/werewolf_playing.screen.dart';
import './screens/werewolf_vote.screen.dart';
import './screens/werewolf_vote_first.screen.dart';
import './screens/werewolf_discussion.screen.dart';
import './screens/werewolf_voted_confirm.screen.dart';
import './screens/werewolf_result.screen.dart';
import './screens/werewolf_summary_result.screen.dart';
import './screens/werewolf_lecture.screen.dart';

import './providers/common.provider.dart';
import './providers/werewolf.provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
              bodyText1: const TextStyle(
                fontSize: 17.0,
                color: Colors.black,
                fontFamily: 'NotoSerifJP',
              ),
              bodyText2: const TextStyle(
                fontSize: 15.5,
                color: Colors.black,
                fontFamily: 'NotoSerifJP',
              ),
              button: const TextStyle(
                fontSize: 19.0,
              ),
              headline1: const TextStyle(
                fontSize: 18.0,
                color: Colors.white,
                fontFamily: 'NotoSerifJP',
              ),
              headline2: const TextStyle(
                // 質問済みリスト用 黒
                fontSize: 18.0,
                color: Colors.black,
                fontFamily: 'NotoSerifJP',
              ),
              headline3: const TextStyle(
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
        WerewolfSettingScreen.routeName: (BuildContext context) =>
            WerewolfSettingScreen(),
        WerewolfPreparationFirstScreen.routeName: (BuildContext context) =>
            WerewolfPreparationFirstScreen(),
        WerewolfPreparationScreen.routeName: (BuildContext context) =>
            WerewolfPreparationScreen(),
        WerewolfPlayingScreen.routeName: (BuildContext context) =>
            WerewolfPlayingScreen(),
        WerewolfVoteFirstScreen.routeName: (BuildContext context) =>
            WerewolfVoteFirstScreen(),
        WerewolfVoteScreen.routeName: (BuildContext context) =>
            WerewolfVoteScreen(),
        WerewolfDiscussionScreen.routeName: (BuildContext context) =>
            WerewolfDiscussionScreen(),
        WerewolfVotedConfirmScreen.routeName: (BuildContext context) =>
            WerewolfVotedConfirmScreen(),
        WerewolfResultScreen.routeName: (BuildContext context) =>
            WerewolfResultScreen(),
        WerewolfSummaryResultScreen.routeName: (BuildContext context) =>
            WerewolfSummaryResultScreen(),
        WerewolfLectureScreen.routeName: (BuildContext context) =>
            WerewolfLectureScreen(),
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (ctx) => TitleScreen(),
        );
      },
    );
  }
}

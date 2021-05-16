import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:audioplayers/audio_cache.dart';

import './quiz_list.screen.dart';
import './lecture_tab.screen.dart';
import '../widgets/background.widget.dart';
import '../providers/quiz.provider.dart';

class TitleScreen extends HookWidget {
  void toQuizList(BuildContext ctx) {
    Navigator.of(ctx).pushNamed(
      QuizListScreen.routeName,
    );
  }

  void toLectureTab(BuildContext ctx) {
    Navigator.of(ctx).pushNamed(
      LectureTabScreen.routeName,
    );
  }

  @override
  Widget build(BuildContext context) {
    final AudioCache soundEffect = useProvider(soundEffectProvider).state;

    return Scaffold(
      body: Stack(
        children: <Widget>[
          background(),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  '謎解きの館',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 40.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '一人用水平思考ゲーム',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 100),
                  child: Column(
                    children: [
                      _selectButton(
                        context,
                        '遊ぶ',
                        Colors.green,
                        Icon(Icons.account_balance),
                        soundEffect,
                      ),
                      _selectButton(
                        context,
                        '遊び方',
                        Colors.teal,
                        Icon(Icons.auto_stories),
                        soundEffect,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _selectButton(
    BuildContext context,
    String text,
    MaterialColor color,
    Icon icon,
    AudioCache soundEffect,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 20,
      ),
      child: ElevatedButton.icon(
        icon: icon,
        onPressed: () => {
          soundEffect.play('sounds/tap.mp3', isNotification: true),
          if (text == '遊ぶ')
            {
              toQuizList(context),
            }
          else
            {
              toLectureTab(context),
            },
        },
        label: Text(text),
        style: ElevatedButton.styleFrom(
          elevation: 8, // 影をつける
          shadowColor: Colors.white,
          primary: color,
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 5,
          ),
          textStyle: Theme.of(context).textTheme.button,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}

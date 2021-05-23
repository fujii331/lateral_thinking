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
    // 初回起動時しか通らないのでload
    soundEffect.loadAll([
      'sounds/correct_answer.mp3',
      'sounds/tap.mp3',
      'sounds/cancel.mp3',
      'sounds/quiz_button.mp3',
      'sounds/hint.mp3',
    ]);

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
                    fontSize: 45.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'KiwiMaru',
                    color: Colors.yellow.shade200,
                  ),
                ),
                Text(
                  '一人用水平思考クイズ',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25.0,
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

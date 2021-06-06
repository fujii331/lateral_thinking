import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:lottie/lottie.dart';

import './quiz_list.screen.dart';
import './lecture_tab.screen.dart';
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
    final height = MediaQuery.of(context).size.height;

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
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/title_back.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Lottie.asset('assets/lottie/night.json'),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Lottie.asset('assets/lottie/castle.json'),
            ),
          ),
          Column(
            children: [
              SizedBox(),
              Spacer(),
              Row(
                children: [
                  SizedBox(),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0, bottom: 8.0),
                    child: Text(
                      'Arun Sajeev, jk kim @LottieFiles',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  '謎解きの王様',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: height > 610 ? 48 : 41,
                    fontFamily: 'YuseiMagic',
                    color: Colors.yellow.shade200,
                  ),
                ),
                Text(
                  '一人用水平思考クイズ',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: height > 610 ? 25 : 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: height > 610 ? 150 : 90),
                  child: Column(
                    children: [
                      _selectButton(
                        context,
                        '遊ぶ',
                        Colors.lightBlue.shade500,
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
    Color color,
    Icon icon,
    AudioCache soundEffect,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 20,
      ),
      child: SizedBox(
        height: 50,
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
            shadowColor: Colors.black,
            primary: color,
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 5,
            ),
            textStyle: Theme.of(context).textTheme.button,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            side: const BorderSide(),
          ),
        ),
      ),
    );
  }
}

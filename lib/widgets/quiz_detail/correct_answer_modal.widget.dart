import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:math';

import '../../providers/quiz.provider.dart';

class CorrectAnswerModal extends HookWidget {
  final String comment;

  CorrectAnswerModal(this.comment);

  final randomNumber = new Random().nextInt(3);

  @override
  Widget build(BuildContext context) {
    final AudioCache soundEffect = useProvider(soundEffectProvider).state;

    return AlertDialog(
      content: Stack(
        children: <Widget>[
          Opacity(
            opacity: 0.2,
            child: Image.asset(randomNumber == 0
                ? 'assets/images/princess.png'
                : 'assets/images/prince.png'),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                ),
                child: Text(
                  "お見事！正解です！",
                  style: TextStyle(
                    fontSize: 22.0,
                    color: Colors.red.shade800,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * .30,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 15,
                    ),
                    child: Text(
                      comment,
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 20,
                ),
                child: ElevatedButton(
                  onPressed: () => {
                    soundEffect.play('sounds/tap.mp3', isNotification: true),
                    Navigator.pop(context),
                    Navigator.pop(context),
                  },
                  child: const Text('一覧に戻る'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue[700],
                    textStyle: Theme.of(context).textTheme.button,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

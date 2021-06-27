import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';

import '../../providers/quiz.provider.dart';
import '../../text.dart';

class CorrectAnswerModal extends HookWidget {
  final String comment;

  CorrectAnswerModal(this.comment);

  @override
  Widget build(BuildContext context) {
    final AudioCache soundEffect = useProvider(soundEffectProvider).state;
    final bool enModeFlg = useProvider(enModeFlgProvider).state;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * .86 > 700 ? 150 : 0,
      ),
      child: AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 10,
              ),
              child: Text(
                enModeFlg
                    ? EN_TEXT['correctAnswer']!
                    : JA_TEXT['correctAnswer']!,
                style: TextStyle(
                  fontSize: 22.0,
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
                child: Text(
                  enModeFlg ? EN_TEXT['back']! : JA_TEXT['back']!,
                ),
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
      ),
    );
  }
}

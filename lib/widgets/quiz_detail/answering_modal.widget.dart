import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'dart:math';
import '../../providers/quiz.provider.dart';

class AnsweringModal extends HookWidget {
  final bool correctFlg;

  AnsweringModal(this.correctFlg);

  final randomNumber1 = new Random().nextInt(3) + 1;
  final randomNumber2 = new Random().nextInt(3) + 1;
  final randomNumber3 = new Random().nextInt(3) + 1;

  @override
  Widget build(BuildContext context) {
    final AudioCache soundEffect = useProvider(soundEffectProvider).state;

    final displayFlg1 = useState<bool>(false);
    final displayFlg2 = useState<bool>(false);
    final displayFlg3 = useState<bool>(false);
    final displayFlg4 = useState<bool>(false);

    useEffect(() {
      WidgetsBinding.instance!.addPostFrameCallback((_) async {
        displayFlg1.value = true;
        soundEffect.play('sounds/think.mp3', isNotification: true);
        await new Future.delayed(
          new Duration(seconds: 1),
        );
        displayFlg1.value = false;
        displayFlg2.value = true;
        await new Future.delayed(
          new Duration(seconds: 1),
        );
        displayFlg2.value = false;
        displayFlg3.value = true;
        if (correctFlg) {
          await new Future.delayed(
            new Duration(seconds: 1),
          );
          displayFlg3.value = false;
          displayFlg4.value = true;
        }
      });
      return null;
    }, const []);

    return Theme(
      data: Theme.of(context)
          .copyWith(dialogBackgroundColor: Colors.white.withOpacity(0.0)),
      child: new SimpleDialog(
        children: <Widget>[
          Center(
            child: Stack(
              children: [
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 500),
                  opacity: displayFlg1.value ? 1 : 0,
                  child: Image.asset(
                      'assets/images/1_' + randomNumber1.toString() + '.png'),
                ),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 500),
                  opacity: displayFlg2.value ? 1 : 0,
                  child: Image.asset(
                      'assets/images/2_' + randomNumber2.toString() + '.png'),
                ),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 500),
                  opacity: displayFlg3.value ? 1 : 0,
                  child: correctFlg
                      ? Image.asset('assets/images/true_3_' +
                          randomNumber3.toString() +
                          '.png')
                      : Image.asset('assets/images/false_3_' +
                          randomNumber3.toString() +
                          '.png'),
                ),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 500),
                  opacity: displayFlg4.value ? 1 : 0,
                  child: Image.asset('assets/images/true_4_1.png'),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

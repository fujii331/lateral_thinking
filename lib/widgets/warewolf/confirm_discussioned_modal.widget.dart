import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';

import '../../providers/quiz.provider.dart';
import '../../screens/warewolf_vote.screen.dart';

class ConfirmDiscussionedModal extends HookWidget {
  final bool timeLimitedFlg;
  final ValueNotifier<bool> timeStopFlg;
  final ValueNotifier<DateTime> time;
  final ValueNotifier<bool> finishFlg;

  ConfirmDiscussionedModal(
    this.timeLimitedFlg,
    this.timeStopFlg,
    this.time,
    this.finishFlg,
  );

  @override
  Widget build(BuildContext context) {
    final AudioCache soundEffect = useProvider(soundEffectProvider).state;

    return Container(
      padding: const EdgeInsets.only(
        left: 20,
        right: 20,
        bottom: 25,
      ),
      height: 300, // よう調整
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 10,
            ),
            child: Text(
              timeLimitedFlg ? '制限時間終了' : '会議終了の確認',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                fontFamily: 'SawarabiGothic',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 20,
            ),
            child: Text(
              '会議を終了して投票に進みますか？',
              style: TextStyle(
                fontSize: 18.0,
                fontFamily: 'SawarabiGothic',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 15,
            ),
            child: Wrap(
              children: [
                ElevatedButton(
                  onPressed: () {
                    soundEffect.play('sounds/tap.mp3', isNotification: true);
                    if (timeLimitedFlg) {
                      time.value = DateTime(2020, 1, 1, 1, 1);
                    }
                    timeStopFlg.value = false;
                    Navigator.pop(context);
                  },
                  child: Text(timeLimitedFlg ? '1分延長' : '戻る'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.only(
                      right: 14,
                      left: 14,
                    ),
                    primary: Colors.amber[500],
                    textStyle: Theme.of(context).textTheme.button,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(width: 30),
                ElevatedButton(
                  onPressed: () {
                    soundEffect.play('sounds/tap.mp3', isNotification: true);
                    finishFlg.value = true;
                    Navigator.of(context).pushNamed(
                      WarewolfVoteScreen.routeName,
                      arguments: 1,
                    );
                  },
                  child: Text('進む'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.only(
                      right: 14,
                      left: 14,
                    ),
                    primary: Colors.amber[500],
                    textStyle: Theme.of(context).textTheme.button,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

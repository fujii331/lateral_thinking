import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:app_review/app_review.dart';

import '../providers/quiz.provider.dart';
import '../../text.dart';

class ReplyModal extends HookWidget {
  final String reply;
  final int reviewNo;

  ReplyModal(
    this.reply,
    this.reviewNo,
  );

  @override
  Widget build(BuildContext context) {
    final AudioCache soundEffect = useProvider(soundEffectProvider).state;
    final bool enModeFlg = useProvider(enModeFlgProvider).state;

    return Padding(
      padding: const EdgeInsets.only(
        left: 20,
        right: 20,
        bottom: 15,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 10,
            ),
            child: Text(
              reply,
              style: TextStyle(
                fontSize: 22.0,
                fontFamily: 'SawarabiGothic',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 15,
            ),
            child: ElevatedButton(
              onPressed: () => {
                soundEffect.play('sounds/cancel.mp3', isNotification: true),
                Navigator.pop(context),
                if (reviewNo == 15 || reviewNo == 18 || reviewNo == 30)
                  {
                    // 別の方法
                    // LaunchReview.launch(
                    //   androidAppId: "io.github.naoto613.lateral_thinking",
                    //   iOSAppId: "1572443299",
                    // ),
                    AppReview.requestReview.then(
                      (_) {},
                    ),
                  },
              },
              child: Text(
                enModeFlg ? EN_TEXT['closeButton']! : JA_TEXT['closeButton']!,
              ),
              style: ElevatedButton.styleFrom(
                primary: Colors.red[400],
                textStyle: Theme.of(context).textTheme.button,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

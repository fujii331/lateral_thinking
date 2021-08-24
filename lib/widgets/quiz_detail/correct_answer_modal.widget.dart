import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

import '../../providers/quiz.provider.dart';
import '../../providers/common.provider.dart';
import '../../models/analytics.model.dart';

import './analytics_modal.widget.dart';
import '../../text.dart';

class CorrectAnswerModal extends HookWidget {
  final String comment;
  final Analytics? data;

  CorrectAnswerModal(
    this.comment,
    this.data,
  );

  @override
  Widget build(BuildContext context) {
    final AudioCache soundEffect = useProvider(soundEffectProvider).state;
    final bool enModeFlg = useProvider(enModeFlgProvider).state;
    final double seVolume = useProvider(seVolumeProvider).state;

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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => {
                      soundEffect.play(
                        'sounds/tap.mp3',
                        isNotification: true,
                        volume: seVolume,
                      ),
                      Navigator.pop(context),
                      Navigator.pop(context),
                    },
                    child: Text(
                      enModeFlg ? EN_TEXT['back']! : '一覧へ',
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue.shade700,
                      textStyle: Theme.of(context).textTheme.button,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  data == null ? Container() : const SizedBox(width: 30),
                  data == null
                      ? Container()
                      : ElevatedButton(
                          onPressed: () {
                            soundEffect.play(
                              'sounds/tap.mp3',
                              isNotification: true,
                              volume: seVolume,
                            );
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.NO_HEADER,
                              headerAnimationLoop: false,
                              animType: AnimType.SCALE,
                              width:
                                  MediaQuery.of(context).size.width * .86 > 650
                                      ? 650
                                      : null,
                              body: AnalyticsModal(
                                data!,
                              ),
                            )..show();
                          },
                          child: Text(
                            '統計',
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.yellow.shade900,
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
      ),
    );
  }
}

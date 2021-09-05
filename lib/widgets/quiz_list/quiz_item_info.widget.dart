import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

import '../../providers/common.provider.dart';
import './info_modal.widget.dart';

class QuizItemInfo extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final AudioCache soundEffect = useProvider(soundEffectProvider).state;
    final double seVolume = useProvider(seVolumeProvider).state;

    return Container(
      height: height > 620 ? 52 : 45,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.orangeAccent.shade700,
        ),
      ),
      margin: EdgeInsets.symmetric(
        vertical: height > 620 ? 8 : 6,
        horizontal: 5,
      ),
      child: ListTile(
        leading: Container(
          padding: EdgeInsets.only(
              top: height > 620 ? 5 : 0,
              bottom: height > 620 ? 10 : 15,
              left: 5,
              right: 5),
          child: Text(
            'お知らせ',
            style: TextStyle(
              color: Colors.deepOrange.shade700,
              fontFamily: 'SawarabiGothic',
              fontSize: 20,
            ),
          ),
        ),
        title: Container(
          padding: EdgeInsets.only(
              top: height > 620 ? 5 : 0,
              bottom: height > 620 ? 10 : 15,
              right: 5),
          child: Text(
            'タップして表示',
            style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 15,
            ),
          ),
        ),
        onTap: () {
          soundEffect.play(
            'sounds/tap.mp3',
            isNotification: true,
            volume: seVolume,
          );
          AwesomeDialog(
            context: context,
            dialogType: DialogType.INFO,
            headerAnimationLoop: false,
            animType: AnimType.SCALE,
            width: MediaQuery.of(context).size.width * .86 > 650 ? 650 : null,
            body: InfoModal(),
          )..show();
        },
      ),
    );
  }
}

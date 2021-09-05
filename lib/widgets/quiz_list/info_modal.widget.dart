import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';

import '../../providers/common.provider.dart';

class InfoModal extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final AudioCache soundEffect = useProvider(soundEffectProvider).state;
    final double seVolume = useProvider(seVolumeProvider).state;

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
              '謎解きの王様をここまで遊んで頂きありがとうございます！\n\n現在、水平思考を題材にしたマッチング対戦アプリ制作に取り組んでいるため、しばらく問題の更新を停止する予定です。\n\n次回作も楽しみにして頂ければ大変嬉しく思います。\n\n今後とも謎解きの王様をよろしくお願い致します。',
              style: TextStyle(
                fontSize: 17.0,
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
                soundEffect.play(
                  'sounds/cancel.mp3',
                  isNotification: true,
                  volume: seVolume,
                ),
                Navigator.pop(context),
              },
              child: Text(
                '閉じる',
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

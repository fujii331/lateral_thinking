import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../providers/quiz.provider.dart';
import '../../../providers/common.provider.dart';

import '../../../text.dart';

class InputModeModal extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final AudioCache soundEffect = useProvider(soundEffectProvider).state;
    final bool enModeFlg = useProvider(enModeFlgProvider).state;
    final bool helperModeFlg = useProvider(helperModeFlgProvider).state;
    final bool displayInputFlg = useProvider(displayInputFlgProvider).state;
    final double seVolume = useProvider(seVolumeProvider).state;

    return Padding(
      padding: const EdgeInsets.only(
        left: 20,
        right: 20,
        bottom: 25,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(
              top: 10,
            ),
            child: ElevatedButton(
              onPressed: () async {
                soundEffect.play(
                  'sounds/tap.mp3',
                  isNotification: true,
                  volume: seVolume,
                );
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setBool('displayInputFlg', false);
                context.read(displayInputFlgProvider).state = false;
              },
              child: Text(enModeFlg ? '　 Fixed layout 　' : 'レイアウトを固定'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.only(
                  right: 14,
                  left: 14,
                ),
                primary: displayInputFlg
                    ? Colors.blue.shade200
                    : Colors.blue.shade400,
                textStyle: Theme.of(context).textTheme.button,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              soundEffect.play(
                'sounds/tap.mp3',
                isNotification: true,
                volume: seVolume,
              );
              SharedPreferences prefs = await SharedPreferences.getInstance();

              prefs.setBool('displayInputFlg', true);
              context.read(displayInputFlgProvider).state = true;
            },
            child: Text(enModeFlg ? 'Display input field' : '入力欄を常に表示'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.only(
                right: 14,
                left: 14,
              ),
              primary: displayInputFlg
                  ? Colors.orange.shade600
                  : Colors.orange.shade200,
              textStyle: Theme.of(context).textTheme.button,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 15,
            ),
            child: Text(
              displayInputFlg
                  ? enModeFlg
                      ? 'When entering words, you can always see the input fields.'
                      : '主語と関連語の入力時、常に入力欄が見えるように調整します。'
                  : enModeFlg
                      ? 'When entering words, the screen layout remains the same.'
                      : '主語と関連語の入力時、画面のレイアウトをそのまま固定します。',
              style: TextStyle(
                fontSize: 18.0,
                fontFamily: 'SawarabiGothic',
              ),
            ),
          ),
          Container(
            width: double.infinity,
            height: 54,
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              displayInputFlg
                  ? enModeFlg
                      ? '*Recommended for small terminals.'
                      : '※小さい端末向け\n　一部背景の変更あり'
                  : enModeFlg
                      ? '*Recommended for large terminals.'
                      : '※大きい端末向け',
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: 16.0,
                fontFamily: 'SawarabiGothic',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 15,
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

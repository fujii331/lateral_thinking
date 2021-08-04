import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../providers/quiz.provider.dart';
import '../../../providers/common.provider.dart';

import '../../../text.dart';

class ModeModal extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final AudioCache soundEffect = useProvider(soundEffectProvider).state;
    final bool enModeFlg = useProvider(enModeFlgProvider).state;
    final bool helperModeFlg = useProvider(helperModeFlgProvider).state;
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
            padding: const EdgeInsets.symmetric(
              vertical: 10,
            ),
            child: Wrap(
              children: [
                ElevatedButton(
                  onPressed: () async {
                    soundEffect.play(
                      'sounds/tap.mp3',
                      isNotification: true,
                      volume: seVolume,
                    );
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.setBool('helperModeFlg', true);
                    context.read(helperModeFlgProvider).state = true;
                  },
                  child: Text(enModeFlg
                      ? EN_TEXT['helperModeButton']!
                      : JA_TEXT['helperModeButton']!),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.only(
                      right: 14,
                      left: 14,
                    ),
                    primary: helperModeFlg
                        ? Colors.blue.shade400
                        : Colors.blue.shade200,
                    textStyle: Theme.of(context).textTheme.button,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(width: 30),
                ElevatedButton(
                  onPressed: () async {
                    soundEffect.play(
                      'sounds/tap.mp3',
                      isNotification: true,
                      volume: seVolume,
                    );
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.setBool('helperModeFlg', false);
                    context.read(helperModeFlgProvider).state = false;
                  },
                  child: Text(enModeFlg
                      ? EN_TEXT['selfModeButton']!
                      : JA_TEXT['selfModeButton']!),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.only(
                      right: 14,
                      left: 14,
                    ),
                    primary: helperModeFlg
                        ? Colors.green.shade200
                        : Colors.green.shade400,
                    textStyle: Theme.of(context).textTheme.button,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 20,
            ),
            child: Text(
              helperModeFlg
                  ? enModeFlg
                      ? EN_TEXT['helperMode']!
                      : JA_TEXT['helperMode']!
                  : enModeFlg
                      ? EN_TEXT['selfMode']!
                      : JA_TEXT['selfMode']!,
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

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';

import '../../providers/quiz.provider.dart';
import '../../providers/common.provider.dart';

import '../../text.dart';

class OpenedSubHintModal extends HookWidget {
  final List<String> subHints;

  const OpenedSubHintModal({
    Key? key,
    required this.subHints,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AudioCache soundEffect = useProvider(soundEffectProvider).state;
    final bool enModeFlg = useProvider(enModeFlgProvider).state;
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
            child: Text(
              enModeFlg
                  ? EN_TEXT['gotSubHintHeader']!
                  : JA_TEXT['gotSubHintHeader']!,
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                fontFamily: 'SawarabiGothic',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 10,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Text(
                    '・ ',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontFamily: 'SawarabiGothic',
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * .86 > 650
                      ? 470
                      : MediaQuery.of(context).size.width * .50,
                  child: Text(
                    subHints[0],
                    style: TextStyle(
                      fontSize: 18.0,
                      fontFamily: 'SawarabiGothic',
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 10,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Text(
                    '・ ',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontFamily: 'SawarabiGothic',
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * .86 > 650
                      ? 470
                      : MediaQuery.of(context).size.width * .50,
                  child: Text(
                    subHints[1],
                    style: TextStyle(
                      fontSize: 18.0,
                      fontFamily: 'SawarabiGothic',
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 10,
              bottom: 15,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Text(
                    '・ ',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontFamily: 'SawarabiGothic',
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * .86 > 650
                      ? 470
                      : MediaQuery.of(context).size.width * .50,
                  child: Text(
                    subHints[2],
                    style: TextStyle(
                      fontSize: 18.0,
                      fontFamily: 'SawarabiGothic',
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 5,
              right: 5,
              top: 5,
            ),
            child: ElevatedButton(
              onPressed: () => {
                soundEffect.play(
                  'sounds/cancel.mp3',
                  isNotification: true,
                  volume: seVolume,
                ),
                Navigator.pop(context)
              },
              child: Text(
                enModeFlg ? EN_TEXT['closeButton']! : JA_TEXT['closeButton']!,
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.only(
                  right: 14,
                  left: 14,
                ),
                primary: Colors.red[500],
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

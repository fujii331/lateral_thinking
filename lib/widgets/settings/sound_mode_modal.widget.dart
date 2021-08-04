import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../providers/quiz.provider.dart';
import '../../../providers/common.provider.dart';

import '../../../text.dart';

class SoundModeModal extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final AudioCache soundEffect = useProvider(soundEffectProvider).state;
    final bool enModeFlg = useProvider(enModeFlgProvider).state;
    final double bgmVolume = useProvider(bgmVolumeProvider).state;
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
              top: 15,
              bottom: 25,
            ),
            child: Text(
              enModeFlg ? 'Slide to adjust volume' : 'スライドして音量を調節',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                fontFamily: 'SawarabiGothic',
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 25,
            ),
            width: double.infinity,
            child: Text(
              enModeFlg ? 'BGM volume' : 'BGM音量',
              textAlign: TextAlign.left,
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontFamily: 'YuseiMagic',
              ),
            ),
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              inactiveTickMarkColor: Colors.blue.shade100,
              activeTickMarkColor: Colors.blue,
            ),
            child: Slider(
              value: bgmVolume * 100,
              min: 0,
              max: 100,
              divisions: 10,
              onChanged: (double value) async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                context.read(bgmProvider).state.setVolume(value * 0.01);
                context.read(bgmVolumeProvider).state = value * 0.01;
                prefs.setDouble('bgmVolume', value * 0.01);
              },
            ),
          ),
          SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 25,
            ),
            width: double.infinity,
            child: Text(
              enModeFlg ? 'SE volume' : 'SE音量',
              textAlign: TextAlign.left,
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontFamily: 'YuseiMagic',
              ),
            ),
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              inactiveTickMarkColor: Colors.blue.shade100,
              activeTickMarkColor: Colors.blue,
            ),
            child: Slider(
              value: seVolume * 100,
              min: 0,
              max: 100,
              divisions: 10,
              onChanged: (double value) async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                context.read(seVolumeProvider).state = value * 0.01;
                prefs.setDouble('seVolume', value * 0.01);
              },
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

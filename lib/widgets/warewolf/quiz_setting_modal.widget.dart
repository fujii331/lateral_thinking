import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';

import '../../providers/common.provider.dart';

import '../../screens/warewolf_preparation_first.screen.dart';

class QuizSettingModal extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final AudioCache soundEffect = useProvider(soundEffectProvider).state;
    final double seVolume = useProvider(seVolumeProvider).state;

    final sentenceController = useTextEditingController();
    final correctAnswerController = useTextEditingController();

    return Padding(
      padding: const EdgeInsets.only(
        left: 15,
        right: 15,
        bottom: 10,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(
              bottom: 10,
            ),
            child: Text(
              '問題と正解を設定',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                fontFamily: 'SawarabiGothic',
              ),
            ),
          ),
          _inputArea(context, '問題', sentenceController),
          SizedBox(height: 10),
          _inputArea(context, '正解', correctAnswerController),
          Padding(
            padding: const EdgeInsets.only(
              top: 10,
            ),
            child: Wrap(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => {
                    soundEffect.play(
                      'sounds/cancel.mp3',
                      isNotification: true,
                      volume: seVolume,
                    ),
                    Navigator.pop(context),
                  },
                  child: Text(
                    '戻る',
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red[400],
                    textStyle: Theme.of(context).textTheme.button,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(width: 30),
                ElevatedButton(
                  onPressed: () {
                    soundEffect.play(
                      'sounds/tap.mp3',
                      isNotification: true,
                      volume: seVolume,
                    );

                    Navigator.of(context).pushNamed(
                      WarewolfPreparationFirstScreen.routeName,
                      arguments: [
                        sentenceController.text,
                        correctAnswerController.text,
                      ],
                    );
                  },
                  child: Text(
                    '開始',
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
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

  Widget _inputArea(
    BuildContext context,
    String fieldText,
    TextEditingController controller,
  ) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(
            bottom: 5,
          ),
          width: double.infinity,
          child: Text(
            fieldText,
            textAlign: TextAlign.left,
            style: TextStyle(
              color: Colors.grey.shade800,
              fontSize: 16.0,
              fontFamily: 'SawarabiGothic',
            ),
          ),
        ),
        Container(
          height: fieldText == '問題'
              ? MediaQuery.of(context).size.height * 0.3 > 500
                  ? 500
                  : MediaQuery.of(context).size.height * 0.3
              : MediaQuery.of(context).size.height * 0.2 > 330
                  ? 330
                  : MediaQuery.of(context).size.height * 0.2,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
          ),
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.multiline,
            maxLines: null,
            style: new TextStyle(
              fontSize: 15.5,
              height: 1.2,
            ),
            decoration: InputDecoration(
              hintText: fieldText + 'を入力',
              enabledBorder: new OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.white,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

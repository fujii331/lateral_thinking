import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audioplayers/audioplayers.dart';

import '../../providers/quiz.provider.dart';
import '../../text.dart';
import '../../screens/quiz_list.screen.dart';
import '../../providers/common.provider.dart';

class LecturePagination extends HookWidget {
  final ValueNotifier<int> screenNo;
  final int numOfPages;
  final bool alreadyPlayedFlg;

  LecturePagination(this.screenNo, this.numOfPages, this.alreadyPlayedFlg);

  @override
  Widget build(BuildContext context) {
    final bool enModeFlg = useProvider(enModeFlgProvider).state;
    final AudioCache soundEffect = useProvider(soundEffectProvider).state;
    final double seVolume = useProvider(seVolumeProvider).state;

    final List<String> pageExplanation = [
      enModeFlg ? EN_TEXT['playMethodBottom1']! : JA_TEXT['playMethodBottom1']!,
      enModeFlg ? EN_TEXT['playMethodBottom2']! : JA_TEXT['playMethodBottom2']!,
      enModeFlg ? EN_TEXT['playMethodBottom3']! : JA_TEXT['playMethodBottom3']!,
      enModeFlg ? EN_TEXT['playMethodBottom4']! : JA_TEXT['playMethodBottom4']!,
      enModeFlg ? EN_TEXT['playMethodBottom5']! : JA_TEXT['playMethodBottom5']!,
      enModeFlg ? EN_TEXT['playMethodBottom6']! : JA_TEXT['playMethodBottom6']!,
      enModeFlg ? EN_TEXT['playMethodBottom7']! : JA_TEXT['playMethodBottom7']!,
      enModeFlg ? EN_TEXT['playMethodBottom8']! : JA_TEXT['playMethodBottom8']!,
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        screenNo.value == 0
            ? _dummyBox(enModeFlg)
            : _pagingButton(context, screenNo, screenNo.value - 1,
                enModeFlg ? 'Back' : '前へ'),
        Container(
          width: enModeFlg ? 130 : 140,
          child: Center(
            child: Text(
              pageExplanation[screenNo.value],
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.white,
              ),
            ),
          ),
        ),
        screenNo.value == numOfPages - 1
            ? alreadyPlayedFlg
                ? _dummyBox(enModeFlg)
                : Container(
                    width: enModeFlg ? 73 : null,
                    child: ElevatedButton(
                      onPressed: () async {
                        SharedPreferences preference =
                            await SharedPreferences.getInstance();
                        soundEffect.play(
                          'sounds/tap.mp3',
                          isNotification: true,
                          volume: seVolume,
                        );
                        context.read(alreadyPlayedQuizFlgProvider).state = true;
                        preference.setBool('alreadyPlayedQuiz', true);
                        Navigator.of(context).pushReplacementNamed(
                          QuizListScreen.routeName,
                          arguments: false,
                        );
                      },
                      child: Text(
                        enModeFlg ? 'Play' : '遊ぶ',
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue.shade700,
                        textStyle: Theme.of(context).textTheme.button,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        side: const BorderSide(),
                      ),
                    ),
                  )
            : _pagingButton(context, screenNo, screenNo.value + 1,
                enModeFlg ? 'Next' : '次へ'),
      ],
    );
  }

  Widget _pagingButton(
    BuildContext context,
    ValueNotifier<int> screenNo,
    int toScreenNo,
    String icon,
  ) {
    return ElevatedButton(
      onPressed: () => {
        screenNo.value = toScreenNo,
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 2),
        child: Text(
          icon,
          style: TextStyle(
            fontSize: 18.0,
            color: Colors.white,
          ),
        ),
      ),
      style: ElevatedButton.styleFrom(
        primary: Colors.white.withOpacity(0.3),
        textStyle: Theme.of(context).textTheme.button,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _dummyBox(bool enModeFlg) {
    return SizedBox(width: enModeFlg ? 71 : 68);
  }
}

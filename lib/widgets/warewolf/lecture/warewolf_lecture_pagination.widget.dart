import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audioplayers/audioplayers.dart';

import '../../../screens/warewolf_setting.screen.dart';
import '../../../providers/common.provider.dart';
import '../../../providers/warewolf.provider.dart';

class WarewolfLecturePagination extends HookWidget {
  final ValueNotifier<int> screenNo;
  final int numOfPages;
  final bool alreadyPlayedFlg;

  WarewolfLecturePagination(
      this.screenNo, this.numOfPages, this.alreadyPlayedFlg);

  @override
  Widget build(BuildContext context) {
    final AudioCache soundEffect = useProvider(soundEffectProvider).state;
    final double seVolume = useProvider(seVolumeProvider).state;

    final List<String> pageExplanation = [
      '始めに',
      'ゲーム設定',
      '市民の時',
      '人狼の時',
      'クイズ開始前',
      'クイズ中',
      '正解者確認',
      '議論',
      '投票',
      '投票結果',
      '終わりに',
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        screenNo.value == 0
            ? _dummyBox()
            : _pagingButton(context, screenNo, screenNo.value - 1, '前へ'),
        Container(
          width: 140,
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
                ? _dummyBox()
                : Container(
                    child: ElevatedButton(
                      onPressed: () async {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        soundEffect.play(
                          'sounds/tap.mp3',
                          isNotification: true,
                          volume: seVolume,
                        );
                        context.read(alreadyPlayedWarewolfFlgProvider).state =
                            true;
                        prefs.setBool('alreadyPlayedWarewolf', true);
                        Navigator.of(context).pushReplacementNamed(
                          WarewolfSettingScreen.routeName,
                        );
                      },
                      child: Text(
                        '遊ぶ',
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
            : _pagingButton(context, screenNo, screenNo.value + 1, '次へ'),
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
      child: Text(
        icon,
        style: TextStyle(
          fontSize: 18.0,
          color: Colors.white,
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

  Widget _dummyBox() {
    return SizedBox(width: 68);
  }
}

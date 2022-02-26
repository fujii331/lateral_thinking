import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../providers/common.provider.dart';
import '../widgets/werewolf/lecture/werewolf_lecture_first.widget.dart';
import '../widgets/werewolf/lecture/werewolf_lecture_setting.widget.dart';
import '../widgets/lecture/lecture_figure.widget.dart';
import '../widgets/werewolf/lecture/werewolf_lecture_last.widget.dart';
import '../providers/werewolf.provider.dart';
import '../widgets/background.widget.dart';
import '../widgets/werewolf/lecture/werewolf_lecture_pagination.widget.dart';
import './werewolf_setting.screen.dart';

class WerewolfLectureScreen extends HookWidget {
  static const routeName = '/werewolf-lecture';

  @override
  Widget build(BuildContext context) {
    final bool alreadyPlayedFlg =
        ModalRoute.of(context)?.settings.arguments as bool;
    final screenNo = useState<int>(0);
    final AudioCache soundEffect = useProvider(soundEffectProvider).state;
    final double seVolume = useProvider(seVolumeProvider).state;

    final int numOfPages = 11;

    final List lecturePages = [
      WerewolfLectureFirst(),
      WerewolfLectureSetting(),
      LectureFigure('assets/images/werewolf_lecture1.png'), // 市民だったときの画面
      LectureFigure('assets/images/werewolf_lecture2.png'), // 人狼だったときの画面
      LectureFigure('assets/images/werewolf_lecture3.png'), // 回答前の画面
      LectureFigure('assets/images/werewolf_lecture4.png'), // 回答中の画面
      LectureFigure('assets/images/werewolf_lecture5.png'), // 正解者確認画面
      LectureFigure('assets/images/werewolf_lecture6.png'), // 議論画面
      LectureFigure('assets/images/werewolf_lecture7.png'), // 投票画面
      LectureFigure('assets/images/werewolf_lecture8.png'), // 投票確認画面
      WerewolfLectureLast(),
    ];

    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/background.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.black.withOpacity(0.5),
        appBar: AppBar(
          title: Text(
            '遊び方',
            style: const TextStyle(
              fontFamily: 'KaiseiOpti',
            ),
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.grey.shade800.withOpacity(0.7),
          actions: <Widget>[
            alreadyPlayedFlg
                ? Container()
                : TextButton(
                    onPressed: () async {
                      SharedPreferences preference =
                          await SharedPreferences.getInstance();
                      soundEffect.play(
                        'sounds/tap.mp3',
                        isNotification: true,
                        volume: seVolume,
                      );
                      context.read(alreadyPlayedWerewolfFlgProvider).state =
                          true;
                      preference.setBool('alreadyPlayedWerewolf', true);
                      Navigator.of(context).pushReplacementNamed(
                        WerewolfSettingScreen.routeName,
                      );
                    },
                    child: Text(
                      "skip",
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ),
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            Container(
              height: MediaQuery.of(context).size.height * 0.85 - 70,
              child: lecturePages[screenNo.value],
            ),
            Container(
              height: 60,
              child: WerewolfLecturePagination(
                screenNo,
                numOfPages,
                alreadyPlayedFlg,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

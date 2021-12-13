import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../providers/common.provider.dart';
import '../widgets/warewolf/lecture/warewolf_lecture_first.widget.dart';
import '../widgets/warewolf/lecture/warewolf_lecture_setting.widget.dart';
import '../widgets/lecture/lecture_figure.widget.dart';
import '../widgets/warewolf/lecture/warewolf_lecture_last.widget.dart';
import '../providers/warewolf.provider.dart';
import '../widgets/background.widget.dart';
import '../widgets/warewolf/lecture/warewolf_lecture_pagination.widget.dart';
import './warewolf_setting.screen.dart';

class WarewolfLectureScreen extends HookWidget {
  static const routeName = '/warewolf-lecture';

  @override
  Widget build(BuildContext context) {
    final bool alreadyPlayedFlg =
        ModalRoute.of(context)?.settings.arguments as bool;
    final screenNo = useState<int>(0);
    final AudioCache soundEffect = useProvider(soundEffectProvider).state;
    final double seVolume = useProvider(seVolumeProvider).state;

    final int numOfPages = 11;

    final List lecturePages = [
      WarewolfLectureFirst(),
      WarewolfLectureSetting(),
      LectureFigure('assets/images/warewolf_lecture1.png'), // 市民だったときの画面
      LectureFigure('assets/images/warewolf_lecture2.png'), // 人狼だったときの画面
      LectureFigure('assets/images/warewolf_lecture3.png'), // 回答前の画面
      LectureFigure('assets/images/warewolf_lecture4.png'), // 回答中の画面
      LectureFigure('assets/images/warewolf_lecture5.png'), // 正解者確認画面
      LectureFigure('assets/images/warewolf_lecture6.png'), // 議論画面
      LectureFigure('assets/images/warewolf_lecture7.png'), // 投票画面
      LectureFigure('assets/images/warewolf_lecture8.png'), // 投票確認画面
      WarewolfLectureLast(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '遊び方',
        ),
        centerTitle: true,
        backgroundColor: Colors.blueGrey[900]?.withOpacity(0.9),
        actions: <Widget>[
          alreadyPlayedFlg
              ? Container()
              : TextButton(
                  onPressed: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    soundEffect.play(
                      'sounds/tap.mp3',
                      isNotification: true,
                      volume: seVolume,
                    );
                    context.read(alreadyPlayedWarewolfFlgProvider).state = true;
                    prefs.setBool('alreadyPlayedWarewolf', true);
                    Navigator.of(context).pushReplacementNamed(
                      WarewolfSettingScreen.routeName,
                    );
                  },
                  child: Text(
                    "skip",
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
        ],
      ),
      body: Stack(
        children: [
          background(),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.85 - 60,
                child: lecturePages[screenNo.value],
              ),
              Container(
                height: 60,
                child: WarewolfLecturePagination(
                  screenNo,
                  numOfPages,
                  alreadyPlayedFlg,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

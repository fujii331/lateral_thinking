import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../providers/common.provider.dart';
import '../widgets/lecture/lecture_first.widget.dart';
import '../widgets/lecture/lecture_figure.widget.dart';
import '../widgets/lecture/lecture_last.widget.dart';
import '../providers/quiz.provider.dart';
import '../text.dart';
import './quiz_list.screen.dart';
import '../widgets/background.widget.dart';
import '../../widgets/lecture/lecture_pagination.widget.dart';

class LectureTabScreen extends HookWidget {
  static const routeName = '/lecture-tab';

  @override
  Widget build(BuildContext context) {
    final bool alreadyPlayedFlg =
        ModalRoute.of(context)?.settings.arguments as bool;
    final screenNo = useState<int>(0);
    final bool enModeFlg = useProvider(enModeFlgProvider).state;
    final AudioCache soundEffect = useProvider(soundEffectProvider).state;
    final double seVolume = useProvider(seVolumeProvider).state;

    final int numOfPages = 10;

    final List lecturePages = [
      LectureFirst(),
      enModeFlg
          ? LectureFigure('assets/images/lecture1_en.png')
          : LectureFigure('assets/images/lecture1.png'),
      enModeFlg
          ? LectureFigure('assets/images/lecture2_en.png')
          : LectureFigure('assets/images/lecture2.png'),
      enModeFlg
          ? LectureFigure('assets/images/lecture3_en.png')
          : LectureFigure('assets/images/lecture3.png'),
      enModeFlg
          ? LectureFigure('assets/images/lecture4_en.png')
          : LectureFigure('assets/images/lecture4.png'),
      enModeFlg
          ? LectureFigure('assets/images/lecture5_en.png')
          : LectureFigure('assets/images/lecture5.png'),
      enModeFlg
          ? LectureFigure('assets/images/lecture6_en.png')
          : LectureFigure('assets/images/lecture6.png'),
      enModeFlg
          ? LectureFigure('assets/images/lecture_hint_en.png')
          : LectureFigure('assets/images/lecture_hint.png'),
      enModeFlg
          ? LectureFigure('assets/images/lecture7_en.png')
          : LectureFigure('assets/images/lecture7.png'),
      LectureLast(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          enModeFlg
              ? EN_TEXT['playMethodButton']!
              : JA_TEXT['playMethodButton']!,
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
                    context.read(alreadyPlayedQuizFlgProvider).state = true;
                    prefs.setBool('alreadyPlayedQuiz', true);
                    Navigator.of(context).pushReplacementNamed(
                      QuizListScreen.routeName,
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
                  child: lecturePages[screenNo.value]),
              Container(
                height: 60,
                child: LecturePagination(
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

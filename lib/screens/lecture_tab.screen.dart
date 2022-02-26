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

    final int numOfPages = 8;

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
          ? LectureFigure('assets/images/lecture_hint_en.png')
          : LectureFigure('assets/images/lecture_hint.png'),
      LectureLast(),
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
            enModeFlg
                ? EN_TEXT['playMethodButton']!
                : JA_TEXT['playMethodButton']!,
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
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.blueGrey.shade900.withOpacity(0.8),
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
                      context.read(alreadyPlayedQuizFlgProvider).state = true;
                      preference.setBool('alreadyPlayedQuiz', true);
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
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            Container(
                height: MediaQuery.of(context).size.height * 0.85 - 70,
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
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lateral_thinking/widgets/quiz_list/quiz_list_detail_title.widget.dart';
import 'package:lateral_thinking/widgets/quiz_list/quiz_list_pagination.widget.dart';
// import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:audioplayers/audioplayers.dart';

import '../widgets/quiz_list/quiz_list_detail.widget.dart';
// import '../widgets/quiz_list/analytics_list_modal.widget.dart';
import '../providers/quiz.provider.dart';
import '../widgets/background.widget.dart';
import '../text.dart';
import './lecture_tab.screen.dart';
import '../providers/common.provider.dart';

class QuizListScreen extends HookWidget {
  static const routeName = '/quiz-list';

  @override
  Widget build(BuildContext context) {
    final screenNo = useState<int>(0);
    final AudioCache soundEffect = useProvider(soundEffectProvider).state;
    final int openingNumber = useProvider(openingNumberProvider).state;
    final double seVolume = useProvider(seVolumeProvider).state;

    final int numOfPages = ((openingNumber + 1) / 6).ceil();
    final bool enModeFlg = useProvider(enModeFlgProvider).state;
    final height = MediaQuery.of(context).size.height;

    final List<String> titles = [
      enModeFlg ? EN_TEXT['listPageTitle1']! : JA_TEXT['listPageTitle1']!,
      enModeFlg ? EN_TEXT['listPageTitle2']! : JA_TEXT['listPageTitle2']!,
      enModeFlg ? EN_TEXT['listPageTitle3']! : JA_TEXT['listPageTitle3']!,
      enModeFlg ? EN_TEXT['listPageTitle4']! : JA_TEXT['listPageTitle4']!,
      enModeFlg ? EN_TEXT['listPageTitle5']! : JA_TEXT['listPageTitle5']!,
      enModeFlg ? EN_TEXT['listPageTitle6']! : JA_TEXT['listPageTitle6']!,
      enModeFlg ? EN_TEXT['listPageTitle7']! : JA_TEXT['listPageTitle7']!,
      enModeFlg ? EN_TEXT['listPageTitle8']! : JA_TEXT['listPageTitle8']!,
      enModeFlg ? EN_TEXT['listPageTitle9']! : JA_TEXT['listPageTitle9']!,
      enModeFlg ? EN_TEXT['listPageTitle10']! : JA_TEXT['listPageTitle10']!,
      enModeFlg ? EN_TEXT['listPageTitle11']! : JA_TEXT['listPageTitle11']!,
      enModeFlg ? EN_TEXT['listPageTitle12']! : JA_TEXT['listPageTitle12']!,
      enModeFlg ? 'Secret passage' : '秘密の通路',
      enModeFlg ? "Children's room" : '子供のお部屋',
    ];

    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/background.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.black.withOpacity(0.3),
        appBar: AppBar(
          title: Text(
            enModeFlg ? EN_TEXT['listTitle']! : JA_TEXT['listTitle']!,
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
          backgroundColor: Colors.blueGrey.shade900.withOpacity(0.8),
          elevation: 0,
          actions: <Widget>[
            IconButton(
              iconSize: 28,
              icon: Icon(
                Icons.help,
                color: Colors.yellow.shade50,
                size: 27,
              ),
              onPressed: () {
                soundEffect.play(
                  'sounds/tap.mp3',
                  isNotification: true,
                  volume: seVolume,
                );
                Navigator.of(context).pushNamed(
                  LectureTabScreen.routeName,
                  arguments: true,
                );
              },
            ),
          ],
        ),
        resizeToAvoidBottomInset: false,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: height > 550 ? 10 : 5),
            QuizListDetailTitle(
              titles[screenNo.value],
            ),
            SizedBox(height: height > 550 ? 10 : 5),
            QuizListDetail(
              openingNumber,
              screenNo,
              numOfPages,
            ),
            const Spacer(),
            SizedBox(height: height > 550 ? 10 : 0),
            QuizListPagination(
              screenNo,
              numOfPages,
            ),
            SizedBox(height: height > 550 ? 10 : 0),
          ],
        ),
      ),
    );
  }
}

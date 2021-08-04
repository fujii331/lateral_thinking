import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lateral_thinking/widgets/quiz_list/quiz_list_detail_title.widget.dart';
import 'package:lateral_thinking/widgets/quiz_list/quiz_list_pagination.widget.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:audioplayers/audioplayers.dart';

import '../widgets/quiz_list/quiz_list_detail.widget.dart';
import '../providers/quiz.provider.dart';
import '../widgets/background.widget.dart';
import '../text.dart';
import './lecture_tab.screen.dart';
import '../widgets/settings/mode_modal.widget.dart';
import '../providers/common.provider.dart';

class QuizListScreen extends HookWidget {
  static const routeName = '/quiz-list';

  @override
  Widget build(BuildContext context) {
    final bool alreadyPlayedFlg =
        ModalRoute.of(context)?.settings.arguments as bool;
    final screenNo = useState<int>(0);
    final AudioCache soundEffect = useProvider(soundEffectProvider).state;
    final int openingNumber = useProvider(openingNumberProvider).state;
    final double seVolume = useProvider(seVolumeProvider).state;

    final int numOfPages = ((openingNumber + 1) / 6).ceil();
    final bool enModeFlg = useProvider(enModeFlgProvider).state;

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
    ];

    return WillPopScope(
      onWillPop: () {
        if (!alreadyPlayedFlg) {
          Navigator.pop(context);
        }
        Navigator.pop(context);
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            enModeFlg ? EN_TEXT['listTitle']! : JA_TEXT['listTitle']!,
          ),
          centerTitle: true,
          backgroundColor: Colors.blueGrey.shade900.withOpacity(0.9),
          actions: <Widget>[
            PopupMenuButton<int>(
              elevation: 20,
              shape: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueGrey, width: 2)),
              onSelected: (int result) {
                soundEffect.play(
                  'sounds/tap.mp3',
                  isNotification: true,
                  volume: seVolume,
                );
                if (result == 1) {
                  Navigator.of(context).pushNamed(
                    LectureTabScreen.routeName,
                    arguments: true,
                  );
                } else if (result == 2) {
                  AwesomeDialog(
                    context: context,
                    dialogType: DialogType.NO_HEADER,
                    headerAnimationLoop: false,
                    animType: AnimType.SCALE,
                    width: MediaQuery.of(context).size.width * .86 > 650
                        ? 650
                        : null,
                    body: ModeModal(),
                  )..show();
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
                PopupMenuItem<int>(
                  value: 1,
                  child: Text(enModeFlg
                      ? EN_TEXT['playMethodButton']!
                      : JA_TEXT['playMethodButton']!),
                ),
                PopupMenuItem<int>(
                  value: 2,
                  child: Text(enModeFlg
                      ? EN_TEXT['modeButton']!
                      : JA_TEXT['modeButton']!),
                ),
              ],
            )
          ],
        ),
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            background(),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                QuizListDetailTitle(
                  titles[screenNo.value],
                ),
                QuizListDetail(
                  openingNumber,
                  screenNo,
                  numOfPages,
                ),
                QuizListPagination(
                  screenNo,
                  numOfPages,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

import '../providers/quiz.provider.dart';
import '../providers/warewolf.provider.dart';
import '../providers/common.provider.dart';

import '../../models/quiz.model.dart';
import '../../models/warewolf.model.dart';
import '../warewolf_settings.dart';
import '../widgets/warewolf/players_setting_modal.widget.dart';
import '../widgets/warewolf/quiz_setting_modal.widget.dart';
import '../widgets/warewolf/reward_for_playing_modal.widget.dart';
import '../../data/quiz_data.dart';
import '../widgets/background.widget.dart';
import '../screens/warewolf_preparation_first.screen.dart';
import '../screens/warewolf_lecture.screen.dart';

class WarewolfSettingScreen extends HookWidget {
  static const routeName = '/warewolf-setting';

  @override
  Widget build(BuildContext context) {
    final int moveJudgeValue =
        ModalRoute.of(context)?.settings.arguments as int;
    final AudioCache soundEffect = useProvider(soundEffectProvider).state;

    const double paddingTop = 15;

    final int openingNumber = useProvider(openingNumberProvider).state;

    final String mode = useProvider(modeProvider).state;
    final double seVolume = useProvider(seVolumeProvider).state;

    final List<Quiz> quizList =
        QUIZ_DATA.where((Quiz quiz) => quiz.id <= openingNumber).toList();

    final List<String> quizTitleList = quizList.map((Quiz quiz) {
      return quiz.title;
    }).toList();

    final String quizTitle = useProvider(quizTitleProvider).state;
    final String questionTime = useProvider(questionTimeProvider).state;
    final List<String> alreadyAnsweredIds =
        useProvider(alreadyAnsweredIdsProvider).state;

    return WillPopScope(
      onWillPop: () {
        if (moveJudgeValue == 3) {
          Navigator.popUntil(context, ModalRoute.withName('/'));
          // Navigator.of(context).pushNamed(
          //   '/',
          // );
        } else if (moveJudgeValue == 2) {
          Navigator.pop(context);
          Navigator.pop(context);
        } else {
          Navigator.pop(context);
        }
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('ゲーム設定'),
          centerTitle: true,
          backgroundColor: Colors.grey[900]?.withOpacity(0.8),
          actions: <Widget>[
            IconButton(
              iconSize: 28,
              icon: Icon(
                Icons.help,
                color: Colors.yellow.shade200,
                size: 27,
              ),
              onPressed: () {
                soundEffect.play(
                  'sounds/tap.mp3',
                  isNotification: true,
                  volume: seVolume,
                );
                Navigator.of(context).pushNamed(
                  WarewolfLectureScreen.routeName,
                  arguments: true,
                );
              },
            ),
          ],
        ),
        body: Stack(
          children: <Widget>[
            background(),
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 5,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color.fromRGBO(0, 0, 0, 0.6),
              ),
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.only(
                              top: 5,
                            ),
                            width: 110,
                            child: Column(
                              children: <Widget>[
                                Container(
                                  height: 35,
                                  child: Text(
                                    '問題の種類',
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: paddingTop),
                                  child: Container(
                                    height: 35,
                                    child: Text(
                                      '使う問題',
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: paddingTop),
                                  child: Container(
                                    height: 35,
                                    child: Text(
                                      '回答者の数',
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: paddingTop),
                                  child: Container(
                                    height: 35,
                                    child: Text(
                                      'メイン時間',
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: paddingTop),
                                  child: Container(
                                    height: 35,
                                    child: Text(
                                      '質問時間',
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: paddingTop),
                                  child: Container(
                                    height: 35,
                                    child: Text(
                                      '会議時間',
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: paddingTop),
                                  child: Container(
                                    height: 35,
                                    child: Text(
                                      '平和村',
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(left: 28.0),
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(top: 5),
                                  child: _valueSelect(
                                    context,
                                    modeProvider,
                                    MODE_SETTINGS,
                                    '',
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: paddingTop),
                                  child: mode == '謎解きの王様'
                                      ? _valueSelect(
                                          context,
                                          quizTitleProvider,
                                          quizTitleList,
                                          '',
                                        )
                                      : Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                          ),
                                          width: 140,
                                          height: 35,
                                          decoration: BoxDecoration(
                                            color: Colors.grey.withOpacity(0.8),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          alignment: Alignment.center,
                                        ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: paddingTop),
                                  child: _valueSelect(
                                    context,
                                    numOfPlayersProvider,
                                    NUM_OF_PLAYERS,
                                    '人',
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: paddingTop),
                                  child: _valueSelect(
                                    context,
                                    mainTimeProvider,
                                    MAIN_TIME,
                                    '分',
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: paddingTop),
                                  child: _valueSelect(
                                    context,
                                    questionTimeProvider,
                                    QUESTION_TIME,
                                    questionTime == '×' ? '　' : '秒',
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: paddingTop),
                                  child: _valueSelect(
                                    context,
                                    discussionTimeProvider,
                                    DISCUSSION_TIME,
                                    '分',
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: paddingTop),
                                  child: _valueSelect(
                                    context,
                                    peaceVillageProvider,
                                    PEACE_VILLAGE_EXSIST,
                                    '平和村',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 40,
                        ),
                        child: SizedBox(
                          height: 50,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: () => {
                                  soundEffect.play(
                                    'sounds/tap.mp3',
                                    isNotification: true,
                                    volume: seVolume,
                                  ),
                                  AwesomeDialog(
                                    context: context,
                                    dialogType: DialogType.NO_HEADER,
                                    headerAnimationLoop: false,
                                    animType: AnimType.SCALE,
                                    width: 350,
                                    body: PlayersSettingModal(),
                                  )..show(),
                                },
                                child: Text('回答者編集'),
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.only(
                                    right: 14,
                                    left: 14,
                                  ),
                                  primary: Colors.green,
                                  textStyle: Theme.of(context).textTheme.button,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                              SizedBox(width: 40),
                              ElevatedButton(
                                onPressed: () {
                                  soundEffect.play(
                                    'sounds/tap.mp3',
                                    isNotification: true,
                                    volume: seVolume,
                                  );
                                  context.read(timerCancelFlgProvider).state =
                                      false;
                                  context.read(voteProvider).state = Vote(
                                    player1: 0,
                                    player2: 0,
                                    player3: 0,
                                    player4: 0,
                                    player5: 0,
                                    player6: 0,
                                  );

                                  if (mode == '謎解きの王様') {
                                    final Quiz quiz = quizList
                                        .where((Quiz quiz) =>
                                            quiz.title == quizTitle)
                                        .toList()[0];

                                    if (alreadyAnsweredIds
                                        .contains(quiz.id.toString())) {
                                      Navigator.of(context).pushNamed(
                                        WarewolfPreparationFirstScreen
                                            .routeName,
                                        arguments: [
                                          quiz.sentence,
                                          quiz.answers[0].comment,
                                        ],
                                      );
                                    } else {
                                      // 動画を見せる
                                      AwesomeDialog(
                                        context: context,
                                        dialogType: DialogType.QUESTION,
                                        headerAnimationLoop: false,
                                        animType: AnimType.BOTTOMSLIDE,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                        .86 >
                                                    650
                                                ? 650
                                                : null,
                                        body: RewardForPlayingModal(
                                          quiz,
                                        ),
                                      )..show();
                                    }
                                  } else {
                                    AwesomeDialog(
                                      context: context,
                                      dialogType: DialogType.NO_HEADER,
                                      headerAnimationLoop: false,
                                      animType: AnimType.SCALE,
                                      dismissOnTouchOutside: false,
                                      width: MediaQuery.of(context).size.width *
                                                  .86 >
                                              650
                                          ? 650
                                          : null,
                                      body: QuizSettingModal(),
                                    )..show();
                                  }
                                },
                                child: Text(
                                  mode == '謎解きの王様' ? '開始' : '次へ',
                                ),
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.blue.shade600,
                                  textStyle: Theme.of(context).textTheme.button,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _valueSelect(
    BuildContext context,
    StateProvider<String> provider,
    List<String> wordList,
    String suffixText,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
          ),
          width: suffixText == '平和村'
              ? 80
              : suffixText == ''
                  ? 140
                  : 65,
          height: 35,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.8),
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: DropdownButton(
            // isExpanded: true,
            underline: Container(
              color: Colors.white,
            ),
            value: useProvider(provider).state,
            items: wordList.map((String word) {
              return DropdownMenuItem(
                value: word,
                child: Text(
                  word,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontFamily: 'NotoSerifJP',
                  ),
                ),
              );
            }).toList(),
            onChanged: (target) {
              context.read(provider).state = target as String;
            },
          ),
        ),
        (suffixText == '' || suffixText == '平和村')
            ? Container()
            : Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  suffixText,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
      ],
    );
  }
}

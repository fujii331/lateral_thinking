import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:io';

import '../background.widget.dart';
import '../../providers/quiz.provider.dart';
import '../../models/quiz.model.dart';
import 'correct_answer_modal.widget.dart';
import '../../advertising.dart';
import './answering_modal.widget.dart';
import '../../text.dart';

class QuizAnswer extends HookWidget {
  final int quizId;

  QuizAnswer(
    this.quizId,
  );

  void getAnswerChoices(
      BuildContext context,
      List<Answer> allAnswers,
      ValueNotifier<List<Answer>> availableAnswers,
      List<Question> askedQuestions,
      List<int> executedAnswerIds,
      List<int> correctAnswerIds) {
    List<Answer> wkAnswers = [];

    List<int> currentQuestionIds = askedQuestions.map((askedQuestion) {
      return askedQuestion.id;
    }).toList();

    bool correctAnswerFlg = false;

    allAnswers.forEach((Answer answer) {
      if (!correctAnswerFlg) {
        bool judgeFlg = true;
        answer.questionIds.forEach((int questionId) {
          if (judgeFlg) {
            // 現在の実行済質問の中に対象のidがなかったらfalse
            if (!currentQuestionIds.contains(questionId)) {
              judgeFlg = false;
            }
          }
        });

        // 必要な質問が出ている、かつ、まだ解答されていないanswerを追加
        if (judgeFlg && !executedAnswerIds.contains(answer.id)) {
          // 正解だった場合はそれを解答に設定して残りのループをスキップする
          if (correctAnswerIds.contains(answer.id)) {
            availableAnswers.value = [answer];
            correctAnswerFlg = true;
          } else {
            wkAnswers.add(answer);
          }
        }
      }
    });

    if (!correctAnswerFlg) {
      availableAnswers.value = wkAnswers;
    }
  }

  void executeAnswer(
      BuildContext context,
      ValueNotifier<bool> enableAnswerButtonFlg,
      ValueNotifier<String> comment,
      ValueNotifier<bool> displayCommentFlg,
      ValueNotifier<String> beforeAnswer,
      ValueNotifier<Answer?> selectedAnswer,
      ValueNotifier<List<Answer>> availableAnswers) {
    enableAnswerButtonFlg.value = false;
    comment.value = selectedAnswer.value!.comment;
    displayCommentFlg.value = true;
    context.read(executedAnswerIdsProvider).state.add(selectedAnswer.value!.id);
    availableAnswers.value = availableAnswers.value
        .where((answer) => answer.id != selectedAnswer.value!.id)
        .toList();

    beforeAnswer.value = selectedAnswer.value!.answer;
    selectedAnswer.value = null;
  }

  Future loading(
    BuildContext context,
    ValueNotifier loaded,
    InterstitialAd myInterstitial,
    ValueNotifier nowLoading,
  ) async {
    myInterstitial.load();
    nowLoading.value = true;
    for (int i = 0; i < 10; i++) {
      if (loaded.value) {
        break;
      }
      await new Future.delayed(new Duration(seconds: 1));
    }
    nowLoading.value = false;
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * .35;
    final AudioCache soundEffect = useProvider(soundEffectProvider).state;
    final List<Answer> allAnswers = useProvider(allAnswersProvider).state;
    final List<String> alreadyAnsweredIds =
        useProvider(alreadyAnsweredIdsProvider).state;

    final List<Question> askedQuestions =
        useProvider(askedQuestionsProvider).state;

    final List<int> executedAnswerIds =
        useProvider(executedAnswerIdsProvider).state;

    final List<int> correctAnswerIds =
        useProvider(correctAnswerIdsProvider).state;

    final availableAnswers = useState<List<Answer>>([]);
    final selectedAnswer = useState<Answer?>(null);
    final enableAnswerButtonFlg = useState<bool>(false);
    final displayCommentFlg = useState<bool>(false);
    final comment = useState<String>('');
    final beforeAnswer = useState<String>('');

    final loaded = useState(false);
    final nowLoading = useState(false);

    final bool enModeFlg = useProvider(enModeFlgProvider).state;

    final InterstitialAd myInterstitial = InterstitialAd(
      adUnitId: Platform.isAndroid
          ? ANDROID_ANSWER_INTERSTITIAL_ADVID
          : IOS_ANSWER_INTERSTITIAL_ADVID,
      // ? TEST_ANDROID_INTERSTITIAL_ADVID
      // : TEST_IOS_INTERSTITIAL_ADVID,
      request: AdRequest(),
      listener: AdListener(
        onAdLoaded: (Ad ad) => {
          loaded.value = true,
          // print('インタースティシャル広告がロードされました。'),
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) => {
          ad.dispose(),
          // print('インタースティシャル広告のロードに失敗しました。: $error'),
        },
        // onAdOpened: (Ad ad) => print('インタースティシャル広告が開かれました。'),
        onAdClosed: (Ad ad) => {
          ad.dispose(),
          // print('インタースティシャル広告が閉じられました。'),
        },
        // onApplicationExit: (Ad ad) => {
        //   print('ユーザーがアプリを離れました。'),
        // },
      ),
    );

    getAnswerChoices(
      context,
      allAnswers,
      availableAnswers,
      askedQuestions,
      executedAnswerIds,
      correctAnswerIds,
    );

    return Stack(
      children: <Widget>[
        background(),
        Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    enModeFlg
                        ? EN_TEXT['answerMessage']!
                        : JA_TEXT['answerMessage']!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: height > 210 ? 28.0 : 22.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 7,
                        horizontal: 10,
                      ),
                      width: MediaQuery.of(context).size.width * .70,
                      height: 110,
                      decoration: BoxDecoration(
                        color: availableAnswers.value.isEmpty
                            ? Colors.grey[400]
                            : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.black,
                        ),
                      ),
                      child: DropdownButton(
                        itemHeight: 100,
                        isExpanded: true,
                        hint: Text(
                          allAnswers.isEmpty
                              ? enModeFlg
                                  ? EN_TEXT['finishedAnswer']!
                                  : JA_TEXT['finishedAnswer']!
                              : beforeAnswer.value.isEmpty
                                  ? availableAnswers.value.isEmpty
                                      ? enModeFlg
                                          ? EN_TEXT['moreQuestion']!
                                          : JA_TEXT['moreQuestion']!
                                      : enModeFlg
                                          ? EN_TEXT['selectAnswer']!
                                          : JA_TEXT['selectAnswer']!
                                  : beforeAnswer.value,
                          style: TextStyle(
                            color: Colors.black54,
                          ),
                        ),
                        underline: Container(
                          color: Colors.white,
                        ),
                        value: selectedAnswer.value,
                        items: availableAnswers.value.map((Answer answer) {
                          return DropdownMenuItem(
                            value: answer,
                            child: Text(answer.answer),
                          );
                        }).toList(),
                        onChanged: (targetAnswer) {
                          enableAnswerButtonFlg.value = true;
                          displayCommentFlg.value = false;
                          selectedAnswer.value = targetAnswer as Answer;
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: ElevatedButton(
                      onPressed: enableAnswerButtonFlg.value
                          ? correctAnswerIds.contains(selectedAnswer.value!.id)
                              ? () async {
                                  enableAnswerButtonFlg.value = false;
                                  soundEffect.play('sounds/quiz_button.mp3',
                                      isNotification: true);

                                  await new Future.delayed(
                                    new Duration(milliseconds: 600),
                                  );

                                  showDialog<int>(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (BuildContext context) {
                                      return AnsweringModal(true);
                                    },
                                  );

                                  // 広告を出す
                                  await loading(
                                    context,
                                    loaded,
                                    myInterstitial,
                                    nowLoading,
                                  );

                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  if (!alreadyAnsweredIds
                                      .contains(quizId.toString())) {
                                    // 正解した問題を登録
                                    context
                                        .read(alreadyAnsweredIdsProvider)
                                        .state
                                        .add(quizId.toString());
                                    prefs.setStringList('alreadyAnsweredIds',
                                        alreadyAnsweredIds);
                                  }

                                  soundEffect.play(
                                    'sounds/correct_answer.mp3',
                                    isNotification: true,
                                  );

                                  if (loaded.value) {
                                    myInterstitial.show();
                                  }

                                  // Navigator.pop(context)を実行させる前に坊やくんの表示を完了させるため
                                  await new Future.delayed(
                                    new Duration(seconds: 3),
                                  );

                                  Navigator.pop(context);

                                  String correctComment =
                                      selectedAnswer.value!.comment;
                                  enableAnswerButtonFlg.value = false;
                                  selectedAnswer.value = null;
                                  context.read(beforeWordProvider).state =
                                      enModeFlg
                                          ? EN_TEXT['finishedAnswer']!
                                          : JA_TEXT['finishedAnswer']!;

                                  context.read(allAnswersProvider).state = [];
                                  context.read(displayReplyFlgProvider).state =
                                      false;
                                  context
                                      .read(remainingQuestionsProvider)
                                      .state = [];

                                  showDialog<int>(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (BuildContext context) {
                                      return CorrectAnswerModal(correctComment);
                                    },
                                  );
                                }
                              : () async {
                                  enableAnswerButtonFlg.value = false;
                                  soundEffect.play('sounds/quiz_button.mp3',
                                      isNotification: true);
                                  await new Future.delayed(
                                    new Duration(milliseconds: 600),
                                  );
                                  showDialog<int>(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (BuildContext context) {
                                      return AnsweringModal(false);
                                    },
                                  );

                                  await new Future.delayed(
                                    new Duration(milliseconds: 3400),
                                  );
                                  enableAnswerButtonFlg.value = true;

                                  soundEffect.play('sounds/wrong_answer.mp3',
                                      isNotification: true);

                                  Navigator.pop(context);

                                  executeAnswer(
                                    context,
                                    enableAnswerButtonFlg,
                                    comment,
                                    displayCommentFlg,
                                    beforeAnswer,
                                    selectedAnswer,
                                    availableAnswers,
                                  );
                                }
                          : () => {},
                      child: Text(enModeFlg
                          ? EN_TEXT['answerButton']!
                          : JA_TEXT['answerButton']!),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.only(
                          right: 11,
                          left: 14,
                        ),
                        primary: enableAnswerButtonFlg.value
                            ? Colors.orange
                            : Colors.orange[200],
                        textStyle: Theme.of(context).textTheme.button,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(
                      top: 15,
                    ),
                    height: height > 200 ? 135 : 125,
                    width: MediaQuery.of(context).size.width * .85,
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 500),
                      opacity: displayCommentFlg.value ? 1 : 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 15,
                          horizontal: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: Colors.blue.shade800,
                            width: 5,
                          ),
                        ),
                        child: Text(
                          comment.value,
                          style: TextStyle(
                            fontSize: height > 200 ? 18 : 16,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

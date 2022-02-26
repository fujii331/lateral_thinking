import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:lateral_thinking/services/admob/interstitial_action.service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../background.widget.dart';

import '../../providers/quiz.provider.dart';
import '../../providers/common.provider.dart';

import '../../models/quiz.model.dart';
import '../../models/analytics.model.dart';
import '../../data/analytics_data.dart';
import 'correct_answer_modal.widget.dart';
import './answering_modal.widget.dart';
import '../../text.dart';

class QuizAnswer extends HookWidget {
  final int quizId;
  final ValueNotifier<InterstitialAd?> interstitialAd;

  const QuizAnswer({
    Key? key,
    required this.quizId,
    required this.interstitialAd,
  }) : super(key: key);

  void executeAnswer(
      BuildContext context,
      ValueNotifier<bool> enableAnswerButtonFlg,
      ValueNotifier<String> comment,
      ValueNotifier<bool> displayCommentFlg,
      ValueNotifier<String> beforeAnswer,
      ValueNotifier<Answer?> selectedAnswer,
      List<Answer> readyForAnswers) {
    enableAnswerButtonFlg.value = false;
    comment.value = selectedAnswer.value!.comment;
    displayCommentFlg.value = true;
    context.read(executedAnswerIdsProvider).state.add(selectedAnswer.value!.id);
    context.read(readyForAnswersProvider).state = readyForAnswers
        .where((answer) => answer.id != selectedAnswer.value!.id)
        .toList();

    beforeAnswer.value = selectedAnswer.value!.answer;
    selectedAnswer.value = null;
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * .35;
    final AudioCache soundEffect = useProvider(soundEffectProvider).state;
    final List<Answer> allAnswers = useProvider(allAnswersProvider).state;
    final List<String> alreadyAnsweredIds =
        useProvider(alreadyAnsweredIdsProvider).state;

    final List<int> correctAnswerIds =
        useProvider(correctAnswerIdsProvider).state;
    final double seVolume = useProvider(seVolumeProvider).state;

    final List<Answer> readyForAnswers =
        useProvider(readyForAnswersProvider).state;

    final selectedAnswer = useState<Answer?>(null);
    final enableAnswerButtonFlg = useState<bool>(false);
    final displayCommentFlg = useState<bool>(false);
    final comment = useState<String>('');
    final beforeAnswer = useState<String>('');

    final bool enModeFlg = useProvider(enModeFlgProvider).state;

    return Center(
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
                    color: readyForAnswers.isEmpty
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
                              ? readyForAnswers.isEmpty
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
                    items: readyForAnswers.map((Answer answer) {
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
                              soundEffect.play(
                                'sounds/quiz_button.mp3',
                                isNotification: true,
                                volume: seVolume,
                              );

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

                              await new Future.delayed(
                                new Duration(milliseconds: 3000),
                              );

                              final bool clearedFirst = !alreadyAnsweredIds
                                  .contains(quizId.toString());

                              if (clearedFirst && !enModeFlg) {
                                // 正解した問題を登録
                                SharedPreferences preference =
                                    await SharedPreferences.getInstance();

                                context
                                    .read(alreadyAnsweredIdsProvider)
                                    .state
                                    .add(quizId.toString());
                                preference.setStringList(
                                    'alreadyAnsweredIds',
                                    context
                                        .read(alreadyAnsweredIdsProvider)
                                        .state);
                              }

                              soundEffect.play(
                                'sounds/correct_answer.mp3',
                                isNotification: true,
                                volume: seVolume,
                              );

                              if (interstitialAd.value != null) {
                                // 広告を表示する
                                showInterstitialAd(
                                  context,
                                  interstitialAd,
                                );
                              } else {
                                // 広告読み込み
                                interstitialLoading(
                                  interstitialAd,
                                  1,
                                );
                                for (int i = 0; i < 7; i++) {
                                  if (i > 2 && interstitialAd.value != null) {
                                    break;
                                  }
                                  await Future.delayed(
                                      const Duration(seconds: 1));
                                }

                                if (interstitialAd.value != null) {
                                  // 広告を表示する
                                  showInterstitialAd(
                                    context,
                                    interstitialAd,
                                  );
                                }
                              }

                              Analytics? data;

                              if (!enModeFlg) {
                                final int hint =
                                    context.read(hintProvider).state;

                                final int relatedWordCountValue = context
                                    .read(relatedWordCountProvider)
                                    .state;

                                final int questionCountValue =
                                    context.read(questionCountProvider).state;

                                final bool subHintFlg =
                                    context.read(subHintFlgProvider).state;

                                final bool noHintFlg = hint == 0 && !subHintFlg;

                                int hint1Count = hint > 0 ? 1 : 0;
                                int hint2Count = hint > 1 ? 1 : 0;
                                int hint3Count = hint > 2 ? 1 : 0;
                                int subHintCount = subHintFlg ? 1 : 0;
                                int relatedWordCount =
                                    noHintFlg ? relatedWordCountValue : 0;
                                int questionCount =
                                    noHintFlg ? questionCountValue : 0;
                                int userCount = 1;
                                int noHintCount = noHintFlg ? 1 : 0;

                                DatabaseReference firebaseInstance =
                                    FirebaseDatabase.instance.ref().child(
                                        'analytics_second/' +
                                            quizId.toString());

                                await firebaseInstance
                                    .get()
                                    .then((DataSnapshot? snapshot) {
                                  if (snapshot != null) {
                                    final Map? firebaseData =
                                        snapshot.value as Map;

                                    hint1Count +=
                                        firebaseData!['hint1Count'] as int;

                                    hint2Count +=
                                        firebaseData['hint2Count'] as int;
                                    hint3Count +=
                                        firebaseData['hint3Count'] as int;
                                    subHintCount +=
                                        firebaseData['subHintCount'] as int;

                                    relatedWordCount +=
                                        firebaseData['relatedWordCount'] as int;
                                    questionCount +=
                                        firebaseData['questionCount'] as int;

                                    userCount +=
                                        firebaseData['userCount'] as int;

                                    noHintCount +=
                                        firebaseData['noHintCount'] as int;

                                    // data = Analytics(
                                    //   hint1:
                                    //       (100 * (hint1Count / userCount))
                                    //           .round(),
                                    //   hint2:
                                    //       (100 * (hint2Count / userCount))
                                    //           .round(),
                                    //   noHint:
                                    //       (100 * (noHintCount / userCount))
                                    //           .round(),
                                    //   subHint:
                                    //       (100 * (subHintCount / userCount))
                                    //           .round(),
                                    //   relatedWordCountAll: noHintCount == 0
                                    //       ? 0
                                    //       : (relatedWordCount / noHintCount)
                                    //           .round(),
                                    //   relatedWordCountYou:
                                    //       relatedWordCountValue,
                                    //   questionCountAll: noHintCount == 0
                                    //       ? 0
                                    //       : (questionCount / noHintCount)
                                    //           .round(),
                                    //   questionCountYou: questionCountValue,
                                    // );

                                    if (clearedFirst) {
                                      firebaseInstance.set({
                                        'hint1Count': hint1Count,
                                        'hint2Count': hint2Count,
                                        'hint3Count': hint3Count,
                                        'subHintCount': subHintCount,
                                        'relatedWordCount': relatedWordCount,
                                        'questionCount': questionCount,
                                        'userCount': userCount,
                                        'noHintCount': noHintCount,
                                      });
                                    }
                                  }
                                }).onError((error, stackTrace) =>
                                        // 何もしない
                                        null);

                                final gotAnalyticsData =
                                    ANALYTICS_DATA[quizId - 1];
                                data = Analytics(
                                  hint1: gotAnalyticsData.hint1,
                                  hint2: gotAnalyticsData.hint2,
                                  noHint: gotAnalyticsData.noHint,
                                  subHint: gotAnalyticsData.subHint,
                                  relatedWordCountAll:
                                      gotAnalyticsData.relatedWordCountAll,
                                  relatedWordCountYou: relatedWordCountValue,
                                  questionCountAll:
                                      gotAnalyticsData.questionCountAll,
                                  questionCountYou: questionCountValue,
                                );
                              }

                              // Navigator.pop(context)を実行させる前に坊やくんの表示を完了させるため
                              await new Future.delayed(
                                new Duration(milliseconds: 1000),
                              );

                              Navigator.pop(context);

                              String correctComment =
                                  selectedAnswer.value!.comment;
                              enableAnswerButtonFlg.value = false;
                              selectedAnswer.value = null;
                              context.read(playingQuizIdProvider).state = 0;
                              context.read(beforeWordProvider).state = enModeFlg
                                  ? EN_TEXT['finishedAnswer']!
                                  : JA_TEXT['finishedAnswer']!;

                              context.read(allAnswersProvider).state = [];
                              context.read(displayReplyFlgProvider).state =
                                  false;
                              context.read(remainingQuestionsProvider).state =
                                  [];

                              showDialog<int>(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  return CorrectAnswerModal(
                                    correctComment,
                                    data,
                                  );
                                },
                              );
                            }
                          : () async {
                              enableAnswerButtonFlg.value = false;
                              soundEffect.play(
                                'sounds/quiz_button.mp3',
                                isNotification: true,
                                volume: seVolume,
                              );
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
                                new Duration(milliseconds: 3200),
                              );
                              enableAnswerButtonFlg.value = true;

                              soundEffect.play(
                                'sounds/wrong_answer.mp3',
                                isNotification: true,
                                volume: seVolume,
                              );

                              Navigator.pop(context);

                              executeAnswer(
                                context,
                                enableAnswerButtonFlg,
                                comment,
                                displayCommentFlg,
                                beforeAnswer,
                                selectedAnswer,
                                readyForAnswers,
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
    );
  }
}

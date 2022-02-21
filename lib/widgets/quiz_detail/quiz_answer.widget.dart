import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:firebase_database/firebase_database.dart';

import 'dart:io';

import '../background.widget.dart';

import '../../providers/quiz.provider.dart';
import '../../providers/common.provider.dart';

import '../../models/quiz.model.dart';
import '../../models/analytics.model.dart';
import '../../data/analytics_data.dart';
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

  void _createInterstitialAd(
    ValueNotifier<InterstitialAd?> myInterstitial,
    int _numInterstitialLoadAttempts,
  ) {
    InterstitialAd.load(
      adUnitId: Platform.isAndroid
          ? ANDROID_ANSWER_INTERSTITIAL_ADVID
          : IOS_ANSWER_INTERSTITIAL_ADVID,
      // ? TEST_ANDROID_INTERSTITIAL_ADVID
      // : TEST_IOS_INTERSTITIAL_ADVID, //InterstitialAd.testAdUnitId
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          myInterstitial.value = ad;
          _numInterstitialLoadAttempts = 0;
          myInterstitial.value!.setImmersiveMode(true);
        },
        onAdFailedToLoad: (LoadAdError error) {
          _numInterstitialLoadAttempts += 1;
          myInterstitial.value = null;
          if (_numInterstitialLoadAttempts <= 3) {
            _createInterstitialAd(
              myInterstitial,
              _numInterstitialLoadAttempts,
            );
          }
        },
      ),
    );
  }

  Future loading(
    BuildContext context,
    ValueNotifier<InterstitialAd?> myInterstitial,
    ValueNotifier nowLoading,
  ) async {
    int _numInterstitialLoadAttempts = 0;
    nowLoading.value = true;
    _createInterstitialAd(
      myInterstitial,
      _numInterstitialLoadAttempts,
    );
    for (int i = 0; i < 10; i++) {
      if (i > 2 && myInterstitial.value != null) {
        break;
      }
      await new Future.delayed(new Duration(seconds: 1));
    }
    nowLoading.value = false;
  }

  void _showInterstitialAd(
    InterstitialAd? myInterstitialValue,
  ) {
    if (myInterstitialValue == null) {
      // print('Warning: attempt to show interstitial before loaded.');
      return;
    }
    myInterstitialValue.fullScreenContentCallback = FullScreenContentCallback(
      // onAdShowedFullScreenContent: (InterstitialAd ad) =>
      //     print('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        // print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        // print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
      },
    );
    myInterstitialValue.show();
    myInterstitialValue = null;
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
    final double seVolume = useProvider(seVolumeProvider).state;

    final availableAnswers = useState<List<Answer>>([]);
    final selectedAnswer = useState<Answer?>(null);
    final enableAnswerButtonFlg = useState<bool>(false);
    final displayCommentFlg = useState<bool>(false);
    final comment = useState<String>('');
    final beforeAnswer = useState<String>('');

    final nowLoading = useState(false);

    final bool enModeFlg = useProvider(enModeFlgProvider).state;

    final ValueNotifier<InterstitialAd?> myInterstitial = useState(null);

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

                                  // 広告を出す
                                  await loading(
                                    context,
                                    myInterstitial,
                                    nowLoading,
                                  );

                                  final bool clearedFirst = !alreadyAnsweredIds
                                      .contains(quizId.toString());

                                  if (clearedFirst && !enModeFlg) {
                                    // 正解した問題を登録
                                    SharedPreferences prefs =
                                        await SharedPreferences.getInstance();

                                    context
                                        .read(alreadyAnsweredIdsProvider)
                                        .state
                                        .add(quizId.toString());
                                    prefs.setStringList(
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

                                  if (myInterstitial.value != null) {
                                    _showInterstitialAd(myInterstitial.value);
                                  }

                                  Analytics? data;

                                  if (!enModeFlg) {
                                    final int hint =
                                        context.read(hintProvider).state;

                                    final int relatedWordCountValue = context
                                        .read(relatedWordCountProvider)
                                        .state;

                                    final int questionCountValue = context
                                        .read(questionCountProvider)
                                        .state;

                                    final bool subHintFlg =
                                        context.read(subHintFlgProvider).state;

                                    final bool noHintFlg =
                                        hint == 0 && !subHintFlg;

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
                                            firebaseData['relatedWordCount']
                                                as int;
                                        questionCount +=
                                            firebaseData['questionCount']
                                                as int;

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
                                            'relatedWordCount':
                                                relatedWordCount,
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
                                      relatedWordCountYou:
                                          relatedWordCountValue,
                                      questionCountAll:
                                          gotAnalyticsData.questionCountAll,
                                      questionCountYou: questionCountValue,
                                    );
                                  }

                                  // Navigator.pop(context)を実行させる前に坊やくんの表示を完了させるため
                                  await new Future.delayed(
                                    new Duration(seconds: 2),
                                  );

                                  Navigator.pop(context);

                                  String correctComment =
                                      selectedAnswer.value!.comment;
                                  enableAnswerButtonFlg.value = false;
                                  selectedAnswer.value = null;
                                  context.read(playingQuizIdProvider).state = 0;
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
                                    new Duration(milliseconds: 3400),
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

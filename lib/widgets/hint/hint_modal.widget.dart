import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'dart:io';
import 'dart:async';
import 'dart:math';

import '../../providers/quiz.provider.dart';

import '../replry_modal.widget.dart';
import './ad_loading_modal.widget.dart';

import '../../models/quiz.model.dart';
import '../../advertising.dart';

class HintModal extends HookWidget {
  final Quiz quiz;

  HintModal(this.quiz);

  Future loading(BuildContext context, ValueNotifier loaded,
      RewardedAd rewardAd, ValueNotifier nowLoading) async {
    rewardAd.load();
    nowLoading.value = true;
    for (int i = 0; i < 15; i++) {
      if (loaded.value) {
        break;
      }
      await new Future.delayed(new Duration(seconds: 1));
    }
    nowLoading.value = false;
  }

  @override
  Widget build(BuildContext context) {
    final AudioCache soundEffect = useProvider(soundEffectProvider).state;
    final int hint = useProvider(hintProvider).state;
    final loaded = useState(false);
    final nowLoading = useState(false);

    final List<Question> askedQuestions =
        useProvider(askedQuestionsProvider).state;

    List<int> currentQuestionIds = askedQuestions.map((askedQuestion) {
      return askedQuestion.id;
    }).toList();

    final rewardAd = RewardedAd(
      adUnitId: Platform.isAndroid
          ? TEST_ANDROID_REWQRD_ADVID
          : IOS_HINT_REWQRD_ADVID,
      request: AdRequest(),
      listener: AdListener(
        onAdLoaded: (Ad ad) {
          loaded.value = true;
          // print('リワード広告を読み込みました！');
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          ad.dispose();
          // print('リワード広告の読み込みに失敗しました。: $error');
        },
        onAdOpened: (Ad ad) {
          // print('リワード広告が開かれました。');
        },
        onAdClosed: (Ad ad) => {
          ad.dispose(),
          // print('リワード広告が閉じられました。'),
          Navigator.pop(context),
          Navigator.pop(context),
          AwesomeDialog(
            context: context,
            dialogType: DialogType.ERROR,
            headerAnimationLoop: false,
            animType: AnimType.SCALE,
            body: ReplyModal(
              AppLocalizations.of(context)!.notGetHint,
            ),
          )..show(),
        },
        // onApplicationExit: (Ad ad) => print('ユーザーがアプリを離れました。'),
        onRewardedAdUserEarnedReward: (RewardedAd ad, RewardItem reward) => {
          // print('報酬を獲得しました: $reward'),
          context.read(hintProvider).state++,
          context.read(selectedQuestionProvider).state = dummyQuestion,
          context.read(displayReplyFlgProvider).state = false,
          if (hint >= 1)
            {
              context.read(beforeWordProvider).state =
                  AppLocalizations.of(context)!.selectQuestion,
              if (hint == 1)
                {
                  context.read(askingQuestionsProvider).state = _shuffle(quiz
                      .questions
                      .take(quiz.hintDisplayQuestionId)
                      .where((question) =>
                          !currentQuestionIds.contains(question.id))
                      .toList()) as List<Question>,
                }
              else if (hint == 2)
                {
                  context.read(askingQuestionsProvider).state = quiz.questions
                      .where((question) =>
                          quiz.correctAnswerQuestionIds.contains(question.id) &&
                          !currentQuestionIds.contains(question.id))
                      .toList(),
                },
              if (context.read(askingQuestionsProvider).state.isEmpty)
                {
                  context.read(beforeWordProvider).state =
                      AppLocalizations.of(context)!.notExistQuestion,
                },
            }
          else
            {
              context.read(beforeWordProvider).state = '',
              context.read(askingQuestionsProvider).state = [],
              context.read(selectedSubjectProvider).state = '',
              context.read(selectedRelatedWordProvider).state = '',
            },
          Navigator.pop(context),
          Navigator.pop(context),
          AwesomeDialog(
            context: context,
            dialogType: DialogType.SUCCES,
            headerAnimationLoop: false,
            animType: AnimType.SCALE,
            body: ReplyModal(
              hint == 0
                  ? AppLocalizations.of(context)!.openedHint1
                  : hint == 1
                      ? AppLocalizations.of(context)!.openedHint2
                      : AppLocalizations.of(context)!.openedHint3,
            ),
          )..show(),
        },
      ),
    );

    return Padding(
      padding: const EdgeInsets.only(
        left: 20,
        right: 20,
        bottom: 25,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 10,
            ),
            child: Text(
              hint < 3
                  ? AppLocalizations.of(context)!.getHintPrefix +
                      (hint + 1).toString() +
                      AppLocalizations.of(context)!.getHintSuffix
                  : AppLocalizations.of(context)!.noHintExist,
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                fontFamily: 'SawarabiGothic',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 5,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Icon(
                  hint < 1 ? Icons.looks_one_outlined : Icons.looks_one,
                  size: 45,
                ),
                Icon(
                  hint < 2 ? Icons.looks_two_outlined : Icons.looks_two,
                  size: 45,
                ),
                Icon(
                  hint < 3 ? Icons.looks_3_outlined : Icons.looks_3,
                  size: 45,
                ),
              ],
            ),
          ),
          Container(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 20,
              ),
              child: Text(
                hint < 1
                    ? AppLocalizations.of(context)!.getHint1
                    : hint == 1
                        ? AppLocalizations.of(context)!.getHint2
                        : hint == 2
                            ? AppLocalizations.of(context)!.getHint3
                            : AppLocalizations.of(context)!.gotAllHint,
                style: TextStyle(
                  fontSize: 18.0,
                  fontFamily: 'SawarabiGothic',
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 5,
              right: 5,
              top: 15,
            ),
            child: Wrap(
              children: [
                ElevatedButton(
                  onPressed: () => {
                    soundEffect.play('sounds/cancel.mp3', isNotification: true),
                    Navigator.pop(context)
                  },
                  child: Text(AppLocalizations.of(context)!.noButton),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.only(
                      right: 14,
                      left: 14,
                    ),
                    primary: Colors.red[500],
                    textStyle: Theme.of(context).textTheme.button,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(width: 30),
                ElevatedButton(
                  onPressed: () async => hint < 3
                      ? {
                          soundEffect.play('sounds/tap.mp3',
                              isNotification: true),
                          showDialog<int>(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return AdLoadingModal();
                            },
                          ),
                          await loading(context, loaded, rewardAd, nowLoading),
                          if (loaded.value)
                            {
                              rewardAd.show(),
                            }
                          else
                            {
                              Navigator.pop(context),
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.ERROR,
                                headerAnimationLoop: false,
                                animType: AnimType.SCALE,
                                body: ReplyModal(
                                  AppLocalizations.of(context)!.failedToLoad,
                                ),
                              )..show(),
                            },
                        }
                      : {},
                  child: Text(AppLocalizations.of(context)!.yesButton),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.only(
                      right: 14,
                      left: 14,
                    ),
                    primary: hint < 3 ? Colors.blue[700] : Colors.blue[300],
                    textStyle: Theme.of(context).textTheme.button,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

List _shuffle(List items) {
  var random = new Random();
  for (var i = items.length - 1; i > 0; i--) {
    var n = random.nextInt(i + 1);
    var temp = items[i];
    items[i] = items[n];
    items[n] = temp;
  }
  return items;
}

import 'dart:io';
import 'dart:math';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/material.dart';
import 'package:lateral_thinking/data/advertising.dart';
import 'package:lateral_thinking/models/quiz.model.dart';
import 'package:lateral_thinking/providers/quiz.provider.dart';
import 'package:lateral_thinking/screens/werewolf_preparation_first.screen.dart';
import 'package:lateral_thinking/text.dart';
import 'package:lateral_thinking/widgets/hint/opened_sub_hint_modal.widget.dart';
import 'package:lateral_thinking/widgets/reply_modal.widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

void showNewQuestionsRewardedAd(
  BuildContext context,
  ValueNotifier<RewardedAd?> rewardAd,
  bool enModeFlg,
) {
  if (rewardAd.value == null) {
    return;
  }
  rewardAd.value!.fullScreenContentCallback = FullScreenContentCallback(
    onAdDismissedFullScreenContent: (RewardedAd ad) {
      ad.dispose();
    },
    onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
      ad.dispose();
      AwesomeDialog(
        context: context,
        dialogType: DialogType.NO_HEADER,
        headerAnimationLoop: false,
        dismissOnTouchOutside: true,
        dismissOnBackKeyPress: true,
        showCloseIcon: true,
        animType: AnimType.SCALE,
        width: MediaQuery.of(context).size.width * .86 > 650 ? 650 : null,
        body: ReplyModal(
          enModeFlg ? EN_TEXT['gotNoQuiz']! : JA_TEXT['gotNoQuiz']!,
          0,
        ),
      ).show();
    },
  );
  rewardAd.value!.setImmersiveMode(true);
  rewardAd.value!.show(
      onUserEarnedReward: (AdWithoutView ad, RewardItem reward) async {
    final int openQuizNumber = context.read(openingNumberProvider).state + 3;

    SharedPreferences preference = await SharedPreferences.getInstance();

    if (enModeFlg) {
      preference.setInt('openingNumberEn', openQuizNumber);
    } else {
      preference.setInt('openingNumber', openQuizNumber);
    }

    context.read(openingNumberProvider).state = openQuizNumber;

    AwesomeDialog(
      context: context,
      dialogType: DialogType.SUCCES,
      headerAnimationLoop: false,
      animType: AnimType.SCALE,
      width: MediaQuery.of(context).size.width * .86 > 650 ? 650 : null,
      body: ReplyModal(
        enModeFlg ? EN_TEXT['gotQuiz']! : JA_TEXT['gotQuiz']!,
        openQuizNumber,
      ),
    ).show();
  });
  rewardAd.value = null;
}

void showHintRewardedAd(
  BuildContext context,
  ValueNotifier<RewardedAd?> rewardAd,
  Quiz quiz,
  TextEditingController subjectController,
  TextEditingController relatedWordController,
  bool enModeFlg,
) {
  if (rewardAd.value == null) {
    return;
  }
  rewardAd.value!.fullScreenContentCallback = FullScreenContentCallback(
    onAdDismissedFullScreenContent: (RewardedAd ad) {
      ad.dispose();
    },
    onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
      ad.dispose();
      AwesomeDialog(
        context: context,
        dialogType: DialogType.NO_HEADER,
        headerAnimationLoop: false,
        dismissOnTouchOutside: true,
        dismissOnBackKeyPress: true,
        showCloseIcon: true,
        animType: AnimType.SCALE,
        width: MediaQuery.of(context).size.width * .86 > 650 ? 650 : null,
        body: ReplyModal(
          enModeFlg ? EN_TEXT['notGetHint']! : JA_TEXT['notGetHint']!,
          0,
        ),
      ).show();
    },
  );
  rewardAd.value!.setImmersiveMode(true);
  rewardAd.value!.show(
    onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
      afterGotHint(
        context,
        quiz,
        subjectController,
        relatedWordController,
        enModeFlg,
      );
    },
  );
  rewardAd.value = null;
}

void showSubHintRewardedAd(
  BuildContext context,
  ValueNotifier<RewardedAd?> rewardAd,
  List<String> subHints,
  bool enModeFlg,
) {
  if (rewardAd.value == null) {
    return;
  }
  rewardAd.value!.fullScreenContentCallback = FullScreenContentCallback(
    onAdDismissedFullScreenContent: (RewardedAd ad) {
      ad.dispose();
    },
    onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
      ad.dispose();
      AwesomeDialog(
        context: context,
        dialogType: DialogType.NO_HEADER,
        headerAnimationLoop: false,
        dismissOnTouchOutside: true,
        dismissOnBackKeyPress: true,
        showCloseIcon: true,
        animType: AnimType.SCALE,
        width: MediaQuery.of(context).size.width * .86 > 650 ? 650 : null,
        body: ReplyModal(
          enModeFlg ? EN_TEXT['notGetSubHint']! : JA_TEXT['notGetSubHint']!,
          0,
        ),
      ).show();
    },
  );
  rewardAd.value!.setImmersiveMode(true);
  rewardAd.value!.show(
    onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
      afterGotSubHint(
        context,
        subHints,
      );
    },
  );
  rewardAd.value = null;
}

void showPlayingWerewolfRewardedAd(
  BuildContext context,
  ValueNotifier<RewardedAd?> rewardAd,
  Quiz quiz,
) {
  if (rewardAd.value == null) {
    return;
  }
  rewardAd.value!.fullScreenContentCallback = FullScreenContentCallback(
    onAdDismissedFullScreenContent: (RewardedAd ad) {
      ad.dispose();
    },
    onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
      ad.dispose();
      AwesomeDialog(
        context: context,
        dialogType: DialogType.NO_HEADER,
        headerAnimationLoop: false,
        dismissOnTouchOutside: true,
        dismissOnBackKeyPress: true,
        showCloseIcon: true,
        animType: AnimType.SCALE,
        width: MediaQuery.of(context).size.width * .86 > 650 ? 650 : null,
        body: ReplyModal(
          '問題を取得できませんでした。',
          0,
        ),
      ).show();
    },
  );
  rewardAd.value!.setImmersiveMode(true);
  rewardAd.value!.show(
      onUserEarnedReward: (AdWithoutView ad, RewardItem reward) async {
    SharedPreferences preference = await SharedPreferences.getInstance();
    context.read(alreadyAnsweredIdsProvider).state.add(quiz.id.toString());
    preference.setStringList(
        'alreadyAnsweredIds', context.read(alreadyAnsweredIdsProvider).state);

    Navigator.of(context).pushNamed(
      WerewolfPreparationFirstScreen.routeName,
      arguments: [
        quiz.sentence,
        quiz.answers[0].comment,
      ],
    );
  });
  rewardAd.value = null;
}

void createRewardedAd(
  ValueNotifier<RewardedAd?> rewardedAd,
  int _numRewardedLoadAttempts,
  int rewardNumber,
) {
  RewardedAd.load(
    adUnitId: Platform.isAndroid
        ? rewardNumber == 1
            ? androidNewQuestionsRewardAdvId
            : rewardNumber == 2
                ? androidHintRewardAdvId
                : androidPlayingWerewolfRewardAdvId
        : rewardNumber == 1
            ? iosNewQuestionsRewardAdvId
            : rewardNumber == 2
                ? iosHintRewardAdvId
                : iosWerewolfInterstitialAdvId,
    // adUnitId: RewardedAd.testAdUnitId,
    request: const AdRequest(),
    rewardedAdLoadCallback: RewardedAdLoadCallback(
      onAdLoaded: (RewardedAd ad) {
        rewardedAd.value = ad;
        _numRewardedLoadAttempts = 0;
      },
      onAdFailedToLoad: (LoadAdError error) {
        rewardedAd.value = null;
        _numRewardedLoadAttempts += 1;
        if (_numRewardedLoadAttempts <= 3) {
          createRewardedAd(
            rewardedAd,
            _numRewardedLoadAttempts,
            rewardNumber,
          );
        }
      },
    ),
  );
}

Future rewardLoading(
  ValueNotifier<RewardedAd?> rewardedAd,
  int rewardNumber,
) async {
  int _numRewardedLoadAttempts = 0;
  createRewardedAd(
    rewardedAd,
    _numRewardedLoadAttempts,
    rewardNumber,
  );
  for (int i = 0; i < 15; i++) {
    if (rewardedAd.value != null) {
      break;
    }
    await Future.delayed(const Duration(seconds: 1));
  }
}

void afterGotHint(
  BuildContext context,
  Quiz quiz,
  TextEditingController subjectController,
  TextEditingController relatedWordController,
  bool enModeFlg,
) {
  final int hint = context.read(hintProvider).state;

  final List<Question> askedQuestions =
      context.read(askedQuestionsProvider).state;

  final List<int> currentQuestionIds = askedQuestions.map((askedQuestion) {
    return askedQuestion.id;
  }).toList();

  AwesomeDialog(
    context: context,
    dialogType: DialogType.SUCCES,
    headerAnimationLoop: false,
    animType: AnimType.SCALE,
    width: MediaQuery.of(context).size.width * .86 > 650 ? 650 : null,
    body: ReplyModal(
      hint == 0
          ? enModeFlg
              ? EN_TEXT['openedHint1Helper']!
              : JA_TEXT['openedHint1Helper']!
          : hint == 1
              ? enModeFlg
                  ? EN_TEXT['openedHint2']!
                  : JA_TEXT['openedHint2']!
              : enModeFlg
                  ? EN_TEXT['openedHint3']!
                  : JA_TEXT['openedHint3']!,
      0,
    ),
  ).show();
  context.read(hintProvider).state++;
  context.read(selectedQuestionProvider).state = dummyQuestion;
  context.read(displayReplyFlgProvider).state = false;
  if (hint >= 1) {
    context.read(beforeWordProvider).state =
        enModeFlg ? EN_TEXT['selectQuestion']! : JA_TEXT['selectQuestion']!;
    if (hint == 1) {
      context.read(askingQuestionsProvider).state = _shuffle(quiz.questions
          .take(quiz.hintDisplayQuestionId)
          .where((question) => !currentQuestionIds.contains(question.id))
          .toList());
    } else if (hint == 2) {
      context.read(askingQuestionsProvider).state = quiz.questions
          .where((question) =>
              quiz.correctAnswerQuestionIds.contains(question.id) &&
              !currentQuestionIds.contains(question.id))
          .toList();
    }
    if (context.read(askingQuestionsProvider).state.isEmpty) {
      context.read(beforeWordProvider).state = enModeFlg
          ? EN_TEXT['notExistQuestion']!
          : JA_TEXT['notExistQuestion']!;
    }
  } else {
    subjectController.text = '';
    relatedWordController.text = '';
    context.read(beforeWordProvider).state = '';
    context.read(askingQuestionsProvider).state = [];
    context.read(selectedSubjectProvider).state = '';
    context.read(selectedRelatedWordProvider).state = '';
  }
}

List<Question> _shuffle(List<Question> items) {
  var random = Random();
  for (var i = items.length - 1; i > 0; i--) {
    var n = random.nextInt(i + 1);
    var temp = items[i];
    items[i] = items[n];
    items[n] = temp;
  }
  return items;
}

void afterGotSubHint(
  BuildContext context,
  List<String> subHints,
) {
  context.read(subHintFlgProvider).state = true;
  AwesomeDialog(
    context: context,
    dialogType: DialogType.NO_HEADER,
    headerAnimationLoop: false,
    animType: AnimType.SCALE,
    width: MediaQuery.of(context).size.width * .86 > 650 ? 650 : null,
    body: OpenedSubHintModal(
      subHints: subHints,
    ),
  ).show();
}

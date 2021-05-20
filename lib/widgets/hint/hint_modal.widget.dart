import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';

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
    final AudioPlayer bgm = useProvider(bgmProvider).state;
    final int hint = useProvider(hintProvider).state;
    final loaded = useState(false);
    final nowLoading = useState(false);

    final List<Question> askedQuestions =
        useProvider(askedQuestionsProvider).state;

    List<int> currentQuestionIds = askedQuestions.map((askedQuestion) {
      return askedQuestion.id;
    }).toList();

    final rewardAd = RewardedAd(
      adUnitId: ANDROID_REWQRD_ADVID,
      request: AdRequest(),
      listener: AdListener(
        onAdLoaded: (Ad ad) {
          loaded.value = true;
          print('リワード広告を読み込みました！');
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          ad.dispose();
          print('リワード広告の読み込みに失敗しました。: $error');
        },
        onAdOpened: (Ad ad) {
          print('リワード広告が開かれました。');
        },
        onAdClosed: (Ad ad) => {
          ad.dispose(),
          print('リワード広告が閉じられました。'),
          Navigator.pop(context),
          Navigator.pop(context),
          showDialog<int>(
            context: context,
            barrierDismissible: true,
            builder: (BuildContext context) {
              return ReplyModal(
                'ヒントを取得できませんでした。',
                true,
              );
            },
          ),
        },
        onApplicationExit: (Ad ad) => print('ユーザーがアプリを離れました。'),
        onRewardedAdUserEarnedReward: (RewardedAd ad, RewardItem reward) => {
          ad.dispose(),
          print('報酬を獲得しました: $reward'),
          context.read(hintProvider).state++,
          context.read(selectedQuestionProvider).state = dummyQuestion,
          context.read(displayReplyFlgProvider).state = false,
          if (hint >= 2)
            {
              context.read(beforeWordProvider).state = '↓質問を選択',
              if (hint == 2)
                {
                  context.read(askingQuestionsProvider).state = _shuffle(quiz
                      .questions
                      .take(quiz.hintDisplayQuestionId)
                      .where((question) =>
                          !currentQuestionIds.contains(question.id))
                      .toList()) as List<Question>,
                }
              else if (hint == 3)
                {
                  context.read(askingQuestionsProvider).state = quiz.questions
                      .where((question) =>
                          quiz.correctAnswerQuestionIds.contains(question.id) &&
                          !currentQuestionIds.contains(question.id))
                      .toList(),
                },
              if (context.read(askingQuestionsProvider).state.isEmpty)
                {
                  context.read(beforeWordProvider).state = 'もう質問はありません。',
                },
            }
          else if (hint >= 0)
            {
              context.read(beforeWordProvider).state = '',
              context.read(askingQuestionsProvider).state = [],
            },
          Navigator.pop(context),
          Navigator.pop(context),
          showDialog<int>(
            context: context,
            barrierDismissible: true,
            builder: (BuildContext context) {
              return ReplyModal(
                hint == 0
                    ? '主語を選択肢で選べるようになりました。'
                    : hint == 1
                        ? '関連語を選択肢で選べるようになりました。'
                        : hint == 2
                            ? '質問を選択肢で選べるようになりました。'
                            : '正解を導く質問のみ選べるようになりました。',
                true,
              );
            },
          ),
        },
      ),
    );

    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 10,
            ),
            child: Text(
              hint < 4
                  ? '短い動画を見てヒント' + (hint + 1).toString() + 'を取得しますか？'
                  : 'ヒントはもうありません。',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 10,
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
                Icon(
                  hint < 4 ? Icons.looks_4_outlined : Icons.looks_4,
                  size: 45,
                ),
              ],
            ),
          ),
          Container(
            height: 100,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 15,
              ),
              child: Text(
                hint < 1
                    ? '主語を選択肢で選べるようになります。'
                    : hint == 1
                        ? '関連語を選択肢で選べるようになります。'
                        : hint == 2
                            ? '質問を選択肢で選べるようになります。'
                            : hint == 3
                                ? '正解を導く質問のみ選べるようになります。'
                                : 'もう答えはすぐそこです！',
                style: TextStyle(
                  fontSize: 18.0,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 15,
            ),
            child: Wrap(
              children: [
                ElevatedButton(
                  onPressed: () => nowLoading.value
                      ? {}
                      : {
                          soundEffect.play('sounds/cancel.mp3',
                              isNotification: true),
                          Navigator.pop(context)
                        },
                  child: const Text('見ない'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red[500],
                    textStyle: Theme.of(context).textTheme.button,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(width: 30),
                ElevatedButton(
                  onPressed: () async => nowLoading.value || hint < 4
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
                              bgm.pause(),
                              rewardAd.show(),
                            }
                          else
                            {
                              Navigator.pop(context),
                              showDialog<int>(
                                context: context,
                                barrierDismissible: true,
                                builder: (BuildContext context) {
                                  return ReplyModal(
                                    '動画の読み込みに失敗しました。\n再度お試しください。',
                                    false,
                                  );
                                },
                              ),
                            },
                        }
                      : {},
                  child: const Text('見る'),
                  style: ElevatedButton.styleFrom(
                    primary: hint < 4 ? Colors.blue[700] : Colors.blue[300],
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

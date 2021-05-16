import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';

import 'dart:async';

import '../replry_modal.widget.dart';
import '../hint/ad_loading_modal.widget.dart';

import '../../providers/quiz.provider.dart';
import '../../advertising.dart';

class AdvertisingModal extends HookWidget {
  final int quizId;

  AdvertisingModal(this.quizId);

  void _setOpeningNumber(int quizNumber, BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('openingNumber', quizNumber);
    context.read(openingNumberProvider).state = quizNumber;
  }

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
    final loaded = useState(false);
    final nowLoading = useState(false);

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
                '問題を開放できませんでした。',
                true,
              );
            },
          ),
        },
        onApplicationExit: (Ad ad) => print('ユーザーがアプリを離れました。'),
        onRewardedAdUserEarnedReward: (RewardedAd ad, RewardItem reward) => {
          ad.dispose(),
          print('報酬を獲得しました: $reward'),
          _setOpeningNumber(quizId, context),
          Navigator.pop(context),
          Navigator.pop(context),
          showDialog<int>(
            context: context,
            barrierDismissible: true,
            builder: (BuildContext context) {
              return ReplyModal(
                '新たな問題を取得しました。',
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
              '短い動画を見て次の問題を取得しますか？',
              style: TextStyle(
                fontSize: 22.0,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 15,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () => {
                    soundEffect.play('sounds/cancel.mp3', isNotification: true),
                    Navigator.pop(context)
                  },
                  child: const Text('見ん'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red[500],
                    textStyle: Theme.of(context).textTheme.button,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                ElevatedButton(
                  child: const Text('見てやる'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue[700],
                    textStyle: Theme.of(context).textTheme.button,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () async => {
                    soundEffect.play('sounds/tap.mp3', isNotification: true),
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
                        Navigator.pop(context),
                        showDialog<int>(
                          context: context,
                          barrierDismissible: true,
                          builder: (BuildContext context) {
                            return ReplyModal(
                              '問題の開放に失敗しました。\n再度お試しください。',
                              false,
                            );
                          },
                        ),
                      },
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

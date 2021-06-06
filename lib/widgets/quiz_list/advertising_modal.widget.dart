import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

import 'dart:async';

import '../replry_modal.widget.dart';
import '../hint/ad_loading_modal.widget.dart';

import '../../providers/quiz.provider.dart';
import '../../advertising.dart';

class AdvertisingModal extends HookWidget {
  final int quizId;

  AdvertisingModal(this.quizId);

  void _setOpeningNumber(int quizNumber, BuildContext context) async {
    int openQuizNumber = (quizNumber / 3).ceil() * 3;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('openingNumber', openQuizNumber);
    context.read(openingNumberProvider).state = openQuizNumber;
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
    final loaded = useState(false);
    final nowLoading = useState(false);

    final rewardAd = RewardedAd(
      adUnitId: ANDROID_OPEN_QUESTION_REWQRD_ADVID,
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
          AwesomeDialog(
            context: context,
            dialogType: DialogType.ERROR,
            headerAnimationLoop: false,
            animType: AnimType.SCALE,
            body: ReplyModal(
              '問題を手に入れられませんでした。',
            ),
          )..show(),
        },
        onApplicationExit: (Ad ad) => print('ユーザーがアプリを離れました。'),
        onRewardedAdUserEarnedReward: (RewardedAd ad, RewardItem reward) => {
          ad.dispose(),
          print('報酬を獲得しました: $reward'),
          _setOpeningNumber(quizId, context),
          Navigator.pop(context),
          Navigator.pop(context),
          AwesomeDialog(
            context: context,
            dialogType: DialogType.SUCCES,
            headerAnimationLoop: false,
            animType: AnimType.SCALE,
            body: ReplyModal(
              '新たな問題で遊べるようになりました！',
            ),
          )..show(),
        },
      ),
    );

    return Padding(
      padding: const EdgeInsets.only(
        left: 20,
        right: 20,
        bottom: 15,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 10,
            ),
            child: Text(
              '短い動画を見て3つの問題を取得しますか？',
              style: TextStyle(
                fontSize: 20.0,
                fontFamily: 'SawarabiGothic',
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
                  onPressed: () => {
                    soundEffect.play('sounds/cancel.mp3', isNotification: true),
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
                  child: const Text('見る'),
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
                        rewardAd.show(),
                      }
                    else
                      {
                        Navigator.pop(context),
                        Navigator.pop(context),
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.ERROR,
                          headerAnimationLoop: false,
                          animType: AnimType.SCALE,
                          body: ReplyModal(
                            '動画の読み込みに失敗しました。\n再度お試しください。',
                          ),
                        )..show(),
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

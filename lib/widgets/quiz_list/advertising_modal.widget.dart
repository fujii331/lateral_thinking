import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

import 'dart:io';
import 'dart:async';

import '../replry_modal.widget.dart';
import '../hint/ad_loading_modal.widget.dart';

import '../../providers/quiz.provider.dart';
import '../../providers/common.provider.dart';

import '../../advertising.dart';
import '../../text.dart';

class AdvertisingModal extends HookWidget {
  final int quizId;

  AdvertisingModal(this.quizId);

  void _setOpeningNumber(
    int quizNumber,
    BuildContext context,
    bool enModeFlg,
  ) async {
    int openQuizNumber = quizNumber + 3;

    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (enModeFlg) {
      prefs.setInt('openingNumberEn', openQuizNumber);
    } else {
      prefs.setInt('openingNumber', openQuizNumber);
    }

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
    final bool enModeFlg = useProvider(enModeFlgProvider).state;
    final double seVolume = useProvider(seVolumeProvider).state;

    final rewardAd = RewardedAd(
      adUnitId: Platform.isAndroid
          ? ANDROID_OPEN_QUESTION_REWQRD_ADVID
          : IOS_OPEN_QUESTION_REWQRD_ADVID,
      // ? TEST_ANDROID_REWQRD_ADVID
      // : TEST_IOS_REWQRD_ADVID,
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
            width: MediaQuery.of(context).size.width * .86 > 650 ? 650 : null,
            body: ReplyModal(
              enModeFlg ? EN_TEXT['gotNoQuiz']! : JA_TEXT['gotNoQuiz']!,
              0,
            ),
          )..show(),
        },
        // onApplicationExit: (Ad ad) => print('ユーザーがアプリを離れました。'),
        onRewardedAdUserEarnedReward: (RewardedAd ad, RewardItem reward) => {
          // print('報酬を獲得しました: $reward'),
          _setOpeningNumber(
            quizId,
            context,
            enModeFlg,
          ),
          Navigator.pop(context),
          Navigator.pop(context),
          AwesomeDialog(
            context: context,
            dialogType: DialogType.SUCCES,
            headerAnimationLoop: false,
            animType: AnimType.SCALE,
            width: MediaQuery.of(context).size.width * .86 > 650 ? 650 : null,
            body: ReplyModal(
              enModeFlg ? EN_TEXT['gotQuiz']! : JA_TEXT['gotQuiz']!,
              quizId,
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
              enModeFlg ? EN_TEXT['getQuiz']! : JA_TEXT['getQuiz']!,
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
                    soundEffect.play(
                      'sounds/cancel.mp3',
                      isNotification: true,
                      volume: seVolume,
                    ),
                    Navigator.pop(context)
                  },
                  child: Text(
                    enModeFlg ? EN_TEXT['noButton']! : JA_TEXT['noButton']!,
                  ),
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
                  child: Text(
                    enModeFlg ? EN_TEXT['yesButton']! : JA_TEXT['yesButton']!,
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue.shade700,
                    textStyle: Theme.of(context).textTheme.button,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () async => {
                    soundEffect.play(
                      'sounds/tap.mp3',
                      isNotification: true,
                      volume: seVolume,
                    ),
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
                          width: MediaQuery.of(context).size.width * .86 > 650
                              ? 650
                              : null,
                          body: ReplyModal(
                            enModeFlg
                                ? EN_TEXT['failedToLoad']!
                                : JA_TEXT['failedToLoad']!,
                            0,
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

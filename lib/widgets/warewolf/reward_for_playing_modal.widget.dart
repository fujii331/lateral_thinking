import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:math';
import 'dart:io';
import 'dart:async';

import '../../providers/quiz.provider.dart';
import '../../providers/warewolf.provider.dart';

import '../../models/quiz.model.dart';

import '../../screens/warewolf_preparation.screen.dart';

import '../replry_modal.widget.dart';
import '../hint/ad_loading_modal.widget.dart';

import '../../advertising.dart';
import '../../text.dart';

class RewardForPlayingModal extends HookWidget {
  final Quiz quiz;

  RewardForPlayingModal(
    this.quiz,
  );

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
    final String peaceVillage = useProvider(peaceVillageProvider).state;
    final String numOfPlayers = useProvider(numOfPlayersProvider).state;

    final loaded = useState(false);
    final nowLoading = useState(false);

    void afterGotReward() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      context.read(alreadyAnsweredIdsProvider).state.add(quiz.id.toString());
      prefs.setStringList(
          'alreadyAnsweredIds', context.read(alreadyAnsweredIdsProvider).state);

      context.read(wolfIdProvider).state =
          peaceVillage == 'あり' && Random().nextInt(4) == 0
              ? 0
              : Random().nextInt(int.parse(numOfPlayers)) + 1;

      Navigator.of(context).pushNamed(
        WarewolfPreparationScreen.routeName,
        arguments: [
          quiz.sentence,
          quiz.answers[0].comment,
          1,
        ],
      );
    }

    ;

    final rewardAd = RewardedAd(
      adUnitId: Platform.isAndroid
          ? ANDROID_PLAYING_WAREWOLF_REWQRD_ADVID
          : IOS_PLAYING_WAREWOLF_REWQRD_ADVID,
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
              '動画が正常に終了しませんでした。',
              0,
            ),
          )..show(),
        },
        // onApplicationExit: (Ad ad) => print('ユーザーがアプリを離れました。'),
        onRewardedAdUserEarnedReward: (RewardedAd ad, RewardItem reward) => {
          // print('報酬を獲得しました: $reward'),
          Navigator.pop(context),
          Navigator.pop(context),
          afterGotReward(),
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
              '短い動画を見てゲームをプレイしますか？',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                fontFamily: 'SawarabiGothic',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 20,
            ),
            child: Text(
              'まだ一人用モードで正解していない問題は動画を見ることで遊ぶことができます。',
              style: TextStyle(
                fontSize: 18.0,
                fontFamily: 'SawarabiGothic',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 10,
            ),
            child: Text(
              '※一人用モードで正解するか、一度動画を見たら何度でも遊ぶことができます。',
              style: TextStyle(
                fontSize: 16.0,
                fontFamily: 'SawarabiGothic',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 15,
            ),
            child: Wrap(
              children: [
                ElevatedButton(
                  onPressed: () => {
                    soundEffect.play('sounds/cancel.mp3', isNotification: true),
                    Navigator.pop(context)
                  },
                  child: Text(JA_TEXT['noButton']!),
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
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.ERROR,
                          headerAnimationLoop: false,
                          animType: AnimType.SCALE,
                          width: MediaQuery.of(context).size.width * .86 > 650
                              ? 650
                              : null,
                          body: ReplyModal(
                            JA_TEXT['failedToLoad']!,
                            0,
                          ),
                        )..show(),
                      },
                  },
                  child: Text(
                    JA_TEXT['yesButton']!,
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.only(
                      right: 14,
                      left: 14,
                    ),
                    primary: Colors.blue.shade700,
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

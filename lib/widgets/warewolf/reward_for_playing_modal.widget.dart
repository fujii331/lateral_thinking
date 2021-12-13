import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:io';
import 'dart:async';

import '../../providers/quiz.provider.dart';
import '../../providers/common.provider.dart';

import '../../models/quiz.model.dart';

import '../../screens/warewolf_preparation_first.screen.dart';

import '../reply_modal.widget.dart';
import '../hint/ad_loading_modal.widget.dart';

import '../../advertising.dart';
import '../../text.dart';

class RewardForPlayingModal extends HookWidget {
  final Quiz quiz;

  RewardForPlayingModal(
    this.quiz,
  );

  void _createRewardedAd(
    ValueNotifier<RewardedAd?> rewardedAd,
    int _numRewardedLoadAttempts,
  ) {
    RewardedAd.load(
      adUnitId: Platform.isAndroid
          ? ANDROID_PLAYING_WAREWOLF_REWQRD_ADVID
          : IOS_PLAYING_WAREWOLF_REWQRD_ADVID,
      // ? TEST_ANDROID_REWQRD_ADVID
      // : TEST_IOS_REWQRD_ADVID, //RewardedAd.testAdUnitId,
      request: AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          rewardedAd.value = ad;
          _numRewardedLoadAttempts = 0;
        },
        onAdFailedToLoad: (LoadAdError error) {
          rewardedAd.value = null;
          _numRewardedLoadAttempts += 1;
          if (_numRewardedLoadAttempts <= 3) {
            _createRewardedAd(
              rewardedAd,
              _numRewardedLoadAttempts,
            );
          }
        },
      ),
    );
  }

  Future loading(
    BuildContext context,
    ValueNotifier<RewardedAd?> rewardedAd,
    ValueNotifier nowLoading,
  ) async {
    int _numRewardedLoadAttempts = 0;
    nowLoading.value = true;
    _createRewardedAd(
      rewardedAd,
      _numRewardedLoadAttempts,
    );
    for (int i = 0; i < 15; i++) {
      if (rewardedAd.value != null) {
        break;
      }
      await new Future.delayed(new Duration(seconds: 1));
    }
    nowLoading.value = false;
  }

  void afterGotReward(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    context.read(alreadyAnsweredIdsProvider).state.add(quiz.id.toString());
    prefs.setStringList(
        'alreadyAnsweredIds', context.read(alreadyAnsweredIdsProvider).state);

    Navigator.of(context).pushNamed(
      WarewolfPreparationFirstScreen.routeName,
      arguments: [
        quiz.sentence,
        quiz.answers[0].comment,
      ],
    );
  }

  void _showRewardedAd(
    BuildContext context,
    RewardedAd? rewardAdValue,
  ) {
    if (rewardAdValue == null) {
      return;
    }
    rewardAdValue.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        ad.dispose();
      },
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
        ad.dispose();
        Navigator.pop(context);
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
        )..show();
      },
    );

    rewardAdValue.setImmersiveMode(true);
    rewardAdValue.show(onUserEarnedReward: (RewardedAd ad, RewardItem reward) {
      Navigator.pop(context);
      afterGotReward(context);
    });
    rewardAdValue = null;
  }

  @override
  Widget build(BuildContext context) {
    final AudioCache soundEffect = useProvider(soundEffectProvider).state;
    final double seVolume = useProvider(seVolumeProvider).state;

    final nowLoading = useState(false);

    final ValueNotifier<RewardedAd?> rewardedAd = useState(null);

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
              '短い動画を見てゲームを始めますか？',
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
              '※正解するか一度動画を見たら何度でもプレイ可能',
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
                    soundEffect.play(
                      'sounds/cancel.mp3',
                      isNotification: true,
                      volume: seVolume,
                    ),
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
                    await loading(
                      context,
                      rewardedAd,
                      nowLoading,
                    ),
                    if (rewardedAd.value != null)
                      {
                        _showRewardedAd(
                          context,
                          rewardedAd.value,
                        ),
                        Navigator.pop(context),
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

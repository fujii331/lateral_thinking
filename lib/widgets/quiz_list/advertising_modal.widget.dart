import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lateral_thinking/services/admob/reward_action.service.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

import '../reply_modal.widget.dart';
import '../hint/ad_loading_modal.widget.dart';

import '../../providers/quiz.provider.dart';
import '../../providers/common.provider.dart';

import '../../text.dart';

class AdvertisingModal extends HookWidget {
  final int quizId;
  final BuildContext screenContext;

  const AdvertisingModal({
    Key? key,
    required this.quizId,
    required this.screenContext,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AudioCache soundEffect = useProvider(soundEffectProvider).state;
    final nowLoading = useState(false);
    final bool enModeFlg = useProvider(enModeFlgProvider).state;
    final double seVolume = useProvider(seVolumeProvider).state;

    final ValueNotifier<RewardedAd?> rewardedAd = useState(null);

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
                  onPressed: () async {
                    soundEffect.play(
                      'sounds/tap.mp3',
                      isNotification: true,
                      volume: seVolume,
                    );
                    showDialog<int>(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return AdLoadingModal();
                      },
                    );
                    // 広告のロード
                    await rewardLoading(
                      rewardedAd,
                      1,
                    );
                    if (rewardedAd.value != null) {
                      showNewQuestionsRewardedAd(
                        screenContext,
                        rewardedAd,
                        enModeFlg,
                      );
                      Navigator.pop(context);
                      Navigator.pop(context);
                    } else {
                      Navigator.pop(context);

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
                      ).show();
                    }
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

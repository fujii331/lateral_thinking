import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:lateral_thinking/services/admob/reward_action.service.dart';

import '../../providers/quiz.provider.dart';
import '../../providers/common.provider.dart';

import '../reply_modal.widget.dart';
import './ad_loading_modal.widget.dart';

import '../../text.dart';

class SubHintModal extends HookWidget {
  final BuildContext screenContext;
  final List<String> subHints;
  final int quizId;

  const SubHintModal({
    Key? key,
    required this.screenContext,
    required this.subHints,
    required this.quizId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AudioCache soundEffect = useProvider(soundEffectProvider).state;
    final bool enModeFlg = useProvider(enModeFlgProvider).state;
    final double seVolume = useProvider(seVolumeProvider).state;

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
              enModeFlg
                  ? quizId == 1
                      ? EN_TEXT['getSubHintHeaderFirst']!
                      : EN_TEXT['getSubHintHeader']!
                  : quizId == 1
                      ? JA_TEXT['getSubHintHeaderFirst']!
                      : JA_TEXT['getSubHintHeader']!,
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
              enModeFlg ? EN_TEXT['getSubHint']! : JA_TEXT['getSubHint']!,
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
              enModeFlg ? EN_TEXT['getSubHint2']! : JA_TEXT['getSubHint2']!,
              style: TextStyle(
                fontSize: 16.0,
                fontFamily: 'SawarabiGothic',
              ),
            ),
          ),
          quizId == 1
              ? Container(
                  child: Text(
                    enModeFlg
                        ? EN_TEXT['getSubHintFirst']!
                        : JA_TEXT['getSubHintFirst']!,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontFamily: 'SawarabiGothic',
                      color: Colors.orange.shade900,
                    ),
                  ),
                )
              : Container(),
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
                  child: Text(
                      enModeFlg ? EN_TEXT['noButton']! : JA_TEXT['noButton']!),
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
                  onPressed: quizId == 1
                      ? () {
                          soundEffect.play(
                            'sounds/tap.mp3',
                            isNotification: true,
                            volume: seVolume,
                          );
                          Navigator.pop(context);
                          afterGotSubHint(
                            context,
                            subHints,
                          );
                        }
                      : () async {
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
                            2,
                          );
                          if (rewardedAd.value != null) {
                            showSubHintRewardedAd(
                              screenContext,
                              rewardedAd,
                              subHints,
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
                              width:
                                  MediaQuery.of(context).size.width * .86 > 650
                                      ? 650
                                      : null,
                              body: ReplyModal(
                                enModeFlg
                                    ? EN_TEXT['failedToLoad']!
                                    : JA_TEXT['failedToLoad']!,
                                0,
                              ),
                            )..show();
                          }
                        },
                  child: Text(
                    enModeFlg ? EN_TEXT['yesButton']! : JA_TEXT['yesButton']!,
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

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

import '../../models/quiz.model.dart';
import '../../text.dart';

class HintModal extends HookWidget {
  final BuildContext screenContext;
  final Quiz quiz;
  final TextEditingController subjectController;
  final TextEditingController relatedWordController;
  final int workHintValue;

  const HintModal({
    Key? key,
    required this.screenContext,
    required this.quiz,
    required this.subjectController,
    required this.relatedWordController,
    required this.workHintValue,
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
                  ? workHintValue < 3
                      ? (quiz.id == 1
                              ? EN_TEXT['getHintPrefixFirst']!
                              : EN_TEXT['getHintPrefix']!) +
                          (workHintValue + 1).toString() +
                          EN_TEXT['getHintSuffix']!
                      : EN_TEXT['noHintExist']!
                  : workHintValue < 3
                      ? (quiz.id == 1
                              ? JA_TEXT['getHintPrefixFirst']!
                              : JA_TEXT['getHintPrefix']!) +
                          (workHintValue + 1).toString() +
                          JA_TEXT['getHintSuffix']!
                      : JA_TEXT['noHintExist']!,
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
                  workHintValue < 1
                      ? Icons.looks_one_outlined
                      : Icons.looks_one,
                  size: 45,
                ),
                Icon(
                  workHintValue < 2
                      ? Icons.looks_two_outlined
                      : Icons.looks_two,
                  size: 45,
                ),
                Icon(
                  workHintValue < 3 ? Icons.looks_3_outlined : Icons.looks_3,
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
                workHintValue < 1
                    ? enModeFlg
                        ? EN_TEXT['getHint1Helper']!
                        : JA_TEXT['getHint1Helper']!
                    : workHintValue == 1
                        ? enModeFlg
                            ? EN_TEXT['getHint2']!
                            : JA_TEXT['getHint2']!
                        : workHintValue == 2
                            ? enModeFlg
                                ? EN_TEXT['getHint3']!
                                : JA_TEXT['getHint3']!
                            : enModeFlg
                                ? EN_TEXT['gotAllHint']!
                                : JA_TEXT['gotAllHint']!,
                style: TextStyle(
                  fontSize: 18.0,
                  fontFamily: 'SawarabiGothic',
                ),
              ),
            ),
          ),
          quiz.id == 1 && workHintValue < 3
              ? Container(
                  child: Text(
                    enModeFlg
                        ? EN_TEXT['getHintFirst']!
                        : JA_TEXT['getHintFirst']!,
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
                  onPressed: workHintValue < 3
                      ? quiz.id == 1
                          ? () {
                              soundEffect.play(
                                'sounds/tap.mp3',
                                isNotification: true,
                                volume: seVolume,
                              );
                              Navigator.pop(context);
                              afterGotHint(
                                screenContext,
                                quiz,
                                subjectController,
                                relatedWordController,
                                enModeFlg,
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
                                showHintRewardedAd(
                                  screenContext,
                                  rewardedAd,
                                  quiz,
                                  subjectController,
                                  relatedWordController,
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
                                      MediaQuery.of(context).size.width * .86 >
                                              650
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
                            }
                      : () {},
                  child: Text(
                    enModeFlg ? EN_TEXT['yesButton']! : JA_TEXT['yesButton']!,
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.only(
                      right: 14,
                      left: 14,
                    ),
                    primary: workHintValue < 3
                        ? Colors.blue.shade700
                        : Colors.blue[300],
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

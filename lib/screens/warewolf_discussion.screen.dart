import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:intl/intl.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'dart:async';

import '../providers/quiz.provider.dart';
import '../providers/warewolf.provider.dart';
import '../widgets/background.widget.dart';
import '../widgets/warewolf/confirm_discussioned_modal.widget.dart';
import '../widgets/warewolf/ready_modal.widget.dart';

class WarewolfDiscussionScreen extends HookWidget {
  static const routeName = '/warewolf-discussion';

  @override
  Widget build(BuildContext context) {
    final AudioCache soundEffect = useProvider(soundEffectProvider).state;

    final discussionTime = useProvider(discussionTimeProvider).state;
    final peaceVillage = useProvider(peaceVillageProvider).state;

    final finishFlg = useState<bool>(false);
    final timeStopFlg = useState<bool>(false);

    final time =
        useState<DateTime>(DateTime(2020, 1, 1, 1, int.parse(discussionTime)));

    void timeStart(
      BuildContext context,
      ValueNotifier<DateTime> time,
      ValueNotifier<bool> timeStopFlg,
      ValueNotifier<bool> finishFlg,
      AudioCache soundEffect,
    ) {
      Timer.periodic(
        Duration(seconds: 1),
        (Timer timer) async {
          if (timer.isActive && finishFlg.value) {
            timer.cancel();
          } else if (!timeStopFlg.value) {
            time.value = time.value.add(
              Duration(
                seconds: -1,
              ),
            );
            if (timer.isActive &&
                DateFormat('mm:ss').format(time.value) == '00:00') {
              timeStopFlg.value = true;
              soundEffect.play('sounds/finish.mp3', isNotification: true);
              await new Future.delayed(
                new Duration(milliseconds: 1000),
              );
              AwesomeDialog(
                context: context,
                dialogType: DialogType.NO_HEADER,
                headerAnimationLoop: false,
                dismissOnTouchOutside: false,
                dismissOnBackKeyPress: false,
                animType: AnimType.SCALE,
                width:
                    MediaQuery.of(context).size.width * .86 > 500 ? 500 : null,
                body: ConfirmDiscussionedModal(
                  true,
                  timeStopFlg,
                  time,
                  finishFlg,
                ),
              )..show();
            }
          }
        },
      );
    }

    useEffect(() {
      WidgetsBinding.instance!.addPostFrameCallback((_) async {
        await showDialog<int>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return ReadyModal();
          },
        );
        await new Future.delayed(
          new Duration(milliseconds: 3000),
        );
        Navigator.pop(context);
        await new Future.delayed(
          new Duration(milliseconds: 500),
        );
        timeStart(
          context,
          time,
          timeStopFlg,
          finishFlg,
          soundEffect,
        );
      });
      return null;
    }, const []);

    return Scaffold(
      body: Stack(
        children: <Widget>[
          background(),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  '残り時間',
                  style: TextStyle(
                    color: Colors.yellow.shade300,
                    fontSize: 26,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 20,
                  ),
                  child: Text(
                    DateFormat('mm:ss').format(time.value),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 10.0,
                  ),
                  child: Image.asset(
                    'assets/images/discussion.png',
                    height: 250,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 20,
                  ),
                  child: Text(
                    '平和村：' + peaceVillage,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 15.0,
                  ),
                  child: ElevatedButton(
                    child: Text(
                      '会議を終わる',
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue,
                      textStyle: Theme.of(context).textTheme.button,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: timeStopFlg.value
                        ? () {}
                        : () {
                            soundEffect.play('sounds/tap.mp3',
                                isNotification: true);

                            timeStopFlg.value = true;

                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.NO_HEADER,
                              headerAnimationLoop: false,
                              dismissOnTouchOutside: false,
                              dismissOnBackKeyPress: false,
                              animType: AnimType.SCALE,
                              width:
                                  MediaQuery.of(context).size.width * .86 > 500
                                      ? 500
                                      : null,
                              body: ConfirmDiscussionedModal(
                                false,
                                timeStopFlg,
                                time,
                                finishFlg,
                              ),
                            )..show();
                          },
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

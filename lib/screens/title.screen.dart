import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:lottie/lottie.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:io';

import './quiz_list.screen.dart';
import './lecture_tab.screen.dart';
import './warewolf_setting.screen.dart';
import '../providers/quiz.provider.dart';
import '../providers/common.provider.dart';
import '../providers/warewolf.provider.dart';

import '../text.dart';
import '../widgets/settings/sound_mode_modal.widget.dart';
import '../should_update.service.dart';
import '../widgets/update_version_modal.widget.dart';
import './warewolf_lecture.screen.dart';

class TitleScreen extends HookWidget {
  void toQuizList(BuildContext ctx) {
    Navigator.of(ctx).pushNamed(
      QuizListScreen.routeName,
      arguments: true,
    );
  }

  void toLectureTab(BuildContext ctx) {
    Navigator.of(ctx).pushNamed(
      LectureTabScreen.routeName,
      arguments: false,
    );
  }

  void toSoundModeModal(BuildContext context) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.NO_HEADER,
      headerAnimationLoop: false,
      animType: AnimType.SCALE,
      width: MediaQuery.of(context).size.width * .86 > 650 ? 650 : null,
      body: SoundModeModal(),
    )..show();
  }

  void toWarewolfSettingTab(BuildContext ctx) {
    Navigator.of(ctx).pushNamed(
      WarewolfSettingScreen.routeName,
      arguments: 1,
    );
  }

  void toWarewolfLectureTab(BuildContext ctx) {
    Navigator.of(ctx).pushNamed(
      WarewolfLectureScreen.routeName,
      arguments: false,
    );
  }

  void _firstSetting(BuildContext context, bool enModeFlg) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (enModeFlg) {
      context.read(openingNumberProvider).state =
          prefs.getInt('openingNumberEn') ?? 9;
    } else {
      context.read(openingNumberProvider).state =
          prefs.getInt('openingNumber') ?? 9;
    }

    // 音量設定
    final double? bgmVolume = prefs.getDouble('bgmVolume');
    final double? seVolume = prefs.getDouble('seVolume');
    final bool alreadyPlayeFlg = prefs.getInt('openingNumber') != null;

    if (bgmVolume != null) {
      context.read(bgmVolumeProvider).state = bgmVolume;
    } else {
      prefs.setDouble('bgmVolume', 0.2);
    }
    if (seVolume != null) {
      context.read(seVolumeProvider).state = seVolume;
    } else {
      prefs.setDouble('seVolume', 0.5);
    }

    context
        .read(bgmProvider)
        .state
        .setVolume(context.read(bgmVolumeProvider).state);

    context.read(soundEffectProvider).state.loadAll([
      'sounds/correct_answer.mp3',
      'sounds/tap.mp3',
      'sounds/cancel.mp3',
      'sounds/quiz_button.mp3',
      'sounds/hint.mp3',
      'sounds/change.mp3',
      'sounds/congraturation.mp3',
      'sounds/fault.mp3',
      'sounds/finish.mp3',
      'sounds/funny.mp3',
      'sounds/push.mp3',
      'sounds/ready.mp3',
      'sounds/start.mp3',
      'sounds/think.mp3',
      'sounds/wrong_answer.mp3',
    ]);

    // 遊び方に誘導するかの判定
    final bool? alreadyPlayedQuiz = prefs.getBool('alreadyPlayedQuiz');
    final bool? alreadyPlayedWarewolf = prefs.getBool('alreadyPlayedWarewolf');

    if (alreadyPlayedQuiz != null || alreadyPlayeFlg) {
      context.read(alreadyPlayedQuizFlgProvider).state = true;
    }
    if (alreadyPlayedWarewolf != null) {
      context.read(alreadyPlayedWarewolfFlgProvider).state = true;
    }

    // お助けモードの設定
    context.read(helperModeFlgProvider).state =
        prefs.getBool('helperModeFlg') ?? true;

    // 入力時設定
    context.read(displayInputFlgProvider).state =
        prefs.getBool('displayInputFlg') ?? false;

    // 正解済みの問題を設定
    if (prefs.getStringList('alreadyAnsweredIds') == null) {
      if (alreadyPlayeFlg) {
        // openingNumberの数だけループして詰める
        List<String> answerIds = [];
        for (var i = 1; i <= prefs.getInt('openingNumber')!; i++) {
          answerIds.add(i.toString());
        }
        prefs.setStringList('alreadyAnsweredIds', answerIds);
      } else {
        prefs.setStringList('alreadyAnsweredIds', ['1']);
      }
    }
    context.read(alreadyAnsweredIdsProvider).state =
        prefs.getStringList('alreadyAnsweredIds')!;
  }

  @override
  Widget build(BuildContext context) {
    final AudioCache soundEffect = useProvider(soundEffectProvider).state;
    final height = MediaQuery.of(context).size.height;
    final bool enModeFlg = useProvider(enModeFlgProvider).state;
    final double seVolume = useProvider(seVolumeProvider).state;

    final bool alreadyPlayedQuizFlg =
        useProvider(alreadyPlayedQuizFlgProvider).state;
    final bool alreadyPlayedWarewolfFlg =
        useProvider(alreadyPlayedWarewolfFlgProvider).state;

    useEffect(() {
      WidgetsBinding.instance!.addPostFrameCallback((_) async {
        if (Localizations.localeOf(context).toString() == 'ja') {
          context.read(enModeFlgProvider).state = false;
        }
        if (await shouldUpdate()) {
          soundEffect.play(
            'sounds/hint.mp3',
            isNotification: true,
            volume: context.read(seVolumeProvider).state,
          );
          AwesomeDialog(
            context: context,
            dialogType: DialogType.INFO_REVERSED,
            headerAnimationLoop: false,
            animType: AnimType.BOTTOMSLIDE,
            width: MediaQuery.of(context).size.width * .86 > 650 ? 650 : null,
            dismissOnTouchOutside: false,
            dismissOnBackKeyPress: false,
            body: UpdateVersionModal(),
          )..show();
        }
      });
      return null;
    }, const []);

    _firstSetting(context, enModeFlg);

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/title_back.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Lottie.asset('assets/lottie/night.json'),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Lottie.asset('assets/lottie/castle.json'),
            ),
          ),
          Column(
            children: [
              Row(
                children: [
                  SizedBox(),
                  Spacer(),
                  Padding(
                    padding: EdgeInsets.only(
                      right: Platform.isAndroid ? 20 : 20,
                      top: Platform.isAndroid ? 40 : 55,
                    ),
                    child: Container(
                      width: 85,
                      child: ElevatedButton.icon(
                        icon: Icon(
                          enModeFlg ? Icons.switch_right : Icons.switch_left,
                          size: 20,
                        ),
                        onPressed: () {
                          soundEffect.play(
                            'sounds/change.mp3',
                            isNotification: true,
                            volume: seVolume,
                          );
                          context.read(enModeFlgProvider).state = !enModeFlg;
                          context.read(playingQuizIdProvider).state = 0;
                        },
                        label: Text(
                          enModeFlg ? 'EN' : 'JP',
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'YuseiMagic',
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: enModeFlg
                              ? Colors.orange.shade700
                              : Colors.blue.shade700,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 5,
                          ),
                          textStyle: Theme.of(context).textTheme.button,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          side: const BorderSide(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Spacer(),
              Row(
                children: [
                  SizedBox(),
                  Spacer(),
                  Padding(
                    padding: EdgeInsets.only(
                      right: Platform.isAndroid ? 10 : 15,
                      bottom: Platform.isAndroid ? 10 : 20,
                    ),
                    child: Text(
                      'Arun Sajeev, jk kim @LottieFiles',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  enModeFlg ? EN_TEXT['title']! : JA_TEXT['title']!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    height: 1.2,
                    fontSize: enModeFlg
                        ? 38
                        : height > 610
                            ? 48
                            : 41,
                    fontFamily: 'YuseiMagic',
                    color: Colors.yellow.shade200,
                  ),
                ),
                Text(
                  enModeFlg ? EN_TEXT['subTitle']! : JA_TEXT['subTitle']!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: enModeFlg ? Colors.white : Colors.blue.shade200,
                    fontSize: enModeFlg
                        ? 23
                        : height > 610
                            ? 24
                            : 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                enModeFlg
                    ? Container()
                    : Text(
                        '水平思考人狼',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.blueGrey.shade100,
                          fontSize: height > 610 ? 24 : 21,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                enModeFlg
                    ? Padding(
                        padding: EdgeInsets.only(
                          top: height > 610 ? 170 : 110,
                          bottom: 30,
                        ),
                        child: Column(
                          children: [
                            _selectButton(
                              context,
                              EN_TEXT['playButton']!,
                              Colors.lightBlue.shade500,
                              Icon(Icons.account_balance),
                              soundEffect,
                              1,
                              seVolume,
                              alreadyPlayedQuizFlg,
                            ),
                            _selectButton(
                              context,
                              'Sounds',
                              Colors.lime.shade700,
                              Icon(Icons.settings_rounded),
                              soundEffect,
                              3,
                              seVolume,
                              true,
                            ),
                          ],
                        ),
                      )
                    : Padding(
                        padding: EdgeInsets.only(top: height > 610 ? 150 : 90),
                        child: Column(
                          children: [
                            _selectButton(
                              context,
                              '一人水平思考',
                              Colors.lightBlue.shade500,
                              Icon(Icons.account_balance),
                              soundEffect,
                              1,
                              seVolume,
                              alreadyPlayedQuizFlg,
                            ),
                            _selectButton(
                              context,
                              '水平思考人狼',
                              Colors.blueGrey.shade600,
                              Icon(Icons.theater_comedy_outlined),
                              soundEffect,
                              2,
                              seVolume,
                              alreadyPlayedWarewolfFlg,
                            ),
                            _selectButton(
                                context,
                                '音量設定',
                                Colors.lime.shade700,
                                Icon(Icons.volume_up),
                                soundEffect,
                                3,
                                seVolume,
                                true),
                          ],
                        ),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _selectButton(
    BuildContext context,
    String text,
    Color color,
    Icon icon,
    AudioCache soundEffect,
    int buttonPuttern,
    double seVolume,
    bool alreadyPlayedFlg,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
      ),
      width: 190,
      child: SizedBox(
        height: 40,
        child: ElevatedButton.icon(
          icon: icon,
          onPressed: () async {
            soundEffect.play(
              'sounds/tap.mp3',
              isNotification: true,
              volume: seVolume,
            );
            if (buttonPuttern == 1) {
              if (alreadyPlayedFlg) {
                toQuizList(context);
              } else {
                toLectureTab(context);
              }
            } else if (buttonPuttern == 2) {
              if (alreadyPlayedFlg) {
                toWarewolfSettingTab(context);
              } else {
                toWarewolfLectureTab(context);
              }
            } else if (buttonPuttern == 3) {
              toSoundModeModal(context);
            }
          },
          label: Text(text),
          style: ElevatedButton.styleFrom(
            elevation: 8, // 影をつける
            shadowColor: Colors.black,
            primary: color,
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 5,
            ),
            textStyle: Theme.of(context).textTheme.button,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            side: const BorderSide(),
          ),
        ),
      ),
    );
  }
}

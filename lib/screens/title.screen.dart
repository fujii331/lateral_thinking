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
import '../providers/quiz.provider.dart';
import '../text.dart';
import '../widgets/mode_modal.widget.dart';
import '../should_update.service.dart';
import '../widgets/update_version_modal.widget.dart';

class TitleScreen extends HookWidget {
  void toQuizList(BuildContext ctx) {
    Navigator.of(ctx).pushNamed(
      QuizListScreen.routeName,
    );
  }

  void toLectureTab(BuildContext ctx) {
    Navigator.of(ctx).pushNamed(
      LectureTabScreen.routeName,
    );
  }

  void toModeModal(BuildContext context) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.NO_HEADER,
      headerAnimationLoop: false,
      animType: AnimType.SCALE,
      width: MediaQuery.of(context).size.width * .86 > 650 ? 650 : null,
      body: ModeModal(),
    )..show();
  }

  @override
  Widget build(BuildContext context) {
    final AudioCache soundEffect = useProvider(soundEffectProvider).state;
    final height = MediaQuery.of(context).size.height;
    final bool enModeFlg = useProvider(enModeFlgProvider).state;

    useEffect(() {
      WidgetsBinding.instance!.addPostFrameCallback((_) async {
        if (Localizations.localeOf(context).toString() == 'ja') {
          context.read(enModeFlgProvider).state = false;
        }
        if (await shouldUpdate()) {
          soundEffect.play('sounds/hint.mp3', isNotification: true);
          AwesomeDialog(
            context: context,
            dialogType: DialogType.INFO_REVERSED,
            headerAnimationLoop: false,
            animType: AnimType.BOTTOMSLIDE,
            width: MediaQuery.of(context).size.width * .86 > 650 ? 650 : null,
            dismissOnTouchOutside: false,
            body: UpdateVersionModal(),
          )..show();
        }
        SharedPreferences prefs = await SharedPreferences.getInstance();
        context.read(helperModeFlgProvider).state =
            prefs.getBool('helperModeFlg') ?? false;
      });
      return null;
    }, const []);

    // 初回起動時しか通らないのでload
    soundEffect.loadAll([
      'sounds/correct_answer.mp3',
      'sounds/tap.mp3',
      'sounds/change.mp3',
      'sounds/cancel.mp3',
      'sounds/quiz_button.mp3',
      'sounds/hint.mp3',
    ]);

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
                          soundEffect.play('sounds/change.mp3',
                              isNotification: true);
                          context.read(enModeFlgProvider).state = !enModeFlg;
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
                    color: Colors.white,
                    fontSize: enModeFlg
                        ? 23
                        : height > 610
                            ? 25
                            : 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: height > 610 ? 150 : 90),
                  child: Column(
                    children: [
                      _selectButton(
                        context,
                        enModeFlg
                            ? EN_TEXT['playButton']!
                            : JA_TEXT['playButton']!,
                        Colors.lightBlue.shade500,
                        Icon(Icons.account_balance),
                        soundEffect,
                        1,
                      ),
                      _selectButton(
                        context,
                        enModeFlg
                            ? EN_TEXT['playMethodButton']!
                            : JA_TEXT['playMethodButton']!,
                        Colors.teal,
                        Icon(Icons.auto_stories),
                        soundEffect,
                        2,
                      ),
                      _selectButton(
                        context,
                        enModeFlg
                            ? EN_TEXT['modeButton']!
                            : JA_TEXT['modeButton']!,
                        Colors.lime.shade700,
                        Icon(Icons.settings_rounded),
                        soundEffect,
                        3,
                      ),
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
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
      ),
      child: SizedBox(
        height: 40,
        child: ElevatedButton.icon(
          icon: icon,
          onPressed: () => {
            soundEffect.play('sounds/tap.mp3', isNotification: true),
            if (buttonPuttern == 1)
              {
                toQuizList(context),
              }
            else if (buttonPuttern == 2)
              {
                toLectureTab(context),
              }
            else
              {
                toModeModal(context),
              },
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

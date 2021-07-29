import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';

import '../providers/quiz.provider.dart';
import '../providers/warewolf.provider.dart';

import '../widgets/background.widget.dart';
import './warewolf_playing.screen.dart';

class WarewolfPreparationScreen extends HookWidget {
  static const routeName = '/warewolf-preparation';

  @override
  Widget build(BuildContext context) {
    final List args = ModalRoute.of(context)?.settings.arguments as List;
    final sentence = args[0];
    final correctAnswer = args[1];
    final playerId = args[2];

    final int wolfId = useProvider(wolfIdProvider).state;

    final wolfFlg = wolfId == playerId ? true : false;

    final player = playerId == 1
        ? useProvider(player1Provider).state
        : playerId == 2
            ? useProvider(player2Provider).state
            : playerId == 3
                ? useProvider(player3Provider).state
                : playerId == 4
                    ? useProvider(player4Provider).state
                    : playerId == 5
                        ? useProvider(player5Provider).state
                        : useProvider(player6Provider).state;

    final AudioCache soundEffect = useProvider(soundEffectProvider).state;
    final numOfPlayers = useProvider(numOfPlayersProvider).state;

    final confirmFlg = useState<bool>(true);
    final display1Flg = useState<bool>(false);
    final display2Flg = useState<bool>(false);
    final display3Flg = useState<bool>(false);

    final height = MediaQuery.of(context).size.height;
    final fontSize = height * .35 > 230 ? 17.0 : 15.5;
    final fontHeight = height * .35 > 230 ? 1.7 : 1.6;
    final widthSetting = MediaQuery.of(context).size.width * .95 > 650.0
        ? 650.0
        : MediaQuery.of(context).size.width * .95;

    return Scaffold(
      body: Stack(
        children: <Widget>[
          background(),
          AnimatedOpacity(
            duration: const Duration(milliseconds: 500),
            opacity: display2Flg.value ? 1 : 0,
            child: Center(
              child: Opacity(
                opacity: 0.5,
                child: Image.asset(
                  wolfFlg
                      ? 'assets/images/warewolf.png'
                      : 'assets/images/citizen.png',
                  width: MediaQuery.of(context).size.width * .6,
                ),
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: confirmFlg.value
                  ? AnimatedOpacity(
                      duration: const Duration(milliseconds: 500),
                      opacity: confirmFlg.value ? 1 : 0,
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                            ),
                            width: double.infinity,
                            child: Text(
                              'あなたは',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                              ),
                            ),
                          ),
                          Text(
                            player.name,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.green.shade100,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                            ),
                            width: double.infinity,
                            child: Text(
                              'ですか？',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 50,
                            ),
                            child: SizedBox(
                              height: 50,
                              child: ElevatedButton(
                                onPressed: confirmFlg.value
                                    ? () async {
                                        soundEffect.play('sounds/tap.mp3',
                                            isNotification: true);
                                        confirmFlg.value = false;
                                        await new Future.delayed(
                                          new Duration(milliseconds: 500),
                                        );
                                        display1Flg.value = true;
                                        await new Future.delayed(
                                          new Duration(milliseconds: 1000),
                                        );
                                        display2Flg.value = true;
                                        await new Future.delayed(
                                          new Duration(milliseconds: 1000),
                                        );
                                        display3Flg.value = true;
                                      }
                                    : () {},
                                child: Text(
                                  '役職・問題を確認',
                                ),
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.blue,
                                  textStyle: Theme.of(context).textTheme.button,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(
                        left: 10,
                        right: 10,
                        top: 30,
                        bottom: 20,
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AnimatedOpacity(
                                duration: const Duration(milliseconds: 500),
                                opacity: display1Flg.value ? 1 : 0,
                                child: Text(
                                  '役職：',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                  ),
                                ),
                              ),
                              AnimatedOpacity(
                                duration: const Duration(milliseconds: 500),
                                opacity: display2Flg.value ? 1 : 0,
                                child: Text(
                                  wolfFlg ? '人狼' : '市民',
                                  style: TextStyle(
                                    color: wolfFlg
                                        ? Colors.red.shade400
                                        : Colors.green.shade300,
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: AnimatedOpacity(
                              duration: const Duration(milliseconds: 500),
                              opacity: display3Flg.value ? 1 : 0,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  _textContent(
                                    sentence,
                                    '問題',
                                    height * 0.32 > 320 ? 320 : height * 0.32,
                                    fontSize,
                                    fontHeight,
                                    widthSetting,
                                    true,
                                  ),
                                  SizedBox(height: 10),
                                  _textContent(
                                    wolfFlg
                                        ? correctAnswer
                                        : '市民なので正解は表示されません。',
                                    '正解',
                                    height * 0.24 > 240 ? 240 : height * 0.24,
                                    fontSize,
                                    fontHeight,
                                    widthSetting,
                                    wolfFlg,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      top: 15,
                                    ),
                                    child: SizedBox(
                                      height: 40,
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          soundEffect.play('sounds/tap.mp3',
                                              isNotification: true);
                                          if (playerId.toString() ==
                                              numOfPlayers) {
                                            Navigator.of(context).pushNamed(
                                              WarewolfPlayingScreen.routeName,
                                              arguments: [
                                                sentence,
                                                correctAnswer,
                                              ],
                                            );
                                            await new Future.delayed(
                                              new Duration(milliseconds: 500),
                                            );
                                            confirmFlg.value = true;
                                          } else {
                                            Navigator.of(context).pushNamed(
                                              WarewolfPreparationScreen
                                                  .routeName,
                                              arguments: [
                                                sentence,
                                                correctAnswer,
                                                playerId + 1,
                                              ],
                                            );
                                            await new Future.delayed(
                                              new Duration(milliseconds: 500),
                                            );
                                            confirmFlg.value = true;
                                          }
                                        },
                                        child: Text(
                                          '確認OK',
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          primary: Colors.blue,
                                          textStyle: Theme.of(context)
                                              .textTheme
                                              .button,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _textContent(
    String text,
    String labelText,
    double contentHeight,
    double fontSize,
    double fontHeight,
    double? widthSetting,
    bool displayFlg,
  ) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(
            bottom: 5,
          ),
          width: double.infinity,
          child: Text(
            labelText,
            textAlign: TextAlign.left,
            style: TextStyle(
              color: Colors.grey.shade300,
              fontSize: 16.0,
              fontFamily: 'SawarabiGothic',
            ),
          ),
        ),
        Container(
          height: contentHeight,
          width: widthSetting,
          margin: EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: displayFlg ? Colors.white : Colors.grey,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Colors.black,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.white54,
                blurRadius: 6.0,
                spreadRadius: 0.1,
                offset: Offset(5, 5),
              )
            ],
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(
              right: 10,
              left: 10,
              top: 4,
              bottom: 10,
            ),
            child: Text(
              text,
              style: TextStyle(
                fontSize: fontSize,
                color: Colors.black,
                height: fontHeight,
                fontFamily: 'NotoSerifJP',
              ),
            ),
          ),
        ),
      ],
    );
  }
}

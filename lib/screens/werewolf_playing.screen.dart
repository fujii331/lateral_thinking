import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:intl/intl.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'dart:async';
import 'dart:math';

import '../providers/werewolf.provider.dart';
import '../providers/common.provider.dart';

import '../models/werewolf.model.dart';
import '../widgets/background.widget.dart';
import '../widgets/werewolf/confirm_answered_modal.widget.dart';

class WerewolfPlayingScreen extends HookWidget {
  static const routeName = '/werewolf-playing';

  void timeStart(
    BuildContext context,
    ValueNotifier<DateTime> time,
    ValueNotifier<DateTime> subTime,
    ValueNotifier<bool> timeStopFlg,
    ValueNotifier<bool> finishFlg,
    DateTime baseSubTime,
    ValueNotifier<int> playerId,
    int numOfPlayersValue,
    AudioCache soundEffect,
    Player player1,
    Player player2,
    Player player3,
    Player player4,
    Player player5,
    Player player6,
    bool timerCancelFlg,
    double seVolume,
  ) {
    Timer.periodic(
      Duration(seconds: 1),
      (Timer timer) async {
        if (!timeStopFlg.value) {
          time.value = time.value.add(
            Duration(
              seconds: -1,
            ),
          );
          if (timer.isActive &&
              DateFormat('mm:ss').format(time.value) == '00:00') {
            finishFlg.value = true;
            soundEffect.play(
              'sounds/finish.mp3',
              isNotification: true,
              volume: seVolume,
            );
            timer.cancel();
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
              width: MediaQuery.of(context).size.width * .86 > 500 ? 500 : null,
              body: ConfirmAnsweredModal(
                true,
                timeStopFlg,
              ),
            )..show();
          }
          if (!context.read(subTimeStopFlgProvider).state) {
            subTime.value = subTime.value.add(
              Duration(
                seconds: -1,
              ),
            );
            if (timer.isActive &&
                DateFormat('s').format(subTime.value) == '0') {
              soundEffect.play(
                'sounds/fault.mp3',
                isNotification: true,
                volume: seVolume,
              );
              if (playerId.value == 1) {
                context.read(player1Provider).state = Player(
                  id: 1,
                  name: player1.name,
                  point: player1.point - 1,
                );
              } else if (playerId.value == 2) {
                context.read(player2Provider).state = Player(
                  id: 2,
                  name: player2.name,
                  point: player2.point - 1,
                );
              } else if (playerId.value == 3) {
                context.read(player3Provider).state = Player(
                  id: 3,
                  name: player3.name,
                  point: player3.point - 1,
                );
              } else if (playerId.value == 4) {
                context.read(player4Provider).state = Player(
                  id: 4,
                  name: player4.name,
                  point: player4.point - 1,
                );
              } else if (playerId.value == 5) {
                context.read(player5Provider).state = Player(
                  id: 5,
                  name: player5.name,
                  point: player5.point - 1,
                );
              } else {
                context.read(player6Provider).state = Player(
                  id: 6,
                  name: player6.name,
                  point: player6.point - 1,
                );
              }
              nextPerson(subTime, baseSubTime, playerId, numOfPlayersValue);
            }
          }
        }
        if (timer.isActive && timerCancelFlg) {
          timer.cancel();
        }
      },
    );
  }

  void nextPerson(
    ValueNotifier<DateTime> subTime,
    DateTime baseSubTime,
    ValueNotifier<int> playerId,
    int numOfPlayersValue,
  ) {
    subTime.value = baseSubTime;
    if (playerId.value != numOfPlayersValue) {
      playerId.value++;
    } else {
      playerId.value = 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    final List args = ModalRoute.of(context)?.settings.arguments as List;
    final sentence = args[0];
    final correctAnswer = args[1];

    final AudioCache soundEffect = useProvider(soundEffectProvider).state;
    final timerCancelFlg = useProvider(timerCancelFlgProvider).state;
    final double seVolume = useProvider(seVolumeProvider).state;
    final double bgmVolume = useProvider(bgmVolumeProvider).state;

    final mainTime = useProvider(mainTimeProvider).state;
    final questionTime = useProvider(questionTimeProvider).state;
    final numOfPlayers = useProvider(numOfPlayersProvider).state;
    final player1 = useProvider(player1Provider).state;
    final player2 = useProvider(player2Provider).state;
    final player3 = useProvider(player3Provider).state;
    final player4 = useProvider(player4Provider).state;
    final player5 = useProvider(player5Provider).state;
    final player6 = useProvider(player6Provider).state;

    final confirmFlg = useState<bool>(true);
    final display1Flg = useState<bool>(true);
    final displayFlg = useState<bool>(false);
    final display2Flg = useState<bool>(true);
    final sentenceFlg = useState<bool>(true);
    final playingFlg = useState<bool>(false);
    final setFlg = useState<bool>(true);

    final questionTimeNotExsistFlg = questionTime == '×';

    final time =
        useState<DateTime>(DateTime(2020, 1, 1, 1, int.parse(mainTime)));

    final baseSubTime = DateTime(2020, 1, 1, 1, 1).add(Duration(
      seconds: questionTimeNotExsistFlg ? 10 : int.parse(questionTime),
    ));

    final subTime = useState<DateTime>(baseSubTime);
    final subTimeStopFlg = useProvider(subTimeStopFlgProvider).state;
    final finishFlg = useState<bool>(false);
    final timeStopFlg = useState<bool>(false);

    final playerId =
        useState<int>(new Random().nextInt(int.parse(numOfPlayers)) + 1);

    final height = MediaQuery.of(context).size.height;
    final widthSetting = MediaQuery.of(context).size.width * .95 > 650.0
        ? 650.0
        : MediaQuery.of(context).size.width * .95;

    useEffect(() {
      WidgetsBinding.instance!.addPostFrameCallback((_) async {
        context.read(subTimeStopFlgProvider).state =
            questionTimeNotExsistFlg ? true : false;
      });
      return null;
    }, const []);

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            background(),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color.fromRGBO(0, 0, 0, 0.6),
              ),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Center(
                child: SingleChildScrollView(
                  child: display1Flg.value
                      ? AnimatedOpacity(
                          duration: const Duration(milliseconds: 500),
                          opacity: confirmFlg.value ? 1 : 0,
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 25,
                                ),
                                child: Text(
                                  '全員の確認が終わりました。\nゲームマスターに端末を渡して下さい。',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 23,
                                    fontWeight: FontWeight.bold,
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
                                            soundEffect.play(
                                              'sounds/tap.mp3',
                                              isNotification: true,
                                              volume: seVolume,
                                            );
                                            confirmFlg.value = false;
                                            await new Future.delayed(
                                              new Duration(milliseconds: 500),
                                            );
                                            display1Flg.value = false;
                                            displayFlg.value = true;
                                          }
                                        : () {},
                                    child: Text(
                                      '渡した',
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.blue.shade600,
                                      textStyle:
                                          Theme.of(context).textTheme.button,
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
                      : AnimatedOpacity(
                          duration: const Duration(milliseconds: 500),
                          opacity: displayFlg.value ? 1 : 0,
                          child: Padding(
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
                                    ElevatedButton(
                                      onPressed: finishFlg.value
                                          ? () {}
                                          : () => {
                                                sentenceFlg.value = true,
                                              },
                                      child: Text(
                                        '問題',
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        primary: sentenceFlg.value
                                            ? Colors.green
                                            : Colors.green.shade200,
                                        textStyle:
                                            Theme.of(context).textTheme.button,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 30),
                                    ElevatedButton(
                                      onPressed: finishFlg.value
                                          ? () {}
                                          : () => {
                                                sentenceFlg.value = false,
                                              },
                                      child: Text(
                                        '正解',
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        primary: sentenceFlg.value
                                            ? Colors.orange.shade200
                                            : Colors.orange.shade700,
                                        textStyle:
                                            Theme.of(context).textTheme.button,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        height: height * 0.35 > 320
                                            ? 320
                                            : height * 0.35,
                                        width: widthSetting,
                                        margin: EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                            color: sentenceFlg.value
                                                ? Colors.green
                                                : Colors.orange,
                                            width: 3,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.white54,
                                              blurRadius: 6.0,
                                              spreadRadius: 0.1,
                                              offset: Offset(1, 1),
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
                                            sentenceFlg.value
                                                ? sentence
                                                : correctAnswer,
                                            style: TextStyle(
                                              fontSize: height * .35 > 230
                                                  ? 17.0
                                                  : 15.5,
                                              color: Colors.black,
                                              height: height * .35 > 230
                                                  ? 1.7
                                                  : 1.6,
                                              fontFamily: 'NotoSerifJP',
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 230,
                                        padding: const EdgeInsets.only(
                                          top: 20,
                                        ),
                                        child: display2Flg.value
                                            ? AnimatedOpacity(
                                                duration: const Duration(
                                                    milliseconds: 500),
                                                opacity: setFlg.value ? 1 : 0,
                                                child: Column(
                                                  children: [
                                                    Container(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                        vertical: 20,
                                                        horizontal: 20,
                                                      ),
                                                      child: Text(
                                                        '問題と正解を確認し、最後に問題を読み上げたら「開始」ボタンをクリック！',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                        top: 15,
                                                      ),
                                                      child: SizedBox(
                                                        height: 40,
                                                        child: ElevatedButton(
                                                          child: Text(
                                                            '開始',
                                                          ),
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            primary: Colors
                                                                .blue.shade600,
                                                            textStyle: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .button,
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                            ),
                                                          ),
                                                          onPressed:
                                                              setFlg.value
                                                                  ? () async {
                                                                      soundEffect
                                                                          .play(
                                                                        'sounds/tap.mp3',
                                                                        isNotification:
                                                                            true,
                                                                        volume:
                                                                            seVolume,
                                                                      );
                                                                      setFlg.value =
                                                                          false;
                                                                      await new Future
                                                                          .delayed(
                                                                        new Duration(
                                                                            milliseconds:
                                                                                600),
                                                                      );
                                                                      display2Flg
                                                                              .value =
                                                                          false;
                                                                      soundEffect
                                                                          .play(
                                                                        'sounds/start.mp3',
                                                                        isNotification:
                                                                            true,
                                                                        volume:
                                                                            seVolume,
                                                                      );
                                                                      playingFlg
                                                                              .value =
                                                                          true;
                                                                      await new Future
                                                                          .delayed(
                                                                        new Duration(
                                                                            milliseconds:
                                                                                100),
                                                                      );
                                                                      context.read(bgmProvider).state = await soundEffect.loop(
                                                                          'sounds/bgm_3.mp3',
                                                                          volume:
                                                                              bgmVolume,
                                                                          isNotification:
                                                                              true);

                                                                      timeStart(
                                                                        context,
                                                                        time,
                                                                        subTime,
                                                                        timeStopFlg,
                                                                        finishFlg,
                                                                        baseSubTime,
                                                                        playerId,
                                                                        int.parse(
                                                                            numOfPlayers),
                                                                        soundEffect,
                                                                        player1,
                                                                        player2,
                                                                        player3,
                                                                        player4,
                                                                        player5,
                                                                        player6,
                                                                        timerCancelFlg,
                                                                        seVolume,
                                                                      );
                                                                    }
                                                                  : () {},
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            : AnimatedOpacity(
                                                duration: const Duration(
                                                    milliseconds: 500),
                                                opacity:
                                                    playingFlg.value ? 1 : 0,
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                    top:
                                                        questionTimeNotExsistFlg
                                                            ? 30
                                                            : 10,
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            '残り時間',
                                                            style: TextStyle(
                                                              color: Colors
                                                                  .orange
                                                                  .shade300,
                                                              fontSize: 24,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                              left: 20,
                                                            ),
                                                            child: Text(
                                                              DateFormat(
                                                                      'mm:ss')
                                                                  .format(time
                                                                      .value),
                                                              style: TextStyle(
                                                                color: (DateFormat('mm').format(time.value) ==
                                                                            '00' &&
                                                                        int.parse(DateFormat('ss').format(time.value)) <
                                                                            30)
                                                                    ? Colors.red
                                                                        .shade200
                                                                    : Colors
                                                                        .white,
                                                                fontSize: 24,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      questionTimeNotExsistFlg
                                                          ? Container(
                                                              height: 30,
                                                            )
                                                          : Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      top: 8.0),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Container(
                                                                    width: 120,
                                                                    child: Text(
                                                                      playerId.value ==
                                                                              1
                                                                          ? player1
                                                                              .name
                                                                          : playerId.value == 2
                                                                              ? player2.name
                                                                              : playerId.value == 3
                                                                                  ? player3.name
                                                                                  : playerId.value == 4
                                                                                      ? player4.name
                                                                                      : playerId.value == 5
                                                                                          ? player5.name
                                                                                          : player6.name,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      style:
                                                                          TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            20,
                                                                        fontFamily:
                                                                            'SawarabiGothic',
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            5),
                                                                    child: Text(
                                                                      'の質問',
                                                                      style:
                                                                          TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            16,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .only(
                                                                      left: 25,
                                                                    ),
                                                                    width: int.parse(DateFormat('s').format(subTime.value)) <
                                                                            10
                                                                        ? 46
                                                                        : null,
                                                                    child: Text(
                                                                      DateFormat(
                                                                              's')
                                                                          .format(
                                                                              subTime.value),
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      style:
                                                                          TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            18,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .only(
                                                                      left: 6,
                                                                      top: 3,
                                                                    ),
                                                                    child:
                                                                        IconButton(
                                                                      iconSize:
                                                                          30,
                                                                      icon:
                                                                          Icon(
                                                                        subTimeStopFlg
                                                                            ? Icons.play_arrow
                                                                            : Icons.pause_circle,
                                                                        color: subTimeStopFlg
                                                                            ? Colors.green.shade200
                                                                            : Colors.red.shade200,
                                                                      ),
                                                                      onPressed: finishFlg
                                                                              .value
                                                                          ? () {}
                                                                          : () {
                                                                              soundEffect.play(
                                                                                'sounds/tap.mp3',
                                                                                isNotification: true,
                                                                                volume: seVolume,
                                                                              );
                                                                              if (subTimeStopFlg) {
                                                                                context.read(subTimeStopFlgProvider).state = false;
                                                                              } else {
                                                                                context.read(subTimeStopFlgProvider).state = true;
                                                                              }
                                                                            },
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                          top: 15,
                                                        ),
                                                        child: SizedBox(
                                                          height: 40,
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              ElevatedButton(
                                                                child: Text(
                                                                  '正解が出た',
                                                                ),
                                                                style: ElevatedButton
                                                                    .styleFrom(
                                                                  primary: Colors
                                                                      .pink
                                                                      .shade600,
                                                                  textStyle: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .button,
                                                                  shape:
                                                                      RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10),
                                                                  ),
                                                                ),
                                                                onPressed:
                                                                    finishFlg
                                                                            .value
                                                                        ? () {}
                                                                        : () {
                                                                            soundEffect.play(
                                                                              'sounds/tap.mp3',
                                                                              isNotification: true,
                                                                              volume: seVolume,
                                                                            );

                                                                            timeStopFlg.value =
                                                                                true;

                                                                            AwesomeDialog(
                                                                              context: context,
                                                                              dialogType: DialogType.NO_HEADER,
                                                                              headerAnimationLoop: false,
                                                                              dismissOnTouchOutside: false,
                                                                              dismissOnBackKeyPress: false,
                                                                              animType: AnimType.SCALE,
                                                                              width: MediaQuery.of(context).size.width * .86 > 500 ? 500 : null,
                                                                              body: ConfirmAnsweredModal(
                                                                                false,
                                                                                timeStopFlg,
                                                                              ),
                                                                            )..show();
                                                                          },
                                                              ),
                                                              questionTimeNotExsistFlg
                                                                  ? Container()
                                                                  : Row(
                                                                      children: [
                                                                        SizedBox(
                                                                            width:
                                                                                30),
                                                                        ElevatedButton(
                                                                          child:
                                                                              Text(
                                                                            '次の人',
                                                                          ),
                                                                          style:
                                                                              ElevatedButton.styleFrom(
                                                                            primary:
                                                                                Colors.blue.shade600,
                                                                            textStyle:
                                                                                Theme.of(context).textTheme.button,
                                                                            shape:
                                                                                RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.circular(10),
                                                                            ),
                                                                          ),
                                                                          onPressed: finishFlg.value
                                                                              ? () {}
                                                                              : () {
                                                                                  soundEffect.play(
                                                                                    'sounds/tap.mp3',
                                                                                    isNotification: true,
                                                                                    volume: seVolume,
                                                                                  );

                                                                                  nextPerson(subTime, baseSubTime, playerId, int.parse(numOfPlayers));
                                                                                },
                                                                        ),
                                                                      ],
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
                                ),
                              ],
                            ),
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

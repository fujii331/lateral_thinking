import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:math';

import '../providers/werewolf.provider.dart';
import '../providers/common.provider.dart';

import '../widgets/background.widget.dart';
import './werewolf_preparation.screen.dart';

class WerewolfPreparationFirstScreen extends HookWidget {
  static const routeName = '/werewolf-preparation-first';

  @override
  Widget build(BuildContext context) {
    final List args = ModalRoute.of(context)?.settings.arguments as List;
    final sentence = args[0];
    final correctAnswer = args[1];

    final AudioCache soundEffect = useProvider(soundEffectProvider).state;
    final numOfPlayers = useProvider(numOfPlayersProvider).state;
    final double seVolume = useProvider(seVolumeProvider).state;
    final String peaceVillage = useProvider(peaceVillageProvider).state;
    final double bgmVolume = useProvider(bgmVolumeProvider).state;

    useEffect(() {
      WidgetsBinding.instance!.addPostFrameCallback((_) async {
        if (bgmVolume > 0.1) {
          context.read(bgmProvider).state.setVolume(0.1);
        }
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
              padding: const EdgeInsets.only(
                top: 30,
                left: 20,
                right: 20,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color.fromRGBO(0, 0, 0, 0.6),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      child: Text(
                        '水平思考人狼を開始します',
                        style: TextStyle(
                          color: Colors.yellow.shade200,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'プレイヤーは順番に役職と問題を確認して下さい',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 50,
                      ),
                      child: SizedBox(
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () async {
                            soundEffect.play(
                              'sounds/tap.mp3',
                              isNotification: true,
                              volume: seVolume,
                            );
                            context.read(wolfIdProvider).state = peaceVillage ==
                                        'あり' &&
                                    Random().nextInt(4) == 1
                                ? 0
                                : Random().nextInt(int.parse(numOfPlayers)) + 1;

                            Navigator.of(context).pushReplacementNamed(
                              WerewolfPreparationScreen.routeName,
                              arguments: [
                                sentence,
                                correctAnswer,
                                1,
                              ],
                            );
                          },
                          child: Text(
                            '最初の人へ',
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.blue.shade600,
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}

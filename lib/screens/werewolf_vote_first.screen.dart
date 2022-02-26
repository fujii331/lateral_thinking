import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';

import '../providers/common.provider.dart';

import '../widgets/background.widget.dart';
import './werewolf_vote.screen.dart';

class WerewolfVoteFirstScreen extends HookWidget {
  static const routeName = '/werewolf-vote-first';

  @override
  Widget build(BuildContext context) {
    final AudioCache soundEffect = useProvider(soundEffectProvider).state;
    final double seVolume = useProvider(seVolumeProvider).state;

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
                        '投票に移ります',
                        style: TextStyle(
                          color: Colors.yellow.shade200,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'プレイヤーは順番に人狼だと思う人に投票して下さい。',
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
                            Navigator.of(context).pushReplacementNamed(
                              WerewolfVoteScreen.routeName,
                              arguments: 1,
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

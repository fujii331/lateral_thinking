import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';

import '../../providers/common.provider.dart';
import '../../providers/warewolf.provider.dart';

import '../../models/warewolf.model.dart';
import '../../screens/warewolf_vote_first.screen.dart';
import '../../screens/warewolf_discussion.screen.dart';
import '../../screens/warewolf_result.screen.dart';

class ConfirmAnsweredModal extends HookWidget {
  final bool timeLimitedFlg;
  final ValueNotifier<bool> timeStopFlg;

  ConfirmAnsweredModal(
    this.timeLimitedFlg,
    this.timeStopFlg,
  );

  @override
  Widget build(BuildContext context) {
    final AudioCache soundEffect = useProvider(soundEffectProvider).state;
    final numOfPlayers = useProvider(numOfPlayersProvider).state;
    final discussionTime = useProvider(discussionTimeProvider).state;
    final double seVolume = useProvider(seVolumeProvider).state;
    final double bgmVolume = useProvider(bgmVolumeProvider).state;

    final int wolfId = useProvider(wolfIdProvider).state;

    final player1 = useProvider(player1Provider).state;
    final player2 = useProvider(player2Provider).state;
    final player3 = useProvider(player3Provider).state;
    final player4 = useProvider(player4Provider).state;
    final player5 = useProvider(player5Provider).state;
    final player6 = useProvider(player6Provider).state;

    final confirmAnsweredFlg = useState<bool>(timeLimitedFlg);
    final confirmPlayerFlg = useState<bool>(!timeLimitedFlg);
    final nextStepFlg = useState<bool>(false);

    final display1Flg = useState<bool>(timeLimitedFlg);
    final display2Flg = useState<bool>(true);

    // final dummyPlayer = Player(id: 0, name: '', point: 0);

    final selectedPlayer = useState<Player?>(null);

    final List<Player> playersList = [
      player1,
      player2,
      player3,
      player4,
      player5,
      player6,
    ].where((player) => player.id <= int.parse(numOfPlayers)).toList();

    // final firstPlayersList = [...playersList];

    // firstPlayersList.insert(0, dummyPlayer);

    // final selectedFlg = useState<bool>(false);

    return Container(
      padding: const EdgeInsets.only(
        left: 15,
        right: 15,
      ),
      height: MediaQuery.of(context).size.width * .86 > 300 ? 260 : 270,
      child: display1Flg.value
          ? AnimatedOpacity(
              duration: const Duration(milliseconds: 500),
              opacity: confirmAnsweredFlg.value ? 1 : 0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                    ),
                    child: Text(
                      '制限時間終了です',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'SawarabiGothic',
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 10,
                      bottom: 5,
                    ),
                    child: Text(
                      'クイズに正解した人はいましたか？\n※「いいえ」を選択するとゲームを終了します。',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontFamily: 'SawarabiGothic',
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 15,
                    ),
                    child: Wrap(
                      children: [
                        ElevatedButton(
                          onPressed: confirmAnsweredFlg.value
                              ? () async {
                                  soundEffect.play(
                                    'sounds/tap.mp3',
                                    isNotification: true,
                                    volume: seVolume,
                                  );
                                  if (wolfId == 1) {
                                    context.read(player1Provider).state =
                                        Player(
                                      id: 1,
                                      name: player1.name,
                                      point: player1.point - 3,
                                    );
                                  } else if (wolfId == 2) {
                                    context.read(player2Provider).state =
                                        Player(
                                      id: 2,
                                      name: player2.name,
                                      point: player2.point - 3,
                                    );
                                  } else if (wolfId == 3) {
                                    context.read(player3Provider).state =
                                        Player(
                                      id: 3,
                                      name: player3.name,
                                      point: player3.point - 3,
                                    );
                                  } else if (wolfId == 4) {
                                    context.read(player4Provider).state =
                                        Player(
                                      id: 4,
                                      name: player4.name,
                                      point: player4.point - 3,
                                    );
                                  } else if (wolfId == 5) {
                                    context.read(player5Provider).state =
                                        Player(
                                      id: 5,
                                      name: player5.name,
                                      point: player5.point - 3,
                                    );
                                  } else if (wolfId == 6) {
                                    context.read(player6Provider).state =
                                        Player(
                                      id: 6,
                                      name: player6.name,
                                      point: player6.point - 3,
                                    );
                                  }
                                  context.read(bgmProvider).state.stop();
                                  context.read(bgmProvider).state =
                                      await soundEffect.loop(
                                    'sounds/bgm.mp3',
                                    volume: bgmVolume,
                                    isNotification: true,
                                  );
                                  Navigator.of(context).pushReplacementNamed(
                                    WarewolfResultScreen.routeName,
                                    arguments: [
                                      [
                                        Player(
                                          id: 0,
                                          name: '',
                                          point: 0,
                                        )
                                      ],
                                      false,
                                      false,
                                    ],
                                  );
                                }
                              : () {},
                          child: Text('いいえ'),
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
                          onPressed: confirmAnsweredFlg.value
                              ? () async {
                                  soundEffect.play(
                                    'sounds/tap.mp3',
                                    isNotification: true,
                                    volume: seVolume,
                                  );
                                  confirmAnsweredFlg.value = false;
                                  await new Future.delayed(
                                    new Duration(milliseconds: 600),
                                  );
                                  display1Flg.value = false;
                                  display2Flg.value = true;
                                  confirmPlayerFlg.value = true;
                                }
                              : () {},
                          child: Text(
                            'はい',
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
            )
          : display2Flg.value
              ? AnimatedOpacity(
                  duration: const Duration(milliseconds: 500),
                  opacity: confirmPlayerFlg.value ? 1 : 0,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                        ),
                        child: Text(
                          '正解者の選択',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'SawarabiGothic',
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 10,
                        ),
                        child: Text(
                          '正解した人を選んで「次へ」ボタンを押して下さい。',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontFamily: 'SawarabiGothic',
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 20,
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                          ),
                          width: 160,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Colors.black,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: DropdownButton(
                            isExpanded: true,
                            underline: Container(
                              color: Colors.white,
                            ),
                            value: selectedPlayer.value != null
                                ? selectedPlayer.value
                                : null,
                            items: playersList.map((Player player) {
                              return DropdownMenuItem(
                                value: player,
                                child: Text(
                                  player.name,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontFamily: 'SawarabiGothic',
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (Player? player) {
                              selectedPlayer.value = player as Player;
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 15,
                        ),
                        child: Wrap(
                          children: [
                            ElevatedButton(
                              onPressed: confirmPlayerFlg.value
                                  ? () async {
                                      soundEffect.play(
                                        'sounds/cancel.mp3',
                                        isNotification: true,
                                        volume: seVolume,
                                      );
                                      if (timeLimitedFlg) {
                                        confirmPlayerFlg.value = false;
                                        await new Future.delayed(
                                          new Duration(milliseconds: 600),
                                        );
                                        display2Flg.value = false;
                                        display1Flg.value = true;
                                        confirmAnsweredFlg.value = true;
                                      } else {
                                        timeStopFlg.value = false;
                                        Navigator.pop(context);
                                      }
                                    }
                                  : () {},
                              child: Text('戻る'),
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
                              onPressed: confirmPlayerFlg.value &&
                                      selectedPlayer.value != null
                                  ? () async {
                                      soundEffect.play(
                                        'sounds/tap.mp3',
                                        isNotification: true,
                                        volume: seVolume,
                                      );
                                      confirmPlayerFlg.value = false;
                                      await new Future.delayed(
                                        new Duration(milliseconds: 600),
                                      );
                                      display2Flg.value = false;
                                      nextStepFlg.value = true;
                                    }
                                  : () {},
                              child: Text('次へ'),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.only(
                                  right: 14,
                                  left: 14,
                                ),
                                primary: selectedPlayer.value != null
                                    ? Colors.blue.shade700
                                    : Colors.blue.shade200,
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
                )
              : AnimatedOpacity(
                  duration: const Duration(milliseconds: 500),
                  opacity: nextStepFlg.value ? 1 : 0,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                        ),
                        child: Text(
                          '正解者の確認',
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
                        child: Wrap(
                          children: [
                            Text(
                              '正解者は ',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontFamily: 'SawarabiGothic',
                              ),
                            ),
                            Text(
                              selectedPlayer.value!.name,
                              style: TextStyle(
                                fontSize: 19.0,
                                fontFamily: 'SawarabiGothic',
                                color: Colors.orange.shade700,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 20,
                        ),
                        child: Text(
                          '正解者を確定して' +
                              (discussionTime == '0' ? '投票' : '会議') +
                              'に進みますか？',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontFamily: 'SawarabiGothic',
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 15,
                        ),
                        child: Wrap(
                          children: [
                            ElevatedButton(
                              onPressed: !nextStepFlg.value
                                  ? () {}
                                  : () async {
                                      soundEffect.play(
                                        'sounds/cancel.mp3',
                                        isNotification: true,
                                        volume: seVolume,
                                      );
                                      nextStepFlg.value = false;
                                      await new Future.delayed(
                                        new Duration(milliseconds: 600),
                                      );
                                      display2Flg.value = true;
                                      confirmPlayerFlg.value = true;
                                    },
                              child: Text('戻る'),
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
                              onPressed: !nextStepFlg.value
                                  ? () {}
                                  : () async {
                                      soundEffect.play(
                                        'sounds/tap.mp3',
                                        isNotification: true,
                                        volume: seVolume,
                                      );
                                      context
                                          .read(timerCancelFlgProvider)
                                          .state = true;
                                      context
                                          .read(answeredPlayerIdProvider)
                                          .state = selectedPlayer.value!.id;
                                      if (discussionTime == '0') {
                                        context.read(bgmProvider).state.stop();
                                        Navigator.of(context)
                                            .pushReplacementNamed(
                                          WarewolfVoteFirstScreen.routeName,
                                        );
                                      } else {
                                        context.read(bgmProvider).state.stop();
                                        Navigator.of(context)
                                            .pushReplacementNamed(
                                          WarewolfDiscussionScreen.routeName,
                                        );
                                      }
                                    },
                              child: Text('進む'),
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
                ),
    );
  }
}

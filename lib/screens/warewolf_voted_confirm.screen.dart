import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';

import '../providers/quiz.provider.dart';
import '../providers/warewolf.provider.dart';
import '../../models/warewolf.model.dart';

import '../widgets/background.widget.dart';
import './warewolf_result.screen.dart';
import '../widgets/warewolf/judging_modal.widget.dart';

class WarewolfVotedConfirmScreen extends HookWidget {
  static const routeName = '/warewolf-voted-confirm';

  @override
  Widget build(BuildContext context) {
    final int wolfId = useProvider(wolfIdProvider).state;
    final Vote vote = useProvider(voteProvider).state;
    final String numOfPlayers = useProvider(numOfPlayersProvider).state;
    final AudioCache soundEffect = useProvider(soundEffectProvider).state;

    final player1 = useProvider(player1Provider).state;
    final player2 = useProvider(player2Provider).state;
    final player3 = useProvider(player3Provider).state;
    final player4 = useProvider(player4Provider).state;
    final player5 = useProvider(player5Provider).state;
    final player6 = useProvider(player6Provider).state;

    int mostVotedPoint = vote.player1;
    List<Player> mostVotedList = [player1];

    if (vote.player2 >= mostVotedPoint) {
      if (vote.player2 == mostVotedPoint) {
        mostVotedList.add(player2);
      } else {
        mostVotedPoint = vote.player2;
        mostVotedList = [player2];
      }
    }
    if (vote.player3 >= mostVotedPoint) {
      if (vote.player3 == mostVotedPoint) {
        mostVotedList.add(player3);
      } else {
        mostVotedPoint = vote.player3;
        mostVotedList = [player3];
      }
    }
    if (int.parse(numOfPlayers) > 3 && vote.player4 >= mostVotedPoint) {
      if (vote.player4 == mostVotedPoint) {
        mostVotedList.add(player4);
      } else {
        mostVotedPoint = vote.player4;
        mostVotedList = [player4];
      }
    }
    if (int.parse(numOfPlayers) > 4 && vote.player5 >= mostVotedPoint) {
      if (vote.player5 == mostVotedPoint) {
        mostVotedList.add(player5);
      } else {
        mostVotedPoint = vote.player5;
        mostVotedList = [player5];
      }
    }
    if (int.parse(numOfPlayers) > 5 && vote.player6 >= mostVotedPoint) {
      if (vote.player6 == mostVotedPoint) {
        mostVotedList.add(player6);
      } else {
        mostVotedList = [player6];
      }
    }

    final bool sameVoteFlg = mostVotedList.length == int.parse(numOfPlayers);

    bool wolfVotedFlg = false;

    if (!sameVoteFlg) {
      mostVotedList.forEach(
        (player) => {
          if (player.id == wolfId) {wolfVotedFlg = true}
        },
      );
    } else if (wolfId == 0) {
      wolfVotedFlg = true;
    }

    final confirmFlg = useState<bool>(true);

    return Scaffold(
      body: Stack(
        children: <Widget>[
          background(),
          Center(
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 500),
              opacity: confirmFlg.value ? 1 : 0,
              child: Padding(
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
                            await showDialog<int>(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return JudgingModal(
                                  mostVotedList,
                                  wolfVotedFlg,
                                  sameVoteFlg,
                                );
                              },
                            );
                            await new Future.delayed(
                              new Duration(milliseconds: 8400),
                            );
                            // 結果画面に移行
                            Navigator.of(context).pushNamed(
                              WarewolfResultScreen.routeName,
                              arguments: [
                                mostVotedList,
                                wolfVotedFlg,
                                sameVoteFlg,
                              ],
                            );
                          }
                        : () {},
                    child: Text(
                      '最多得票者を確認',
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
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';

import '../../providers/common.provider.dart';
import '../../providers/werewolf.provider.dart';

import '../../models/werewolf.model.dart';
import '../../screens/werewolf_vote.screen.dart';
import '../../screens/werewolf_voted_confirm.screen.dart';

class ConfirmVoteModal extends HookWidget {
  final int playerId;
  final int votetargetId;

  ConfirmVoteModal(
    this.playerId,
    this.votetargetId,
  );

  @override
  Widget build(BuildContext context) {
    final AudioCache soundEffect = useProvider(soundEffectProvider).state;
    final Vote vote = useProvider(voteProvider).state;
    final Vote votingDestination = useProvider(votingDestinationProvider).state;
    final numOfPlayers = useProvider(numOfPlayersProvider).state;
    final double seVolume = useProvider(seVolumeProvider).state;

    final String votedPlayerName = votetargetId == 1
        ? useProvider(player1Provider).state.name
        : votetargetId == 2
            ? useProvider(player2Provider).state.name
            : votetargetId == 3
                ? useProvider(player3Provider).state.name
                : votetargetId == 4
                    ? useProvider(player4Provider).state.name
                    : votetargetId == 5
                        ? useProvider(player5Provider).state.name
                        : useProvider(player6Provider).state.name;

    return Container(
      padding: const EdgeInsets.only(
        left: 20,
        right: 20,
        bottom: 25,
      ),
      // height: 220,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 10,
            ),
            child: Text(
              '投票先の確認',
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
            child: Column(
              children: [
                Text(
                  votedPlayerName,
                  style: TextStyle(
                    fontSize: 20.0,
                    fontFamily: 'SawarabiGothic',
                    color: Colors.orange.shade900,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'でよろしいですか？',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontFamily: 'SawarabiGothic',
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 20,
            ),
            child: Wrap(
              children: [
                ElevatedButton(
                  onPressed: () {
                    soundEffect.play(
                      'sounds/cancel.mp3',
                      isNotification: true,
                      volume: seVolume,
                    );
                    Navigator.pop(context);
                  },
                  child: Text('戻る'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.only(
                      right: 14,
                      left: 14,
                    ),
                    primary: Colors.red.shade400,
                    textStyle: Theme.of(context).textTheme.button,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(width: 30),
                ElevatedButton(
                  onPressed: () {
                    soundEffect.play(
                      'sounds/tap.mp3',
                      isNotification: true,
                      volume: seVolume,
                    );
                    context.read(voteProvider).state = Vote(
                      player1:
                          votetargetId == 1 ? vote.player1 + 1 : vote.player1,
                      player2:
                          votetargetId == 2 ? vote.player2 + 1 : vote.player2,
                      player3:
                          votetargetId == 3 ? vote.player3 + 1 : vote.player3,
                      player4:
                          votetargetId == 4 ? vote.player4 + 1 : vote.player4,
                      player5:
                          votetargetId == 5 ? vote.player5 + 1 : vote.player5,
                      player6:
                          votetargetId == 6 ? vote.player6 + 1 : vote.player6,
                    );

                    context.read(votingDestinationProvider).state = Vote(
                      player1: playerId == 1
                          ? votetargetId
                          : votingDestination.player1,
                      player2: playerId == 2
                          ? votetargetId
                          : votingDestination.player2,
                      player3: playerId == 3
                          ? votetargetId
                          : votingDestination.player3,
                      player4: playerId == 4
                          ? votetargetId
                          : votingDestination.player4,
                      player5: playerId == 5
                          ? votetargetId
                          : votingDestination.player5,
                      player6: playerId == 6
                          ? votetargetId
                          : votingDestination.player6,
                    );

                    if (playerId.toString() == numOfPlayers) {
                      Navigator.of(context).pushReplacementNamed(
                        WerewolfVotedConfirmScreen.routeName,
                      );
                    } else {
                      Navigator.of(context).pushReplacementNamed(
                        WerewolfVoteScreen.routeName,
                        arguments: playerId + 1,
                      );
                    }
                  },
                  child: Text('投票する'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.only(
                      right: 14,
                      left: 14,
                    ),
                    primary: Colors.blue.shade600,
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

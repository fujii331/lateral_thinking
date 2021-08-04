import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

import '../providers/common.provider.dart';
import '../providers/warewolf.provider.dart';
import '../widgets/background.widget.dart';
import '../widgets/warewolf/confirm_vote_modal.widget.dart';

class WarewolfVoteScreen extends HookWidget {
  static const routeName = '/warewolf-vote';

  @override
  Widget build(BuildContext context) {
    final int playerId = ModalRoute.of(context)?.settings.arguments as int;

    final player1 = useProvider(player1Provider).state;
    final player2 = useProvider(player2Provider).state;
    final player3 = useProvider(player3Provider).state;
    final player4 = useProvider(player4Provider).state;
    final player5 = useProvider(player5Provider).state;
    final player6 = useProvider(player6Provider).state;

    final player = playerId == 1
        ? player1
        : playerId == 2
            ? player2
            : playerId == 3
                ? player3
                : playerId == 4
                    ? player4
                    : playerId == 5
                        ? player5
                        : player6;

    final AudioCache soundEffect = useProvider(soundEffectProvider).state;
    final numOfPlayers = useProvider(numOfPlayersProvider).state;
    final double seVolume = useProvider(seVolumeProvider).state;

    final confirmFlg = useState<bool>(true);
    final voteTimeFlg = useState<bool>(false);
    final displayFlg = useState<bool>(true);
    final widthSetting = MediaQuery.of(context).size.width * .95 > 400.0
        ? 400.0
        : MediaQuery.of(context).size.width * .95;

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
              child: Center(
                child: SingleChildScrollView(
                  child: displayFlg.value
                      ? AnimatedOpacity(
                          duration: const Duration(milliseconds: 500),
                          opacity: confirmFlg.value ? 1 : 0,
                          child: Column(
                            children: <Widget>[
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                ),
                                width: widthSetting,
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
                                  color: Colors.green.shade200,
                                  fontSize: 28,
                                  fontFamily: 'SawarabiGothic',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                ),
                                width: widthSetting,
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
                                            soundEffect.play(
                                              'sounds/tap.mp3',
                                              isNotification: true,
                                              volume: seVolume,
                                            );
                                            confirmFlg.value = false;
                                            await new Future.delayed(
                                              new Duration(milliseconds: 600),
                                            );
                                            displayFlg.value = false;
                                            voteTimeFlg.value = true;
                                          }
                                        : () {},
                                    child: Text(
                                      '投票に進む',
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
                          opacity: voteTimeFlg.value ? 1 : 0,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 30,
                            ),
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(
                                    bottom: 10,
                                  ),
                                  child: Text(
                                    '人狼だと思う人に投票',
                                    style: TextStyle(
                                      fontSize: 25.0,
                                      color: Colors.yellow.shade100,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 140,
                                      child: Column(
                                        children: <Widget>[
                                          playerId != 1
                                              ? _labelContent(player1.name)
                                              : Container(),
                                          playerId != 2
                                              ? _labelContent(player2.name)
                                              : Container(),
                                          playerId != 3
                                              ? _labelContent(player3.name)
                                              : Container(),
                                          int.parse(numOfPlayers) > 3 &&
                                                  playerId != 4
                                              ? _labelContent(player4.name)
                                              : Container(),
                                          int.parse(numOfPlayers) > 4 &&
                                                  playerId != 5
                                              ? _labelContent(player5.name)
                                              : Container(),
                                          int.parse(numOfPlayers) > 5 &&
                                                  playerId != 6
                                              ? _labelContent(player6.name)
                                              : Container(),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding:
                                          const EdgeInsets.only(left: 28.0),
                                      child: Column(
                                        children: <Widget>[
                                          playerId != 1
                                              ? _voteButton(
                                                  context,
                                                  playerId,
                                                  1,
                                                  soundEffect,
                                                  seVolume,
                                                )
                                              : Container(),
                                          playerId != 2
                                              ? _voteButton(
                                                  context,
                                                  playerId,
                                                  2,
                                                  soundEffect,
                                                  seVolume,
                                                )
                                              : Container(),
                                          playerId != 3
                                              ? _voteButton(
                                                  context,
                                                  playerId,
                                                  3,
                                                  soundEffect,
                                                  seVolume,
                                                )
                                              : Container(),
                                          int.parse(numOfPlayers) > 3 &&
                                                  playerId != 4
                                              ? _voteButton(
                                                  context,
                                                  playerId,
                                                  4,
                                                  soundEffect,
                                                  seVolume,
                                                )
                                              : Container(),
                                          int.parse(numOfPlayers) > 4 &&
                                                  playerId != 5
                                              ? _voteButton(
                                                  context,
                                                  playerId,
                                                  5,
                                                  soundEffect,
                                                  seVolume,
                                                )
                                              : Container(),
                                          int.parse(numOfPlayers) > 5 &&
                                                  playerId != 6
                                              ? _voteButton(
                                                  context,
                                                  playerId,
                                                  6,
                                                  soundEffect,
                                                  seVolume,
                                                )
                                              : Container(),
                                        ],
                                      ),
                                    ),
                                  ],
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

  Widget _labelContent(
    String text,
  ) {
    return Padding(
      padding: const EdgeInsets.only(top: 25),
      child: Container(
        height: 39,
        child: Text(
          text,
          style: TextStyle(
            fontSize: 20.0,
            color: Colors.white,
            fontFamily: 'SawarabiGothic',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _voteButton(
    BuildContext context,
    int playerId,
    int votetargetId,
    AudioCache soundEffect,
    double seVolume,
  ) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: ElevatedButton(
        child: Text(
          '投票する',
        ),
        style: ElevatedButton.styleFrom(
          primary: Colors.blue.shade700,
          textStyle: Theme.of(context).textTheme.button,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: () async {
          soundEffect.play(
            'sounds/tap.mp3',
            isNotification: true,
            volume: seVolume,
          );
          AwesomeDialog(
            context: context,
            dialogType: DialogType.NO_HEADER,
            headerAnimationLoop: false,
            animType: AnimType.SCALE,
            width: MediaQuery.of(context).size.width * .86 > 650 ? 650 : null,
            body: ConfirmVoteModal(
              playerId,
              votetargetId,
            ),
          )..show();
        },
      ),
    );
  }
}

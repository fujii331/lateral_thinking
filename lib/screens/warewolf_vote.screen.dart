import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

import '../providers/quiz.provider.dart';
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

    final confirmFlg = useState<bool>(true);
    final voteTimeFlg = useState<bool>(false);

    return Scaffold(
      body: Stack(
        children: <Widget>[
          background(),
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
                                        voteTimeFlg.value = true;
                                      }
                                    : () {},
                                child: Text(
                                  '投票に進む',
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
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(
                              bottom: 10,
                            ),
                            child: Text(
                              '人狼だと思う人に投票',
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'SawarabiGothic',
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
                                    int.parse(numOfPlayers) > 3
                                        ? playerId != 4
                                            ? _labelContent(player4.name)
                                            : Container()
                                        : Container(),
                                    int.parse(numOfPlayers) > 4
                                        ? playerId != 5
                                            ? _labelContent(player5.name)
                                            : Container()
                                        : Container(),
                                    int.parse(numOfPlayers) > 5
                                        ? playerId != 6
                                            ? _labelContent(player6.name)
                                            : Container()
                                        : Container(),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.only(left: 28.0),
                                child: Column(
                                  children: <Widget>[
                                    _voteButton(
                                      context,
                                      playerId,
                                      1,
                                      soundEffect,
                                    ),
                                    _voteButton(
                                      context,
                                      playerId,
                                      2,
                                      soundEffect,
                                    ),
                                    _voteButton(
                                      context,
                                      playerId,
                                      3,
                                      soundEffect,
                                    ),
                                    int.parse(numOfPlayers) > 3
                                        ? _voteButton(
                                            context,
                                            playerId,
                                            4,
                                            soundEffect,
                                          )
                                        : Container(),
                                    int.parse(numOfPlayers) > 4
                                        ? _voteButton(
                                            context,
                                            playerId,
                                            5,
                                            soundEffect,
                                          )
                                        : Container(),
                                    int.parse(numOfPlayers) > 5
                                        ? _voteButton(
                                            context,
                                            playerId,
                                            6,
                                            soundEffect,
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
        ],
      ),
    );
  }

  Widget _labelContent(
    String text,
  ) {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: Container(
        height: 35,
        child: Text(
          text,
          style: TextStyle(
            fontSize: 20.0,
            color: Colors.white,
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
  ) {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: ElevatedButton(
        child: Text(
          '投票する',
        ),
        style: ElevatedButton.styleFrom(
          primary: Colors.blue,
          textStyle: Theme.of(context).textTheme.button,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: () async {
          soundEffect.play('sounds/tap.mp3', isNotification: true);
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

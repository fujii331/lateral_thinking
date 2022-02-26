import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';

import '../providers/common.provider.dart';
import '../providers/werewolf.provider.dart';

import '../widgets/background.widget.dart';
import './werewolf_setting.screen.dart';
import '../../models/werewolf.model.dart';

class WerewolfSummaryResultScreen extends HookWidget {
  static const routeName = '/werewolf-summary-result';

  @override
  Widget build(BuildContext context) {
    final AudioCache soundEffect = useProvider(soundEffectProvider).state;
    final numOfPlayers = useProvider(numOfPlayersProvider).state;
    final double seVolume = useProvider(seVolumeProvider).state;

    final player1 = useProvider(player1Provider).state;
    final player2 = useProvider(player2Provider).state;
    final player3 = useProvider(player3Provider).state;
    final player4 = useProvider(player4Provider).state;
    final player5 = useProvider(player5Provider).state;
    final player6 = useProvider(player6Provider).state;

    final loadedFlg = useState<bool>(false);

    int mostHighestPoint = player1.point;
    List<int> mostHighestPointIdList = [1];

    if (player2.point >= mostHighestPoint) {
      if (player2.point == mostHighestPoint) {
        mostHighestPointIdList.add(2);
      } else {
        mostHighestPoint = player2.point;
        mostHighestPointIdList = [2];
      }
    }
    if (player3.point >= mostHighestPoint) {
      if (player3.point == mostHighestPoint) {
        mostHighestPointIdList.add(3);
      } else {
        mostHighestPoint = player3.point;
        mostHighestPointIdList = [3];
      }
    }
    if (int.parse(numOfPlayers) > 3 && player4.point >= mostHighestPoint) {
      if (player4.point == mostHighestPoint) {
        mostHighestPointIdList.add(4);
      } else {
        mostHighestPoint = player4.point;
        mostHighestPointIdList = [4];
      }
    }
    if (int.parse(numOfPlayers) > 4 && player5.point >= mostHighestPoint) {
      if (player5.point == mostHighestPoint) {
        mostHighestPointIdList.add(5);
      } else {
        mostHighestPoint = player5.point;
        mostHighestPointIdList = [5];
      }
    }
    if (int.parse(numOfPlayers) > 5 && player6.point >= mostHighestPoint) {
      if (player6.point == mostHighestPoint) {
        mostHighestPointIdList.add(6);
      } else {
        mostHighestPointIdList = [6];
      }
    }

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            background(),
            Container(
              padding: const EdgeInsets.only(top: 40),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color.fromRGBO(0, 0, 0, 0.6),
              ),
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.only(
                          left: 20,
                          right: 20,
                          top: 15,
                          bottom: 20,
                        ),
                        child: Text(
                          'これまでの集計結果',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Colors.yellow.shade200,
                            fontSize: 28,
                            fontFamily: 'YuseiMagic',
                          ),
                        ),
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.symmetric(vertical: 15.0),
                      //   child: Container(
                      //     alignment: Alignment.center,
                      //     child: loadedFlg.value
                      //         ? AdWidget(ad: myBanner)
                      //         : Container(),
                      //     width: myBanner.size.width.toDouble(),
                      //     height: myBanner.size.height.toDouble(),
                      //   ),
                      // ),
                      _playerResult(
                        player1,
                        mostHighestPointIdList,
                      ),
                      _playerResult(
                        player2,
                        mostHighestPointIdList,
                      ),
                      _playerResult(
                        player3,
                        mostHighestPointIdList,
                      ),
                      int.parse(numOfPlayers) > 3
                          ? _playerResult(
                              player4,
                              mostHighestPointIdList,
                            )
                          : Container(),
                      int.parse(numOfPlayers) > 4
                          ? _playerResult(
                              player5,
                              mostHighestPointIdList,
                            )
                          : Container(),
                      int.parse(numOfPlayers) > 5
                          ? _playerResult(
                              player6,
                              mostHighestPointIdList,
                            )
                          : Container(),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 30,
                        ),
                        child: SizedBox(
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              soundEffect.play(
                                'sounds/tap.mp3',
                                isNotification: true,
                                volume: seVolume,
                              );
                              Navigator.popUntil(
                                  context,
                                  ModalRoute.withName(
                                      WerewolfSettingScreen.routeName));
                            },
                            child: Text(
                              '設定画面に戻る',
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _playerResult(
    Player player,
    List<int> mostHighestPointIdList,
  ) {
    final bool topFlg = mostHighestPointIdList.contains(player.id);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 245,
        decoration: BoxDecoration(
          color: topFlg ? Colors.yellow.shade100 : Colors.blueGrey.shade100,
          border: Border.all(
            color: topFlg ? Colors.yellow.shade900 : Colors.blueGrey.shade900,
          ),
          borderRadius: BorderRadius.circular(30),
        ),
        child: ListTile(
          leading: Container(
            child: Container(
              width: 110,
              child: Text(
                player.name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.black,
                  fontFamily: 'SawarabiGothic',
                ),
              ),
            ),
          ),
          title: Text(
            player.point.toString() + ' 点',
            style: TextStyle(
              color: Colors.blueGrey.shade900,
              fontSize: 18,
            ),
          ),
          trailing: topFlg
              ? Icon(
                  Icons.flag,
                  color: Colors.yellow.shade900,
                )
              : null,
        ),
      ),
    );
  }
}

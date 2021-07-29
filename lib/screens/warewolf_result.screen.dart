import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'dart:io';

import '../providers/quiz.provider.dart';
import '../providers/warewolf.provider.dart';

import '../widgets/background.widget.dart';
import './warewolf_summary_result.screen.dart';
import '../../models/warewolf.model.dart';
import '../../advertising.dart';

class WarewolfResultScreen extends HookWidget {
  static const routeName = '/warewolf-result';

  @override
  Widget build(BuildContext context) {
    final List args = ModalRoute.of(context)?.settings.arguments as List;
    final List<Player> mostVotedList = args[0];
    final bool wolfVotedFlg = args[1];
    final bool sameVoteFlg = args[2];

    final int wolfId = useProvider(wolfIdProvider).state;
    final Vote votingDestination = useProvider(votingDestinationProvider).state;

    final AudioCache soundEffect = useProvider(soundEffectProvider).state;
    final numOfPlayers = useProvider(numOfPlayersProvider).state;
    final answeredPlayerId = useProvider(answeredPlayerIdProvider).state;

    final player1 = useProvider(player1Provider).state;
    final player2 = useProvider(player2Provider).state;
    final player3 = useProvider(player3Provider).state;
    final player4 = useProvider(player4Provider).state;
    final player5 = useProvider(player5Provider).state;
    final player6 = useProvider(player6Provider).state;

    final loadedFlg = useState<bool>(false);

    final votingDestinationNamesList = [
      player1.name,
      player2.name,
      player3.name,
      player4.name,
      player5.name,
      player6.name,
    ];

    int player1Point = player1.point;
    int player2Point = player2.point;
    int player3Point = player3.point;
    int player4Point = player4.point;
    int player5Point = player5.point;
    int player6Point = player6.point;

    final noAnswerFlg = mostVotedList.length == 0;

    // 正解者が出なかった場合は得点は動かない
    if (!noAnswerFlg) {
      // 得点をつける
      if (!wolfVotedFlg) {
        if (wolfId == 1) {
          player1Point += 3;
        } else if (wolfId == 2) {
          player2Point += 3;
        } else if (wolfId == 3) {
          player3Point += 3;
        } else if (wolfId == 4) {
          player4Point += 3;
        } else if (wolfId == 5) {
          player5Point += 3;
        } else if (wolfId == 6) {
          player6Point += 3;
        }
      } else {
        if (wolfId != 1) {
          player1Point += 1;
        } else if (wolfId != 2) {
          player2Point += 1;
        } else if (wolfId != 3) {
          player3Point += 1;
        } else if (wolfId != 4) {
          player4Point += 1;
        } else if (wolfId != 5) {
          player5Point += 1;
        } else if (wolfId != 6) {
          player6Point += 1;
        }
      }

      if (answeredPlayerId == 1) {
        if (wolfId == 1 && !wolfVotedFlg) {
          player1Point += 1;
        } else if (wolfId != 1) {
          player1Point += 2;
        }
      } else if (answeredPlayerId == 2) {
        if (wolfId == 2 && !wolfVotedFlg) {
          player2Point += 1;
        } else if (wolfId != 2) {
          player2Point += 2;
        }
      } else if (wolfId == 3) {
        if (wolfId == 3 && !wolfVotedFlg) {
          player3Point += 1;
        } else if (wolfId != 3) {
          player3Point += 2;
        }
      } else if (wolfId == 4) {
        if (wolfId == 4 && !wolfVotedFlg) {
          player4Point += 1;
        } else if (wolfId != 4) {
          player4Point += 2;
        }
      } else if (wolfId == 5) {
        if (wolfId == 5 && !wolfVotedFlg) {
          player5Point += 1;
        } else if (wolfId != 5) {
          player5Point += 2;
        }
      } else if (wolfId == 6) {
        if (wolfId == 6 && !wolfVotedFlg) {
          player6Point += 1;
        } else if (wolfId != 6) {
          player6Point += 2;
        }
      }

      context.read(player1Provider).state = Player(
        id: 1,
        name: player1.name,
        point: player1Point,
      );

      context.read(player2Provider).state = Player(
        id: 2,
        name: player2.name,
        point: player2Point,
      );

      context.read(player3Provider).state = Player(
        id: 3,
        name: player3.name,
        point: player3Point,
      );
      if (int.parse(numOfPlayers) > 3) {
        context.read(player4Provider).state = Player(
          id: 4,
          name: player4.name,
          point: player4Point,
        );
      }

      if (int.parse(numOfPlayers) > 4) {
        context.read(player5Provider).state = Player(
          id: 5,
          name: player5.name,
          point: player5Point,
        );
      }

      if (int.parse(numOfPlayers) > 5) {
        context.read(player6Provider).state = Player(
          id: 6,
          name: player6.name,
          point: player6Point,
        );
      }
    }

    final BannerAd myBanner = BannerAd(
      adUnitId: Platform.isAndroid
          // ? ANDROID_RESULT_BANNER_ADVID
          // : IOS_RESULT_BANNER_ADVID,
          ? TEST_ANDROID_BANNER_ADVID
          : TEST_IOS_BANNER_ADVID,
      size: AdSize.banner,
      request: AdRequest(),
      listener: AdListener(
        // 広告が正常にロードされたときに呼ばれます。
        onAdLoaded: (Ad ad) {
          // print('バナー広告がロードされました。');
          loadedFlg.value = true;
        },
        // 広告のロードが失敗した際に呼ばれます。
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          // print('バナー広告のロードに失敗しました。: $error');
          ad.dispose();
        },
        // 広告が開かれたときに呼ばれます。
        // onAdOpened: (Ad ad) => print('バナー広告が開かれました。'),
        // 広告が閉じられたときに呼ばれます。
        onAdClosed: (Ad ad) {
          ad.dispose();
          // print('バナー広告が閉じられました。');
        },
        // ユーザーがアプリを閉じるときに呼ばれます。
        onApplicationExit: (Ad ad) => print('ユーザーがアプリを離れました。'),
      ),
    );

    myBanner.load();

    return Scaffold(
      body: Stack(
        children: <Widget>[
          background(),
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  width: double.infinity,
                  child: noAnswerFlg && wolfId == 0
                      ? Text(
                          '人狼がいなかったので引き分け！',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                          ),
                        )
                      : Row(
                          children: [
                            Text(
                              wolfVotedFlg ? '市民チーム' : '人狼',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: wolfVotedFlg ? Colors.green : Colors.red,
                                fontSize: 22,
                              ),
                            ),
                            Text(
                              noAnswerFlg ? 'の負け！' : 'の勝利！',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                              ),
                            ),
                          ],
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    alignment: Alignment.center,
                    child:
                        loadedFlg.value ? AdWidget(ad: myBanner) : Container(),
                    width: myBanner.size.width.toDouble(),
                    height: myBanner.size.height.toDouble(),
                  ),
                ),
                _playerResult(
                  player1,
                  wolfId,
                  votingDestinationNamesList[votingDestination.player1 - 1],
                  mostVotedList,
                  noAnswerFlg,
                  sameVoteFlg,
                ),
                _playerResult(
                  player2,
                  wolfId,
                  votingDestinationNamesList[votingDestination.player2 - 1],
                  mostVotedList,
                  noAnswerFlg,
                  sameVoteFlg,
                ),
                _playerResult(
                  player3,
                  wolfId,
                  votingDestinationNamesList[votingDestination.player3 - 1],
                  mostVotedList,
                  noAnswerFlg,
                  sameVoteFlg,
                ),
                int.parse(numOfPlayers) > 3
                    ? _playerResult(
                        player4,
                        wolfId,
                        votingDestinationNamesList[
                            votingDestination.player4 - 1],
                        mostVotedList,
                        noAnswerFlg,
                        sameVoteFlg,
                      )
                    : Container(),
                int.parse(numOfPlayers) > 4
                    ? _playerResult(
                        player5,
                        wolfId,
                        votingDestinationNamesList[
                            votingDestination.player5 - 1],
                        mostVotedList,
                        noAnswerFlg,
                        sameVoteFlg,
                      )
                    : Container(),
                int.parse(numOfPlayers) > 5
                    ? _playerResult(
                        player6,
                        wolfId,
                        votingDestinationNamesList[
                            votingDestination.player6 - 1],
                        mostVotedList,
                        noAnswerFlg,
                        sameVoteFlg,
                      )
                    : Container(),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 50,
                  ),
                  child: SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        soundEffect.play('sounds/tap.mp3',
                            isNotification: true);
                        Navigator.of(context).pushNamed(
                          WarewolfSummaryResultScreen.routeName,
                          arguments: wolfVotedFlg,
                        );
                      },
                      child: Text(
                        '集計結果へ',
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
          ),
        ],
      ),
    );
  }

  Widget _playerResult(
    Player player,
    int wolfId,
    String votingDestinationName,
    List<Player> mostVotedList,
    bool noAnswerFlg,
    bool sameVoteFlg,
  ) {
    final bool wolfFlg = player.id == wolfId;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        leading: Container(
          padding: EdgeInsets.only(top: 5, bottom: 15, left: 5, right: 5),
          child: Text(
            player.name,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.white,
            ),
          ),
        ),
        title: Row(
          children: [
            Text(
              '役職: ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
            Text(
              wolfFlg ? '人狼' : '市民',
              style: TextStyle(
                color: wolfFlg ? Colors.red : Colors.green,
                fontSize: 12,
              ),
            ),
          ],
        ),
        subtitle: Text(
          noAnswerFlg ? '投票なし' : '投票先: ' + votingDestinationName,
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
          ),
        ),
        trailing: mostVotedList.contains(player.id) && !sameVoteFlg
            ? Image.asset(
                'assets/images/judge_2.png',
                height: 50,
              )
            : null,
        tileColor: wolfFlg ? Colors.red.shade200 : Colors.green.shade200,
      ),
    );
  }
}

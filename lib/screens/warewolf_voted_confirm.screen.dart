import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'dart:io';

import '../providers/common.provider.dart';
import '../providers/warewolf.provider.dart';
import '../../models/warewolf.model.dart';
import '../../advertising.dart';

import '../widgets/background.widget.dart';
import './warewolf_result.screen.dart';
import '../widgets/warewolf/judging_modal.widget.dart';

class WarewolfVotedConfirmScreen extends HookWidget {
  static const routeName = '/warewolf-voted-confirm';

  void _createInterstitialAd(
    ValueNotifier<InterstitialAd?> myInterstitial,
    ValueNotifier<int> numInterstitialLoadAttempts,
  ) {
    InterstitialAd.load(
      adUnitId: Platform.isAndroid
          ? ANDROID_WAREWOLF_INTERSTITIAL_ADVID
          : IOS_WAREWOLF_INTERSTITIAL_ADVID,
      // ? TEST_ANDROID_INTERSTITIAL_ADVID
      // : TEST_IOS_INTERSTITIAL_ADVID, //InterstitialAd.testAdUnitId
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          myInterstitial.value = ad;
          numInterstitialLoadAttempts.value = 0;
          myInterstitial.value!.setImmersiveMode(true);
        },
        onAdFailedToLoad: (LoadAdError error) {
          numInterstitialLoadAttempts.value += 1;
          myInterstitial.value = null;
          if (numInterstitialLoadAttempts.value <= 3) {
            _createInterstitialAd(
              myInterstitial,
              numInterstitialLoadAttempts,
            );
          }
        },
      ),
    );
  }

  void _showInterstitialAd(
    InterstitialAd? myInterstitialValue,
  ) {
    if (myInterstitialValue == null) {
      return;
    }
    myInterstitialValue.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        ad.dispose();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        ad.dispose();
      },
    );
    myInterstitialValue.show();
    myInterstitialValue = null;
  }

  @override
  Widget build(BuildContext context) {
    final int wolfId = useProvider(wolfIdProvider).state;
    final Vote vote = useProvider(voteProvider).state;
    final String numOfPlayers = useProvider(numOfPlayersProvider).state;
    final AudioCache soundEffect = useProvider(soundEffectProvider).state;
    final double seVolume = useProvider(seVolumeProvider).state;
    final answeredPlayerId = useProvider(answeredPlayerIdProvider).state;
    final double bgmVolume = useProvider(bgmVolumeProvider).state;
    final Vote votingDestination = useProvider(votingDestinationProvider).state;

    final player1 = useProvider(player1Provider).state;
    final player2 = useProvider(player2Provider).state;
    final player3 = useProvider(player3Provider).state;
    final player4 = useProvider(player4Provider).state;
    final player5 = useProvider(player5Provider).state;
    final player6 = useProvider(player6Provider).state;

    final numInterstitialLoadAttempts = useState(0);

    final ValueNotifier<InterstitialAd?> myInterstitial = useState(null);

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
                                _createInterstitialAd(
                                  myInterstitial,
                                  numInterstitialLoadAttempts,
                                );
                                soundEffect.play(
                                  'sounds/tap.mp3',
                                  isNotification: true,
                                  volume: seVolume,
                                );
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

                                // 点数を計算
                                int player1Point = player1.point;
                                int player2Point = player2.point;
                                int player3Point = player3.point;
                                int player4Point = player4.point;
                                int player5Point = player5.point;
                                int player6Point = player6.point;

                                // 正解者が出なかった場合は得点は動かない
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
                                    if (votingDestination.player1 == wolfId) {
                                      player1Point += 2;
                                    } else {
                                      player1Point += 1;
                                    }
                                  }
                                  if (wolfId != 2) {
                                    if (votingDestination.player2 == wolfId) {
                                      player2Point += 2;
                                    } else {
                                      player2Point += 1;
                                    }
                                  }
                                  if (wolfId != 3) {
                                    if (votingDestination.player3 == wolfId) {
                                      player3Point += 2;
                                    } else {
                                      player3Point += 1;
                                    }
                                  }
                                  if (int.parse(numOfPlayers) > 3 &&
                                      wolfId != 4) {
                                    if (votingDestination.player4 == wolfId) {
                                      player4Point += 2;
                                    } else {
                                      player4Point += 1;
                                    }
                                  }
                                  if (int.parse(numOfPlayers) > 4 &&
                                      wolfId != 5) {
                                    if (votingDestination.player5 == wolfId) {
                                      player5Point += 2;
                                    } else {
                                      player5Point += 1;
                                    }
                                  }
                                  if (int.parse(numOfPlayers) > 5 &&
                                      wolfId != 6) {
                                    if (votingDestination.player6 == wolfId) {
                                      player6Point += 2;
                                    } else {
                                      player6Point += 1;
                                    }
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

                                context.read(bgmProvider).state =
                                    await soundEffect.loop(
                                  'sounds/bgm.mp3',
                                  volume: 0,
                                  isNotification: true,
                                );

                                if (myInterstitial.value != null) {
                                  _showInterstitialAd(myInterstitial.value);
                                }

                                await new Future.delayed(
                                  new Duration(milliseconds: 700),
                                );

                                context.read(bgmProvider).state.setVolume(
                                    context.read(bgmVolumeProvider).state);

                                // 結果画面に移行
                                Navigator.of(context).pushReplacementNamed(
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
                          primary: Colors.blue.shade900,
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
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'dart:io';

import '../providers/common.provider.dart';
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
    final List<Player> mostVotedList = args[0] as List<Player>;
    final bool wolfVotedFlg = args[1];
    final bool sameVoteFlg = args[2];

    final int wolfId = useProvider(wolfIdProvider).state;
    final Vote votingDestination = useProvider(votingDestinationProvider).state;

    final AudioCache soundEffect = useProvider(soundEffectProvider).state;
    final numOfPlayers = useProvider(numOfPlayersProvider).state;
    final double seVolume = useProvider(seVolumeProvider).state;

    final widthSetting = MediaQuery.of(context).size.width > 400.0
        ? 400.0
        : MediaQuery.of(context).size.width;

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
    final noAnswerFlg = mostVotedList[0].id == 0;

    final List<int> mostVotedListIds = mostVotedList.map((player) {
      return player.id;
    }).toList();

    // final BannerAd myBanner = BannerAd(
    //   adUnitId: Platform.isAndroid
    //       // ? ANDROID_RESULT_BANNER_ADVID
    //       // : IOS_RESULT_BANNER_ADVID,
    //       ? TEST_ANDROID_BANNER_ADVID
    //       : TEST_IOS_BANNER_ADVID,
    //   size: AdSize.banner,
    //   request: AdRequest(),
    //   listener: AdListener(
    //     // 広告が正常にロードされたときに呼ばれます。
    //     onAdLoaded: (Ad ad) {
    //       // print('バナー広告がロードされました。');
    //       loadedFlg.value = true;
    //     },
    //     // 広告のロードが失敗した際に呼ばれます。
    //     onAdFailedToLoad: (Ad ad, LoadAdError error) {
    //       // print('バナー広告のロードに失敗しました。: $error');
    //       ad.dispose();
    //     },
    //     // 広告が開かれたときに呼ばれます。
    //     // onAdOpened: (Ad ad) => print('バナー広告が開かれました。'),
    //     // 広告が閉じられたときに呼ばれます。
    //     onAdClosed: (Ad ad) {
    //       ad.dispose();
    //       // print('バナー広告が閉じられました。');
    //     },
    //     // ユーザーがアプリを閉じるときに呼ばれます。
    //     onApplicationExit: (Ad ad) => print('ユーザーがアプリを離れました。'),
    //   ),
    // );

    // myBanner.load();

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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.only(
                          left: 20,
                          right: 20,
                          top: 15,
                          bottom: 20,
                        ),
                        child: Center(
                          child: noAnswerFlg && wolfId == 0
                              ? Text(
                                  '人狼いないので引き分け！',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 26,
                                    fontFamily: 'YuseiMagic',
                                  ),
                                )
                              : wolfId == 0 && !wolfVotedFlg
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          '残念ながら',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 30,
                                            fontFamily: 'YuseiMagic',
                                          ),
                                        ),
                                        Text(
                                          '平和村',
                                          style: TextStyle(
                                            color: Colors.red.shade300,
                                            fontSize: 30,
                                            fontFamily: 'YuseiMagic',
                                            decoration:
                                                TextDecoration.underline,
                                          ),
                                        ),
                                        Text(
                                          'でした',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 30,
                                            fontFamily: 'YuseiMagic',
                                          ),
                                        ),
                                      ],
                                    )
                                  : wolfId == 0 && wolfVotedFlg
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              '平和村',
                                              style: TextStyle(
                                                color: Colors.green.shade300,
                                                fontSize: 30,
                                                fontFamily: 'YuseiMagic',
                                              ),
                                            ),
                                            Text(
                                              'なので全員勝利！',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 30,
                                              ),
                                            ),
                                          ],
                                        )
                                      : Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              wolfVotedFlg ? '市民チーム' : '人狼',
                                              style: TextStyle(
                                                  color: wolfVotedFlg
                                                      ? Colors.green.shade300
                                                      : Colors.red.shade300,
                                                  fontSize: 30,
                                                  fontFamily: 'YuseiMagic',
                                                  decoration:
                                                      TextDecoration.underline),
                                            ),
                                            Text(
                                              noAnswerFlg ||
                                                      (wolfId == 0 &&
                                                          !wolfVotedFlg)
                                                  ? 'の負け！'
                                                  : 'の勝利！',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 30,
                                                fontFamily: 'YuseiMagic',
                                              ),
                                            ),
                                          ],
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
                        wolfId,
                        votingDestinationNamesList[
                            votingDestination.player1 - 1],
                        mostVotedListIds,
                        noAnswerFlg,
                        sameVoteFlg,
                        widthSetting,
                      ),
                      _playerResult(
                        player2,
                        wolfId,
                        votingDestinationNamesList[
                            votingDestination.player2 - 1],
                        mostVotedListIds,
                        noAnswerFlg,
                        sameVoteFlg,
                        widthSetting,
                      ),
                      _playerResult(
                        player3,
                        wolfId,
                        votingDestinationNamesList[
                            votingDestination.player3 - 1],
                        mostVotedListIds,
                        noAnswerFlg,
                        sameVoteFlg,
                        widthSetting,
                      ),
                      int.parse(numOfPlayers) > 3
                          ? _playerResult(
                              player4,
                              wolfId,
                              votingDestinationNamesList[
                                  votingDestination.player4 - 1],
                              mostVotedListIds,
                              noAnswerFlg,
                              sameVoteFlg,
                              widthSetting,
                            )
                          : Container(),
                      int.parse(numOfPlayers) > 4
                          ? _playerResult(
                              player5,
                              wolfId,
                              votingDestinationNamesList[
                                  votingDestination.player5 - 1],
                              mostVotedListIds,
                              noAnswerFlg,
                              sameVoteFlg,
                              widthSetting,
                            )
                          : Container(),
                      int.parse(numOfPlayers) > 5
                          ? _playerResult(
                              player6,
                              wolfId,
                              votingDestinationNamesList[
                                  votingDestination.player6 - 1],
                              mostVotedListIds,
                              noAnswerFlg,
                              sameVoteFlg,
                              widthSetting,
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
                              Navigator.of(context).pushNamed(
                                WarewolfSummaryResultScreen.routeName,
                              );
                            },
                            child: Text(
                              '集計結果へ',
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
    int wolfId,
    String votingDestinationName,
    List<int> mostVotedListIds,
    bool noAnswerFlg,
    bool sameVoteFlg,
    double widthSetting,
  ) {
    final bool wolfFlg = player.id == wolfId;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: widthSetting,
        decoration: BoxDecoration(
          color: wolfFlg ? Colors.red.shade100 : Colors.green.shade100,
          border: Border.all(
            color: wolfFlg ? Colors.red.shade900 : Colors.green.shade900,
          ),
          borderRadius: BorderRadius.circular(30),
        ),
        child: ListTile(
          leading: Container(
            padding: const EdgeInsets.only(top: 6.0),
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
          title: Row(
            children: [
              Text(
                '役職：',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 17,
                ),
              ),
              Text(
                wolfFlg ? '人狼' : '市民',
                style: TextStyle(
                  color: wolfFlg ? Colors.red.shade900 : Colors.green.shade900,
                  fontSize: 18,
                  fontFamily: 'SawarabiGothic',
                  fontWeight: FontWeight.bold,
                ),
              ),
              mostVotedListIds.contains(player.id) && !sameVoteFlg
                  ? Padding(
                      padding: const EdgeInsets.only(
                        top: 2.0,
                        left: 10.0,
                      ),
                      child: Image.asset(
                        'assets/images/judge_2.png',
                        height: 24,
                        width: 24,
                      ),
                    )
                  : SizedBox(),
            ],
          ),
          subtitle: Wrap(
            children: [
              Text(
                noAnswerFlg ? '投票なし' : '投票先：',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 17,
                ),
              ),
              Text(
                votingDestinationName,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 17,
                  fontFamily: 'SawarabiGothic',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

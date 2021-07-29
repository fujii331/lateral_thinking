import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'dart:io';

import '../providers/quiz.provider.dart';
import '../providers/warewolf.provider.dart';

import '../widgets/background.widget.dart';
import './warewolf_setting.screen.dart';
import '../../models/warewolf.model.dart';
import '../../advertising.dart';

class WarewolfSummaryResultScreen extends HookWidget {
  static const routeName = '/warewolf-summary-result';

  @override
  Widget build(BuildContext context) {
    final bool wolfVotedFlg =
        ModalRoute.of(context)?.settings.arguments as bool;

    final AudioCache soundEffect = useProvider(soundEffectProvider).state;
    final numOfPlayers = useProvider(numOfPlayersProvider).state;

    final player1 = useProvider(player1Provider).state;
    final player2 = useProvider(player2Provider).state;
    final player3 = useProvider(player3Provider).state;
    final player4 = useProvider(player4Provider).state;
    final player5 = useProvider(player5Provider).state;
    final player6 = useProvider(player6Provider).state;

    final loadedFlg = useState<bool>(false);

    final BannerAd myBanner = BannerAd(
      adUnitId: Platform.isAndroid
          // ? ANDROID_SUMMARY_RESULT_BANNER_ADVID
          // : IOS_SUMMARY_RESULT_BANNER_ADVID,
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
                  child: Text(
                    'これまでの集計結果',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: wolfVotedFlg ? Colors.green : Colors.red,
                      fontSize: 22,
                    ),
                  ),
                ),
                _playerResult(
                  player1,
                ),
                _playerResult(
                  player2,
                ),
                _playerResult(
                  player3,
                ),
                int.parse(numOfPlayers) > 3
                    ? _playerResult(
                        player4,
                      )
                    : Container(),
                int.parse(numOfPlayers) > 4
                    ? _playerResult(
                        player5,
                      )
                    : Container(),
                int.parse(numOfPlayers) > 5
                    ? _playerResult(
                        player6,
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
                          WarewolfSettingScreen.routeName,
                        );
                      },
                      child: Text(
                        '設定画面に戻る',
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
  ) {
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
        title: Text(
          player.point.toString() + ' 点',
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
          ),
        ),
        tileColor: Colors.white,
      ),
    );
  }
}

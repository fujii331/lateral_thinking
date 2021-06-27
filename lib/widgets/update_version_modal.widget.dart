import 'dart:io';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdateVersionModal extends StatelessWidget {
  void _launchURL(
    String url,
    bool isJapanese,
  ) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw isJapanese
          ? '申し訳ありません。ストア情報が取得できませんでした。直接ストアより更新をお願いします。'
          : 'Sorry, Could not launch store url. Please update directly at store.';
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isJapanese = Localizations.localeOf(context).toString() == 'ja';
    const APP_STORE_URL = 'https://apps.apple.com/jp/app/id1572443299';
    const PLAY_STORE_URL =
        'https://play.google.com/store/apps/details?id=io.github.naoto613.lateral_thinking';

    return new WillPopScope(
      onWillPop: () async => false,
      child: Padding(
        padding: const EdgeInsets.only(
          left: 15,
          right: 15,
          bottom: 15,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 10,
              ),
              child: Text(
                isJapanese ? "バージョン更新のお知らせ" : 'Notice of version update',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'SawarabiGothic',
                ),
              ),
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 15,
                  bottom: 10,
                ),
                child: Text(
                  isJapanese
                      ? "新しいバージョンのアプリが利用可能です。\nストアより更新版を入手してご利用下さい。"
                      : 'A new version of the app is available. Please obtain the updated version from the store.',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontFamily: 'SawarabiGothic',
                  ),
                ),
              ),
            ),
            Row(
              children: [
                SizedBox(),
                Spacer(),
                TextButton(
                  child: Text(isJapanese ? "今すぐ更新" : 'Update now'),
                  style: TextButton.styleFrom(
                    primary: Colors.orange.shade800,
                  ),
                  onPressed: () => {
                    _launchURL(
                      Platform.isIOS ? APP_STORE_URL : PLAY_STORE_URL,
                      isJapanese,
                    ),
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

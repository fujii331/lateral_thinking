import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:lateral_thinking/widgets/reply_modal.widget.dart';
import 'package:url_launcher/url_launcher.dart';

class NextAppLink extends StatelessWidget {
  final BuildContext context;

  const NextAppLink({
    Key? key,
    required this.context,
  }) : super(key: key);

  void _launchURL(
    String url,
  ) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.NO_HEADER,
        headerAnimationLoop: false,
        dismissOnTouchOutside: true,
        dismissOnBackKeyPress: true,
        showCloseIcon: true,
        animType: AnimType.SCALE,
        width: MediaQuery.of(context).size.width * .86 > 550 ? 550 : null,
        body: ReplyModal(
          '申し訳ありません。ストア情報が取得できませんでした。',
          0,
        ),
      ).show();
    }
  }

  @override
  Widget build(BuildContext context) {
    final String storeUrl = Platform.isAndroid
        ? 'https://play.google.com/store/apps/details?id=io.github.naoto613.king_of_lateral_thinking_2'
        : 'https://apps.apple.com/app/id1606486849';

    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Row(
        children: [
          Column(
            children: [
              const Text(
                '続編!',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'KaiseiOpti',
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              InkWell(
                onTap: () => _launchURL(storeUrl),
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey.shade500,
                      width: 2,
                    ),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(50),
                    ),
                  ),
                  child: Image.asset(
                    'assets/images/king_2.png',
                  ),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '↑ストアへ',
                style: TextStyle(
                  color: Colors.yellow.shade50,
                  fontFamily: 'KaiseiOpti',
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const Spacer(),
          const SizedBox(),
        ],
      ),
    );
  }
}

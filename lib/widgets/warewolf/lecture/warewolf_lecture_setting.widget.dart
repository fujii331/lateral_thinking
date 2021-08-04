import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../background.widget.dart';

class WarewolfLectureSetting extends HookWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        background(),
        Center(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Color.fromRGBO(0, 0, 0, 0.6),
            ),
            width: MediaQuery.of(context).size.width * .92,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: Text(
                        'ゲーム前に設定する項目',
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.yellow.shade200,
                          fontFamily: 'NotoSerifJP',
                          fontWeight: FontWeight.bold,
                          height: 1.7,
                        ),
                      ),
                    ),
                    _eachItemExplain(
                      '問題の種類（謎解きの王様・オリジナル）',
                      '一人用プレイで解放した問題で遊ぶか、ネットや本で自分で見つけた問題を入力して遊ぶかの違いです。',
                    ),
                    _eachItemExplain(
                      '使う問題（クイズのタイトル）',
                      '問題の種類に「謎解きの王様」を選択した場合に遊ぶクイズを選択します。',
                    ),
                    _eachItemExplain(
                      '回答者の数（3~6人）',
                      '回答する人の人数です。\nこの人数とは別に出題者が一人必要です。',
                    ),
                    _eachItemExplain(
                      'メイン時間（2~6分）',
                      '出題されたクイズに対して質問を行い、正解を導くための制限時間です。',
                    ),
                    _eachItemExplain(
                      '質問時間（5~20秒・なし）',
                      '順番に質問する際の制限時間です。\n市民が全く質問しなければ人狼が不利になるため用意しました。\n「なし」の場合、このシステムを使わずに遊ぶこともできます。',
                    ),
                    _eachItemExplain(
                      '会議時間（0~5分）',
                      'クイズに正解者が出た場合に誰が人狼なのかを議論する時間です。\n0分に設定すると議論なしで投票に移ります。',
                    ),
                    _eachItemExplain(
                      '平和村（なし・あり）',
                      '「なし」の場合は必ず一人人狼がいて、「あり」の場合は誰も人狼ではない時があります。',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _eachItemExplain(
    String label,
    String text,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.blue.shade200,
              height: 1.7,
            ),
          ),
          Text(
            text,
            style: TextStyle(
              fontSize: 17.0,
              color: Colors.white,
              fontFamily: 'NotoSerifJP',
              height: 1.7,
            ),
          ),
        ],
      ),
    );
  }
}

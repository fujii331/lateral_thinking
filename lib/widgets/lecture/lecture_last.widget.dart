import 'package:flutter/material.dart';

import '../background.widget.dart';

class LectureLast extends StatelessWidget {
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
            child: Container(
              height: MediaQuery.of(context).size.height * .75,
              width: MediaQuery.of(context).size.width * .88,
              margin: EdgeInsets.all(5),
              child: Column(
                children: [
                  Text('・主語は本文にある、または、関係する”名詞”を選ぶと良いです。\n'),
                  Text('・関連語は名詞・形容詞以外にも本文にある「帰って」「寄って」などの単語も選択肢になることがあります。\n'),
                  Text('・質問は入力した言葉を必ず含むので、質問文からイメージしましょう。\n'),
                  Text('・一度実行した質問や回答はもう表示されません。\n'),
                  Text('・質問をするほど回答の選択肢は増えるのでとにかく質問してみましょう。\n'),
                  Text(
                    'どうぞ、謎解きの館をお楽しみください！\n',
                    style: TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

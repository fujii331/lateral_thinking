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
            height: MediaQuery.of(context).size.height * .75,
            width: MediaQuery.of(context).size.width * .88,
            margin: EdgeInsets.all(5),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    '・主語は本文にある、または、関係する”名詞”を選ぶと良いです。\n',
                    style: Theme.of(context).textTheme.headline1,
                  ),
                  Text(
                    '・関連語は名詞・形容詞以外にも本文にある「帰って」「寄って」などの単語も選択肢になることがあります。\n',
                    style: Theme.of(context).textTheme.headline1,
                  ),
                  Text(
                    '・質問は入力した言葉を必ず含むので、質問文からイメージしましょう。\n',
                    style: Theme.of(context).textTheme.headline1,
                  ),
                  Text(
                    '・質問をするほど回答の選択肢は増えるのでどんどん質問してみましょう。\n',
                    style: Theme.of(context).textTheme.headline1,
                  ),
                  Text(
                    'どうぞ、謎解きの館をお楽しみください！\n',
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.white,
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

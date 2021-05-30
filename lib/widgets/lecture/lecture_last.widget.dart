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
                    '・質問は入力した言葉を必ず含むので、質問文からイメージしましょう。\n',
                    style: Theme.of(context).textTheme.headline1,
                  ),
                  Text(
                    '・同じ関連語でも主語を変えてみると質問が出てくる場合もあります。\n',
                    style: Theme.of(context).textTheme.headline1,
                  ),
                  Text(
                    '・質問をするほど回答の選択肢は増えるのでどんどん質問してみましょう。（複数パターンの正解がある場合もあります。）\n',
                    style: Theme.of(context).textTheme.headline1,
                  ),
                  Text(
                    '・関連語に「関係」という言葉を選ぶと、きっかけとしてはいい情報が得られる場合が多いです。\n',
                    style: Theme.of(context).textTheme.headline1,
                  ),
                  Text(
                    'それでは、謎解きの王様をお楽しみください！m(._.)m\n',
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

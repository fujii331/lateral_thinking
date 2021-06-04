import 'package:flutter/material.dart';

import '../background.widget.dart';

class LectureLast extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        background(),
        Center(
          child: Opacity(
            opacity: 0.4,
            child: Image.asset(
              'assets/images/true_4_1.png',
              // width: 130,
            ),
          ),
        ),
        Center(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Color.fromRGBO(0, 0, 0, 0.6),
            ),
            height: MediaQuery.of(context).size.height * .80,
            width: MediaQuery.of(context).size.width * .92,
            margin: EdgeInsets.all(5),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text(
                      '・質問は入力した言葉を必ず含むので、質問文からイメージしましょう。\n',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.white,
                        fontFamily: 'NotoSerifJP',
                        height: 1.7,
                      ),
                    ),
                    Text(
                      '・同じ関連語でも主語を変えてみると質問が出てくる場合もあります。\n',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.white,
                        fontFamily: 'NotoSerifJP',
                        height: 1.7,
                      ),
                    ),
                    Text(
                      '・関連語に「関係」という言葉を選ぶと、きっかけとしてはいい情報が得られる場合が多いです。\n',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.white,
                        fontFamily: 'NotoSerifJP',
                        height: 1.7,
                      ),
                    ),
                    Text(
                      '・主語に「一般の人」という言葉を選ぶと、世間一般の人の場合はどうかについての質問を得られることがあります。\n（例）\n主語：一般の人\n関連語：起こる\n質問：一般の人でも起こることですか？\n',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.yellow,
                        fontFamily: 'NotoSerifJP',
                        height: 1.7,
                      ),
                    ),
                    Text(
                      'それでは、謎解きの王様をお楽しみください！\n',
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        height: 1.7,
                      ),
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
}

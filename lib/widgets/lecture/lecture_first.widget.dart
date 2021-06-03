import 'package:flutter/material.dart';

import '../background.widget.dart';

class LectureFirst extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        background(),
        Opacity(
          opacity: 0.9,
          child: Image.asset(
            'assets/images/1_2.png',
            width: 130,
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
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text(
                      'アプリをダウンロードしていただきありがとうございます！\n',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.white,
                        fontFamily: 'NotoSerifJP',
                        height: 1.7,
                      ),
                    ),
                    Text(
                      '「謎解きの王様　一人用水平思考クイズ」',
                      style: TextStyle(
                        fontSize: 19.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.yellow.shade200,
                        height: 1.7,
                      ),
                    ),
                    Text(
                      'は、ウミガメのスープに代表される水平思考クイズを、一人で遊べる様に作成したものです。\n\nちなみに水平思考クイズとは、問題出題者と回答者に分かれ、回答者は出題されたクイズに対してYESかNOで答えられる質問を行い、答えを推理していくゲームです。\n\n操作について実際の画面で例題を見ながら説明させてください。',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.white,
                        fontFamily: 'NotoSerifJP',
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

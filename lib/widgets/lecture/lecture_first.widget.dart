import 'package:flutter/material.dart';

import '../background.widget.dart';

class LectureFirst extends StatelessWidget {
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
                  Text('アプリをダウンロードしていただきありがとうございます！\n'),
                  Text(
                    '「謎解きの館　一人用水平思考ゲーム」',
                    style: TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.yellow.shade200,
                    ),
                  ),
                  Text(
                      'は、ウミガメのスープに代表される水平思考ゲームを、一人で遊べる様に作成したものです。\n\nちなみに水平思考ゲームとは、問題出題者と回答者に分かれ、回答者は出題されたクイズに対してYESかNOで答えられる質問を行い、答えを推理していくゲームです。\n\n操作について実際の画面で例題を見ながら説明させてください。'),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

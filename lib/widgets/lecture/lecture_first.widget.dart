import 'package:flutter/material.dart';

import '../background.widget.dart';

class LectureFirst extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        background(),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Opacity(
                opacity: 0.5,
                child: Image.asset(
                  'assets/images/1_2.png',
                  width: MediaQuery.of(context).size.width * .6,
                ),
              ),
            ),
            Text(
              '坊やくん',
              style: TextStyle(
                fontSize: 26.0,
                color: Colors.white,
                fontFamily: 'YuseiMagic',
              ),
            ),
          ],
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
                        fontSize: 17.0,
                        color: Colors.white,
                        fontFamily: 'NotoSerifJP',
                        height: 1.7,
                      ),
                    ),
                    Text(
                      '「謎解きの王様　一人用水平思考クイズ」',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.yellow.shade200,
                        height: 1.7,
                      ),
                    ),
                    Text(
                      'は、ウミガメのスープに代表される水平思考クイズを、一人で遊べるように作成したものです。',
                      style: TextStyle(
                        fontSize: 17.0,
                        color: Colors.white,
                        fontFamily: 'NotoSerifJP',
                        height: 1.7,
                      ),
                    ),
                    Text(
                      '\n※水平思考クイズ：YESかNOで答えられる質問を行い、答えを推理していくゲーム',
                      style: TextStyle(
                        fontSize: 15.0,
                        color: Colors.white,
                        fontFamily: 'NotoSerifJP',
                        height: 1.7,
                      ),
                    ),
                    Text(
                      '\nこのゲームでは、城に迷い込んだ「坊やくん」が謎好きの王様にいろいろな謎を出題されて困っているので、彼を手伝ってあげましょう。\n\nでは、下のボタンを押す、またはスワイプ操作で画面を切り替えてみてください。',
                      style: TextStyle(
                        fontSize: 17.0,
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

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class WerewolfLectureFirst extends HookWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
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
                Text(
                  '水平思考人狼へようこそ！\n',
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.white,
                    fontFamily: 'NotoSerifJP',
                    fontWeight: FontWeight.bold,
                    height: 1.7,
                  ),
                ),
                Text(
                  '「水平思考人狼」は、水平思考クイズと人狼ゲームを組み合わせたらおもしろいんじゃないかと思って作ってみた多人数用おまけゲームです。',
                  style: TextStyle(
                    fontSize: 17.0,
                    color: Colors.white,
                    fontFamily: 'NotoSerifJP',
                    height: 1.7,
                  ),
                ),
                Text(
                  '\nこのゲームでは、人狼一人と二人以上の市民が一緒に水平思考クイズを解きますが、人狼だけがクイズの答えをあらかじめ知っています。\n\n人狼は制限時間内に答えが出るように誘導していく必要があり、かつ市民に人狼であることを悟られてはいけません。\n\n市民チームは誰が人狼なのか探りながらクイズの正解を考える必要があります。\n\nでは、「次へ」ボタンを押して操作説明に移りましょう。',
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
    );
  }
}

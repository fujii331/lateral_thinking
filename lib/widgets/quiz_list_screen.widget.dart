import 'package:flutter/material.dart';

import 'quiz_item.widget.dart';
import '../quiz_data.dart';
import './background.widget.dart';

class QuizListScreen extends StatelessWidget {
  static const routeName = '/quiz-list';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('問題一覧'),
        centerTitle: true,
        backgroundColor: Colors.blueGrey[900].withOpacity(0.9),
      ),
      body: Stack(
        children: <Widget>[
          background(),
          Container(
            height: MediaQuery.of(context).size.height * .85,
            margin: EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 15,
            ),
            child: ListView.builder(
              itemBuilder: (ctx, index) {
                // TODO 開放数＋1の分ループを回す。
                // index = 開放数 + 1 >= quizzes.lengthの場合は近日公開のitemを表示
                // index = 開放数 + 1 < quizzes.lengthの場合はを広告用の別のitemを出すように条件分岐する
                return QuizItem(
                  quiz: QUIZ_DATA[index],
                );
              },
              itemCount: QUIZ_DATA.length,
            ),
          ),
        ],
      ),
    );
  }
}

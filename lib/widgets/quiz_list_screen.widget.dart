import 'package:flutter/material.dart';
import '../models/quiz.model.dart';
import 'quiz_item.widget.dart';

class QuizListScreen extends StatelessWidget {
  final List<Quiz> quizzes = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('問題一覧'),
        centerTitle: true,
      ),
      body: Container(
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
              quiz: quizzes[index],
            );
          },
          itemCount: quizzes.length,
        ),
      ),
    );
  }
}

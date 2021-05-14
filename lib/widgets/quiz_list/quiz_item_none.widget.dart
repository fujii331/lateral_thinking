import 'package:flutter/material.dart';

class QuizItemNone extends StatelessWidget {
  final int quizNum;

  QuizItemNone(this.quizNum);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      color: Colors.grey.shade700,
      margin: EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 5,
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
          child: Text(
            '問' + quizNum.toString(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.white60,
            ),
          ),
        ),
        title: Text(
          '近日公開！お楽しみに',
          style: TextStyle(
            color: Colors.white60,
            fontSize: 20,
          ),
        ),
        onTap: () => {},
      ),
    );
  }
}

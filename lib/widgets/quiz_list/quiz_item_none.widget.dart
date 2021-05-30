import 'package:flutter/material.dart';

class QuizItemNone extends StatelessWidget {
  final int quizNum;

  QuizItemNone(this.quizNum);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.grey.shade700,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.black,
        ),
      ),
      margin: EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 5,
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.only(top: 5, bottom: 10, left: 5, right: 5),
          child: Text(
            '問' + quizNum.toString(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.white60,
            ),
          ),
        ),
        title: Container(
          padding: const EdgeInsets.only(top: 5, bottom: 10, right: 5),
          child: Text(
            '近日公開！お楽しみに',
            style: TextStyle(
              color: Colors.white60,
              fontSize: 20,
            ),
          ),
        ),
        onTap: () => {},
      ),
    );
  }
}

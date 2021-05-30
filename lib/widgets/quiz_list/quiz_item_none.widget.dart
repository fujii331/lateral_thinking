import 'package:flutter/material.dart';

class QuizItemNone extends StatelessWidget {
  final int quizNum;

  QuizItemNone(this.quizNum);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Container(
      height: height > 620 ? 52 : 44,
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
          padding: EdgeInsets.only(
              top: height > 620 ? 5 : 0,
              bottom: height > 620 ? 10 : 15,
              left: 5,
              right: 5),
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
          padding: EdgeInsets.only(
              top: height > 620 ? 5 : 0,
              bottom: height > 620 ? 10 : 15,
              right: 5),
          child: Text(
            '近日公開！お楽しみに',
            style: TextStyle(
              color: Colors.white60,
              fontSize: 20,
            ),
          ),
        ),
        onTap: null,
      ),
    );
  }
}

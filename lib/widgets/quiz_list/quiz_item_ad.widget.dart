import 'package:flutter/material.dart';

import '../../models/quiz.model.dart';

class QuizItemAd extends StatelessWidget {
  final Quiz quiz;

  QuizItemAd(this.quiz);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Container(
      height: height > 620 ? 52 : 45,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.black,
        ),
      ),
      margin: EdgeInsets.symmetric(
        vertical: height > 620 ? 8 : 6,
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
            '問' + quiz.id.toString(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.purple[800],
            ),
          ),
        ),
        title: Container(
          padding: EdgeInsets.only(
              top: height > 620 ? 5 : 0,
              bottom: height > 620 ? 10 : 15,
              right: 5),
          child: Text(
            quiz.title,
            style: TextStyle(
              fontSize: 20,
            ),
          ),
        ),
        onTap: null,
      ),
    );
  }
}

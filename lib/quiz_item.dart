import 'package:flutter/material.dart';
import 'models/quiz.dart';

class QuizItem extends StatelessWidget {
  const QuizItem({
    Key key,
    @required this.quiz,
  }) : super(key: key);

  final Quiz quiz;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 5,
      ),
      child: ListTile(
        leading: Container(
          padding: EdgeInsets.all(10),
          child: Text(
            '問' + quiz.id.toString(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.purple,
            ),
          ),
        ),
        title: Text(
          quiz.title,
          style: TextStyle(
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}

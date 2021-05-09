import 'package:flutter/material.dart';
import '../models/quiz.model.dart';
import '../screens/quiz_detail.screen.dart';

class QuizItem extends StatelessWidget {
  final Quiz quiz;

  QuizItem(this.quiz);

  void toQuizDetail(BuildContext ctx) {
    Navigator.of(ctx).pushNamed(
      QuizDetailScreen.routeName,
      arguments: quiz,
    );
  }

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
              color: Colors.purple[800],
            ),
          ),
        ),
        title: Text(
          quiz.title,
          style: TextStyle(
            fontSize: 20,
          ),
        ),
        onTap: () => toQuizDetail(context),
      ),
    );
  }
}

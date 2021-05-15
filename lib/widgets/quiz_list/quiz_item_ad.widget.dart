import 'package:flutter/material.dart';

import './advertising_modal.widget.dart';
import '../../models/quiz.model.dart';

class QuizItemAd extends StatelessWidget {
  final Quiz quiz;

  QuizItemAd(this.quiz);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      color: Colors.grey,
      margin: EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 5,
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
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
        onTap: () => showDialog<int>(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext context) {
            return AdvertisingModal(quiz.id);
          },
        ),
      ),
    );
  }
}

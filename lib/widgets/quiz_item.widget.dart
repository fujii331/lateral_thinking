import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../models/quiz.model.dart';
import '../screens/quiz_detail_tab.screen.dart';
import '../providers/quiz.provider.dart';

class QuizItem extends StatelessWidget {
  final Quiz quiz;

  QuizItem(this.quiz);

  void toQuizDetail(BuildContext ctx) {
    ctx.read(remainingQuestionsProvider).state = quiz.questions;
    ctx.read(askedQuestionsProvider).state = [];
    ctx.read(allAnswersProvider).state = quiz.answers;
    ctx.read(executedAnswerIdsProvider).state = [];
    ctx.read(correctAnswerIdsProvider).state = quiz.correctAnswerIds;
    ctx.read(hintProvider).state = 0;

    ctx.read(replyProvider).state = '';
    ctx.read(beforeWordProvider).state = '';
    ctx.read(displayReplyFlgProvider).state = false;
    ctx.read(selectedSubjectProvider).state = '';
    ctx.read(selectedRelatedWordProvider).state = '';
    ctx.read(askQuestionsProvider).state = [];

    Navigator.of(ctx).pushNamed(
      QuizDetailTabScreen.routeName,
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
        onTap: () => toQuizDetail(context),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:audioplayers/audio_cache.dart';

import '../../models/quiz.model.dart';
import '../../screens/quiz_detail_tab.screen.dart';
import '../../providers/quiz.provider.dart';

class QuizItem extends HookWidget {
  final Quiz quiz;

  QuizItem(this.quiz);

  void toQuizDetail(BuildContext ctx, AudioCache soundEffect) {
    soundEffect.play('sounds/tap.mp3', isNotification: true);

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
    ctx.read(askingQuestionsProvider).state = [];

    Navigator.of(ctx).pushNamed(QuizDetailTabScreen.routeName, arguments: quiz);
  }

  @override
  Widget build(BuildContext context) {
    final AudioCache soundEffect = useProvider(soundEffectProvider).state;

    return Container(
      height: 54,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
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
            '問' + quiz.id.toString(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.purple[800],
            ),
          ),
        ),
        title: Container(
          padding: const EdgeInsets.only(top: 5, bottom: 10, right: 5),
          child: Text(
            quiz.title,
            style: TextStyle(
              fontSize: 20,
            ),
          ),
        ),
        onTap: () => toQuizDetail(context, soundEffect),
      ),
    );
  }
}

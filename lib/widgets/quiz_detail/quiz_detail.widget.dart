import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../models/quiz.model.dart';
import '../background.widget.dart';
import 'quiz_sentence.widget.dart';
import 'question_reply.widget.dart';
import 'quiz_input_words.widget.dart';
import 'question_input.widget.dart';

import '../../providers/quiz.provider.dart';

class QuizDetail extends HookWidget {
  final Quiz quiz;
  final TextEditingController subjectController;
  final TextEditingController relatedWordController;
  final bool subHintFlg;

  QuizDetail(
    this.quiz,
    this.subjectController,
    this.relatedWordController,
    this.subHintFlg,
  );

  @override
  Widget build(BuildContext context) {
    final Question selectedQuestion =
        useProvider(selectedQuestionProvider).state;

    final List<Question> askingQuestions =
        useProvider(askingQuestionsProvider).state;

    final String reply = useProvider(replyProvider).state;

    final bool displayReplyFlg = useProvider(displayReplyFlgProvider).state;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Stack(
        children: <Widget>[
          background(),
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 5, bottom: 16.0, right: 16.0, left: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    QuizSentence(
                      quiz.sentence,
                    ),
                    QuizInputWords(
                      quiz,
                      selectedQuestion,
                      askingQuestions,
                      subjectController,
                      relatedWordController,
                      subHintFlg,
                    ),
                    QuestionInput(
                      selectedQuestion,
                      askingQuestions,
                    ),
                    QuestionReply(
                      displayReplyFlg,
                      reply,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

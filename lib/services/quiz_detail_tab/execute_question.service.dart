import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lateral_thinking/models/quiz.model.dart';
import 'package:lateral_thinking/providers/quiz.provider.dart';

void executeQuestion(
  BuildContext context,
  List<Question> askingQuestions,
  Question selectedQuestion,
  AudioCache soundEffect,
  double seVolume,
  Quiz quiz,
) {
  context.read(questionCountProvider).state++;
  context.read(replyProvider).state = selectedQuestion.reply;
  context.read(displayReplyFlgProvider).state = true;
  context.read(remainingQuestionsProvider).state = context
      .read(remainingQuestionsProvider)
      .state
      .where((question) => question.id != selectedQuestion.id)
      .toList();

  context.read(askingQuestionsProvider).state = askingQuestions
      .where((question) => question.id != selectedQuestion.id)
      .toList();
  context.read(beforeWordProvider).state = selectedQuestion.asking;
  context.read(selectedQuestionProvider).state = dummyQuestion;

  // 正解を導く質問を行った場合、判定実行
  if (quiz.correctAnswerQuestionIds.contains(selectedQuestion.id) ||
      quiz.wrongAnswerQuestionIds.contains(selectedQuestion.id)) {
    // 重要な質問リストに追加
    List<int> importantQuestionedIds =
        context.read(importantQuestionedIdsProvider).state;

    importantQuestionedIds.add(selectedQuestion.id);
    context.read(importantQuestionedIdsProvider).state = importantQuestionedIds;

    bool correctAnswerFlg = false;
    List<Answer> wkAnswers = [];

    context.read(allAnswersProvider).state.forEach((Answer answer) {
      if (!correctAnswerFlg) {
        bool judgeFlg = true;
        answer.questionIds.forEach((int questionId) {
          if (judgeFlg) {
            // 現在の実行済質問の中に対象のidがなかったらfalse
            if (!importantQuestionedIds.contains(questionId)) {
              judgeFlg = false;
            }
          }
        });

        // 必要な質問が出ている、かつ、まだ解答されていないanswerを追加
        if (judgeFlg &&
            !context
                .read(executedAnswerIdsProvider)
                .state
                .contains(answer.id)) {
          // 正解だった場合はそれを解答に設定して残りのループをスキップする
          if (context
              .read(correctAnswerIdsProvider)
              .state
              .contains(answer.id)) {
            wkAnswers = [answer];
            correctAnswerFlg = true;
          } else {
            wkAnswers.add(answer);
          }
        }
      }
    });

    context.read(readyForAnswersProvider).state = wkAnswers;

    soundEffect.play(
      'sounds/nice_question.mp3',
      isNotification: true,
      volume: seVolume,
    );
  } else {
    soundEffect.play(
      'sounds/quiz_button.mp3',
      isNotification: true,
      volume: seVolume,
    );
  }

  context.read(askedQuestionsProvider).state.add(selectedQuestion);
}

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lateral_thinking/data/restriction_words.dart';
import 'package:lateral_thinking/models/quiz.model.dart';
import 'package:lateral_thinking/providers/quiz.provider.dart';
import 'package:lateral_thinking/text.dart';

void checkQuestions(
  BuildContext context,
  String subject,
  String relatedWord,
  List<Question> remainingQuestions,
  List<String> allSubjects,
  List<String> allRelatedWords,
  List<Question> askingQuestions,
  bool enModeFlg,
) {
  if (enModeFlg) {
    bool existFlg = false;
    bool existSubjectFlg = false;

    // 主語リストに存在するか判定
    for (String targetSubject in allSubjects) {
      if (targetSubject == subject) {
        existSubjectFlg = true;
        break;
      }
    }
    // 主語リストに存在した場合、関連語リストに存在するか判定
    if (existSubjectFlg) {
      for (String targetRelatedWords in allRelatedWords) {
        if (targetRelatedWords == relatedWord) {
          existFlg = true;
          break;
        }
      }
    }

    if (!existFlg) {
      context.read(askingQuestionsProvider).state = [];
    } else {
      List<Question> createdQuestions = [];

      remainingQuestions.forEach((question) {
        if (question.asking.indexOf(subject) != -1 &&
            question.asking.indexOf(subject) <
                question.asking.indexOf(relatedWord)) {
          createdQuestions.add(question);
        }
      });

      context.read(askingQuestionsProvider).state = createdQuestions;
    }

    context.read(displayReplyFlgProvider).state = false;

    if (context.read(askingQuestionsProvider).state.isEmpty) {
      if (!existSubjectFlg) {
        context.read(beforeWordProvider).state = EN_TEXT['subjectNotExist']!;
      } else if (existFlg) {
        if (remainingQuestions
            .where((question) =>
                question.asking.contains(relatedWord) &&
                !question.asking.startsWith(relatedWord))
            .isEmpty) {
          context.read(beforeWordProvider).state =
              "You can't ask in that related word.";
        } else {
          context.read(beforeWordProvider).state =
              'You can ask by changing subject.';
        }
      } else {
        final randomNumber = new Random().nextInt(5);
        if (randomNumber == 0) {
          context.read(beforeWordProvider).state = EN_TEXT['seekHint']!;
        } else {
          context.read(beforeWordProvider).state = EN_TEXT['noQuestions']!;
        }
      }
    } else {
      context.read(selectedQuestionProvider).state = dummyQuestion;
      context.read(beforeWordProvider).state = EN_TEXT['selectQuestion']!;
    }
  } else {
    // 質問文のうち、関連語が含まれていて、関連語から始まっていない質問を抽出
    final List<Question> includeRelatedWordQuestions = remainingQuestions
        .where((question) => question.asking
            // 主語以外で判定
            .substring(question.asking.indexOf('は') + 1)
            .contains(relatedWord))
        .toList();

    // 対象の関連語では質問が見つからなかった場合
    // 質問が6個以上見つかった場合
    // 使用禁止用語を使っていた場合
    if (includeRelatedWordQuestions.isEmpty ||
        includeRelatedWordQuestions.length > 6 ||
        restrictionWords.contains(relatedWord)) {
      // 選択した主語から始まる質問を抽出
      final enableQuestionsCount = remainingQuestions
          .where((question) => question.asking.startsWith(subject))
          .toList()
          .length;

      if (enableQuestionsCount == 0) {
        context.read(beforeWordProvider).state = 'その主語ではもう質問できないようです。';
      } else {
        final randomNumber = Random().nextInt(3);
        if (randomNumber == 0) {
          context.read(beforeWordProvider).state = '質問が見つかりませんでした。';
        } else {
          context.read(beforeWordProvider).state =
              'その主語を使う質問は' + enableQuestionsCount.toString() + '個あります。';
        }
      }

      context.read(askingQuestionsProvider).state = [];
    } else {
      // 該当の関連語を使用する質問が見つかった場合
      // 抽出した質問のうち、選択した主語から始まる質問を抽出
      final List<Question> includeSubjectQuestions = includeRelatedWordQuestions
          .where((question) => question.asking.startsWith(subject))
          .toList();

      // 対象の主語では質問が見つからなかった場合
      if (includeSubjectQuestions.isEmpty) {
        context.read(beforeWordProvider).state = '主語だけ変えれば質問できそう！';
        context.read(askingQuestionsProvider).state = [];
      } else {
        context.read(selectedQuestionProvider).state = dummyQuestion;
        context.read(beforeWordProvider).state = '↓質問を選択';
        context.read(askingQuestionsProvider).state = includeSubjectQuestions;
      }
    }
  }
}

void submitData(
  BuildContext context,
  Quiz quiz,
  List<Question> remainingQuestions,
  Question selectedQuestion,
  List<Question> askingQuestions,
  bool enModeFlg,
  ValueNotifier<String> subjectData,
  ValueNotifier<String> relatedWordData,
  String enteredSubject,
  String enteredRelatedWord,
) {
  if (subjectData.value != enteredSubject ||
      relatedWordData.value != enteredRelatedWord) {
    // 前回の言葉を初期化
    context.read(beforeWordProvider).state = '';
    // 返答を非表示にする
    context.read(displayReplyFlgProvider).state = false;

    // 主語か関連語が空白だったら初期化
    if (enteredSubject.isEmpty || enteredRelatedWord.isEmpty) {
      context.read(selectedQuestionProvider).state = dummyQuestion;
      context.read(askingQuestionsProvider).state = [];

      return;
    }

    // 関連語入力回数を増やす
    if (relatedWordData.value != enteredRelatedWord) {
      context.read(relatedWordCountProvider).state++;
    }

    subjectData.value = enteredSubject;
    relatedWordData.value = enteredRelatedWord;
  }
  checkQuestions(
    context,
    enteredSubject,
    enteredRelatedWord,
    remainingQuestions,
    quiz.subjects,
    quiz.relatedWords,
    askingQuestions,
    enModeFlg,
  );
}

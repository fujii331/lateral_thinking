import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'dart:math';

import '../../providers/quiz.provider.dart';
import './hint_replry_modal.widget.dart';

import '../../models/quiz.model.dart';

class HintModal extends HookWidget {
  final Quiz quiz;

  HintModal(this.quiz);

  @override
  Widget build(BuildContext context) {
    final int hint = useProvider(hintProvider).state;
    final List<Question> askedQuestions =
        useProvider(askedQuestionsProvider).state;

    List<int> currentQuestionIds = askedQuestions.map((askedQuestion) {
      return askedQuestion.id;
    }).toList();

    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 10,
            ),
            child: Text(
              hint < 4
                  ? 'ヒント' + (hint + 1).toString() + 'を開放しますか？'
                  : 'ヒントはもうありません。',
              style: TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 10,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Icon(
                  hint < 1 ? Icons.looks_one_outlined : Icons.looks_one,
                  size: 45,
                ),
                Icon(
                  hint < 2 ? Icons.looks_two_outlined : Icons.looks_two,
                  size: 45,
                ),
                Icon(
                  hint < 3 ? Icons.looks_3_outlined : Icons.looks_3,
                  size: 45,
                ),
                Icon(
                  hint < 4 ? Icons.looks_4_outlined : Icons.looks_4,
                  size: 45,
                ),
              ],
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * .15,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 15,
              ),
              child: Text(
                hint < 1
                    ? '主語を選択肢で選べるようになります。'
                    : hint == 1
                        ? '関連語を選択肢で選べるようになります。'
                        : hint == 2
                            ? '質問を選択肢で選べるようになります。'
                            : hint == 3
                                ? '正解を導く質問のみ選べるようになります。'
                                : 'もう答えはすぐそこです！',
                style: TextStyle(
                  fontSize: 18.0,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 15,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('やめる'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red[500],
                    textStyle: Theme.of(context).textTheme.button,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                ElevatedButton(
                  onPressed: () async => hint < 4
                      ? {
                          Navigator.pop(context),
                          context.read(selectedQuestionProvider).state =
                              dummyQuestion,
                          context.read(displayReplyFlgProvider).state = false,
                          if (hint >= 2)
                            {
                              context.read(beforeWordProvider).state = '↓質問を選択',
                              if (hint == 2)
                                {
                                  context.read(askingQuestionsProvider).state =
                                      _shuffle(quiz.questions
                                          .take(quiz.hintDisplayQuestionId)
                                          .where((question) =>
                                              !currentQuestionIds
                                                  .contains(question.id))
                                          .toList()) as List<Question>,
                                }
                              else if (hint == 3)
                                {
                                  context.read(askingQuestionsProvider).state =
                                      quiz
                                          .questions
                                          .take(quiz.correctAnswerQuestionId)
                                          .where((question) =>
                                              !currentQuestionIds
                                                  .contains(question.id))
                                          .toList(),
                                },
                              if (context
                                  .read(askingQuestionsProvider)
                                  .state
                                  .isEmpty)
                                {
                                  context.read(beforeWordProvider).state =
                                      'もう質問はありません。',
                                },
                            }
                          else if (hint >= 0)
                            {
                              context.read(beforeWordProvider).state = '',
                              context.read(askingQuestionsProvider).state = [],
                            },
                          context.read(hintProvider).state++,
                          await showDialog<int>(
                            context: context,
                            barrierDismissible: true,
                            builder: (BuildContext context) {
                              return HintReplyModal(hint == 0
                                  ? '主語を選択肢で選べるようになりました。'
                                  : hint == 1
                                      ? '関連語を選択肢で選べるようになりました。'
                                      : hint == 2
                                          ? '質問を選択肢で選べるようになりました。'
                                          : '正解を導く質問のみ選べるようになりました。');
                            },
                          ),
                        }
                      : {},
                  child: const Text('開放する'),
                  style: ElevatedButton.styleFrom(
                    primary: hint < 4 ? Colors.blue[700] : Colors.blue[300],
                    textStyle: Theme.of(context).textTheme.button,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

List _shuffle(List items) {
  var random = new Random();
  for (var i = items.length - 1; i > 0; i--) {
    var n = random.nextInt(i + 1);
    var temp = items[i];
    items[i] = items[n];
    items[n] = temp;
  }
  return items;
}

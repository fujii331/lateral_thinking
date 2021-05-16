import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:audioplayers/audio_cache.dart';

import '../../providers/quiz.provider.dart';
import '../../models/quiz.model.dart';

class QuestionInput extends HookWidget {
  final Question selectedQuestion;
  final List<Question> askingQuestions;

  QuestionInput(this.selectedQuestion, this.askingQuestions);

  void _executeQuestion(BuildContext context, List<Question> askingQuestions,
      Question selectedQuestion) {
    context.read(replyProvider).state = selectedQuestion.reply;
    context.read(displayReplyFlgProvider).state = true;
    context.read(askedQuestionsProvider).state.add(selectedQuestion);
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
  }

  @override
  Widget build(BuildContext context) {
    final AudioCache player = useProvider(soundEffectProvider).state;
    final String beforeWord = useProvider(beforeWordProvider).state;

    return Padding(
      padding: const EdgeInsets.only(
        top: 23,
        bottom: 8,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: 7,
              horizontal: 10,
            ),
            width: MediaQuery.of(context).size.width * .60,
            height: MediaQuery.of(context).size.height * .09,
            decoration: BoxDecoration(
              color: askingQuestions.isEmpty ? Colors.grey[400] : Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Colors.black,
              ),
            ),
            child: DropdownButton(
              isExpanded: true,
              hint: Text(
                beforeWord.isEmpty ? '' : beforeWord,
                style: TextStyle(
                  color: Colors.black54,
                ),
              ),
              underline: Container(
                color: Colors.white,
              ),
              value: selectedQuestion.id != 0 ? selectedQuestion : null,
              items: askingQuestions.map((Question question) {
                return DropdownMenuItem(
                  value: question,
                  child: Text(question.asking),
                );
              }).toList(),
              onChanged: (targetQuestion) {
                context.read(displayReplyFlgProvider).state = false;
                context.read(selectedQuestionProvider).state =
                    targetQuestion as Question;
              },
            ),
          ),
          ElevatedButton(
            onPressed: () => selectedQuestion.id != 0
                ? {
                    _executeQuestion(
                      context,
                      askingQuestions,
                      selectedQuestion,
                    ),
                    player.play('sounds/quiz_button.mp3', isNotification: true),
                  }
                : {},
            child: const Text('質問！'),
            style: ElevatedButton.styleFrom(
              primary:
                  selectedQuestion.id != 0 ? Colors.blue : Colors.blue[200],
              textStyle: Theme.of(context).textTheme.button,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

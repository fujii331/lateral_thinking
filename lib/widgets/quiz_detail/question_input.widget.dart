import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';

import '../../providers/quiz.provider.dart';
import '../../providers/common.provider.dart';

import '../../models/quiz.model.dart';
import '../../text.dart';

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
    final height = MediaQuery.of(context).size.height * .35;
    final AudioCache soundEffect = useProvider(soundEffectProvider).state;
    final String beforeWord = useProvider(beforeWordProvider).state;
    final bool enModeFlg = useProvider(enModeFlgProvider).state;
    final double seVolume = useProvider(seVolumeProvider).state;

    return Padding(
      padding: EdgeInsets.only(
        top: height < 210 ? 11 : 16.5,
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * .86 > 650 ? 650 : null,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(
                top: height < 220 ? 4 : 7,
                bottom: height < 220 ? 5 : 7,
                right: 10,
                left: 10,
              ),
              width: MediaQuery.of(context).size.width * .86 > 650
                  ? 520
                  : MediaQuery.of(context).size.width * .60,
              height: height < 220 ? 58 : 67,
              decoration: BoxDecoration(
                color:
                    askingQuestions.isEmpty ? Colors.grey[400] : Colors.white,
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
                      soundEffect.play(
                        'sounds/quiz_button.mp3',
                        isNotification: true,
                        volume: seVolume,
                      ),
                    }
                  : {},
              child: Text(
                enModeFlg ? EN_TEXT['ask']! : JA_TEXT['ask']!,
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.only(
                  right: 7,
                  left: 11,
                ),
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
      ),
    );
  }
}

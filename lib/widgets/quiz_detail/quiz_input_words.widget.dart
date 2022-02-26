import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lateral_thinking/services/quiz_detail_tab/check_question.service.dart';

import '../../providers/quiz.provider.dart';
import '../../models/quiz.model.dart';
import '../../text.dart';

class QuizInputWords extends HookWidget {
  final Quiz quiz;
  final Question selectedQuestion;
  final List<Question> askingQuestions;
  final TextEditingController subjectController;
  final TextEditingController relatedWordController;

  QuizInputWords(
    this.quiz,
    this.selectedQuestion,
    this.askingQuestions,
    this.subjectController,
    this.relatedWordController,
  );

  @override
  Widget build(BuildContext context) {
    final subjectFocusNode = useFocusNode();
    final relatedWordFocusNode = useFocusNode();

    final List<Question> remainingQuestions =
        useProvider(remainingQuestionsProvider).state;

    final int hint = useProvider(hintProvider).state;

    final String? selectedSubject = useProvider(selectedSubjectProvider).state;
    final String? selectedRelatedWord =
        useProvider(selectedRelatedWordProvider).state;

    final bool enModeFlg = useProvider(enModeFlgProvider).state;

    final subjectData = useState<String>('');
    final relatedWordData = useState<String>('');

    subjectFocusNode.addListener(() {
      if (!subjectFocusNode.hasFocus) {
        submitData(
          context,
          quiz,
          remainingQuestions,
          selectedQuestion,
          askingQuestions,
          enModeFlg,
          subjectData,
          relatedWordData,
          subjectController.text.trim(),
          relatedWordController.text.trim(),
        );
      }
    });

    relatedWordFocusNode.addListener(() {
      if (!relatedWordFocusNode.hasFocus) {
        submitData(
          context,
          quiz,
          remainingQuestions,
          selectedQuestion,
          askingQuestions,
          enModeFlg,
          subjectData,
          relatedWordData,
          subjectController.text.trim(),
          relatedWordController.text.trim(),
        );
      }
    });

    return Padding(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).size.height * .35 < 210 ? 6 : 12,
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * .86 > 650 ? 650 : null,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            // 主語の入力
            _wordSelectForQuestion(
              context,
              selectedSubject,
              selectedSubjectProvider,
              enModeFlg ? EN_TEXT['subject']! : JA_TEXT['subject']!,
              hint,
              quiz.subjects,
              subjectController,
              remainingQuestions,
              selectedQuestion,
              askingQuestions,
              enModeFlg,
              subjectData,
              relatedWordData,
            ),
            Text(
              enModeFlg ? EN_TEXT['afterSubject']! : JA_TEXT['afterSubject']!,
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.white,
                fontFamily: 'NotoSerifJP',
              ),
            ),
            // 関連語の入力
            hint < 1
                ? _wordForQuestion(
                    context,
                    enModeFlg
                        ? EN_TEXT['relatedWord']!
                        : JA_TEXT['relatedWord']!,
                    relatedWordController,
                    relatedWordFocusNode,
                    enModeFlg,
                  )
                : _wordSelectForQuestion(
                    context,
                    selectedRelatedWord,
                    selectedRelatedWordProvider,
                    enModeFlg
                        ? EN_TEXT['relatedWord']!
                        : JA_TEXT['relatedWord']!,
                    hint,
                    quiz.relatedWords.take(quiz.hintDisplayWordId).toList(),
                    relatedWordController,
                    remainingQuestions,
                    selectedQuestion,
                    askingQuestions,
                    enModeFlg,
                    subjectData,
                    relatedWordData,
                  ),
            Text(
              '...？',
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.white,
                fontFamily: 'NotoSerifJP',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _wordForQuestion(
    BuildContext context,
    String text,
    TextEditingController controller,
    FocusNode _focusNode,
    bool enModeFlg,
  ) {
    final height = MediaQuery.of(context).size.height * .35;

    return Container(
      width: MediaQuery.of(context).size.width * .86 > 650
          ? 250
          : MediaQuery.of(context).size.width * .30,
      height: height < 210 ? 50 : null,
      child: TextField(
        textAlignVertical: height < 210 ? TextAlignVertical.bottom : null,
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          hintText: text,
          enabledBorder: new OutlineInputBorder(
            borderRadius: new BorderRadius.circular(15.0),
            borderSide: BorderSide(
              color: Colors.black,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: new BorderRadius.circular(15.0),
            borderSide: BorderSide(
              color: Colors.blue,
              width: 3.0,
            ),
          ),
        ),
        inputFormatters: <TextInputFormatter>[
          LengthLimitingTextInputFormatter(
            enModeFlg ? 30 : 10,
          ),
        ],
        controller: controller,
        focusNode: _focusNode,
      ),
    );
  }

  Widget _wordSelectForQuestion(
    BuildContext context,
    String? selectedWord,
    StateProvider<String> selectedWordProvider,
    String displayHint,
    int hint,
    List<String> wordList,
    TextEditingController controller,
    List<Question> remainingQuestions,
    Question selectedQuestion,
    List<Question> askingQuestions,
    bool enModeFlg,
    ValueNotifier<String> subjectData,
    ValueNotifier<String> relatedWordData,
  ) {
    final height = MediaQuery.of(context).size.height * .35;

    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 7,
        horizontal: 10,
      ),
      width: MediaQuery.of(context).size.width * .86 > 650
          ? 250
          : MediaQuery.of(context).size.width * .305,
      height: height < 210 ? 50 : 63,
      decoration: BoxDecoration(
        color: hint < 2 ? Colors.white : Colors.grey[400],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.black,
        ),
      ),
      alignment: Alignment.center,
      child: DropdownButton(
        isExpanded: true,
        hint: Text(
          displayHint,
          style: TextStyle(
            color: Colors.black54,
          ),
        ),
        underline: Container(
          color: Colors.white,
        ),
        value: selectedWord != '' ? selectedWord : null,
        items: hint < 2
            ? wordList.map((String word) {
                return DropdownMenuItem(
                  value: word,
                  child: Text(word),
                );
              }).toList()
            : null,
        onChanged: (targetSubject) {
          controller.text = context.read(selectedWordProvider).state =
              targetSubject as String;
          submitData(
            context,
            quiz,
            remainingQuestions,
            selectedQuestion,
            askingQuestions,
            enModeFlg,
            subjectData,
            relatedWordData,
            subjectController.text.trim(),
            relatedWordController.text.trim(),
          );
        },
      ),
    );
  }
}

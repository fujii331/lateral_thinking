import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:firebase_database/firebase_database.dart';

import 'dart:math';

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

  void _submitData(
    BuildContext context,
    Quiz quiz,
    List<Question> remainingQuestions,
    Question selectedQuestion,
    List<Question> askingQuestions,
    bool enModeFlg,
    ValueNotifier<String> subjectData,
    ValueNotifier<String> relatedWordData,
    int hint,
  ) {
    final enteredSubject = subjectController.text.trim();
    final enteredRelatedWord = relatedWordController.text.trim();

    if (subjectData.value != enteredSubject ||
        relatedWordData.value != enteredRelatedWord) {
      context.read(beforeWordProvider).state = '';

      if (enteredSubject.isEmpty || enteredRelatedWord.isEmpty) {
        context.read(displayReplyFlgProvider).state = false;
        context.read(selectedQuestionProvider).state = dummyQuestion;
        context.read(askingQuestionsProvider).state = [];

        return;
      }

      if (relatedWordData.value != enteredRelatedWord) {
        context.read(relatedWordCountProvider).state++;
      }
      // if (hint == 0 && quiz.id > 66) {
      //   FirebaseDatabase.instance
      //       .reference()
      //       .child('input_words/' +
      //           quiz.id.toString() +
      //           '/' +
      //           enteredSubject +
      //           '/' +
      //           enteredRelatedWord)
      //       .push()
      //       .set({
      //     'subHintFlg': context.read(subHintFlgProvider).state,
      //   });
      // }

      subjectData.value = enteredSubject;
      relatedWordData.value = enteredRelatedWord;
    }
    _checkQuestions(
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

  void _checkQuestions(
    BuildContext context,
    String subject,
    String relatedWord,
    List<Question> remainingQuestions,
    List<String> allSubjects,
    List<String> allRelatedWords,
    List<Question> askingQuestions,
    bool enModeFlg,
  ) {
    bool existFlg = false;
    bool exsistSubjectFlg = false;

    // 主語リストに存在するか判定
    for (String targetSubject in allSubjects) {
      if (targetSubject == subject) {
        exsistSubjectFlg = true;
        break;
      }
    }
    // 主語リストに存在した場合、関連語リストに存在するか判定
    if (exsistSubjectFlg) {
      for (String targetRelatedWords in allRelatedWords) {
        if (targetRelatedWords == relatedWord) {
          existFlg = true;
          break;
        }
      }
    }

    if (enModeFlg) {
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
    } else {
      context.read(askingQuestionsProvider).state = existFlg
          ? remainingQuestions
              .where((question) =>
                  question.asking.startsWith(subject) &&
                  (!question.asking.startsWith(relatedWord) &&
                      question.asking.contains(relatedWord)))
              .toList()
          : [];
    }

    context.read(displayReplyFlgProvider).state = false;

    if (context.read(askingQuestionsProvider).state.isEmpty) {
      if (!exsistSubjectFlg) {
        context.read(beforeWordProvider).state = enModeFlg
            ? EN_TEXT['subjectNotExist']!
            : JA_TEXT['subjectNotExist']!;
      } else if (existFlg) {
        if (remainingQuestions
            .where((question) =>
                question.asking.contains(relatedWord) &&
                !question.asking.startsWith(relatedWord))
            .isEmpty) {
          context.read(beforeWordProvider).state = enModeFlg
              ? "You can't ask in that related word."
              : 'その関連語ではもう質問できません。';
        } else {
          context.read(beforeWordProvider).state = enModeFlg
              ? 'You can ask by changing subject.'
              : '主語だけ変えれば質問できそう！';
        }
      } else {
        if (enModeFlg) {
          final randomNumber = new Random().nextInt(5);
          if (randomNumber == 0) {
            context.read(beforeWordProvider).state = EN_TEXT['seekHint']!;
          } else {
            context.read(beforeWordProvider).state = EN_TEXT['noQuestions']!;
          }
        } else {
          final enableQuestionsCount = remainingQuestions
              .where((question) => question.asking.startsWith(subject))
              .toList()
              .length;

          if (enableQuestionsCount == 0) {
            context.read(beforeWordProvider).state =
                JA_TEXT['subjectNotExist']!;
          } else {
            final randomNumber = new Random().nextInt(2);
            if (randomNumber == 0) {
              context.read(beforeWordProvider).state = JA_TEXT['noQuestions']!;
            } else {
              context.read(beforeWordProvider).state =
                  'その主語を使う質問は' + enableQuestionsCount.toString() + '個あります。';
            }
          }
        }
      }
    } else {
      context.read(selectedQuestionProvider).state = dummyQuestion;
      context.read(beforeWordProvider).state =
          enModeFlg ? EN_TEXT['selectQuestion']! : JA_TEXT['selectQuestion']!;
    }
  }

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
    final bool helperModeFlg = useProvider(helperModeFlgProvider).state;

    final subjectData = useState<String>('');
    final relatedWordData = useState<String>('');

    subjectFocusNode.addListener(() {
      if (!subjectFocusNode.hasFocus) {
        _submitData(
          context,
          quiz,
          remainingQuestions,
          selectedQuestion,
          askingQuestions,
          enModeFlg,
          subjectData,
          relatedWordData,
          hint,
        );
      }
    });

    relatedWordFocusNode.addListener(() {
      if (!relatedWordFocusNode.hasFocus) {
        _submitData(
          context,
          quiz,
          remainingQuestions,
          selectedQuestion,
          askingQuestions,
          enModeFlg,
          subjectData,
          relatedWordData,
          hint,
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
            hint < 1 && !helperModeFlg
                ? _wordForQuestion(
                    context,
                    enModeFlg ? EN_TEXT['subject']! : JA_TEXT['subject']!,
                    subjectController,
                    subjectFocusNode,
                    enModeFlg,
                  )
                : _wordSelectForQuestion(
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
          _submitData(
            context,
            quiz,
            remainingQuestions,
            selectedQuestion,
            askingQuestions,
            enModeFlg,
            subjectData,
            relatedWordData,
            hint,
          );
        },
      ),
    );
  }
}

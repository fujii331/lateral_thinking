import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'dart:math';

import '../../models/quiz.model.dart';
import '../background.widget.dart';
import './quiz_sentence.widget.dart';
import './quiz_reply.widget.dart';
import '../../providers/quiz.provider.dart';

class QuizDetail extends HookWidget {
  final Quiz quiz;

  QuizDetail(this.quiz);

  final subjectController = useTextEditingController();
  final relatedWordController = useTextEditingController();

  void _executeQuestion(
    BuildContext context,
    ValueNotifier<String> reply,
    ValueNotifier<bool> displayReplyFlg,
    ValueNotifier<List<Question>> askQuestions,
    ValueNotifier<String> beforeWord,
    ValueNotifier<Question?> selectedQuestion,
  ) {
    reply.value = selectedQuestion.value!.reply;
    displayReplyFlg.value = true;
    context.read(askedQuestionsProvider).state.add(selectedQuestion.value!);
    context.read(remainingQuestionsProvider).state = context
        .read(remainingQuestionsProvider)
        .state
        .where((question) => question.id != selectedQuestion.value!.id)
        .toList();

    askQuestions.value = askQuestions.value
        .where((question) => question.id != selectedQuestion.value!.id)
        .toList();
    beforeWord.value = selectedQuestion.value!.asking;
    selectedQuestion.value = null;
  }

  void _checkQuestions(
    String subject,
    String relatedWord,
    List<Question> questions,
    List<String> allSubjects,
    List<String> allRelatedWords,
    ValueNotifier<List<Question>> askQuestions,
    ValueNotifier<bool> displayReplyFlg,
    ValueNotifier<bool> dummyDisplayFlg,
    ValueNotifier<Question?> selectedQuestion,
    ValueNotifier<String> beforeWord,
  ) {
    bool existFlg = false;

    // 主語リストに存在するか判定
    for (String targetSubject in allSubjects) {
      existFlg = targetSubject == subject ? true : false;
      if (existFlg) {
        break;
      }
    }
    // 主語リストに存在した場合、関連語リストに存在するか判定
    if (existFlg) {
      for (String targetRelatedWords in allRelatedWords) {
        existFlg = targetRelatedWords == relatedWord ? true : false;
        if (existFlg) {
          break;
        }
      }
    }

    askQuestions.value = existFlg
        ? questions
            .where((question) =>
                question.asking.startsWith(subject) &&
                (!question.asking.startsWith(relatedWord) &&
                    question.asking.contains(relatedWord)))
            .toList()
        : [];

    if (askQuestions.value.isEmpty) {
      displayReplyFlg.value = false;
      dummyDisplayFlg.value = true;
    } else {
      displayReplyFlg.value = false;
      selectedQuestion.value = null;
      beforeWord.value = '↓質問を選択';
      dummyDisplayFlg.value = false;
    }
  }

  void submitData(
    Quiz quiz,
    List<Question> remainingQuestions,
    ValueNotifier<String> beforeWord,
    ValueNotifier<bool> displayReplyFlg,
    ValueNotifier<Question?> selectedQuestion,
    ValueNotifier<bool> dummyDisplayFlg,
    ValueNotifier<List<Question>> askQuestions,
  ) {
    final enteredSubject = subjectController.text;
    final enteredRelatedWord = relatedWordController.text;

    beforeWord.value = '';

    if (enteredSubject.isEmpty || enteredRelatedWord.isEmpty) {
      displayReplyFlg.value = false;
      selectedQuestion.value = null;
      dummyDisplayFlg.value = false;
      askQuestions.value = [];

      return;
    }

    _checkQuestions(
      enteredSubject,
      enteredRelatedWord,
      remainingQuestions,
      quiz.subjects,
      quiz.relatedWords,
      askQuestions,
      displayReplyFlg,
      dummyDisplayFlg,
      selectedQuestion,
      beforeWord,
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Question> remainingQuestions =
        useProvider(remainingQuestionsProvider).state;

    final bool finishFlg = useProvider(finishFlgProvider).state;
    final int hint = useProvider(hintProvider).state;
    // ヒント開放時の質問などの考慮が必要！
    final selectedQuestion = useState<Question?>(null);

    final reply = useState<String>('');
    // 質問語にhintで表示用
    final beforeWord = useState<String>('');

    final displayReplyFlg = useState<bool>(false);
    final dummyDisplayFlg = useState<bool>(false);

    final askQuestions = useState<List<Question>>([]);

    final selectedSubject = useState<String?>(null);
    final selectedRelatedWord = useState<String?>(null);

    useEffect(() {
      if (hint > 2) {
        selectedQuestion.value = null;
        displayReplyFlg.value = false;
        dummyDisplayFlg.value = false;
        if (hint == 3) {
          askQuestions.value =
              _shuffle(quiz.questions.take(quiz.hintDisplayQuestionId).toList())
                  as List<Question>;
        } else if (hint == 4) {
          askQuestions.value =
              quiz.questions.take(quiz.correctAnswerQuestionId).toList();
        }
      } else if (hint > 0) {
        selectedQuestion.value = null;
        displayReplyFlg.value = false;
        dummyDisplayFlg.value = false;
        askQuestions.value = [];
        beforeWord.value = '↓質問を選択';
      }
      return () => {};
    }, [hint]);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Stack(
        children: <Widget>[
          background(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                QuizSentence(quiz.sentence),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 18,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      // 主語の入力
                      hint < 1
                          ? _wordForQuestion(
                              context,
                              '主語',
                              subjectController,
                              remainingQuestions,
                              beforeWord,
                              displayReplyFlg,
                              selectedQuestion,
                              dummyDisplayFlg,
                              askQuestions,
                            )
                          : _wordSelectForQuestion(
                              context,
                              selectedRelatedWord,
                              '主語',
                              hint,
                              quiz.subjects,
                              subjectController,
                              remainingQuestions,
                              beforeWord,
                              displayReplyFlg,
                              selectedQuestion,
                              dummyDisplayFlg,
                              askQuestions,
                            ),
                      Text(
                        'は',
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                      // 関連語の入力
                      hint < 2
                          ? _wordForQuestion(
                              context,
                              '関連語',
                              relatedWordController,
                              remainingQuestions,
                              beforeWord,
                              displayReplyFlg,
                              selectedQuestion,
                              dummyDisplayFlg,
                              askQuestions,
                            )
                          : _wordSelectForQuestion(
                              context,
                              selectedSubject,
                              '関連語',
                              hint,
                              quiz.relatedWords
                                  .take(quiz.hintDisplayWordId)
                                  .toList(),
                              relatedWordController,
                              remainingQuestions,
                              beforeWord,
                              displayReplyFlg,
                              selectedQuestion,
                              dummyDisplayFlg,
                              askQuestions,
                            ),
                      Text(
                        '...？',
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                    ],
                  ),
                ),
                // 質問入力
                Padding(
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
                          color: askQuestions.value.isEmpty
                              ? Colors.grey[400]
                              : Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.black,
                          ),
                        ),
                        child: DropdownButton(
                          isExpanded: true,
                          hint: Text(
                            finishFlg
                                ? 'この問題は終わりです。'
                                : hint > 2 &&
                                        askQuestions.value.isEmpty &&
                                        beforeWord.value.isEmpty
                                    ? 'もう質問はありません。'
                                    : dummyDisplayFlg.value
                                        ? 'それらの言葉は関係ないようです。'
                                        : beforeWord.value.isEmpty
                                            ? ''
                                            : beforeWord.value,
                            style: TextStyle(
                              color: Colors.black54,
                            ),
                          ),
                          underline: Container(
                            color: Colors.white,
                          ),
                          value: selectedQuestion.value,
                          items: askQuestions.value.map((Question question) {
                            return DropdownMenuItem(
                              value: question,
                              child: Text(question.asking),
                            );
                          }).toList(),
                          onChanged: (targetQuestion) {
                            displayReplyFlg.value = false;
                            selectedQuestion.value = targetQuestion as Question;
                          },
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () => selectedQuestion.value != null
                            ? _executeQuestion(
                                context,
                                reply,
                                displayReplyFlg,
                                askQuestions,
                                beforeWord,
                                selectedQuestion,
                              )
                            : {},
                        child: const Text('質問！'),
                        style: ElevatedButton.styleFrom(
                          primary: selectedQuestion.value != null
                              ? Colors.blue
                              : Colors.blue[200],
                          textStyle: Theme.of(context).textTheme.button,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                QuizReply(
                  displayReplyFlg.value,
                  reply.value,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _wordForQuestion(
    BuildContext context,
    String text,
    TextEditingController controller,
    List<Question> remainingQuestions,
    ValueNotifier<String> beforeWord,
    ValueNotifier<bool> displayReplyFlg,
    ValueNotifier<Question?> selectedQuestion,
    ValueNotifier<bool> dummyDisplayFlg,
    ValueNotifier<List<Question>> askQuestions,
  ) {
    return Container(
      width: MediaQuery.of(context).size.width * .30,
      child: TextField(
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
          LengthLimitingTextInputFormatter(10),
        ],
        controller: controller,
        onSubmitted: (_) => submitData(
          quiz,
          remainingQuestions,
          beforeWord,
          displayReplyFlg,
          selectedQuestion,
          dummyDisplayFlg,
          askQuestions,
        ),
      ),
    );
  }

  Widget _wordSelectForQuestion(
    BuildContext context,
    ValueNotifier<String?> selectedWord,
    String displayHint,
    int hint,
    List<String> wordList,
    TextEditingController controller,
    List<Question> remainingQuestions,
    ValueNotifier<String> beforeWord,
    ValueNotifier<bool> displayReplyFlg,
    ValueNotifier<Question?> selectedQuestion,
    ValueNotifier<bool> dummyDisplayFlg,
    ValueNotifier<List<Question>> askQuestions,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 7,
        horizontal: 10,
      ),
      width: MediaQuery.of(context).size.width * .305,
      height: MediaQuery.of(context).size.height * .083,
      decoration: BoxDecoration(
        color: hint < 3 ? Colors.white : Colors.grey[400],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.black,
        ),
      ),
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
        value: selectedWord.value,
        items: hint < 3
            ? wordList.map((String subject) {
                return DropdownMenuItem(
                  value: subject,
                  child: Text(subject),
                );
              }).toList()
            : null,
        onChanged: (targetSubject) {
          controller.text = selectedWord.value = targetSubject as String;
          submitData(
            quiz,
            remainingQuestions,
            beforeWord,
            displayReplyFlg,
            selectedQuestion,
            dummyDisplayFlg,
            askQuestions,
          );
        },
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

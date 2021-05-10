import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../models/quiz.model.dart';
import '../background.widget.dart';
import './quiz_sentence.widget.dart';
import './quiz_reply.widget.dart';
import '../../providers/quiz.provider.dart';

class QuizDetailScreen extends HookWidget {
  final Quiz quiz;

  QuizDetailScreen(this.quiz);

  final subjectController = TextEditingController();
  final relatedWordController = TextEditingController();

  void _executeQuestion(
    BuildContext context,
    ValueNotifier<bool> enableQuestionButtonFlg,
    ValueNotifier<String> reply,
    ValueNotifier<bool> displayReplyFlg,
    ValueNotifier<List<Question>> askQuestions,
    ValueNotifier<String> beforeWord,
    ValueNotifier<Question?> selectedQuestion,
  ) {
    enableQuestionButtonFlg.value = false;
    reply.value = selectedQuestion.value!.reply;
    displayReplyFlg.value = !displayReplyFlg.value;
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
    ValueNotifier<bool> enableQuestionButtonFlg,
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
      enableQuestionButtonFlg.value = false;
      displayReplyFlg.value = false;
      dummyDisplayFlg.value = true;
    } else {
      enableQuestionButtonFlg.value = true;
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
    ValueNotifier<bool> enableQuestionButtonFlg,
    ValueNotifier<bool> displayReplyFlg,
    ValueNotifier<Question?> selectedQuestion,
    ValueNotifier<bool> dummyDisplayFlg,
    ValueNotifier<List<Question>> askQuestions,
  ) {
    final enteredSubject = subjectController.text;
    final enteredRelatedWord = relatedWordController.text;

    beforeWord.value = '';

    if (enteredSubject.isEmpty || enteredRelatedWord.isEmpty) {
      enableQuestionButtonFlg.value = false;
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
      enableQuestionButtonFlg,
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

    final selectedQuestion = useState<Question?>(null);

    final reply = useState<String>('');
    // 質問語にhintで表示用
    final beforeWord = useState<String>('');

    final displayReplyFlg = useState<bool>(false);
    final enableQuestionButtonFlg = useState<bool>(false);
    final dummyDisplayFlg = useState<bool>(false);

    final askQuestions = useState<List<Question>>([]);

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
                  padding: const EdgeInsets.symmetric(
                    vertical: 15,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      // 主語の入力
                      _wordForQuestion(
                        context,
                        '主語',
                        subjectController,
                        quiz,
                        remainingQuestions,
                        beforeWord,
                        enableQuestionButtonFlg,
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
                      _wordForQuestion(
                        context,
                        '関連語',
                        relatedWordController,
                        quiz,
                        remainingQuestions,
                        beforeWord,
                        enableQuestionButtonFlg,
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
                  padding: const EdgeInsets.symmetric(
                    vertical: 15,
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
                          hint: dummyDisplayFlg.value
                              ? Text(
                                  'それらの言葉は関係ないようです。',
                                  style: TextStyle(
                                    // fontSize: 20,
                                    color: Colors.black87,
                                  ),
                                )
                              : beforeWord.value.isEmpty
                                  ? null
                                  : Text(beforeWord.value),
                          // 下線をなくすため
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
                            enableQuestionButtonFlg.value = true;
                            displayReplyFlg.value = false;
                            selectedQuestion.value = targetQuestion as Question;
                          },
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () => enableQuestionButtonFlg.value
                            ? _executeQuestion(
                                context,
                                enableQuestionButtonFlg,
                                reply,
                                displayReplyFlg,
                                askQuestions,
                                beforeWord,
                                selectedQuestion,
                              )
                            : {},
                        child: const Text('質問！'),
                        style: ElevatedButton.styleFrom(
                          primary: enableQuestionButtonFlg.value
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
    Quiz quiz,
    List<Question> remainingQuestions,
    ValueNotifier<String> beforeWord,
    ValueNotifier<bool> enableQuestionButtonFlg,
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
          enableQuestionButtonFlg,
          displayReplyFlg,
          selectedQuestion,
          dummyDisplayFlg,
          askQuestions,
        ),
      ),
    );
  }
}

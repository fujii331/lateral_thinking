import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

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

  void _executeQuestion(BuildContext context, List<Question> askQuestions,
      Question selectedQuestion) {
    context.read(replyProvider).state = selectedQuestion.reply;
    context.read(displayReplyFlgProvider).state = true;
    context.read(askedQuestionsProvider).state.add(selectedQuestion);
    context.read(remainingQuestionsProvider).state = context
        .read(remainingQuestionsProvider)
        .state
        .where((question) => question.id != selectedQuestion.id)
        .toList();

    context.read(askQuestionsProvider).state = askQuestions
        .where((question) => question.id != selectedQuestion.id)
        .toList();
    context.read(beforeWordProvider).state = selectedQuestion.asking;
    context.read(selectedQuestionProvider).state = dummyQuestion;
  }

  void _checkQuestions(
    BuildContext context,
    String subject,
    String relatedWord,
    List<Question> remainingQuestions,
    List<String> allSubjects,
    List<String> allRelatedWords,
    List<Question> askQuestions,
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

    context.read(askQuestionsProvider).state = existFlg
        ? remainingQuestions
            .where((question) =>
                question.asking.startsWith(subject) &&
                (!question.asking.startsWith(relatedWord) &&
                    question.asking.contains(relatedWord)))
            .toList()
        : [];

    context.read(displayReplyFlgProvider).state = false;

    if (context.read(askQuestionsProvider).state.isEmpty) {
      context.read(beforeWordProvider).state = 'それらの言葉は関係ないようです。';
    } else {
      context.read(selectedQuestionProvider).state = dummyQuestion;
      context.read(beforeWordProvider).state = '↓質問を選択';
    }
  }

  void submitData(
    BuildContext context,
    Quiz quiz,
    List<Question> remainingQuestions,
    Question selectedQuestion,
    List<Question> askQuestions,
  ) {
    final enteredSubject = subjectController.text;
    final enteredRelatedWord = relatedWordController.text;

    context.read(beforeWordProvider).state = '';

    if (enteredSubject.isEmpty || enteredRelatedWord.isEmpty) {
      context.read(displayReplyFlgProvider).state = false;
      context.read(selectedQuestionProvider).state = dummyQuestion;
      context.read(askQuestionsProvider).state = [];

      return;
    }

    _checkQuestions(
      context,
      enteredSubject,
      enteredRelatedWord,
      remainingQuestions,
      quiz.subjects,
      quiz.relatedWords,
      askQuestions,
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Question> remainingQuestions =
        useProvider(remainingQuestionsProvider).state;

    final bool finishFlg = useProvider(finishFlgProvider).state;
    final int hint = useProvider(hintProvider).state;

    final selectedQuestion = useProvider(selectedQuestionProvider).state;

    final String reply = useProvider(replyProvider).state;
    final String beforeWord = useProvider(beforeWordProvider).state;

    final bool displayReplyFlg = useProvider(displayReplyFlgProvider).state;

    final String? selectedSubject = useProvider(selectedSubjectProvider).state;
    final String? selectedRelatedWord =
        useProvider(selectedRelatedWordProvider).state;
    final List<Question> askQuestions = useProvider(askQuestionsProvider).state;

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
                              selectedQuestion,
                              askQuestions,
                            )
                          : _wordSelectForQuestion(
                              context,
                              selectedSubject,
                              selectedSubjectProvider,
                              '主語',
                              hint,
                              quiz.subjects,
                              subjectController,
                              remainingQuestions,
                              selectedQuestion,
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
                              selectedQuestion,
                              askQuestions,
                            )
                          : _wordSelectForQuestion(
                              context,
                              selectedRelatedWord,
                              selectedRelatedWordProvider,
                              '関連語',
                              hint,
                              quiz.relatedWords
                                  .take(quiz.hintDisplayWordId)
                                  .toList(),
                              relatedWordController,
                              remainingQuestions,
                              selectedQuestion,
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
                          color: askQuestions.isEmpty
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
                                        askQuestions.isEmpty &&
                                        beforeWord.isEmpty
                                    ? 'もう質問はありません。'
                                    : beforeWord.isEmpty
                                        ? ''
                                        : beforeWord,
                            style: TextStyle(
                              color: Colors.black54,
                            ),
                          ),
                          underline: Container(
                            color: Colors.white,
                          ),
                          value: selectedQuestion.id != 0
                              ? selectedQuestion
                              : null,
                          items: askQuestions.map((Question question) {
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
                            ? _executeQuestion(
                                context,
                                askQuestions,
                                selectedQuestion,
                              )
                            : {},
                        child: const Text('質問！'),
                        style: ElevatedButton.styleFrom(
                          primary: selectedQuestion.id != 0
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
                  displayReplyFlg,
                  reply,
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
    Question selectedQuestion,
    List<Question> askQuestions,
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
          context,
          quiz,
          remainingQuestions,
          selectedQuestion,
          askQuestions,
        ),
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
    List<Question> askQuestions,
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
        value: selectedWord != '' ? selectedWord : null,
        items: hint < 3
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
            askQuestions,
          );
        },
      ),
    );
  }
}

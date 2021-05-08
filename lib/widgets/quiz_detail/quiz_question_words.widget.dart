import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../models/quiz.model.dart';

class QuizQuestionWords extends StatelessWidget {
  final Function checkQuestions;
  final Quiz quiz;
  final subjectController = TextEditingController();
  final relatedWordController = TextEditingController();

  QuizQuestionWords(this.checkQuestions, this.quiz);

  void submitData() {
    final enteredSubject = subjectController.text;
    final enteredRelatedWord = relatedWordController.text;

    if (enteredSubject.isEmpty || enteredRelatedWord.isEmpty) {
      return;
    }

    checkQuestions(
      enteredSubject,
      enteredRelatedWord,
      quiz.questions,
      quiz.subjects,
      quiz.relatedWords,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 15,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          // 主語の入力
          Container(
            width: MediaQuery.of(context).size.width * .30,
            child: TextField(
              decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                hintText: "主語",
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
              controller: subjectController,
              onSubmitted: (_) => submitData(),
            ),
          ),
          Text(
            'は',
            style: Theme.of(context).textTheme.bodyText2,
          ),
          // 関連語の入力
          Container(
            width: MediaQuery.of(context).size.width * .30,
            child: TextField(
              decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                hintText: "関連語",
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
              controller: relatedWordController,
              onSubmitted: (_) => submitData(),
            ),
          ),
          Text(
            '...？',
            style: Theme.of(context).textTheme.bodyText2,
          ),
        ],
      ),
    );
  }
}

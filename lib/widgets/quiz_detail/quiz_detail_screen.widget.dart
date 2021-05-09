import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../models/quiz.model.dart';
import '../background.widget.dart';
import './quiz_sentence.widget.dart';

class QuizDetailScreen extends StatefulWidget {
  static const routeName = '/quiz-detail';

  @override
  _QuizDetailScreenState createState() => _QuizDetailScreenState();
}

class _QuizDetailScreenState extends State<QuizDetailScreen> {
  final subjectController = TextEditingController();
  final relatedWordController = TextEditingController();

  List<Question> askQuestions = []; // 質問時表示用
  List<Question> remainingQuestions = []; // 質問削除実行用
  List<Question> askedQuestions = []; // 質問実行後用

  List<Answer> allAnswers = []; // 回答作成用
  List<Answer> availableAnswers = []; // 回答用
  List<int> executedAnswerIds = []; // 回答削除用

  bool initiateFlg = true;
  Question _selectedQuestion;
  String _reply = '';
  String _beforeWord = ''; // 質問語にhintで表示用
  bool _displayReply = false;
  bool _enableQuestionButton = false;
  bool _dummyDisplayFlg = false;

  void _executeQuestion() {
    setState(() {
      _enableQuestionButton = false;
      _reply = _selectedQuestion.reply;
      _displayReply = !_displayReply;
      askedQuestions.add(_selectedQuestion);

      remainingQuestions = remainingQuestions
          .where((question) => question.id != _selectedQuestion.id)
          .toList();

      askQuestions = askQuestions
          .where((question) => question.id != _selectedQuestion.id)
          .toList();
      _beforeWord = _selectedQuestion.asking;
      _selectedQuestion = null;
    });
  }

  void _setQuestion(Question targetQuestion) {
    setState(
      () {
        _enableQuestionButton = true;
        _displayReply = false;
        _selectedQuestion = targetQuestion;
      },
    );
  }

  void _checkQuestions(
    String subject,
    String relatedWord,
    List<Question> questions,
    List<String> allSubjects,
    List<String> allRelatedWords,
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
    setState(
      () {
        askQuestions = existFlg
            ? askQuestions = questions
                .where((question) =>
                    question.asking.startsWith(subject) &&
                    (!question.asking.startsWith(relatedWord) &&
                        question.asking.contains(relatedWord)))
                .toList()
            : [];

        if (askQuestions.isEmpty) {
          _enableQuestionButton = false;
          _displayReply = false;
          _dummyDisplayFlg = true;
        } else {
          _enableQuestionButton = true;
          _displayReply = false;
          _selectedQuestion = null;
          _dummyDisplayFlg = false;
        }
      },
    );
  }

  void submitData(Quiz quiz) {
    final enteredSubject = subjectController.text;
    final enteredRelatedWord = relatedWordController.text;

    setState(() {
      _beforeWord = '';
    });

    if (enteredSubject.isEmpty || enteredRelatedWord.isEmpty) {
      setState(() {
        _enableQuestionButton = false;
        _displayReply = false;
        _selectedQuestion = null;
        _dummyDisplayFlg = false;
        askQuestions = [];
      });
      return;
    }

    _checkQuestions(
      enteredSubject,
      enteredRelatedWord,
      remainingQuestions,
      quiz.subjects,
      quiz.relatedWords,
    );
  }

  void getAnswerChoices() {
    bool judgeFlg = true;
    List<Answer> wkAnswers = [];

    List<int> currentQuestionIds = askedQuestions.map((askedQuestion) {
      return askedQuestion.id;
    });

    allAnswers.forEach((Answer answer) {
      answer.questionIds.forEach((int questionId) {
        if (judgeFlg) {
          // 現在の回答の中に対象のidがなかったらfalse
          if (!currentQuestionIds.contains(questionId)) {
            judgeFlg = false;
          }
        }
      });

      // 必要な質問が出ている、かつ、まだ回答されていないanswerを追加
      if (judgeFlg && !executedAnswerIds.contains(answer.id)) {
        wkAnswers.add(answer);
      }
    });

    setState(() {
      availableAnswers = wkAnswers;
    });
  }

  @override
  Widget build(BuildContext context) {
    final quiz = ModalRoute.of(context).settings.arguments as Quiz;

    if (initiateFlg) {
      setState(() {
        remainingQuestions = quiz.questions;
        allAnswers = quiz.answers;
        initiateFlg = false;
      });
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(quiz.title),
        centerTitle: true,
        backgroundColor: Colors.blueGrey[900].withOpacity(0.9),
      ),
      body: GestureDetector(
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
                    padding: EdgeInsets.symmetric(
                      vertical: 15,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        // 主語の入力
                        _word_for_question(
                          context,
                          '主語',
                          subjectController,
                          quiz,
                        ),
                        Text(
                          'は',
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                        // 関連語の入力
                        _word_for_question(
                          context,
                          '関連語',
                          relatedWordController,
                          quiz,
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
                    padding: EdgeInsets.symmetric(
                      vertical: 15,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.symmetric(
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
                            hint: _dummyDisplayFlg
                                ? Text(
                                    'それらの言葉は関係ないようです。',
                                    style: TextStyle(
                                      // fontSize: 20,
                                      color: Colors.black87,
                                    ),
                                  )
                                : _beforeWord.isEmpty
                                    ? null
                                    : Text(_beforeWord),
                            // 下線をなくすため
                            underline: Container(
                              color: Colors.white,
                            ),
                            value: _selectedQuestion,
                            items: askQuestions.map((Question question) {
                              return DropdownMenuItem(
                                value: question,
                                child: Text(question.asking),
                              );
                            }).toList(),
                            onChanged: (selectedQuestion) {
                              _setQuestion(selectedQuestion);
                            },
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () =>
                              _enableQuestionButton ? _executeQuestion() : {},
                          child: const Text('質問！'),
                          style: ElevatedButton.styleFrom(
                            primary: _enableQuestionButton
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
                  // 返答出力
                  Padding(
                    padding: EdgeInsets.only(
                      top: 15,
                    ),
                    child: Container(
                      height: MediaQuery.of(context).size.height * .12,
                      width: MediaQuery.of(context).size.width * .85,
                      padding: EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black87,
                        border: Border.all(
                          color: Colors.pink[800],
                          width: 5,
                        ),
                      ),
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 500),
                        opacity: _displayReply ? 1 : 0,
                        child: Text(
                          _reply,
                          style: TextStyle(
                            fontSize: 17.0,
                            color: Colors.white,
                            fontFamily: 'NotoSerifJP',
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _word_for_question(
    BuildContext context,
    String text,
    TextEditingController controller,
    Quiz quiz,
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
        onSubmitted: (_) => submitData(quiz),
      ),
    );
  }
}

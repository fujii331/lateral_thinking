import 'package:flutter/foundation.dart';

class Question {
  final int id;
  final String question;
  final String reply;

  Question({
    @required this.id,
    @required this.question,
    @required this.reply,
  });
}

class Answer {
  final int id;
  final List<int> questionIds;
  final String answer;
  final String comment;

  Answer({
    @required this.id,
    @required this.questionIds,
    @required this.answer,
    @required this.comment,
  });
}

class Quiz {
  final int id;
  final String title;
  final String sentence;
  final List<String> subjects;
  final List<String> relatedWords;
  final List<Question> questions;
  final List<int> correctAnswerIds;
  final List<Answer> answers;

  Quiz({
    @required this.id,
    @required this.title,
    @required this.sentence,
    @required this.subjects,
    @required this.relatedWords,
    @required this.questions,
    @required this.correctAnswerIds,
    @required this.answers,
  });
}

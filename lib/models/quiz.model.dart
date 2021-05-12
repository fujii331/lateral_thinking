class Question {
  final int id;
  final String asking;
  final String reply;

  const Question({
    required this.id,
    required this.asking,
    required this.reply,
  });
}

class Answer {
  final int id;
  final List<int> questionIds;
  final String answer;
  final String comment;

  const Answer({
    required this.id,
    required this.questionIds,
    required this.answer,
    required this.comment,
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
  final int hintDisplayWordId;
  final int hintDisplayQuestionId;
  final int correctAnswerQuestionId;

  const Quiz({
    required this.id,
    required this.title,
    required this.sentence,
    required this.subjects,
    required this.relatedWords,
    required this.questions,
    required this.correctAnswerIds,
    required this.answers,
    required this.hintDisplayWordId,
    required this.hintDisplayQuestionId,
    required this.correctAnswerQuestionId,
  });
}

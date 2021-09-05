class GotAnalytics {
  final int id;
  final int hint1;
  final int hint2;
  final int noHint;
  final int subHint;
  final int relatedWordCountAll;
  final int questionCountAll;

  const GotAnalytics({
    required this.id,
    required this.hint1,
    required this.hint2,
    required this.noHint,
    required this.subHint,
    required this.relatedWordCountAll,
    required this.questionCountAll,
  });
}

class Analytics {
  final int hint1;
  final int hint2;
  final int noHint;
  final int subHint;
  final int relatedWordCountAll;
  final int relatedWordCountYou;
  final int questionCountAll;
  final int questionCountYou;

  const Analytics({
    required this.hint1,
    required this.hint2,
    required this.noHint,
    required this.subHint,
    required this.relatedWordCountAll,
    required this.relatedWordCountYou,
    required this.questionCountAll,
    required this.questionCountYou,
  });
}

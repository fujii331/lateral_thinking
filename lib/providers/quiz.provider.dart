import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../models/quiz.model.dart';

final remainingQuestionsProvider = StateProvider((ref) => <Question>[]);
final askedQuestionsProvider = StateProvider((ref) => <Question>[]);
final allAnswersProvider = StateProvider((ref) => <Answer>[]);
final executedAnswerIdsProvider = StateProvider((ref) => <int>[]);

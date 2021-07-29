import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../models/quiz.model.dart';
import 'package:audioplayers/audioplayers.dart';

final remainingQuestionsProvider = StateProvider((ref) => <Question>[]);
final askedQuestionsProvider = StateProvider((ref) => <Question>[]);
final allAnswersProvider = StateProvider((ref) => <Answer>[]);
final executedAnswerIdsProvider = StateProvider((ref) => <int>[]);
final correctAnswerIdsProvider = StateProvider((ref) => <int>[]);
final hintProvider = StateProvider((ref) => 0);
final subHintFlgProvider = StateProvider((ref) => false);
final openingNumberProvider = StateProvider((ref) => 0);
final openingNumberEnglishProvider = StateProvider((ref) => 0);
final enModeFlgProvider = StateProvider((ref) => true);
final helperModeFlgProvider = StateProvider((ref) => false);
final alreadyAnsweredIdsProvider = StateProvider((ref) => <String>[]);

// detail画面用
final selectedQuestionProvider = StateProvider((ref) => dummyQuestion);
final replyProvider = StateProvider((ref) => '');
final beforeWordProvider = StateProvider((ref) => '');
final displayReplyFlgProvider = StateProvider((ref) => false);
final selectedSubjectProvider = StateProvider((ref) => '');
final selectedRelatedWordProvider = StateProvider((ref) => '');
final askingQuestionsProvider = StateProvider((ref) => <Question>[]);

const dummyQuestion = Question(asking: '', id: 0, reply: '');

final soundEffectProvider = StateProvider((ref) => new AudioCache());

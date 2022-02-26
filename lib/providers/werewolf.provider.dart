import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../models/werewolf.model.dart';

final timerCancelFlgProvider = StateProvider((ref) => false);
final wolfIdProvider = StateProvider((ref) => 0);
final answeredPlayerIdProvider = StateProvider((ref) => 0);
final alreadyPlayedWerewolfFlgProvider = StateProvider((ref) => false);
final subTimeStopFlgProvider = StateProvider((ref) => false);

final modeProvider = StateProvider((ref) => '謎解きの王様');
final quizTitleProvider = StateProvider((ref) => '捨てる男');
final numOfPlayersProvider = StateProvider((ref) => '3');
final mainTimeProvider = StateProvider((ref) => '4');
final questionTimeProvider = StateProvider((ref) => '15');
final discussionTimeProvider = StateProvider((ref) => '3');
final peaceVillageProvider = StateProvider((ref) => 'なし');

final player1Provider = StateProvider(
  (ref) => Player(
    id: 1,
    name: 'プレイヤー１',
    point: 0,
  ),
);
final player2Provider = StateProvider(
  (ref) => Player(
    id: 2,
    name: 'プレイヤー２',
    point: 0,
  ),
);
final player3Provider = StateProvider(
  (ref) => Player(
    id: 3,
    name: 'プレイヤー３',
    point: 0,
  ),
);
final player4Provider = StateProvider(
  (ref) => Player(
    id: 4,
    name: 'プレイヤー４',
    point: 0,
  ),
);
final player5Provider = StateProvider(
  (ref) => Player(
    id: 5,
    name: 'プレイヤー５',
    point: 0,
  ),
);
final player6Provider = StateProvider(
  (ref) => Player(
    id: 6,
    name: 'プレイヤー６',
    point: 0,
  ),
);

final voteProvider = StateProvider(
  (ref) => Vote(
    player1: 0,
    player2: 0,
    player3: 0,
    player4: 0,
    player5: 0,
    player6: 0,
  ),
);

final votingDestinationProvider = StateProvider(
  (ref) => Vote(
    player1: 1,
    player2: 1,
    player3: 1,
    player4: 1,
    player5: 1,
    player6: 1,
  ),
);

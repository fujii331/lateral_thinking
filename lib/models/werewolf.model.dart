class Player {
  final int id;
  final String name;
  final int point;

  const Player({
    required this.id,
    required this.name,
    required this.point,
  });
}

class Vote {
  final int player1;
  final int player2;
  final int player3;
  final int player4;
  final int player5;
  final int player6;

  const Vote({
    required this.player1,
    required this.player2,
    required this.player3,
    required this.player4,
    required this.player5,
    required this.player6,
  });
}

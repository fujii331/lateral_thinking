import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lateral_thinking/widgets/quiz_list/quiz_list_detail_title.widget.dart';
import 'package:lateral_thinking/widgets/quiz_list/quiz_list_pagination.widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/quiz_list/quiz_list_detail.widget.dart';
import '../providers/quiz.provider.dart';
import '../widgets/background.widget.dart';

class QuizListScreen extends HookWidget {
  static const routeName = '/quiz-list';

  void _getOpeningNumber(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    context.read(openingNumberProvider).state =
        prefs.getInt('openingNumber') ?? 9;
  }

  @override
  Widget build(BuildContext context) {
    final screenNo = useState<int>(0);

    _getOpeningNumber(context);

    final int openingNumber = useProvider(openingNumberProvider).state;

    final int numOfPages = ((openingNumber + 1) / 6).ceil();
    final List<String> titles = [
      '- 始まりの門 -',
      '- 客人の間 -',
      '- お洒落な厨房 -',
      '- 憩いの食堂 -',
      '- 安らぎの寝室 -',
      '- 多忙の執務室 -',
      '- 王の居間 -',
      '- 地下の洞窟 -',
      '- 優雅な中庭 -',
      '- 開放的な屋上 -',
      '- 歌人の間 -',
      '- 王座の間 -',
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('問題一覧'),
        centerTitle: true,
        backgroundColor: Colors.blueGrey[900]?.withOpacity(0.9),
      ),
      body: Stack(
        children: [
          background(),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              QuizListDetailTitle(
                titles[screenNo.value],
              ),
              QuizListDetail(
                openingNumber,
                screenNo,
                numOfPages,
              ),
              QuizListPagination(
                screenNo,
                numOfPages,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

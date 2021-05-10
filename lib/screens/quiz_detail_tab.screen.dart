import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../widgets/quiz_detail/quiz_detail.widget.dart';
import '../widgets/quiz_detail/quiz_questioned.widget.dart';
import '../widgets/quiz_detail/quiz_answer.widget.dart';

import '../providers/quiz.provider.dart';
import '../models/enums.model.dart';
import '../models/quiz.model.dart';

class QuizDetailTabScreen extends HookWidget {
  static const routeName = '/quiz-detail-tab';

  @override
  Widget build(BuildContext context) {
    final quiz = ModalRoute.of(context)?.settings.arguments as Quiz;
    final _views = [
      QuizDetailScreen(quiz),
      QuizQuestioned(),
      QuizAnswer(),
    ];

    final tabType = useProvider(tabTypeProvider).state;
    return Scaffold(
      appBar: AppBar(
        title: Text(quiz.title),
        centerTitle: true,
        backgroundColor: Colors.blueGrey[900]?.withOpacity(0.9),
      ),
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: '問題',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_box),
            label: '質問済',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.comment),
            label: '回答',
          ),
        ],
        onTap: (int selectIndex) {
          context.read(tabTypeProvider).state = TabType.values[selectIndex];
        },
        currentIndex: tabType.index,
      ),
      body: _views[tabType.index],
      // body: ProviderScope(
      //   child: _views[_selectIndex],
      // ),
    );
  }
}

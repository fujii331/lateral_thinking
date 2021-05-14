import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../widgets/quiz_detail.widget.dart';
import '../widgets/quiz_detail/questioned.widget.dart';
import '../widgets/quiz_detail/quiz_answer.widget.dart';
import '../widgets/hint/hint_modal.widget.dart';

import '../models/quiz.model.dart';

class QuizDetailTabScreen extends HookWidget {
  static const routeName = '/quiz-detail-tab';

  @override
  Widget build(BuildContext context) {
    final quiz = ModalRoute.of(context)?.settings.arguments as Quiz;

    final _screen = useState<int>(0);
    final _pageController = usePageController(initialPage: 0, keepPage: true);

    return Scaffold(
      appBar: AppBar(
        title: Text(quiz.title),
        centerTitle: true,
        backgroundColor: Colors.blueGrey[900]?.withOpacity(0.9),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.lightbulb,
              color: Colors.yellow,
            ),
            onPressed: () async {
              await showDialog<int>(
                context: context,
                barrierDismissible: true,
                builder: (BuildContext context) {
                  return HintModal(quiz);
                },
              );
            },
          ),
        ],
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
          _screen.value = selectIndex;
          _pageController.animateToPage(selectIndex,
              duration: Duration(milliseconds: 400), curve: Curves.easeOut);
        },
        currentIndex: _screen.value,
      ),
      body: PageView(
        controller: _pageController,
        // ページ切り替え時に実行する処理
        onPageChanged: (index) {
          _screen.value = index;
        },
        children: [
          QuizDetail(quiz),
          Questioned(),
          QuizAnswer(),
        ],
      ),
    );
  }
}

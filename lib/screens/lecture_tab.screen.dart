import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../widgets/lecture/lecture_first.widget.dart';
import '../widgets/lecture/lecture_figure.widget.dart';
import '../widgets/lecture/lecture_last.widget.dart';

class LectureTabScreen extends HookWidget {
  static const routeName = '/lecture-tab';

  @override
  Widget build(BuildContext context) {
    final screenNo = useState<int>(0);
    final pageController = usePageController(initialPage: 0, keepPage: true);

    return Scaffold(
      appBar: AppBar(
        title: Text('遊び方'),
        centerTitle: true,
        backgroundColor: Colors.blueGrey[900]?.withOpacity(0.9),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.assistant_photo_outlined),
            label: '始めに',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.looks_one_outlined),
            label: '質問',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.looks_two_outlined),
            label: '質問返答',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.looks_3_outlined),
            label: '質問一覧',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.looks_4_outlined),
            label: '回答',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.looks_5_outlined),
            label: '不正解時',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.looks_6_outlined),
            label: '正解時',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.lightbulb_outline),
            label: 'ヒント',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_run),
            label: '終わりに',
          ),
        ],
        onTap: (int selectIndex) {
          screenNo.value = selectIndex;
          pageController.animateToPage(selectIndex,
              duration: Duration(milliseconds: 400), curve: Curves.easeOut);
        },
        currentIndex: screenNo.value,
      ),
      body: PageView(
        controller: pageController,
        // ページ切り替え時に実行する処理
        onPageChanged: (index) {
          screenNo.value = index;
        },
        children: [
          LectureFirst(),
          LectureFigure('assets/images/lecture1.png'),
          LectureFigure('assets/images/lecture2.png'),
          LectureFigure('assets/images/lecture3.png'),
          LectureFigure('assets/images/lecture4.png'),
          LectureFigure('assets/images/lecture5.png'),
          LectureFigure('assets/images/lecture6.png'),
          LectureFigure('assets/images/lecture_hint.png'),
          LectureLast(),
        ],
      ),
    );
  }
}

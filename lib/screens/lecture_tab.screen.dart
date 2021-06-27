import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../widgets/lecture/lecture_first.widget.dart';
import '../widgets/lecture/lecture_figure.widget.dart';
import '../widgets/lecture/lecture_last.widget.dart';
import '../providers/quiz.provider.dart';
import '../text.dart';

class LectureTabScreen extends HookWidget {
  static const routeName = '/lecture-tab';

  @override
  Widget build(BuildContext context) {
    final screenNo = useState<int>(0);
    final pageController = usePageController(initialPage: 0, keepPage: true);
    final bool enModeFlg = useProvider(enModeFlgProvider).state;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          enModeFlg
              ? EN_TEXT['playMethodButton']!
              : JA_TEXT['playMethodButton']!,
        ),
        centerTitle: true,
        backgroundColor: Colors.blueGrey[900]?.withOpacity(0.9),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.assistant_photo_outlined),
            label: enModeFlg
                ? EN_TEXT['playMethodBottom1']!
                : JA_TEXT['playMethodBottom1']!,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.looks_one_outlined),
            label: enModeFlg
                ? EN_TEXT['playMethodBottom2']!
                : JA_TEXT['playMethodBottom2'],
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.looks_two_outlined),
            label: enModeFlg
                ? EN_TEXT['playMethodBottom3']!
                : JA_TEXT['playMethodBottom3']!,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.looks_3_outlined),
            label: enModeFlg
                ? EN_TEXT['playMethodBottom4']!
                : JA_TEXT['playMethodBottom4']!,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.looks_4_outlined),
            label: enModeFlg
                ? EN_TEXT['playMethodBottom5']!
                : JA_TEXT['playMethodBottom5']!,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.looks_5_outlined),
            label: enModeFlg
                ? EN_TEXT['playMethodBottom6']!
                : JA_TEXT['playMethodBottom6']!,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.looks_6_outlined),
            label: enModeFlg
                ? EN_TEXT['playMethodBottom7']!
                : JA_TEXT['playMethodBottom7']!,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.lightbulb_outline),
            label: enModeFlg
                ? EN_TEXT['playMethodBottom8']!
                : JA_TEXT['playMethodBottom8']!,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_run),
            label: enModeFlg
                ? EN_TEXT['playMethodBottom9']!
                : JA_TEXT['playMethodBottom9']!,
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
          enModeFlg
              ? LectureFigure('assets/images/lecture1_en.png')
              : LectureFigure('assets/images/lecture1.png'),
          enModeFlg
              ? LectureFigure('assets/images/lecture2_en.png')
              : LectureFigure('assets/images/lecture2.png'),
          enModeFlg
              ? LectureFigure('assets/images/lecture3_en.png')
              : LectureFigure('assets/images/lecture3.png'),
          enModeFlg
              ? LectureFigure('assets/images/lecture4_en.png')
              : LectureFigure('assets/images/lecture4.png'),
          enModeFlg
              ? LectureFigure('assets/images/lecture5_en.png')
              : LectureFigure('assets/images/lecture5.png'),
          enModeFlg
              ? LectureFigure('assets/images/lecture6_en.png')
              : LectureFigure('assets/images/lecture6.png'),
          enModeFlg
              ? LectureFigure('assets/images/lecture_hint_en.png')
              : LectureFigure('assets/images/lecture_hint.png'),
          LectureLast(),
        ],
      ),
    );
  }
}

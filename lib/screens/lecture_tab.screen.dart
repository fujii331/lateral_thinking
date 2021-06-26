import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
        title: Text(AppLocalizations.of(context)!.playMethodButton),
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
            label: AppLocalizations.of(context)!.playMethodBottom1,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.looks_one_outlined),
            label: AppLocalizations.of(context)!.playMethodBottom2,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.looks_two_outlined),
            label: AppLocalizations.of(context)!.playMethodBottom3,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.looks_3_outlined),
            label: AppLocalizations.of(context)!.playMethodBottom4,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.looks_4_outlined),
            label: AppLocalizations.of(context)!.playMethodBottom5,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.looks_5_outlined),
            label: AppLocalizations.of(context)!.playMethodBottom6,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.looks_6_outlined),
            label: AppLocalizations.of(context)!.playMethodBottom7,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.lightbulb_outline),
            label: AppLocalizations.of(context)!.playMethodBottom8,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_run),
            label: AppLocalizations.of(context)!.playMethodBottom9,
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

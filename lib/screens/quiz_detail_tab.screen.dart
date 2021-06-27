import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

import '../widgets/quiz_detail/quiz_detail.widget.dart';
import '../widgets/quiz_detail/questioned.widget.dart';
import '../widgets/quiz_detail/quiz_answer.widget.dart';
import '../widgets/hint/hint_modal.widget.dart';
import '../providers/quiz.provider.dart';

import '../models/quiz.model.dart';
import '../text.dart';

class QuizDetailTabScreen extends HookWidget {
  static const routeName = '/quiz-detail-tab';

  @override
  Widget build(BuildContext context) {
    final AudioCache soundEffect = useProvider(soundEffectProvider).state;
    final Quiz quiz = ModalRoute.of(context)?.settings.arguments as Quiz;

    final screenNo = useState<int>(0);
    final pageController = usePageController(initialPage: 0, keepPage: true);
    final List<Answer> allAnswers = useProvider(allAnswersProvider).state;
    final bool enModeFlg = useProvider(enModeFlgProvider).state;

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
            onPressed: allAnswers.isEmpty
                ? null
                : () {
                    soundEffect.play('sounds/hint.mp3', isNotification: true);
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.QUESTION,
                      headerAnimationLoop: false,
                      animType: AnimType.BOTTOMSLIDE,
                      width: MediaQuery.of(context).size.width * .86 > 650
                          ? 650
                          : null,
                      body: HintModal(quiz),
                    )..show();
                  },
          ),
        ],
      ),
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: enModeFlg ? EN_TEXT['bottomQuiz']! : JA_TEXT['bottomQuiz']!,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_box),
            label: enModeFlg
                ? EN_TEXT['bottomQuestioned']!
                : JA_TEXT['bottomQuestioned']!,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.comment),
            label:
                enModeFlg ? EN_TEXT['bottomAnswer']! : JA_TEXT['bottomAnswer']!,
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
          QuizDetail(quiz),
          Questioned(),
          QuizAnswer(),
        ],
      ),
    );
  }
}

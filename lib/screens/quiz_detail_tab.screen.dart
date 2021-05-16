import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:audioplayers/audio_cache.dart';

import '../widgets/quiz_detail/quiz_detail.widget.dart';
import '../widgets/quiz_detail/questioned.widget.dart';
import '../widgets/quiz_detail/quiz_answer.widget.dart';
import '../widgets/hint/hint_modal.widget.dart';
import '../widgets/loading.widget.dart';
import '../providers/quiz.provider.dart';

import '../models/quiz.model.dart';

class QuizDetailTabScreen extends HookWidget {
  static const routeName = '/quiz-detail-tab';

  @override
  Widget build(BuildContext context) {
    final AudioCache soundEffect = useProvider(soundEffectProvider).state;
    final Quiz quiz = ModalRoute.of(context)?.settings.arguments as Quiz;

    final screenNo = useState<int>(0);
    final pageController = usePageController(initialPage: 0, keepPage: true);
    final List<Answer> allAnswers = useProvider(allAnswersProvider).state;

    final nowLoading = useState(false);

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
            onPressed: nowLoading.value || allAnswers.isEmpty
                ? () {}
                : () {
                    soundEffect.play('sounds/hint.mp3', isNotification: true);
                    showDialog<int>(
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
        onTap: nowLoading.value
            ? (int selectIndex) {}
            : (int selectIndex) {
                screenNo.value = selectIndex;
                pageController.animateToPage(selectIndex,
                    duration: Duration(milliseconds: 400),
                    curve: Curves.easeOut);
              },
        currentIndex: screenNo.value,
      ),
      body: Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.antiAlias,
        children: <Widget>[
          PageView(
            controller: pageController,
            // ページ切り替え時に実行する処理
            onPageChanged: (index) {
              screenNo.value = index;
            },
            children: [
              QuizDetail(quiz),
              Questioned(),
              QuizAnswer(nowLoading),
            ],
          ),
          Loading(nowLoading.value),
        ],
      ),
    );
  }
}

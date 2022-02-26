import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:lateral_thinking/services/admob/interstitial_action.service.dart';

import '../widgets/quiz_detail/quiz_detail.widget.dart';
import '../widgets/quiz_detail/questioned.widget.dart';
import '../widgets/quiz_detail/quiz_answer.widget.dart';
import '../widgets/hint/hint_modal.widget.dart';
import '../providers/quiz.provider.dart';
import '../widgets/hint/opened_sub_hint_modal.widget.dart';
import '../widgets/hint/sub_hint_modal.widget.dart';
import '../providers/common.provider.dart';

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
    final bool subHintFlg = useProvider(subHintFlgProvider).state;
    final int hint = useProvider(hintProvider).state;
    final double seVolume = useProvider(seVolumeProvider).state;
    final List<Answer> readyForAnswers =
        useProvider(readyForAnswersProvider).state;
    final bool enableAnswer = readyForAnswers.length > 0;

    final workHint = useState<int>(0);

    final subjectController = useTextEditingController();
    final relatedWordController = useTextEditingController();

    final ValueNotifier<InterstitialAd?> interstitialAd = useState(null);

    useEffect(() {
      WidgetsBinding.instance!.addPostFrameCallback((_) async {
        // 広告読み込み
        interstitialLoading(
          interstitialAd,
          1,
        );
      });
      return null;
    }, const []);

    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/background.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.black.withOpacity(0.3),
        appBar: AppBar(
          title: Text(
            quiz.title,
            style: const TextStyle(
              fontFamily: 'KaiseiOpti',
            ),
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
          ),
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.blueGrey.shade900.withOpacity(0.8),
          actions: <Widget>[
            IconButton(
                iconSize: 22,
                icon: Icon(
                  subHintFlg ? Icons.info : Icons.lightbulb,
                  color: Colors.orange.shade400,
                ),
                onPressed: allAnswers.isEmpty
                    ? null
                    : subHintFlg
                        ? () {
                            soundEffect.play(
                              'sounds/tap.mp3',
                              isNotification: true,
                              volume: seVolume,
                            );
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.NO_HEADER,
                              headerAnimationLoop: false,
                              animType: AnimType.SCALE,
                              width:
                                  MediaQuery.of(context).size.width * .86 > 650
                                      ? 650
                                      : null,
                              body: OpenedSubHintModal(
                                subHints: quiz.subHints,
                              ),
                            )..show();
                          }
                        : () {
                            soundEffect.play(
                              'sounds/hint.mp3',
                              isNotification: true,
                              volume: seVolume,
                            );
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.QUESTION,
                              headerAnimationLoop: false,
                              animType: AnimType.BOTTOMSLIDE,
                              width:
                                  MediaQuery.of(context).size.width * .86 > 650
                                      ? 650
                                      : null,
                              body: SubHintModal(
                                screenContext: context,
                                subHints: quiz.subHints,
                                quizId: quiz.id,
                              ),
                            )..show();
                          }),
            IconButton(
              icon: Icon(
                Icons.lightbulb,
                color: Colors.yellow,
              ),
              onPressed: allAnswers.isEmpty
                  ? null
                  : () {
                      soundEffect.play(
                        'sounds/hint.mp3',
                        isNotification: true,
                        volume: seVolume,
                      );
                      workHint.value = hint;
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.QUESTION,
                        headerAnimationLoop: false,
                        animType: AnimType.BOTTOMSLIDE,
                        width: MediaQuery.of(context).size.width * .86 > 650
                            ? 650
                            : null,
                        body: HintModal(
                          screenContext: context,
                          quiz: quiz,
                          subjectController: subjectController,
                          relatedWordController: relatedWordController,
                          workHintValue: workHint.value,
                        ),
                      ).show();
                    },
            ),
          ],
        ),
        // extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: true,
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.shifting,
          selectedItemColor: Colors.blue.shade200,
          unselectedItemColor: Colors.grey.shade200,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.school),
              label:
                  enModeFlg ? EN_TEXT['bottomQuiz']! : JA_TEXT['bottomQuiz']!,
              backgroundColor: Colors.blueGrey.shade600.withOpacity(0.4),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.check_box),
              label: enModeFlg
                  ? EN_TEXT['bottomQuestioned']!
                  : JA_TEXT['bottomQuestioned']!,
              backgroundColor: Colors.blueGrey.shade600.withOpacity(0.4),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.comment,
                color: enableAnswer ? Colors.cyan.shade300 : null,
              ),
              label: enModeFlg
                  ? EN_TEXT['bottomAnswer']!
                  : JA_TEXT['bottomAnswer']!,
              backgroundColor: Colors.blueGrey.shade600.withOpacity(0.4),
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
            QuizDetail(
              quiz,
              subjectController,
              relatedWordController,
            ),
            Questioned(),
            QuizAnswer(
              quizId: quiz.id,
              interstitialAd: interstitialAd,
            ),
          ],
        ),
      ),
    );
  }
}

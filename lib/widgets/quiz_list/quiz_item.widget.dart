import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';

import '../../models/quiz.model.dart';
import '../../screens/quiz_detail_tab.screen.dart';
import '../../providers/quiz.provider.dart';
import '../../providers/common.provider.dart';

import '../../text.dart';

class QuizItem extends HookWidget {
  final Quiz quiz;

  QuizItem(this.quiz);

  void toQuizDetail(BuildContext context, AudioCache soundEffect) {
    if (context.read(playingQuizIdProvider).state != quiz.id) {
      context.read(remainingQuestionsProvider).state = quiz.questions;
      context.read(askedQuestionsProvider).state = [];
      context.read(allAnswersProvider).state = quiz.answers;
      context.read(executedAnswerIdsProvider).state = [];
      context.read(correctAnswerIdsProvider).state = quiz.correctAnswerIds;
      context.read(hintProvider).state = 0;
      context.read(subHintFlgProvider).state = false;
      context.read(selectedQuestionProvider).state = dummyQuestion;
      context.read(playingQuizIdProvider).state = quiz.id;
      context.read(relatedWordCountProvider).state = 0;
      context.read(questionCountProvider).state = 0;
    }

    context.read(replyProvider).state = '';
    context.read(beforeWordProvider).state = '';
    context.read(displayReplyFlgProvider).state = false;
    context.read(selectedSubjectProvider).state = '';
    context.read(selectedRelatedWordProvider).state = '';
    context.read(askingQuestionsProvider).state = [];

    Navigator.of(context)
        .pushNamed(QuizDetailTabScreen.routeName, arguments: quiz);
  }

  @override
  Widget build(BuildContext context) {
    final AudioCache soundEffect = useProvider(soundEffectProvider).state;
    final height = MediaQuery.of(context).size.height;
    final bool enModeFlg = useProvider(enModeFlgProvider).state;
    final double seVolume = useProvider(seVolumeProvider).state;
    final List<String> alreadyAnsweredIds =
        useProvider(alreadyAnsweredIdsProvider).state;

    return Stack(
      children: [
        Container(
          height: height > 620 ? 52 : 45,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: FractionalOffset.topLeft,
              end: FractionalOffset.bottomRight,
              colors: [
                const Color(0xFFFFFFFF),
                quiz.difficulty == 1
                    ? Color(0xf2339999)
                    : quiz.difficulty == 2
                        ? Color(0xf22288d8)
                        : quiz.difficulty == 3
                            ? Color(0xf2ff5577)
                            : Color(0xF2FFFFFF),
              ],
              stops: const [
                0.6,
                0.8,
              ],
            ),
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Colors.black,
              width: 1,
            ),
          ),
          margin: EdgeInsets.symmetric(
            vertical: height > 620 ? 8 : 6,
            horizontal: 5,
          ),
          child: ListTile(
            leading: Container(
              padding: EdgeInsets.only(
                  top: height > 620 ? 5 : 0,
                  bottom: height > 620 ? 10 : 15,
                  left: 5,
                  right: 5),
              child: Text(
                enModeFlg
                    ? EN_TEXT['listPrefix']! + quiz.id.toString()
                    : JA_TEXT['listPrefix']! + quiz.id.toString(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.purple.shade500,
                ),
              ),
            ),
            title: Container(
              padding: EdgeInsets.only(
                  top: height > 620 ? 5 : 0,
                  bottom: height > 620 ? 10 : 15,
                  right: 5),
              child: Text(
                quiz.title,
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
            trailing: Container(
              padding: EdgeInsets.only(
                bottom: height > 620
                    ? 6
                    : quiz.id == 1
                        ? 14
                        : 12,
              ),
              width: 70,
              child: quiz.difficulty == 0
                  ? Text(
                      enModeFlg ? 'Trial' : '練習用',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.orange.shade900,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : Row(
                      children: [
                        Icon(
                          Icons.star,
                          size: 22,
                          color: Colors.yellow.shade400,
                        ),
                        quiz.difficulty > 1
                            ? Icon(
                                Icons.star,
                                size: 22,
                                color: Colors.yellow.shade500,
                              )
                            : Container(),
                        quiz.difficulty > 2
                            ? Icon(
                                Icons.star,
                                size: 22,
                                color: Colors.yellow.shade600,
                              )
                            : Container(),
                      ],
                    ),
            ),
            onTap: () {
              soundEffect.play(
                'sounds/tap.mp3',
                isNotification: true,
                volume: seVolume,
              );
              toQuizDetail(context, soundEffect);
            },
          ),
        ),
        !enModeFlg && alreadyAnsweredIds.contains(quiz.id.toString())
            ? Container(
                padding: EdgeInsets.only(
                  top: height > 620 ? 7 : 4,
                  left: 10,
                ),
                child: Text(
                  'Clear!',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.green.shade700,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            : Container()
      ],
    );
  }
}

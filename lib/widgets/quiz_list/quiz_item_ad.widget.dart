import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../models/quiz.model.dart';
import '../../providers/quiz.provider.dart';
import '../../text.dart';

class QuizItemAd extends HookWidget {
  final Quiz quiz;

  QuizItemAd(this.quiz);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final bool enModeFlg = useProvider(enModeFlgProvider).state;

    return Container(
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
        color: Colors.grey,
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
              color: Colors.purple[800],
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
            bottom: height > 620 ? 6 : 12,
          ),
          width: 75,
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
                      color: Colors.yellow.shade400,
                    ),
                    quiz.difficulty > 1
                        ? Icon(
                            Icons.star,
                            color: Colors.yellow.shade500,
                          )
                        : Container(),
                    quiz.difficulty > 2
                        ? Icon(
                            Icons.star,
                            color: Colors.yellow.shade600,
                          )
                        : Container(),
                  ],
                ),
        ),
        onTap: null,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../providers/quiz.provider.dart';
import '../../text.dart';

class QuizItemNone extends HookWidget {
  final int quizNum;

  QuizItemNone(this.quizNum);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final bool enModeFlg = useProvider(enModeFlgProvider).state;

    return Container(
      height: height > 620 ? 52 : 45,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.grey.shade700,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.black,
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
                ? EN_TEXT['listPrefix']! + quizNum.toString()
                : JA_TEXT['listPrefix']! + quizNum.toString(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.white60,
            ),
          ),
        ),
        title: Container(
          padding: EdgeInsets.only(
              top: height > 620 ? 5 : 0,
              bottom: height > 620 ? 10 : 15,
              right: 5),
          child: Text(
            enModeFlg
                ? EN_TEXT['quizItemNoneText']!
                : JA_TEXT['quizItemNoneText']!,
            style: TextStyle(
              color: Colors.white60,
              fontSize: 20,
            ),
          ),
        ),
        onTap: null,
      ),
    );
  }
}

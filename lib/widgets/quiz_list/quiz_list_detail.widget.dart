import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import './quiz_item.widget.dart';
import './quiz_item_ad.widget.dart';
import './quiz_item_none.widget.dart';
import '../../quiz_data.dart';

class QuizListDetail extends HookWidget {
  final int openingNumber;
  final ValueNotifier<int> screenNo;
  final int numOfPages;

  QuizListDetail(
    this.openingNumber,
    this.screenNo,
    this.numOfPages,
  );

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Container(
      height: height > 610
          ? 420
          : height > 480
              ? 338
              : height * 0.65,
      margin: EdgeInsets.symmetric(
        vertical: 5,
        horizontal: 15,
      ),
      child: ListView.builder(
        itemBuilder: (ctx, index) {
          int quizNumber = index + 6 * (screenNo.value);
          return quizNumber < openingNumber
              ? QuizItem(QUIZ_DATA[quizNumber])
              : openingNumber < QUIZ_DATA.length
                  ? QuizItemAd(QUIZ_DATA[quizNumber])
                  : quizNumber == QUIZ_DATA.length
                      ? QuizItemNone(openingNumber + 1)
                      : Container();
        },
        itemCount:
            screenNo.value + 1 == numOfPages && openingNumber % 6 == 0 ? 3 : 6,
      ),
    );
  }
}

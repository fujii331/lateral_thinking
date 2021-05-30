import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import './quiz_item.widget.dart';
import './quiz_item_ad.widget.dart';
import './quiz_item_none.widget.dart';
import '../../quiz_data.dart';
import '../background.widget.dart';

class QuizListPage extends HookWidget {
  final int pageNumber;
  final int openingNumber;
  final ValueNotifier<int> screenNo;
  final PageController pageController;
  final int numOfPages;
  final String tabTitle;

  QuizListPage(this.pageNumber, this.openingNumber, this.screenNo,
      this.pageController, this.numOfPages, this.tabTitle);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        background(),
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 10),
              child: Text(
                tabTitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                  // fontFamily: 'KiwiMaru',
                  color: Colors.yellow.shade100,
                ),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * .7 > 430
                  ? 430
                  : MediaQuery.of(context).size.height * .7,
              margin: EdgeInsets.symmetric(
                vertical: 5,
                horizontal: 15,
              ),
              child: ListView.builder(
                  itemBuilder: (ctx, index) {
                    int quizNumber = index + 6 * (pageNumber - 1);
                    return quizNumber < openingNumber
                        ? QuizItem(QUIZ_DATA[quizNumber])
                        : openingNumber < QUIZ_DATA.length
                            ? QuizItemAd(QUIZ_DATA[quizNumber])
                            : quizNumber == QUIZ_DATA.length
                                ? QuizItemNone(openingNumber + 1)
                                : Container();
                  },
                  itemCount: pageNumber == numOfPages && openingNumber % 6 == 0
                      ? 3
                      : 6),
            ),
            Padding(
              padding: const EdgeInsets.only(
                bottom: 10,
                right: 10,
                left: 10,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  screenNo.value == 0
                      ? _dummyBox()
                      : _paginationButton(
                          context, screenNo, pageController, 0, '<<'),
                  screenNo.value == 0
                      ? _dummyBox()
                      : _paginationButton(context, screenNo, pageController,
                          screenNo.value - 1, '<'),
                  screenNo.value == numOfPages - 1
                      ? _dummyBox()
                      : _paginationButton(context, screenNo, pageController,
                          screenNo.value + 1, '>'),
                  screenNo.value == numOfPages - 1
                      ? _dummyBox()
                      : _paginationButton(context, screenNo, pageController,
                          numOfPages - 1, '>>'),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _paginationButton(
    BuildContext context,
    ValueNotifier<int> screenNo,
    PageController pageController,
    int toScreenNo,
    String icon,
  ) {
    return ElevatedButton(
      onPressed: () => {
        screenNo.value = toScreenNo,
        pageController.animateToPage(toScreenNo,
            duration: Duration(milliseconds: 10), curve: Curves.easeOut),
      },
      child: Text(
        icon,
        style: TextStyle(
          fontSize: 25.0,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      style: ElevatedButton.styleFrom(
        primary: Colors.white.withOpacity(0.3),
        textStyle: Theme.of(context).textTheme.button,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _dummyBox() {
    return const SizedBox(
      width: 64,
    );
  }
}

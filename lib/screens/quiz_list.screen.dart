import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/quiz_list/quiz_item.widget.dart';
import '../widgets/quiz_list/quiz_item_ad.widget.dart';
import '../widgets/quiz_list/quiz_item_none.widget.dart';

import '../quiz_data.dart';
import '../widgets/background.widget.dart';
import '../providers/quiz.provider.dart';

class QuizListScreen extends HookWidget {
  static const routeName = '/quiz-list';

  void _getOpeningNumber(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    context.read(openingNumberProvider).state =
        prefs.getInt('openingNumber') ?? 10;
  }

  @override
  Widget build(BuildContext context) {
    final int openingNumber = useProvider(openingNumberProvider).state;

    _getOpeningNumber(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('問題一覧'),
        centerTitle: true,
        backgroundColor: Colors.blueGrey[900]?.withOpacity(0.9),
      ),
      body: Stack(
        children: <Widget>[
          background(),
          Container(
            height: MediaQuery.of(context).size.height * .85,
            margin: EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 15,
            ),
            child: ListView.builder(
                itemBuilder: (ctx, index) {
                  return index < openingNumber
                      ? QuizItem(QUIZ_DATA[index])
                      : openingNumber < QUIZ_DATA.length
                          ? QuizItemAd(QUIZ_DATA[index])
                          : QuizItemNone(openingNumber + 1);
                },
                itemCount: openingNumber + 1),
          ),
        ],
      ),
    );
  }
}

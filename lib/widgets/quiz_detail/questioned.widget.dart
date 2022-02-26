import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../background.widget.dart';
import '../../providers/quiz.provider.dart';
import '../../models/quiz.model.dart';
import '../../text.dart';

class Questioned extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * .35;
    final List<Question> askedQuestions =
        useProvider(askedQuestionsProvider).state;
    final bool enModeFlg = useProvider(enModeFlgProvider).state;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          height: MediaQuery.of(context).size.height * .75,
          width: MediaQuery.of(context).size.width * .85,
          margin: EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Colors.black,
            ),
          ),
          child: askedQuestions.isEmpty
              ? Container(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    enModeFlg
                        ? EN_TEXT['questionedList']!
                        : JA_TEXT['questionedList']!,
                    style: TextStyle(
                      fontSize: height > 210 ? 18 : 16,
                      color: Colors.black54,
                      fontFamily: 'NotoSerifJP',
                    ),
                  ),
                )
              : Container(
                  padding: const EdgeInsets.all(10),
                  child: ListView.builder(
                    itemBuilder: (ctx, index) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            minLeadingWidth: 5,
                            leading: Text(
                              'Q:',
                              style: TextStyle(
                                fontSize: height > 210 ? 18.0 : 16.0,
                                color: Colors.black,
                                fontFamily: 'NotoSerifJP',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            title: Text(
                              askedQuestions[index].asking,
                              style: height > 210
                                  ? Theme.of(context).textTheme.headline2
                                  : Theme.of(context).textTheme.headline3,
                            ),
                          ),
                          ListTile(
                            minLeadingWidth: 5,
                            leading: Text(
                              'A:',
                              style: TextStyle(
                                fontSize: height > 210 ? 18.0 : 16.0,
                                color: Colors.red.shade800,
                                fontFamily: 'NotoSerifJP',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            title: Text(
                              askedQuestions[index].reply,
                              style: height > 210
                                  ? Theme.of(context).textTheme.headline2
                                  : Theme.of(context).textTheme.headline3,
                            ),
                          ),
                          SizedBox(height: height > 210 ? 25 : 15),
                        ],
                      );
                    },
                    itemCount: askedQuestions.length,
                  ),
                ),
        ),
      ),
    );
  }
}

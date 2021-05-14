import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../background.widget.dart';
import '../../providers/quiz.provider.dart';
import '../../models/quiz.model.dart';

class Questioned extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final List<Question> askedQuestions =
        useProvider(askedQuestionsProvider).state;

    return Stack(
      children: <Widget>[
        background(),
        Center(
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
                      '質問をすることで、ここに聞いた質問と返答が追加されていきます。',
                      style: TextStyle(
                        fontSize: 20.0,
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
                                  fontSize: 20.0,
                                  color: Colors.black,
                                  fontFamily: 'NotoSerifJP',
                                ),
                              ),
                              title: Text(
                                askedQuestions[index].asking,
                                style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.black,
                                  fontFamily: 'NotoSerifJP',
                                ),
                              ),
                            ),
                            ListTile(
                              minLeadingWidth: 5,
                              leading: Text(
                                'A:',
                                style: TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.red.shade800,
                                  fontFamily: 'NotoSerifJP',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              title: Text(
                                askedQuestions[index].reply,
                                style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.black,
                                  fontFamily: 'NotoSerifJP',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 25),
                          ],
                        );
                      },
                      itemCount: askedQuestions.length,
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}

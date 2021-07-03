import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../background.widget.dart';
import '../../providers/quiz.provider.dart';
import '../../text.dart';

class LectureFirst extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final bool enModeFlg = useProvider(enModeFlgProvider).state;

    return Stack(
      children: <Widget>[
        background(),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Opacity(
                opacity: 0.5,
                child: Image.asset(
                  'assets/images/1_2.png',
                  width: MediaQuery.of(context).size.width * .6,
                ),
              ),
            ),
            Text(
              enModeFlg ? EN_TEXT['boyaName']! : JA_TEXT['boyaName']!,
              style: TextStyle(
                fontSize: 26.0,
                color: Colors.white,
                fontFamily: 'YuseiMagic',
              ),
            ),
          ],
        ),
        Center(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Color.fromRGBO(0, 0, 0, 0.6),
            ),
            height: MediaQuery.of(context).size.height * .80,
            width: MediaQuery.of(context).size.width * .92,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      enModeFlg
                          ? EN_TEXT['lectureFirst1']!
                          : JA_TEXT['lectureFirst1']!,
                      style: TextStyle(
                        fontSize: 17.0,
                        color: Colors.white,
                        fontFamily: 'NotoSerifJP',
                        height: 1.7,
                      ),
                    ),
                    Text(
                      enModeFlg
                          ? EN_TEXT['lectureFirst2']!
                          : JA_TEXT['lectureFirst2']!,
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.yellow.shade200,
                        height: 1.7,
                      ),
                    ),
                    Text(
                      enModeFlg
                          ? EN_TEXT['lectureFirst3']!
                          : JA_TEXT['lectureFirst3']!,
                      style: TextStyle(
                        fontSize: 17.0,
                        color: Colors.white,
                        fontFamily: 'NotoSerifJP',
                        height: 1.7,
                      ),
                    ),
                    Text(
                      enModeFlg
                          ? EN_TEXT['lectureFirst4']!
                          : JA_TEXT['lectureFirst4']!,
                      style: TextStyle(
                        fontSize: 15.0,
                        color: Colors.white,
                        fontFamily: 'NotoSerifJP',
                        height: 1.7,
                      ),
                    ),
                    Text(
                      enModeFlg
                          ? EN_TEXT['lectureFirst5']!
                          : JA_TEXT['lectureFirst5']!,
                      style: TextStyle(
                        fontSize: 17.0,
                        color: Colors.white,
                        fontFamily: 'NotoSerifJP',
                        height: 1.7,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

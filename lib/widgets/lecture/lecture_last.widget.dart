import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../background.widget.dart';
import '../../providers/quiz.provider.dart';
import '../../text.dart';

class LectureLast extends HookWidget {
  final bool enModeFlg = useProvider(enModeFlgProvider).state;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        background(),
        Center(
          child: Opacity(
            opacity: 0.5,
            child: Image.asset(
              'assets/images/true_4_1.png',
              width: MediaQuery.of(context).size.width * .6,
            ),
          ),
        ),
        Center(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Color.fromRGBO(0, 0, 0, 0.6),
            ),
            width: MediaQuery.of(context).size.width * .92,
            margin: EdgeInsets.all(5),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      enModeFlg
                          ? EN_TEXT['lectureLast1']!
                          : JA_TEXT['lectureLast1']!,
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.white,
                        fontFamily: 'NotoSerifJP',
                        height: 1.7,
                      ),
                    ),
                    Text(
                      enModeFlg
                          ? EN_TEXT['lectureLast2']!
                          : JA_TEXT['lectureLast2']!,
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
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

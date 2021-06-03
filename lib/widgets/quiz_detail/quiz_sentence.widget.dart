import 'package:flutter/material.dart';

class QuizSentence extends StatelessWidget {
  final String sentence;

  QuizSentence(this.sentence);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Container(
      height: height * .35 < 240
          ? height * .33
          : height * .35 > 320
              ? 320
              : height * .40,
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.black,
        ),
        boxShadow: [
          BoxShadow(
              color: Colors.white54,
              blurRadius: 12.0,
              spreadRadius: 0.1,
              offset: Offset(5, 5))
        ],
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(
          right: 10,
          left: 10,
          top: 4,
          bottom: 10,
        ),
        child: Text(
          sentence,
          style: height * .35 > 230
              ? TextStyle(
                  fontSize: 17.0,
                  color: Colors.black,
                  height: 1.7,
                  fontFamily: 'NotoSerifJP',
                )
              : TextStyle(
                  fontSize: 15.5,
                  color: Colors.black,
                  height: 1.6,
                  fontFamily: 'NotoSerifJP',
                ),
        ),
      ),
    );
  }
}

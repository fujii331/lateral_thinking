import 'package:flutter/material.dart';

class QuizSentence extends StatelessWidget {
  final String sentence;

  QuizSentence(this.sentence);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * .35,
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
        padding: const EdgeInsets.all(10),
        child: Text(
          sentence,
          style: Theme.of(context).textTheme.bodyText1,
        ),
      ),
    );
  }
}

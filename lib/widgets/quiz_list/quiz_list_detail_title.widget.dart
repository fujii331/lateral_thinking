import 'package:flutter/material.dart';

class QuizListDetailTitle extends StatelessWidget {
  final String title;

  QuizListDetailTitle(this.title);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return height > 528
        ? Padding(
            padding: height > 610
                ? EdgeInsets.only(top: 20, bottom: 10)
                : EdgeInsets.only(top: 10, bottom: 3),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: height > 610 ? 28 : 22,
                fontWeight: FontWeight.bold,
                color: Colors.yellow.shade100,
              ),
            ),
          )
        : Container();
  }
}

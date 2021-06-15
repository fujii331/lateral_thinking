import 'package:flutter/material.dart';
import 'dart:io';

class QuizListDetailTitle extends StatelessWidget {
  final String title;

  QuizListDetailTitle(this.title);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return height > 528
        ? Padding(
            padding: height > 610
                ? EdgeInsets.only(top: Platform.isAndroid ? 20 : 10, bottom: 10)
                : EdgeInsets.only(top: Platform.isAndroid ? 10 : 5, bottom: 3),
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

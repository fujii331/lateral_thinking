import 'package:flutter/material.dart';

import '../background.widget.dart';

class LectureFigure extends StatelessWidget {
  final String imagePath;

  LectureFigure(this.imagePath);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        background(),
        Center(
          child: Container(
            child: Container(
              margin: EdgeInsets.all(5),
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(imagePath),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

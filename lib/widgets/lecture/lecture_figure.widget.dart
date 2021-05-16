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
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Color.fromRGBO(0, 0, 0, 0.6),
            ),
            child: Container(
              height: MediaQuery.of(context).size.height * 80,
              width: MediaQuery.of(context).size.width * .88,
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

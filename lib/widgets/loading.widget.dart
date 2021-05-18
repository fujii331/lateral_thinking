import 'package:flutter/material.dart';

//
// 全面表示のローディング
//
class Loading extends StatelessWidget {
  final bool visible;

  Loading(this.visible);

  @override
  Widget build(BuildContext context) {
    return visible
        ? Container(
            decoration: new BoxDecoration(
              color: Color.fromRGBO(0, 0, 0, 0.6),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                  ),
                  child: Text(
                    'Now Loading...',
                    style: TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                CircularProgressIndicator(
                  strokeWidth: 4.0,
                  valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ],
            ),
          )
        : Container();
  }
}

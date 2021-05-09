import 'package:flutter/material.dart';
import 'quiz_list.screen.dart';
import '../widgets/background.widget.dart';

class TitleScreen extends StatelessWidget {
  void toQuizList(BuildContext ctx) {
    Navigator.of(ctx).pushNamed(
      QuizListScreen.routeName,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          background(),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  '謎解きの館',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 40.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '一人用水平思考ゲーム',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 100),
                  child: Column(
                    children: [
                      _selectButton(
                        context,
                        '遊ぶ',
                        Colors.green,
                        Icon(Icons.account_balance),
                      ),
                      _selectButton(
                        context,
                        '遊び方',
                        Colors.teal,
                        Icon(Icons.auto_stories),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _selectButton(
    BuildContext context,
    String text,
    MaterialColor color,
    Icon icon,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 20,
      ),
      child: ElevatedButton.icon(
        icon: icon,
        onPressed: () => toQuizList(context),
        label: Text(text),
        style: ElevatedButton.styleFrom(
          elevation: 8, // 影をつける
          shadowColor: Colors.white,
          primary: color,
          padding: EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 5,
          ),
          textStyle: Theme.of(context).textTheme.button,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}

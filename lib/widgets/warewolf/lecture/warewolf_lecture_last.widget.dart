import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../background.widget.dart';

class WarewolfLectureLast extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final wordWidth = MediaQuery.of(context).size.width * .8;
    return Stack(
      children: <Widget>[
        background(),
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
                      '・問題を解いている間、解答はどのタイミングでしても構いませんが、質問の順番が来たときだけ解答できるルールでもOKです。\n\n・平和村の場合で誰も正解者が出なかった場合は引き分けになります。\n\n・最多得票者が二人以上になった場合、一人でも人狼が含まれていれば市民の勝ちになります。（全員同票の場合は誰も追放されません）\n\n・平和村だと思った場合は、全員が一票ずつ投票されるように調整しましょう。\n',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.white,
                        fontFamily: 'NotoSerifJP',
                        height: 1.7,
                      ),
                    ),
                    Text(
                      '点数の配分',
                      style: TextStyle(
                        fontSize: 17.0,
                        color: Colors.yellow.shade200,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      '市民',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.green.shade300,
                        height: 1.7,
                      ),
                    ),
                    _eachItemExplain(
                      'クイズで正解を答えたら正解者に + 2点',
                      wordWidth,
                    ),
                    _eachItemExplain(
                      '人狼を追放できたら全員に + 1点',
                      wordWidth,
                    ),
                    _eachItemExplain(
                      '人狼を追放できた場合に人狼に投票していた人に + 1点',
                      wordWidth,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        '人狼',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.red.shade300,
                          height: 1.7,
                        ),
                      ),
                    ),
                    _eachItemExplain(
                      '追放されなかったら + 3点',
                      wordWidth,
                    ),
                    _eachItemExplain(
                      '正解者が出なかったら - 3点',
                      wordWidth,
                    ),
                    _eachItemExplain(
                      '自分で正解を答えて追放されなかったら + 1点',
                      wordWidth,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        '共通',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.blue.shade200,
                          height: 1.7,
                        ),
                      ),
                    ),
                    _eachItemExplain(
                      'クイズを解く際、制限時間内に質問できなかったらその度に - 1点',
                      wordWidth,
                    ),
                    SizedBox(height: 50),
                    Text(
                      'それでは、水平思考人狼をお楽しみ下さい！',
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

  Widget _eachItemExplain(
    String text,
    double wordWidth,
  ) {
    return Padding(
      padding: const EdgeInsets.only(top: 3.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: Text(
              '・',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.white,
                fontFamily: 'NotoSerifJP',
              ),
            ),
          ),
          Container(
            width: wordWidth,
            child: Text(
              text,
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.white,
                fontFamily: 'NotoSerifJP',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

class QuestionReply extends StatelessWidget {
  final bool displayReplyFlg;
  final String reply;

  QuestionReply(this.displayReplyFlg, this.reply);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: EdgeInsets.only(
        top: size.height * .35 < 210 ? 11 : 16.5,
      ),
      child: Container(
        height: size.height * .35 < 200 ? 66 : 80,
        width: size.width * .86,
        padding: EdgeInsets.symmetric(
          vertical: 6,
          horizontal: 10,
        ),
        decoration: BoxDecoration(
          color: Colors.black87,
          border: Border.all(
            color: Colors.blue.shade500,
            width: 5,
          ),
        ),
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 500),
          opacity: displayReplyFlg ? 1 : 0,
          child: Text(
            reply,
            style: TextStyle(
              fontSize: size.height * .35 > 200 ? 18 : 16,
              color: Colors.white,
              fontFamily: 'NotoSerifJP',
            ),
          ),
        ),
      ),
    );
  }
}

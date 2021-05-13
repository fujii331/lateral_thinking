import 'package:flutter/material.dart';

class QuizReply extends StatelessWidget {
  final bool displayReplyFlg;
  final String reply;

  QuizReply(this.displayReplyFlg, this.reply);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 15,
      ),
      child: Container(
        height: MediaQuery.of(context).size.height * .12,
        width: MediaQuery.of(context).size.width * .85,
        padding: const EdgeInsets.symmetric(
          vertical: 15,
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
              fontSize: 17.0,
              color: Colors.white,
              fontFamily: 'NotoSerifJP',
            ),
          ),
        ),
      ),
    );
  }
}

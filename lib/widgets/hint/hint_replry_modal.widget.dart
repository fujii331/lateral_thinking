import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class HintReplyModal extends HookWidget {
  final String reply;

  HintReplyModal(this.reply);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 10,
            ),
            child: Text(
              reply,
              style: TextStyle(
                fontSize: 22.0,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 15,
            ),
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('閉じる'),
              style: ElevatedButton.styleFrom(
                primary: Colors.red[500],
                textStyle: Theme.of(context).textTheme.button,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

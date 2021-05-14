import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../providers/quiz.provider.dart';

class HintReplyModal extends HookWidget {
  final int quizId;

  HintReplyModal(this.quizId);

  void _setOpeningNumber(int quizNumber, BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // TODO広告を入れる
    prefs.setInt('openingNumber', quizNumber);
    context.read(openingNumberProvider).state = quizNumber;
    Navigator.pop(context);
  }

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
              '広告を見て次の問題を開放しますか？',
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('見ん'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red[500],
                    textStyle: Theme.of(context).textTheme.button,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                ElevatedButton(
                  onPressed: () async => _setOpeningNumber(quizId, context),
                  child: const Text('見てやる'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue[700],
                    textStyle: Theme.of(context).textTheme.button,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

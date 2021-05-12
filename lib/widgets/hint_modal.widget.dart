import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../providers/quiz.provider.dart';

class HintModal extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final int hint = useProvider(hintProvider).state;

    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 10,
            ),
            child: Text(
              hint < 4
                  ? 'ヒント' + (hint + 1).toString() + 'を開放しますか？'
                  : 'ヒントはもうありません。',
              style: TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 10,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Icon(
                  hint < 1 ? Icons.looks_one_outlined : Icons.looks_one,
                  size: 45,
                ),
                Icon(
                  hint < 2 ? Icons.looks_two_outlined : Icons.looks_two,
                  size: 45,
                ),
                Icon(
                  hint < 3 ? Icons.looks_3_outlined : Icons.looks_3,
                  size: 45,
                ),
                Icon(
                  hint < 4 ? Icons.looks_4_outlined : Icons.looks_4,
                  size: 45,
                ),
              ],
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * .15,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 15,
              ),
              child: Text(
                hint < 1
                    ? '主語を選択肢で選べるようになります。'
                    : hint == 1
                        ? '関連語を選択肢で選べるようになります。'
                        : hint == 2
                            ? '質問を選択肢で選べるようになります。'
                            : hint == 3
                                ? '正解を導く質問のみ選べるようになります。'
                                : 'もう答えはすぐそこです！',
                style: TextStyle(
                  fontSize: 18.0,
                ),
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
                  child: const Text('やめる'),
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
                  onPressed: () async => hint < 4
                      ? {
                          Navigator.pop(context),
                          Fluttertoast.showToast(
                            msg: 'ヒント' + (hint + 1).toString() + 'を開放しました。',
                          ),
                          context.read(hintProvider).state++,
                        }
                      : {},
                  child: const Text('開放する'),
                  style: ElevatedButton.styleFrom(
                    primary: hint < 4 ? Colors.blue[700] : Colors.blue[300],
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

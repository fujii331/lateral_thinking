import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:audioplayers/audio_cache.dart';

import '../providers/quiz.provider.dart';

class ReplyModal extends HookWidget {
  final String reply;

  ReplyModal(this.reply);

  @override
  Widget build(BuildContext context) {
    final AudioCache soundEffect = useProvider(soundEffectProvider).state;

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
              onPressed: () => {
                soundEffect.play('sounds/cancel.mp3', isNotification: true),
                Navigator.pop(context)
              },
              child: const Text('閉じる'),
              style: ElevatedButton.styleFrom(
                primary: Colors.red[400],
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

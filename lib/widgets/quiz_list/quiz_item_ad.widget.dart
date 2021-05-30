import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import './advertising_modal.widget.dart';
import '../../models/quiz.model.dart';
import '../../providers/quiz.provider.dart';
import 'package:audioplayers/audio_cache.dart';

class QuizItemAd extends HookWidget {
  final Quiz quiz;

  QuizItemAd(this.quiz);

  @override
  Widget build(BuildContext context) {
    final AudioCache soundEffect = useProvider(soundEffectProvider).state;

    return Container(
      height: 54,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.black,
        ),
      ),
      margin: EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 5,
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.only(top: 5, bottom: 10, left: 5, right: 5),
          child: Text(
            '問' + quiz.id.toString(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.purple[800],
            ),
          ),
        ),
        title: Container(
          padding: const EdgeInsets.only(top: 5, bottom: 10, right: 5),
          child: Text(
            quiz.title,
            style: TextStyle(
              fontSize: 20,
            ),
          ),
        ),
        onTap: () => showDialog<int>(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext context) {
            soundEffect.play('sounds/hint.mp3', isNotification: true);
            return AdvertisingModal(quiz.id);
          },
        ),
      ),
    );
  }
}

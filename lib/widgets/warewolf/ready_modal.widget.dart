import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../providers/quiz.provider.dart';

class ReadyModal extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final AudioCache soundEffect = useProvider(soundEffectProvider).state;

    final displayFlg1 = useState<bool>(false);
    final displayFlg2 = useState<bool>(false);

    useEffect(() {
      WidgetsBinding.instance!.addPostFrameCallback((_) async {
        await new Future.delayed(
          new Duration(milliseconds: 500),
        );
        displayFlg1.value = true;
        soundEffect.play('sounds/ready.mp3', isNotification: true);
        await new Future.delayed(
          new Duration(milliseconds: 1000),
        );
        displayFlg2.value = true;
      });
      return null;
    }, const []);

    return Theme(
      data: Theme.of(context)
          .copyWith(dialogBackgroundColor: Colors.white.withOpacity(0.0)),
      child: new SimpleDialog(
        children: <Widget>[
          Center(
            child: Column(
              children: [
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 500),
                  opacity: displayFlg1.value ? 1 : 0,
                  child: Text(
                    '人狼会議',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'SawarabiGothic',
                    ),
                  ),
                ),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 500),
                  opacity: displayFlg2.value ? 1 : 0,
                  child: Text(
                    'START！',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'SawarabiGothic',
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

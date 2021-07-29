import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../providers/quiz.provider.dart';
import '../../models/warewolf.model.dart';

class JudgingModal extends HookWidget {
  final List<Player> mostVotedList;
  final bool wolfVotedFlg;
  final bool sameVoteFlg;

  JudgingModal(
    this.mostVotedList,
    this.wolfVotedFlg,
    this.sameVoteFlg,
  );

  @override
  Widget build(BuildContext context) {
    final AudioCache soundEffect = useProvider(soundEffectProvider).state;

    final displayWord1Flg = useState<bool>(false);
    final displayWord2Flg = useState<bool>(false);
    final displayWord3Flg = useState<bool>(false);
    final displayWord4Flg = useState<bool>(false);

    final displayFlg1 = useState<bool>(false);
    final displayFlg2 = useState<bool>(false);
    final displayFlg3 = useState<bool>(false);

    useEffect(() {
      WidgetsBinding.instance!.addPostFrameCallback((_) async {
        await new Future.delayed(
          new Duration(milliseconds: 1000),
        );
        displayWord1Flg.value = true;
        await new Future.delayed(
          new Duration(milliseconds: 1000),
        );
        displayWord2Flg.value = true;
        await new Future.delayed(
          new Duration(milliseconds: 500),
        );
        displayWord3Flg.value = true;
        await new Future.delayed(
          new Duration(milliseconds: 800),
        );
        displayWord4Flg.value = true;
        displayFlg1.value = true;
        soundEffect.play('sounds/think.mp3', isNotification: true);
        await new Future.delayed(
          new Duration(seconds: 1),
        );
        displayFlg1.value = false;
        displayFlg2.value = true;
        await new Future.delayed(
          new Duration(seconds: 1),
        );
        displayFlg2.value = false;
        displayFlg3.value = true;
      });
      return null;
    }, const []);

    return Theme(
      // これいるか？
      data: Theme.of(context)
          .copyWith(dialogBackgroundColor: Colors.white.withOpacity(0.0)),
      child: new SimpleDialog(
        children: <Widget>[
          Center(
            child: Column(
              children: [
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 500),
                  opacity: displayWord1Flg.value ? 1 : 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    width: double.infinity,
                    child: Text(
                      sameVoteFlg ? '今回の投票は...' : '一番票を集めたのは...',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                      ),
                    ),
                  ),
                ),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 500),
                  opacity: displayWord2Flg.value ? 1 : 0,
                  child: Text(
                    sameVoteFlg
                        ? '全員同じ得票数'
                        : mostVotedList.length == 1
                            ? mostVotedList[0].name
                            : mostVotedList.length == 2
                                ? mostVotedList[0].name +
                                    '\n' +
                                    mostVotedList[1].name
                                : mostVotedList[0].name +
                                    '\n' +
                                    mostVotedList[1].name +
                                    '\n' +
                                    mostVotedList[2].name,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.orange,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 500),
                  opacity: displayWord3Flg.value ? 1 : 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    width: double.infinity,
                    child: Text(
                      'でした',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                      ),
                    ),
                  ),
                ),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 500),
                  opacity: displayWord4Flg.value ? 1 : 0,
                  child: Container(
                    height: 200,
                    child: Stack(
                      children: [
                        AnimatedOpacity(
                          duration: const Duration(milliseconds: 500),
                          opacity: displayFlg1.value ? 1 : 0,
                          child: Image.asset(
                            sameVoteFlg
                                ? 'assets/images/enjoy_1.png'
                                : 'assets/images/judge_1.png',
                            height: 200,
                          ),
                        ),
                        AnimatedOpacity(
                          duration: const Duration(milliseconds: 500),
                          opacity: displayFlg2.value ? 1 : 0,
                          child: Image.asset(
                            sameVoteFlg
                                ? 'assets/images/enjoy_2.png'
                                : 'assets/images/judge_2.png',
                            height: 200,
                          ),
                        ),
                        AnimatedOpacity(
                          duration: const Duration(milliseconds: 500),
                          opacity: displayFlg3.value ? 1 : 0,
                          child: wolfVotedFlg
                              ? Image.asset(
                                  'assets/images/judge_good.png',
                                  height: 200,
                                )
                              : Image.asset(
                                  'assets/images/judge_bad.png',
                                  height: 200,
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 500),
                  opacity: displayWord4Flg.value ? 1 : 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    width: double.infinity,
                    child: Text(
                      sameVoteFlg ? '歓談中...' : '追放中...',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
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

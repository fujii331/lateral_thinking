import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'dart:math';
import '../../providers/quiz.provider.dart';
import '../../text.dart';

class AdLoadingModal extends HookWidget {
  final randomNumber = new Random().nextInt(3);

  @override
  Widget build(BuildContext context) {
    final bool enModeFlg = useProvider(enModeFlgProvider).state;

    return Theme(
      data: Theme.of(context)
          .copyWith(dialogBackgroundColor: Colors.white.withOpacity(0.0)),
      child: new SimpleDialog(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 25),
            child: Text(
              enModeFlg ? EN_TEXT['nowLoading']! : JA_TEXT['nowLoading']!,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontFamily: 'YuseiMagic',
                color: Colors.white,
              ),
            ),
          ),
          randomNumber == 0
              ? SpinKitFadingCube(
                  itemBuilder: (BuildContext context, int index) {
                    return DecoratedBox(
                      decoration: BoxDecoration(
                        color: index.isEven ? Colors.lightGreen : Colors.green,
                      ),
                    );
                  },
                )
              : randomNumber == 1
                  ? SpinKitWave(
                      color: Colors.blue.shade200,
                      size: 50.0,
                    )
                  : randomNumber == 2
                      ? SpinKitWanderingCubes(
                          color: Colors.yellow.shade200,
                          size: 50.0,
                        )
                      : SpinKitCubeGrid(color: Colors.orange),
        ],
      ),
    );
  }
}

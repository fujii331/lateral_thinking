import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';

import '../../providers/warewolf.provider.dart';
import '../../providers/common.provider.dart';

import '../../models/warewolf.model.dart';

import '../../text.dart';

class PlayersSettingModal extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final AudioCache soundEffect = useProvider(soundEffectProvider).state;
    final double seVolume = useProvider(seVolumeProvider).state;

    final int numOfPlayers =
        int.tryParse(useProvider(numOfPlayersProvider).state)!;

    final player1 = useProvider(player1Provider).state;
    final player2 = useProvider(player2Provider).state;
    final player3 = useProvider(player3Provider).state;
    final player4 = useProvider(player4Provider).state;
    final player5 = useProvider(player5Provider).state;
    final player6 = useProvider(player6Provider).state;

    final player1Controller = useTextEditingController(text: player1.name);
    final player2Controller = useTextEditingController(text: player2.name);
    final player3Controller = useTextEditingController(text: player3.name);
    final player4Controller = useTextEditingController(text: player4.name);
    final player5Controller = useTextEditingController(text: player5.name);
    final player6Controller = useTextEditingController(text: player6.name);

    final player1FocusNode = useFocusNode();
    final player2FocusNode = useFocusNode();
    final player3FocusNode = useFocusNode();
    final player4FocusNode = useFocusNode();
    final player5FocusNode = useFocusNode();
    final player6FocusNode = useFocusNode();

    player1FocusNode.addListener(() {
      if (!player1FocusNode.hasFocus) {
        context.read(player1Provider).state = Player(
            id: 1,
            name: player1Controller.text.isEmpty
                ? 'プレイヤー１'
                : player1Controller.text,
            point: player1.point);
      }
    });

    player2FocusNode.addListener(() {
      if (!player2FocusNode.hasFocus) {
        context.read(player2Provider).state = Player(
            id: 2,
            name: player2Controller.text.isEmpty
                ? 'プレイヤー２'
                : player2Controller.text,
            point: player2.point);
      }
    });

    player3FocusNode.addListener(() {
      if (!player3FocusNode.hasFocus) {
        context.read(player3Provider).state = Player(
            id: 3,
            name: player3Controller.text.isEmpty
                ? 'プレイヤー３'
                : player3Controller.text,
            point: player3.point);
      }
    });

    player4FocusNode.addListener(() {
      if (!player4FocusNode.hasFocus) {
        context.read(player4Provider).state = Player(
            id: 4,
            name: player4Controller.text.isEmpty
                ? 'プレイヤー４'
                : player4Controller.text,
            point: player4.point);
      }
    });

    player5FocusNode.addListener(() {
      if (!player5FocusNode.hasFocus) {
        context.read(player5Provider).state = Player(
            id: 5,
            name: player5Controller.text.isEmpty
                ? 'プレイヤー５'
                : player5Controller.text,
            point: player5.point);
      }
    });

    player6FocusNode.addListener(() {
      if (!player6FocusNode.hasFocus) {
        context.read(player6Provider).state = Player(
            id: 6,
            name: player6Controller.text.isEmpty
                ? 'プレイヤー６'
                : player6Controller.text,
            point: player6.point);
      }
    });

    return Padding(
      padding: const EdgeInsets.only(
        left: 20,
        right: 20,
        bottom: 15,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 5,
            ),
            child: Text(
              '回答者の名前を編集',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                fontFamily: 'SawarabiGothic',
              ),
            ),
          ),
          _player(
            context,
            player1Controller,
            player1FocusNode,
          ),
          _player(
            context,
            player2Controller,
            player2FocusNode,
          ),
          _player(
            context,
            player3Controller,
            player3FocusNode,
          ),
          numOfPlayers > 3
              ? _player(
                  context,
                  player4Controller,
                  player4FocusNode,
                )
              : Container(),
          numOfPlayers > 4
              ? _player(
                  context,
                  player5Controller,
                  player5FocusNode,
                )
              : Container(),
          numOfPlayers > 5
              ? _player(
                  context,
                  player6Controller,
                  player6FocusNode,
                )
              : Container(),
          Padding(
            padding: const EdgeInsets.only(
              top: 15,
            ),
            child: ElevatedButton(
              onPressed: () => {
                soundEffect.play(
                  'sounds/tap.mp3',
                  isNotification: true,
                  volume: seVolume,
                ),
                context.read(player1Provider).state = Player(
                  id: 1,
                  name: player1.name,
                  point: 0,
                ),
                context.read(player2Provider).state = Player(
                  id: 2,
                  name: player2.name,
                  point: 0,
                ),
                context.read(player3Provider).state = Player(
                  id: 3,
                  name: player3.name,
                  point: 0,
                ),
                context.read(player4Provider).state = Player(
                  id: 4,
                  name: player4.name,
                  point: 0,
                ),
                context.read(player5Provider).state = Player(
                  id: 5,
                  name: player5.name,
                  point: 0,
                ),
                context.read(player6Provider).state = Player(
                  id: 6,
                  name: player6.name,
                  point: 0,
                ),
              },
              child: Text(
                '点数リセット',
              ),
              style: ElevatedButton.styleFrom(
                primary: Colors.orange.shade600,
                textStyle: Theme.of(context).textTheme.button,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 5,
            ),
            child: ElevatedButton(
              onPressed: () => {
                soundEffect.play(
                  'sounds/cancel.mp3',
                  isNotification: true,
                  volume: seVolume,
                ),
                Navigator.pop(context),
              },
              child: Text(
                JA_TEXT['closeButton']!,
              ),
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

  Widget _player(
    BuildContext context,
    TextEditingController controller,
    FocusNode focusNode,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 3,
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: '名前を入力',
        ),
        inputFormatters: <TextInputFormatter>[
          LengthLimitingTextInputFormatter(
            6,
          ),
        ],
        controller: controller,
        focusNode: focusNode,
      ),
    );
  }
}

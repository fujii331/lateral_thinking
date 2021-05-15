import 'package:flutter/material.dart';

class AdLoadingModal extends StatelessWidget {
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
              'Now Loading...',
              style: TextStyle(
                fontSize: 22.0,
              ),
            ),
          ),
          CircularProgressIndicator(
            strokeWidth: 4.0,
            valueColor: new AlwaysStoppedAnimation<Color>(Colors.grey),
          )
        ],
      ),
    );
  }
}

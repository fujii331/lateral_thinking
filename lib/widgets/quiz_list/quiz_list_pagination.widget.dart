import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class QuizListPagination extends HookWidget {
  final ValueNotifier<int> screenNo;
  final int numOfPages;

  QuizListPagination(this.screenNo, this.numOfPages);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 10,
        right: 10,
        left: 10,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          screenNo.value == 0
              ? _dummyBox()
              : _paginationButton(context, screenNo, 0, '<<'),
          screenNo.value == 0
              ? _dummyBox()
              : _paginationButton(context, screenNo, screenNo.value - 1, '<'),
          screenNo.value == numOfPages - 1
              ? _dummyBox()
              : _paginationButton(context, screenNo, screenNo.value + 1, '>'),
          screenNo.value == numOfPages - 1
              ? _dummyBox()
              : _paginationButton(context, screenNo, numOfPages - 1, '>>'),
        ],
      ),
    );
  }

  Widget _paginationButton(
    BuildContext context,
    ValueNotifier<int> screenNo,
    int toScreenNo,
    String icon,
  ) {
    return ElevatedButton(
      onPressed: () => {
        screenNo.value = toScreenNo,
      },
      child: Text(
        icon,
        style: TextStyle(
          fontSize: 25.0,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      style: ElevatedButton.styleFrom(
        primary: Colors.white.withOpacity(0.3),
        textStyle: Theme.of(context).textTheme.button,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _dummyBox() {
    return const SizedBox(width: 64);
  }
}

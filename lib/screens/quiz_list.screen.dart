import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lateral_thinking/widgets/quiz_list/quiz_list_detail_title.widget.dart';
import 'package:lateral_thinking/widgets/quiz_list/quiz_list_pagination.widget.dart';

import '../widgets/quiz_list/quiz_list_detail.widget.dart';
import '../providers/quiz.provider.dart';
import '../widgets/background.widget.dart';
import '../text.dart';

class QuizListScreen extends HookWidget {
  static const routeName = '/quiz-list';

  @override
  Widget build(BuildContext context) {
    final screenNo = useState<int>(0);

    final int openingNumber = useProvider(openingNumberProvider).state;

    final int numOfPages = ((openingNumber + 1) / 6).ceil();
    final bool enModeFlg = useProvider(enModeFlgProvider).state;

    final List<String> titles = [
      enModeFlg ? EN_TEXT['listPageTitle1']! : JA_TEXT['listPageTitle1']!,
      enModeFlg ? EN_TEXT['listPageTitle2']! : JA_TEXT['listPageTitle2']!,
      enModeFlg ? EN_TEXT['listPageTitle3']! : JA_TEXT['listPageTitle3']!,
      enModeFlg ? EN_TEXT['listPageTitle4']! : JA_TEXT['listPageTitle4']!,
      enModeFlg ? EN_TEXT['listPageTitle5']! : JA_TEXT['listPageTitle5']!,
      enModeFlg ? EN_TEXT['listPageTitle6']! : JA_TEXT['listPageTitle6']!,
      enModeFlg ? EN_TEXT['listPageTitle7']! : JA_TEXT['listPageTitle7']!,
      enModeFlg ? EN_TEXT['listPageTitle8']! : JA_TEXT['listPageTitle8']!,
      enModeFlg ? EN_TEXT['listPageTitle9']! : JA_TEXT['listPageTitle9']!,
      enModeFlg ? EN_TEXT['listPageTitle10']! : JA_TEXT['listPageTitle10']!,
      enModeFlg ? EN_TEXT['listPageTitle11']! : JA_TEXT['listPageTitle11']!,
      enModeFlg ? EN_TEXT['listPageTitle12']! : JA_TEXT['listPageTitle12']!,
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          enModeFlg ? EN_TEXT['listTitle']! : JA_TEXT['listTitle']!,
        ),
        centerTitle: true,
        backgroundColor: Colors.blueGrey[900]?.withOpacity(0.9),
      ),
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          background(),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              QuizListDetailTitle(
                titles[screenNo.value],
              ),
              QuizListDetail(
                openingNumber,
                screenNo,
                numOfPages,
              ),
              QuizListPagination(
                screenNo,
                numOfPages,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

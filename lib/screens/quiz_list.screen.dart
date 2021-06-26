import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lateral_thinking/widgets/quiz_list/quiz_list_detail_title.widget.dart';
import 'package:lateral_thinking/widgets/quiz_list/quiz_list_pagination.widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../widgets/quiz_list/quiz_list_detail.widget.dart';
import '../providers/quiz.provider.dart';
import '../widgets/background.widget.dart';

class QuizListScreen extends HookWidget {
  static const routeName = '/quiz-list';

  void _getOpeningNumber(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    context.read(openingNumberProvider).state =
        prefs.getInt('openingNumber') ?? 9;
  }

  @override
  Widget build(BuildContext context) {
    final screenNo = useState<int>(0);

    _getOpeningNumber(context);

    final int openingNumber = useProvider(openingNumberProvider).state;

    final int numOfPages = ((openingNumber + 1) / 6).ceil();
    // Localeの方法
    Locale locale = Localizations.localeOf(context);
    final List<String> titles = [
      AppLocalizations.of(context)!.listPageTitle1,
      AppLocalizations.of(context)!.listPageTitle2,
      AppLocalizations.of(context)!.listPageTitle3,
      AppLocalizations.of(context)!.listPageTitle4,
      AppLocalizations.of(context)!.listPageTitle5,
      AppLocalizations.of(context)!.listPageTitle6,
      AppLocalizations.of(context)!.listPageTitle7,
      AppLocalizations.of(context)!.listPageTitle8,
      AppLocalizations.of(context)!.listPageTitle9,
      AppLocalizations.of(context)!.listPageTitle10,
      AppLocalizations.of(context)!.listPageTitle11,
      AppLocalizations.of(context)!.listPageTitle12,
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.listTitle),
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

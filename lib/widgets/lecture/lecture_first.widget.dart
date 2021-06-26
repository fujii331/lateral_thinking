import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../background.widget.dart';

class LectureFirst extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        background(),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Opacity(
                opacity: 0.5,
                child: Image.asset(
                  'assets/images/1_2.png',
                  width: MediaQuery.of(context).size.width * .6,
                ),
              ),
            ),
            Text(
              AppLocalizations.of(context)!.boyaName,
              style: TextStyle(
                fontSize: 26.0,
                color: Colors.white,
                fontFamily: 'YuseiMagic',
              ),
            ),
          ],
        ),
        Center(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Color.fromRGBO(0, 0, 0, 0.6),
            ),
            height: MediaQuery.of(context).size.height * .80,
            width: MediaQuery.of(context).size.width * .92,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text(
                      AppLocalizations.of(context)!.lectureFirst1,
                      style: TextStyle(
                        fontSize: 17.0,
                        color: Colors.white,
                        fontFamily: 'NotoSerifJP',
                        height: 1.7,
                      ),
                    ),
                    Text(
                      AppLocalizations.of(context)!.lectureFirst2,
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.yellow.shade200,
                        height: 1.7,
                      ),
                    ),
                    Text(
                      AppLocalizations.of(context)!.lectureFirst3,
                      style: TextStyle(
                        fontSize: 17.0,
                        color: Colors.white,
                        fontFamily: 'NotoSerifJP',
                        height: 1.7,
                      ),
                    ),
                    Text(
                      AppLocalizations.of(context)!.lectureFirst4,
                      style: TextStyle(
                        fontSize: 15.0,
                        color: Colors.white,
                        fontFamily: 'NotoSerifJP',
                        height: 1.7,
                      ),
                    ),
                    Text(
                      AppLocalizations.of(context)!.lectureFirst5,
                      style: TextStyle(
                        fontSize: 17.0,
                        color: Colors.white,
                        fontFamily: 'NotoSerifJP',
                        height: 1.7,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_hooks/flutter_hooks.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:audioplayers/audioplayers.dart';
// import 'package:firebase_database/firebase_database.dart';

// import '../../providers/common.provider.dart';
// import '../../providers/quiz.provider.dart';
// import '../../models/analytics.model.dart';
// import '../../models/quiz.model.dart';
// import '../../data/quiz_data.dart';

// class AnalyticsListModal extends HookWidget {
//   void getAnalyticsData(String id, ValueNotifier<Analytics> data) async {
//     DatabaseReference firebaseInstance =
//         FirebaseDatabase.instance.reference().child('analytics/' + id);

//     await firebaseInstance.get().then((DataSnapshot? snapshot) {
//       if (snapshot != null) {
//         final firebaseData = snapshot.value;

//         final hint1Count = firebaseData['hint1Count'] as int;
//         final hint2Count = firebaseData['hint2Count'] as int;
//         final subHintCount = firebaseData['subHintCount'] as int;

//         final relatedWordCount = firebaseData['relatedWordCount'] as int;
//         final questionCount = firebaseData['questionCount'] as int;
//         final userCount = firebaseData['userCount'] as int;
//         final noHintCount = firebaseData['noHintCount'] as int;

//         data.value = Analytics(
//           hint1: (100 * (hint1Count / userCount)).round(),
//           hint2: (100 * (hint2Count / userCount)).round(),
//           noHint: (100 * (noHintCount / userCount)).round(),
//           subHint: (100 * (subHintCount / userCount)).round(),
//           relatedWordCountAll:
//               noHintCount == 0 ? 0 : (relatedWordCount / noHintCount).round(),
//           relatedWordCountYou: 0,
//           questionCountAll:
//               noHintCount == 0 ? 0 : (questionCount / noHintCount).round(),
//           questionCountYou: 0,
//         );
//       }
//     }).onError((error, stackTrace) =>
//         // 何もしない
//         null);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final AudioCache soundEffect = useProvider(soundEffectProvider).state;
//     final double seVolume = useProvider(seVolumeProvider).state;
//     final int openingNumber = useProvider(openingNumberProvider).state;

//     final List<Quiz> quizList =
//         QUIZ_DATA.where((Quiz quiz) => quiz.id <= openingNumber).toList();

//     final List<String> quizTitleList = quizList.map((Quiz quiz) {
//       return quiz.id.toString() + '：' + quiz.title;
//     }).toList();

//     final selectedQuizState = useState('1：捨てる男');
//     final analyticsData = useState(Analytics(
//       hint1: 0,
//       hint2: 0,
//       noHint: 0,
//       subHint: 0,
//       relatedWordCountAll: 0,
//       relatedWordCountYou: 0,
//       questionCountAll: 0,
//       questionCountYou: 1,
//     ));

//     return Padding(
//       padding: const EdgeInsets.only(
//         left: 20,
//         right: 20,
//         bottom: 15,
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: <Widget>[
//           Padding(
//             padding: const EdgeInsets.only(
//               top: 10,
//               bottom: 15,
//             ),
//             child: Text(
//               '正解者の統計データ',
//               style: TextStyle(
//                 fontSize: 20.0,
//                 fontWeight: FontWeight.bold,
//                 fontFamily: 'SawarabiGothic',
//               ),
//             ),
//           ),
//           Container(
//             // padding: const EdgeInsets.only(
//             //   top: 15,
//             // ),
//             width: 200,
//             // height: 35,
//             decoration: BoxDecoration(
//               color: Colors.grey.withOpacity(0.4),
//               borderRadius: BorderRadius.circular(8),
//             ),
//             alignment: Alignment.center,
//             child: DropdownButton(
//               // isExpanded: true,
//               underline: Container(
//                 color: Colors.white,
//               ),
//               value: selectedQuizState.value,
//               items: quizTitleList.map((String word) {
//                 return DropdownMenuItem(
//                   value: word,
//                   child: Text(
//                     word,
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                       fontSize: 16,
//                       color: Colors.black,
//                       fontFamily: 'NotoSerifJP',
//                     ),
//                   ),
//                 );
//               }).toList(),
//               onChanged: (target) {
//                 selectedQuizState.value = target as String;
//                 getAnalyticsData(
//                   target.substring(1, 2) == '：'
//                       ? target.substring(0, 1)
//                       : target.substring(0, 2),
//                   analyticsData,
//                 );
//               },
//             ),
//           ),
//           analyticsData.value.questionCountYou != 1
//               ? Column(
//                   children: [
//                     Container(
//                       width: double.infinity,
//                       padding: const EdgeInsets.only(
//                         top: 20,
//                       ),
//                       child: Text(
//                         'ヒント使用率',
//                         style: TextStyle(
//                           fontSize: 15.0,
//                           fontFamily: 'SawarabiGothic',
//                           color: Colors.blue.shade600,
//                         ),
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(
//                         top: 5,
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceAround,
//                         children: [
//                           _analyticsItem(
//                             'ヒント1',
//                             analyticsData.value.questionCountYou == 1
//                                 ? ''
//                                 : analyticsData.value.hint1.toString() + '%',
//                             false,
//                           ),
//                           _analyticsItem(
//                             'ヒント2以上',
//                             analyticsData.value.questionCountYou == 1
//                                 ? ''
//                                 : analyticsData.value.hint2.toString() + '%',
//                             false,
//                           ),
//                         ],
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(
//                         top: 10,
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceAround,
//                         children: [
//                           _analyticsItem(
//                             'サブヒント',
//                             analyticsData.value.questionCountYou == 1
//                                 ? ''
//                                 : analyticsData.value.subHint.toString() + '%',
//                             false,
//                           ),
//                           _analyticsItem(
//                             'ヒント未使用',
//                             analyticsData.value.questionCountYou == 1
//                                 ? ''
//                                 : analyticsData.value.noHint.toString() + '%',
//                             true,
//                           ),
//                         ],
//                       ),
//                     ),
//                     Container(
//                       padding: const EdgeInsets.only(
//                         top: 20,
//                       ),
//                       width: double.infinity,
//                       child: Text(
//                         'ヒント未使用者の平均回数',
//                         style: TextStyle(
//                           fontSize: 15.0,
//                           fontFamily: 'SawarabiGothic',
//                           color: Colors.blue.shade600,
//                         ),
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(
//                         top: 5,
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceAround,
//                         children: [
//                           _analyticsItem(
//                             '関連語の入力',
//                             analyticsData.value.questionCountYou == 1
//                                 ? ''
//                                 : analyticsData.value.relatedWordCountAll == 0
//                                     ? '正解者なし'
//                                     : analyticsData.value.relatedWordCountAll
//                                             .toString() +
//                                         '回',
//                             true,
//                           ),
//                           _analyticsItem(
//                             '質問回数',
//                             analyticsData.value.questionCountYou == 1
//                                 ? ''
//                                 : analyticsData.value.questionCountAll == 0
//                                     ? '正解者なし'
//                                     : analyticsData.value.questionCountAll
//                                             .toString() +
//                                         '回',
//                             true,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 )
//               : Padding(
//                   padding: const EdgeInsets.only(
//                     top: 10,
//                   ),
//                   child: Text(
//                     'データが取得できませんでした。',
//                     style: TextStyle(
//                       fontSize: 18.0,
//                       fontFamily: 'SawarabiGothic',
//                     ),
//                   ),
//                 ),
//           Padding(
//             padding: const EdgeInsets.only(
//               top: 15,
//             ),
//             child: ElevatedButton(
//               onPressed: () => {
//                 soundEffect.play(
//                   'sounds/cancel.mp3',
//                   isNotification: true,
//                   volume: seVolume,
//                 ),
//                 Navigator.pop(context),
//               },
//               child: Text(
//                 '閉じる',
//               ),
//               style: ElevatedButton.styleFrom(
//                 primary: Colors.red[400],
//                 textStyle: Theme.of(context).textTheme.button,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _analyticsItem(
//     String itemName,
//     String itemInfo,
//     bool colorFlg,
//   ) {
//     return Column(
//       children: [
//         Text(
//           itemName,
//           style: TextStyle(
//             fontSize: 14.0,
//             fontFamily: 'SawarabiGothic',
//             color: colorFlg ? Colors.orange.shade800 : Colors.grey.shade700,
//           ),
//         ),
//         Text(
//           itemInfo,
//           style: TextStyle(
//             fontSize: 17.0,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ],
//     );
//   }
// }

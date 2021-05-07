import 'package:flutter/material.dart';
import 'models/quiz.dart';
import './quiz_item.dart';

class QuizListScreen extends StatelessWidget {
  final List<Quiz> quizzes = [
    Quiz(
      id: 1,
      title: 'お気に入りの帽子',
      sentence:
          'ある男はいつも同じ帽子を持っていました。/nその男は常にその帽子を被って出かけ、無くさないように大切にしています。/nところがある日、妻に「この帽子いつまで被ってるの！捨てるわね」と言われて捨てられてしまいました。/n男は妻がそのまま帽子を捨てても「いいよ」と言い、怒ったりしませんでした。/nいったいなぜ？',
      subjects: ['男', '帽子', '常', 'ある日', '妻'],
      relatedWords: [
        '幼い',
        '老人',
        '河童',
        '帽子',
        'スポーツ',
        '嫌い',
        '好き',
        '怒',
        'はげ',
        '育毛剤',
        '日',
        '日差し',
        '日よけ'
      ],
      questions: [
        Question(id: 1, question: '男は幼いですか', reply: 'いいえ。妻がいるので結婚もしています。'),
        Question(
            id: 2, question: '男は老人ですか', reply: 'いくつでもいいですが、30歳くらいと考えて下さい。'),
        Question(id: 3, question: '男は河童ですか', reply: 'いいえ。人間です。レア質問！'),
        Question(id: 4, question: '男は帽子が好きですか。', reply: 'どちらでもありません。いい質問！'),
        Question(
            id: 5, question: '男は帽子を昔から被っていますか', reply: 'いいえ。おそらくそんなに昔ではありません。'),
        Question(id: 6, question: '男はスポーツをしていますか', reply: 'どちらでもいいです。'),
        Question(
            id: 7, question: '男は妻が嫌いですか', reply: 'どちらでもいいです。嫌いではないと思いますが。'),
        Question(id: 8, question: '男は妻が好きですか', reply: 'どちらでもいいです。'),
        Question(
            id: 9, question: '男は帽子が嫌いですか', reply: 'どちらでもありませんが、嫌いではないと思います。'),
        Question(
            id: 10, question: '男はあまり怒らないですか', reply: 'どちらでもいいですが、怒らない方だと思います。'),
        Question(id: 11, question: '男ははげていますか', reply: 'いいえ。すばらしい質問！'),
        Question(id: 12, question: '男ははげていた時がありますか', reply: 'はい。すばらしい質問！'),
        Question(id: 13, question: '男は育毛剤をつけていますか。', reply: 'はい。すばらしい質問！'),
        Question(id: 14, question: '男は日よけのために帽子を被っていますか？', reply: 'いいえ。'),
        Question(id: 15, question: '男は日差しを避けるのために帽子を被っていますか？', reply: 'いいえ。'),
        Question(id: 16, question: '女は帽子が嫌いですか', reply: 'いいえ。'),
      ],
      correctAnswerIds: [1, 2, 3],
      answers: [
        Answer(
            id: 1,
            questionIds: [11, 12],
            answer: '男ははげていたが、今ははげじゃなくなったので帽子が必要なくなったから',
            comment:
                '男は今まで髪がなく、恥ずかしくてそれを隠すために毎日欠かさず帽子を被っていた。しかし、育毛剤をつけ続けたことで髪が生えて帽子を被らなくても外に出られるようになった。妻は髪が生えたのでもう帽子は必要ないだろうと思い捨てたのだった。'),
        Answer(
            id: 2,
            questionIds: [12, 13],
            answer: '男ははげていたが、育毛剤をつけたことで髪が生え、帽子が必要なくなったから',
            comment:
                '男は今まで髪がなく、恥ずかしくてそれを隠すために毎日欠かさず帽子を被っていた。しかし、育毛剤をつけ続けたことで髪が生えて帽子を被らなくても外に出られるようになった。妻は髪が生えたのでもう帽子は必要ないだろうと思い捨てたのだった。'),
      ],
    ),
    Quiz(
      id: 2,
      title: 'お気に入りの帽子２',
      sentence:
          'ある男はいつも同じ帽子を持っていました。/nその男は常にその帽子を被って出かけ、無くさないように大切にしています。/nところがある日、妻に「この帽子いつまで被ってるの！捨てるわね」と言われて捨てられてしまいました。/n男は妻がそのまま帽子を捨てても「いいよ」と言い、怒ったりしませんでした。/nいったいなぜ？',
      subjects: ['男', '帽子', '常', 'ある日', '妻'],
      relatedWords: [
        '幼い',
        '老人',
        '河童',
        '帽子',
        'スポーツ',
        '嫌い',
        '好き',
        '怒',
        'はげ',
        '育毛剤',
        '日',
        '日差し',
        '日よけ'
      ],
      questions: [
        Question(id: 1, question: '男は幼いですか', reply: 'いいえ。妻がいるので結婚もしています。'),
        Question(
            id: 2, question: '男は老人ですか', reply: 'いくつでもいいですが、30歳くらいと考えて下さい。'),
        Question(id: 3, question: '男は河童ですか', reply: 'いいえ。人間です。レア質問！'),
        Question(id: 4, question: '男は帽子が好きですか。', reply: 'どちらでもありません。いい質問！'),
        Question(
            id: 5, question: '男は帽子を昔から被っていますか', reply: 'いいえ。おそらくそんなに昔ではありません。'),
        Question(id: 6, question: '男はスポーツをしていますか', reply: 'どちらでもいいです。'),
        Question(
            id: 7, question: '男は妻が嫌いですか', reply: 'どちらでもいいです。嫌いではないと思いますが。'),
        Question(id: 8, question: '男は妻が好きですか', reply: 'どちらでもいいです。'),
        Question(
            id: 9, question: '男は帽子が嫌いですか', reply: 'どちらでもありませんが、嫌いではないと思います。'),
        Question(
            id: 10, question: '男はあまり怒らないですか', reply: 'どちらでもいいですが、怒らない方だと思います。'),
        Question(id: 11, question: '男ははげていますか', reply: 'いいえ。すばらしい質問！'),
        Question(id: 12, question: '男ははげていた時がありますか', reply: 'はい。すばらしい質問！'),
        Question(id: 13, question: '男は育毛剤をつけていますか。', reply: 'はい。すばらしい質問！'),
        Question(id: 14, question: '男は日よけのために帽子を被っていますか？', reply: 'いいえ。'),
        Question(id: 15, question: '男は日差しを避けるのために帽子を被っていますか？', reply: 'いいえ。'),
        Question(id: 16, question: '女は帽子が嫌いですか', reply: 'いいえ。'),
      ],
      correctAnswerIds: [1, 2, 3],
      answers: [
        Answer(
            id: 1,
            questionIds: [11, 12],
            answer: '男ははげていたが、今ははげじゃなくなったので帽子が必要なくなったから',
            comment:
                '男は今まで髪がなく、恥ずかしくてそれを隠すために毎日欠かさず帽子を被っていた。しかし、育毛剤をつけ続けたことで髪が生えて帽子を被らなくても外に出られるようになった。妻は髪が生えたのでもう帽子は必要ないだろうと思い捨てたのだった。'),
        Answer(
            id: 2,
            questionIds: [12, 13],
            answer: '男ははげていたが、育毛剤をつけたことで髪が生え、帽子が必要なくなったから',
            comment:
                '男は今まで髪がなく、恥ずかしくてそれを隠すために毎日欠かさず帽子を被っていた。しかし、育毛剤をつけ続けたことで髪が生えて帽子を被らなくても外に出られるようになった。妻は髪が生えたのでもう帽子は必要ないだろうと思い捨てたのだった。'),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('問題一覧'),
        centerTitle: true,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height * .85,
        margin: EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 15,
        ),
        child: ListView.builder(
          itemBuilder: (ctx, index) {
            return QuizItem(
              quiz: quizzes[index],
            );
          },
          itemCount: quizzes.length,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:triviazilla/src/model/news_model.dart';
import 'package:triviazilla/src/model/user_model.dart';

import '../../widgets/card/news_card_main.dart';
import '../news/carousel_news.dart';

class ExploreLatestNews extends StatelessWidget {
  const ExploreLatestNews({
    super.key,
    required this.allNews,
    required this.mainContext,
    required this.user,
    required this.starredNews,
  });
  final List<NewsModel> allNews;
  final List<NewsModel> starredNews;
  final BuildContext mainContext;
  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(bottom: 40),
      children: [
        CarouselNews(
          mainContext: mainContext,
          newsList: starredNews,
          user: user,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(allNews.length, (index) {
            NewsModel news = allNews[index];

            return newsCardMain(
              context: mainContext,
              news: news,
              user: user,
            );
          }),
        ),
      ],
    );
  }
}

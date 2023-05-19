import 'package:flutter/material.dart';
import 'package:triviazilla/src/features/news/carousel_news.dart';
import 'package:triviazilla/src/model/user_model.dart';
import 'package:triviazilla/src/services/helpers.dart';

import '../../model/news_model.dart';

Widget whatsNew({
  required BuildContext context,
  required BuildContext mainContext,
  required UserModel? user,
  required List<NewsModel> newsList,
}) =>
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20, left: 20, bottom: 5),
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: "What's New?",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: getColorByBackground(context),
                  ),
                ),
                const WidgetSpan(child: SizedBox(width: 5)),
                const WidgetSpan(
                    child: Icon(
                  Icons.announcement,
                  size: 18,
                )),
              ],
            ),
          ),
        ),
        CarouselNews(
          mainContext: mainContext,
          newsList: newsList,
          user: user!,
        )
      ],
    );

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:triviazilla/src/model/news_model.dart';
import 'package:triviazilla/src/model/user_model.dart';
import 'package:shimmer/shimmer.dart';

import '../../features/news/news_view.dart';

Widget newsCardSimple({
  required NewsModel news,
  required BuildContext context,
  required UserModel user,
}) =>
    GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => NewsView(
            mainContext: context,
            news: news,
            user: user,
          ),
        ),
      ),
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 80,
                height: 80,
                child: news.imgURL == null
                    ? Image.asset(
                        'assets/images/noimage.png',
                        fit: BoxFit.cover,
                      )
                    : CachedNetworkImage(
                        imageUrl: news.imgURL!,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Shimmer.fromColors(
                          baseColor: CupertinoColors.systemGrey,
                          highlightColor: CupertinoColors.systemGrey2,
                          child: Container(
                            color: Colors.grey,
                          ),
                        ),
                        errorWidget: (context, url, error) => Image.asset(
                          'assets/images/noimage.png',
                          fit: BoxFit.cover,
                        ),
                      ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      news.title,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );

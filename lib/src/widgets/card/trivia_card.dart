import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:triviazilla/src/model/trivia_model.dart';

import '../../services/helpers.dart';
import '../image/avatar.dart';
import '../modal/trivia_modal.dart';

Widget triviaCard({
  required BuildContext mainContext,
  required BuildContext context,
  required TriviaModel trivia,
}) =>
    Container(
      width: MediaQuery.of(context).size.width * 0.4,
      height: MediaQuery.of(context).size.height * 0.3,
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: CupertinoColors.systemGrey,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(8.0),
        onTap: () => showTriviaModal(context: mainContext),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            trivia.imgURL == null
                ? Image.asset(
                    'assets/images/noimage.png',
                    fit: BoxFit.cover,
                    height: MediaQuery.of(context).size.height * 0.15,
                    width: double.infinity,
                  )
                : SizedBox(
                    height: MediaQuery.of(context).size.height * 0.15,
                    width: double.infinity,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(8.0),
                        topRight: Radius.circular(8.0),
                      ),
                      child: CachedNetworkImage(
                        imageUrl: trivia.imgURL!,
                        // 'https://firebasestorage.googleapis.com/v0/b/news-app-v2-e2716.appspot.com/o/news%2Fthumbnail%2FthDdoQJ78nHpEkjBfL10.jpg?alt=media&token=eb5da999-beb1-4f11-9319-3a346133b14d',
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Shimmer.fromColors(
                          baseColor: CupertinoColors.systemGrey,
                          highlightColor: CupertinoColors.systemGrey2,
                          child: Container(color: Colors.grey),
                        ),
                      ),
                    ),
                  ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: CustomColor.primary,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(5),
                      child: Text(
                        "${trivia.questions.length} Qs",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    trivia.title,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      avatar(
                        user: trivia.author!,
                        width: MediaQuery.of(context).size.height * 0.03,
                        height: MediaQuery.of(context).size.height * 0.03,
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          trivia.author!.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

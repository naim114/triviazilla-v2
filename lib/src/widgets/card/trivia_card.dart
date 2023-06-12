import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:triviazilla/src/model/trivia_model.dart';

import '../../model/user_model.dart';
import '../../services/helpers.dart';
import '../image/avatar.dart';
import '../modal/trivia_modal.dart';

Widget triviaCard({
  required BuildContext mainContext,
  required BuildContext context,
  required TriviaModel trivia,
  required UserModel user,
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
        onTap: () => showTriviaModal(
          context: mainContext,
          trivia: trivia,
          user: user,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            trivia.imgURL == null
                ? ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8.0),
                      topRight: Radius.circular(8.0),
                    ),
                    child: Image.asset(
                      'assets/images/noimage.png',
                      fit: BoxFit.cover,
                      height: MediaQuery.of(context).size.height * 0.15,
                      width: double.infinity,
                    ),
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
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        "${trivia.questions.length} Qs",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    trivia.title,
                    maxLines: 1,
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

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shimmer/shimmer.dart';
import 'package:triviazilla/src/features/start/countdown.dart';
import 'package:triviazilla/src/features/trivia/leaderboard.dart';
import 'package:triviazilla/src/model/trivia_model.dart';
import 'package:triviazilla/src/model/user_model.dart';
import 'package:triviazilla/src/services/helpers.dart';
import 'package:triviazilla/src/services/trivia_services.dart';

import '../image/avatar.dart';

void showTriviaModal({
  required TriviaModel trivia,
  required BuildContext context,
  required UserModel user,
}) =>
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(15),
        ),
      ),
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(15.0),
            topRight: Radius.circular(15.0),
          ),
          child: Container(
            color:
                isDarkTheme(context) ? CustomColor.darkerBg : Colors.grey[200],
            height: MediaQuery.of(context).size.height * 0.9,
            child: Stack(
              children: [
                CustomScrollView(
                  slivers: [
                    // Cover image
                    SliverAppBar(
                      flexibleSpace: trivia.imgURL == null
                          ? ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(15.0),
                                topRight: Radius.circular(15.0),
                              ),
                              child: Image.asset(
                                'assets/images/noimage.png',
                                fit: BoxFit.cover,
                                height:
                                    MediaQuery.of(context).size.height * 0.3,
                                width: double.infinity,
                              ),
                            )
                          : ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(15.0),
                                topRight: Radius.circular(15.0),
                              ),
                              child: CachedNetworkImage(
                                imageUrl: trivia.imgURL!,
                                fit: BoxFit.cover,
                                height:
                                    MediaQuery.of(context).size.height * 0.3,
                                placeholder: (context, url) =>
                                    Shimmer.fromColors(
                                  baseColor: CupertinoColors.systemGrey,
                                  highlightColor: CupertinoColors.systemGrey2,
                                  child: Container(
                                    color: Colors.grey,
                                    height: MediaQuery.of(context).size.height *
                                        0.3,
                                  ),
                                ),
                                errorWidget: (context, url, error) =>
                                    Image.asset(
                                  'assets/images/noimage.png',
                                  fit: BoxFit.cover,
                                  height:
                                      MediaQuery.of(context).size.height * 0.3,
                                ),
                              ),
                            ),
                      expandedHeight: MediaQuery.of(context).size.height * 0.3,
                      leading: IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(
                          Icons.close,
                          color: Colors.white,
                        ),
                      ),
                      actions: [
                        PopupMenuButton(
                          icon: const Icon(
                            Icons.more_vert,
                            color: Colors.white,
                          ),
                          onSelected: (value) async {
                            if (value == 'Leaderboard') {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => TriviaLeaderboard(trivia: trivia,),
                                ),
                              );
                            } else if (value == 'Like') {
                              Navigator.pop(context);

                              final result = await TriviaServices()
                                  .like(trivia: trivia, user: user);

                              if (result) {
                                Fluttertoast.showToast(msg: "Trivia Liked!");
                              }
                            } else if (value == 'Unlike') {
                              Navigator.pop(context);
                              final result = await TriviaServices()
                                  .unlike(trivia: trivia, user: user);

                              if (result) {
                                Fluttertoast.showToast(msg: "Trivia Unliked!");
                              }
                            } else if (value == 'Bookmark') {
                              Navigator.pop(context);

                              final result = await TriviaServices()
                                  .bookmark(trivia: trivia, user: user);

                              if (result) {
                                Fluttertoast.showToast(
                                    msg: "Trivia Bookmarked!");
                              }
                            } else if (value == 'Unbookmark') {
                              Navigator.pop(context);

                              print("unbookmark");

                              final result = await TriviaServices()
                                  .unbookmark(trivia: trivia, user: user);

                              if (result) {
                                Fluttertoast.showToast(
                                    msg: "Trivia Unbookmarked!");
                              }
                            }
                          },
                          itemBuilder: (BuildContext context) =>
                              <PopupMenuEntry>[
                            PopupMenuItem(
                              value: 'Leaderboard',
                              child: Text.rich(
                                TextSpan(
                                  style: TextStyle(
                                      color: getColorByBackground(context)),
                                  children: const [
                                    WidgetSpan(child: Icon(Icons.leaderboard)),
                                    WidgetSpan(child: SizedBox(width: 5)),
                                    TextSpan(text: "Leaderboard"),
                                  ],
                                ),
                              ),
                            ),
                            TriviaServices().isLike(trivia: trivia, user: user)
                                ? PopupMenuItem(
                                    value: 'Unlike',
                                    child: Text.rich(
                                      TextSpan(
                                        style: TextStyle(
                                            color:
                                                getColorByBackground(context)),
                                        children: const [
                                          WidgetSpan(
                                              child: Icon(CupertinoIcons
                                                  .heart_slash_fill)),
                                          WidgetSpan(child: SizedBox(width: 5)),
                                          TextSpan(text: "Unlike"),
                                        ],
                                      ),
                                    ),
                                  )
                                : PopupMenuItem(
                                    value: 'Like',
                                    child: Text.rich(
                                      TextSpan(
                                        style: TextStyle(
                                            color:
                                                getColorByBackground(context)),
                                        children: const [
                                          WidgetSpan(
                                              child: Icon(
                                                  CupertinoIcons.heart_fill)),
                                          WidgetSpan(child: SizedBox(width: 5)),
                                          TextSpan(text: "Like"),
                                        ],
                                      ),
                                    ),
                                  ),
                            TriviaServices()
                                    .isBookmark(trivia: trivia, user: user)
                                ? PopupMenuItem(
                                    value: 'Unbookmark',
                                    child: Text.rich(
                                      TextSpan(
                                        style: TextStyle(
                                            color:
                                                getColorByBackground(context)),
                                        children: const [
                                          WidgetSpan(
                                              child:
                                                  Icon(Icons.bookmark_remove)),
                                          WidgetSpan(child: SizedBox(width: 5)),
                                          TextSpan(text: "Unbookmark"),
                                        ],
                                      ),
                                    ),
                                  )
                                : PopupMenuItem(
                                    value: 'Bookmark',
                                    child: Text.rich(
                                      TextSpan(
                                        style: TextStyle(
                                            color:
                                                getColorByBackground(context)),
                                        children: const [
                                          WidgetSpan(
                                              child: Icon(Icons.bookmark)),
                                          WidgetSpan(child: SizedBox(width: 5)),
                                          TextSpan(text: "Bookmark"),
                                        ],
                                      ),
                                    ),
                                  ),
                          ],
                        ),
                      ],
                    ),
                    // Title & Stats
                    SliverToBoxAdapter(
                      child: Container(
                        color: isDarkTheme(context)
                            ? CustomColor.darkBg
                            : Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 15,
                            horizontal: 20,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Title
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Text(
                                  trivia.title,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: getColorByBackground(context),
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                              const Divider(color: CupertinoColors.systemGrey),
                              // Stats Row TODO
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text.rich(
                                    TextSpan(
                                      children: [
                                        const WidgetSpan(
                                          child: Icon(
                                            CupertinoIcons.play_arrow_solid,
                                            size: 25,
                                            color: Colors.blue,
                                          ),
                                        ),
                                        TextSpan(
                                          text: ' 12',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 25,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  Text.rich(
                                    TextSpan(
                                      children: [
                                        const WidgetSpan(
                                          child: Icon(
                                            CupertinoIcons.question_circle_fill,
                                            size: 25,
                                            color: Colors.green,
                                          ),
                                        ),
                                        TextSpan(
                                          text:
                                              ' ${trivia.questions.isEmpty ? 0 : trivia.questions.length}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 25,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  Text.rich(
                                    TextSpan(
                                      children: [
                                        const WidgetSpan(
                                          child: Icon(
                                            CupertinoIcons.heart_fill,
                                            size: 25,
                                            color: Colors.pink,
                                          ),
                                        ),
                                        TextSpan(
                                          text:
                                              ' ${trivia.likedBy == null || trivia.likedBy!.isEmpty ? 0 : trivia.likedBy!.length}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 25,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Author & Description
                    SliverToBoxAdapter(
                      child: SizedBox(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              leading: avatar(
                                user: trivia.author!,
                                height:
                                    MediaQuery.of(context).size.height * 0.05,
                                width:
                                    MediaQuery.of(context).size.height * 0.05,
                              ),
                              title: Text(
                                trivia.author!.name,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: getColorByBackground(context),
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              subtitle: Text(
                                trivia.author!.name,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(
                                    color: getColorByBackground(context)),
                              ),
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Description',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                    textAlign: TextAlign.start,
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    trivia.description,
                                    textAlign: TextAlign.start,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: isDarkTheme(context)
                          ? CustomColor.darkBg
                          : Colors.white,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 10,
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            PageTransition(
                              type: PageTransitionType.topToBottom,
                              child: StartTriviaCountdown(),
                            ),
                          );
                        },
                        child: const Text(
                          "Start",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

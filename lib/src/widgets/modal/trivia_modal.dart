import 'dart:io';

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
import 'package:triviazilla/src/widgets/editor/trivia_editor.dart';

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
                                  builder: (context) => TriviaLeaderboard(
                                    trivia: trivia,
                                  ),
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
                            } else if (value == 'Edit') {
                              File? downloadedFile;

                              if (trivia.imgURL != null) {
                                downloadedFile =
                                    await downloadFile(trivia.imgURL!);
                              }

                              List<String>? tags;

                              if (trivia.tag != null ||
                                  trivia.tag!.isNotEmpty) {
                                tags = trivia.tag!
                                    .map((e) => e.toString())
                                    .toList();
                              }

                              List<Map<String, dynamic>>? question;

                              if (trivia.questions.isNotEmpty) {
                                question = trivia.questions
                                    .map((e) => e.toMap())
                                    .toList();
                              }

                              if (context.mounted) {
                                Navigator.pop(context);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => TriviaEditor(
                                      category: trivia.category,
                                      description: trivia.description,
                                      title: trivia.title,
                                      thumbnailFile: downloadedFile,
                                      tags: tags,
                                      question: question,
                                      onPost: (coverImageFile,
                                          title,
                                          description,
                                          category,
                                          tags,
                                          question) async {
                                        final result =
                                            await TriviaServices().edit(
                                          title: title,
                                          description: description,
                                          author: user,
                                          question: question,
                                          coverImageFile: coverImageFile,
                                          category: category,
                                          tags: tags,
                                          trivia: trivia,
                                        );

                                        if (result) {
                                          Fluttertoast.showToast(
                                              msg: "Trivia edited!");
                                        }
                                      },
                                    ),
                                  ),
                                );
                              } else {
                                Fluttertoast.showToast(msg: "Loading...");
                              }
                            } else if (value == 'Delete') {
                              showDialog<String>(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  title: const Text(
                                      'Are you sure you want to delete this trivia?'),
                                  content: const Text(
                                      'Deleted data can\'t be retrieve back. Select OK to delete.'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text(
                                        'Cancel',
                                        style: TextStyle(
                                          color: CupertinoColors.systemGrey,
                                        ),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                        Fluttertoast.showToast(
                                            msg: "Deleting trivia..");

                                        final result = await TriviaServices()
                                            .delete(trivia: trivia);

                                        if (result) {
                                          Fluttertoast.showToast(
                                              msg: "Trivia deleted!!");
                                        }
                                      },
                                      child: const Text(
                                        'OK',
                                        style: TextStyle(
                                            color: CustomColor.danger),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                          },
                          itemBuilder: (BuildContext context) =>
                              <PopupMenuEntry>[
                            if (trivia.author!.id == user.id ||
                                (user.role != null &&
                                    user.role!.name != "user"))
                              PopupMenuItem(
                                value: 'Edit',
                                child: Text.rich(
                                  TextSpan(
                                    style: TextStyle(
                                        color: getColorByBackground(context)),
                                    children: const [
                                      WidgetSpan(child: Icon(Icons.edit)),
                                      WidgetSpan(child: SizedBox(width: 5)),
                                      TextSpan(text: "Edit"),
                                    ],
                                  ),
                                ),
                              ),
                            if (trivia.author!.id == user.id ||
                                (user.role != null &&
                                    user.role!.name != "user"))
                              PopupMenuItem(
                                value: 'Delete',
                                child: Text.rich(
                                  TextSpan(
                                    style: TextStyle(
                                        color: getColorByBackground(context)),
                                    children: const [
                                      WidgetSpan(child: Icon(Icons.delete)),
                                      WidgetSpan(child: SizedBox(width: 5)),
                                      TextSpan(text: "Delete"),
                                    ],
                                  ),
                                ),
                              ),
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
                              // Stats Row
                              FutureBuilder<int>(
                                future: TriviaServices()
                                    .getPlayCount(trivia: trivia),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  }

                                  return Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
                                              text: ' ${snapshot.data}',
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
                                                CupertinoIcons
                                                    .question_circle_fill,
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
                                  );
                                },
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
                            const SizedBox(height: 20),
                            trivia.category == null || trivia.category == ""
                                ? const SizedBox()
                                : Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Category',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                          textAlign: TextAlign.start,
                                        ),
                                        const SizedBox(height: 5),
                                        GestureDetector(
                                          onTap: () async {
                                            showDialog(
                                              context: context,
                                              barrierDismissible: false,
                                              builder: (BuildContext context) {
                                                return const Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                );
                                              },
                                            );

                                            await TriviaServices().search(
                                              context: context,
                                              user: user,
                                              query: trivia.category,
                                            );

                                            if (context.mounted) {
                                              Navigator.of(context,
                                                      rootNavigator: true)
                                                  .pop();
                                            }
                                          },
                                          child: Text(
                                            trivia.category!,
                                            textAlign: TextAlign.start,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                            const SizedBox(height: 20),
                            trivia.tag == null || trivia.tag!.isEmpty
                                ? const SizedBox()
                                : Container(
                                    padding: const EdgeInsets.only(
                                      left: 20,
                                      right: 20,
                                      bottom: 50,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Tag',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                          textAlign: TextAlign.start,
                                        ),
                                        const SizedBox(height: 10),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            left: 15,
                                            bottom: 30,
                                          ),
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Row(
                                              children: trivia.tag!.map((tag) {
                                                return Container(
                                                  decoration:
                                                      const BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(20.0),
                                                    ),
                                                    color: CustomColor.primary,
                                                  ),
                                                  margin: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 5.0),
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 10.0,
                                                      vertical: 5.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      InkWell(
                                                        child: Text(
                                                          "#$tag",
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                        ),
                                                        onTap: () async {
                                                          showDialog(
                                                            context: context,
                                                            barrierDismissible:
                                                                false,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return const Center(
                                                                child:
                                                                    CircularProgressIndicator(),
                                                              );
                                                            },
                                                          );

                                                          await TriviaServices()
                                                              .search(
                                                            context: context,
                                                            user: user,
                                                            query: tag,
                                                          );

                                                          if (context.mounted) {
                                                            Navigator.of(
                                                                    context,
                                                                    rootNavigator:
                                                                        true)
                                                                .pop();
                                                          }
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              }).toList(),
                                            ),
                                          ),
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
                              child: StartTriviaCountdown(
                                trivia: trivia,
                                user: user,
                              ),
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

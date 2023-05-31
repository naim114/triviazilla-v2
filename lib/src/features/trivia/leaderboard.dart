import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../model/trivia_model.dart';
import '../../services/helpers.dart';

class TriviaLeaderboard extends StatelessWidget {
  final TriviaModel trivia;
  const TriviaLeaderboard({super.key, required this.trivia});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar.large(
            pinned: true,
            snap: false,
            floating: false,
            leading: null,
            automaticallyImplyLeading: false,
            expandedHeight: 300.0,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(0),
              child: AppBar(
                elevation: 0,
                title: Text.rich(
                  TextSpan(
                    style: TextStyle(color: getColorByBackground(context)),
                    children: const [
                      TextSpan(text: "Leaderboard"),
                      WidgetSpan(child: SizedBox(width: 10)),
                      WidgetSpan(child: Icon(Icons.leaderboard)),
                    ],
                  ),
                ),
                centerTitle: true,
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              background: trivia.imgURL == null
                  ? Image.asset(
                      'assets/images/noimage.png',
                      fit: BoxFit.cover,
                      // height: MediaQuery.of(context).size.height * 0.3,
                    )
                  : CachedNetworkImage(
                      imageUrl: trivia.imgURL!,
                      // 'https://cdn.pixabay.com/photo/2019/07/02/10/25/giraffe-4312090_1280.jpg',
                      fit: BoxFit.cover,
                      // height: MediaQuery.of(context).size.height * 0.3,
                      placeholder: (context, url) => Shimmer.fromColors(
                        baseColor: CupertinoColors.systemGrey,
                        highlightColor: CupertinoColors.systemGrey2,
                        child: Container(
                          color: Colors.grey,
                          // height: MediaQuery.of(context).size.height * 0.3,
                        ),
                      ),
                      errorWidget: (context, url, error) => Image.asset(
                        'assets/images/noimage.png',
                        fit: BoxFit.cover,
                        // height: MediaQuery.of(context).size.height * 0.3,
                      ),
                    ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              color: isDarkTheme(context) ? CustomColor.darkBg : Colors.white,
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
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
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
          // TODO
          SliverToBoxAdapter(
            child: Container(
              color: isDarkTheme(context)
                  ? CustomColor.darkerBg
                  : Colors.grey[200],
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 3,
                      horizontal: 8,
                    ),
                    child: Card(
                      child: ListTile(
                        leading: Text(
                          '#8',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: getColorByBackground(context),
                            fontSize: 18,
                          ),
                        ),
                        title: Text(
                          'user.name',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: getColorByBackground(context),
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        trailing: Text(
                          '200',
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 18,
                            color: getColorByBackground(context),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return Container(
                  color: index.isOdd ? Colors.white : Colors.black12,
                  height: 100.0,
                  child: Center(
                    child: Text('$index', textScaleFactor: 5),
                  ),
                );
              },
              childCount: 20,
            ),
          ),
        ],
      ),
    );
  }
}

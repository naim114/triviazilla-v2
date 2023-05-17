import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:triviazilla/src/features/explore/latest.dart';
import 'package:triviazilla/src/services/helpers.dart';
import 'package:triviazilla/src/services/news_services.dart';
import '../../model/news_model.dart';
import '../../model/user_model.dart';
import '../../widgets/card/news_card_main.dart';
import '../../widgets/image/avatar.dart';
import '../../widgets/skeleton/skeleton_news.dart';

class Explore extends StatefulWidget {
  const Explore({
    super.key,
    required this.mainContext,
    this.user,
    this.onAvatarTap,
  });
  final BuildContext mainContext;
  final UserModel? user;
  final void Function()? onAvatarTap;

  @override
  State<Explore> createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  List<List<NewsModel>> allList = [
    [],
    [],
  ];
  bool loading = true;

  Future<void> _refreshData() async {
    try {
      final List<NewsModel> fetchedAllNews =
          (await NewsService().getAll()).whereType<NewsModel>().toList();
      final List<NewsModel> fetchedStarredNews = (await NewsService().getAllBy(
        fieldName: 'starred',
        desc: true,
        limit: 5,
      ))
          .whereType<NewsModel>()
          .toList();
      setState(() {
        loading = false;
        allList = [fetchedAllNews, fetchedStarredNews];
      });

      // Trigger a refresh of the RefreshIndicator widget
      _refreshIndicatorKey.currentState?.show();
    } catch (e) {
      print("Error Get All Type of News:  ${e.toString()}");
    }

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? const SkeletonNews()
        : RefreshIndicator(
            key: _refreshIndicatorKey,
            onRefresh: _refreshData,
            child: Builder(
              builder: (context) {
                final List<NewsModel> allNews = allList[0];
                final List<NewsModel> starredNews = allList[1];

                Map<String, List<NewsModel>> groupedNews = {};

                for (NewsModel news in allNews) {
                  if (news.category != null) {
                    if (groupedNews.containsKey(news.category!.toLowerCase())) {
                      groupedNews[news.category!.toLowerCase()]!.add(news);
                    } else {
                      groupedNews[news.category!.toLowerCase()] = [news];
                    }
                  }
                }

                final tabs = <Widget>[
                  Tab(
                    child: Text(
                      "ALL",
                      style: TextStyle(color: getColorByBackground(context)),
                    ),
                  ),
                ];

                final children = <Widget>[
                  ExploreLatestNews(
                    mainContext: widget.mainContext,
                    user: widget.user!,
                    allNews: allNews,
                    starredNews: starredNews,
                  ),
                ];

                groupedNews.forEach((category, newsList) {
                  tabs.add(
                    Tab(
                      child: Text(
                        category.toUpperCase(),
                        style: TextStyle(color: getColorByBackground(context)),
                      ),
                    ),
                  );
                  children.add(
                    ListView(
                      padding: const EdgeInsets.only(bottom: 40),
                      children: List.generate(newsList.length, (index) {
                        NewsModel news = newsList[index];

                        return newsCardMain(
                          context: widget.mainContext,
                          news: news,
                          user: widget.user!,
                        );
                      }),
                    ),
                  );
                });
                return DefaultTabController(
                  length: groupedNews.length + 1,
                  initialIndex: 0,
                  child: Scaffold(
                    appBar: AppBar(
                      centerTitle: true,
                      actions: [
                        SizedBox(width: MediaQuery.of(context).size.width * 0.1)
                      ],
                      title: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.045,
                        child: GestureDetector(
                          onTap: () async {
                            showDialog(
                              context: widget.mainContext,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              },
                            );

                            await NewsService().searchNews(
                              context: widget.mainContext,
                              user: widget.user!,
                            );

                            if (context.mounted) {
                              Navigator.of(widget.mainContext,
                                      rootNavigator: true)
                                  .pop();
                            }
                          },
                          child: TextField(
                            readOnly: false,
                            autofocus: false,
                            enabled: false,
                            decoration: InputDecoration(
                              fillColor: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? CupertinoColors.darkBackgroundGray
                                  : Colors.white,
                              disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50.0),
                                borderSide: const BorderSide(
                                  color: CupertinoColors.systemGrey,
                                  width: 1,
                                ),
                              ),
                              contentPadding: const EdgeInsets.all(0),
                              prefixIcon: const Icon(Icons.search),
                              hintText: 'Search news',
                            ),
                          ),
                        ),
                      ),
                      leading: GestureDetector(
                        onTap: widget.onAvatarTap,
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 20.0,
                            top: 10,
                            bottom: 10,
                          ),
                          child: avatar(
                            user: widget.user!,
                            width: MediaQuery.of(context).size.height * 0.05,
                            height: MediaQuery.of(context).size.height * 0.05,
                          ),
                        ),
                      ),
                      bottom: TabBar(
                        isScrollable: true,
                        tabs: tabs,
                      ),
                    ),
                    body: TabBarView(
                      children: children,
                    ),
                  ),
                );
              },
            ),
          );
  }
}

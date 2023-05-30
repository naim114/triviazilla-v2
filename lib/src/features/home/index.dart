import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:triviazilla/src/features/home/whats_new.dart';
import 'package:triviazilla/src/model/news_model.dart';

import '../../model/user_model.dart';
import '../../services/news_services.dart';
import '../../widgets/image/avatar.dart';
import '../../widgets/carousel/trivia_row.dart';
import '../../widgets/image/logo_main.dart';
import 'categories.dart';

class Home extends StatefulWidget {
  final UserModel? user;
  final BuildContext mainContext;
  final void Function()? onAvatarTap;

  const Home({
    super.key,
    required this.user,
    required this.mainContext,
    this.onAvatarTap,
  });

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  List<List<Object>> allList = [
    [], // all trivia
    [], // categories
    [], // my trivia
    [], // popular
    [], // news
  ];

  bool loading = true;

  Future<void> _refreshData() async {
    try {
      List<NewsModel> newsList = await NewsService().getPopularNews();

      setState(() {
        loading = false;
        allList = [
          [], // all trivia
          [], // categories
          [], // my trivia
          [], // popular
          newsList,
        ];
      });

      // Trigger a refresh of the RefreshIndicator widget
      _refreshIndicatorKey.currentState?.show();
    } catch (e) {
      print("Error Get All Type of News:  ${e.toString()}");
    }

    // setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: logoMain(
          context: context,
          height: MediaQuery.of(context).size.height * 0.06,
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
      ),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _refreshData,
        child: Builder(builder: (context) {
          final List<NewsModel> latestNewsList =
              List<NewsModel>.from(allList[4]);

          return ListView(
            children: [
              // Search box
              Padding(
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 20,
                ),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.045,
                  child: GestureDetector(
                    onTap: () {},
                    child: TextField(
                      readOnly: false,
                      autofocus: false,
                      enabled: false,
                      decoration: InputDecoration(
                        fillColor:
                            Theme.of(context).brightness == Brightness.dark
                                ? CupertinoColors.darkBackgroundGray
                                : Colors.white,
                        disabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: CupertinoColors.systemGrey,
                            width: 1,
                          ),
                        ),
                        contentPadding: const EdgeInsets.all(0),
                        prefixIcon: const Icon(Icons.search),
                        hintText: 'Search trivia by title, categories, ...',
                      ),
                    ),
                  ),
                ),
              ),
              // Categories
              categoriesHome(context: context),
              // My Trivia
              triviaRow(
                context: context,
                mainContext: widget.mainContext,
                trivias: [],
                user: widget.user!,
              ),
              // Popular Trivia
              triviaRow(
                context: context,
                mainContext: widget.mainContext,
                title: "Popular Trivia",
                icon: Icons.stacked_line_chart,
                trivias: [],
                user: widget.user!,
              ),
              // Whats New
              latestNewsList.isEmpty
                  ? const SizedBox()
                  : whatsNew(
                      mainContext: widget.mainContext,
                      user: widget.user,
                      context: context,
                      newsList: latestNewsList,
                    ),
              // End
              const SizedBox(height: 50),
            ],
          );
        }),
      ),
    );
  }
}

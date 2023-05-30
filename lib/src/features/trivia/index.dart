import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:triviazilla/src/features/trivia/add.dart';
import 'package:triviazilla/src/model/trivia_model.dart';
import 'package:triviazilla/src/services/helpers.dart';
import 'package:triviazilla/src/services/trivia_services.dart';

import '../../model/user_model.dart';
import '../../widgets/typography/page_title_icon.dart';
import '../../widgets/carousel/trivia_row.dart';

class TriviaMenu extends StatefulWidget {
  final BuildContext mainContext;
  final UserModel user;

  const TriviaMenu({
    super.key,
    required this.mainContext,
    required this.user,
  });

  @override
  State<TriviaMenu> createState() => _TriviaMenuState();
}

class _TriviaMenuState extends State<TriviaMenu> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  List<List<TriviaModel>> allList = [
    [],
    [],
    [],
  ];

  bool loading = true;

  Future<void> _refreshData() async {
    List<TriviaModel> all = await TriviaServices().getAll();

    List<TriviaModel> myTrivia = List.empty(growable: true);
    List<TriviaModel> bookmarkTrivia = List.empty(growable: true);
    List<TriviaModel> likedTrivia = List.empty(growable: true);

    for (var trivia in all) {
      if (trivia.author!.id == widget.user.id) {
        myTrivia.add(trivia);
      }

      if (TriviaServices().isBookmark(trivia: trivia, user: widget.user)) {
        bookmarkTrivia.add(trivia);
      }

      if (TriviaServices().isLike(trivia: trivia, user: widget.user)) {
        likedTrivia.add(trivia);
      }
    }

    setState(() {
      loading = false;
      allList = [
        myTrivia,
        bookmarkTrivia,
        likedTrivia,
      ];
    });

    // Trigger a refresh of the RefreshIndicator widget
    _refreshIndicatorKey.currentState?.show();

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
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _refreshData,
        child: Builder(builder: (context) {
          final List<TriviaModel> myTrivias =
              List<TriviaModel>.from(allList[0]);
          final List<TriviaModel> bookmarkTrivias =
              List<TriviaModel>.from(allList[1]);
          final List<TriviaModel> likedTrivias =
              List<TriviaModel>.from(allList[2]);

          return ListView(
            children: [
              // Title
              Container(
                padding: const EdgeInsets.only(
                  top: 25,
                  left: 20,
                  right: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    pageTitleIcon(
                      context: context,
                      title: "Menu",
                      icon: const Icon(
                        Icons.lightbulb,
                        size: 20,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        'View all your trivias here. You can create a trivia by tapping on the floating button.',
                        style: TextStyle(),
                      ),
                    ),
                  ],
                ),
              ),
              //  My Trivia
              triviaRow(
                context: context,
                mainContext: widget.mainContext,
                title: "Created Trivia",
                trivias: myTrivias,
                user: widget.user,
              ),
              // Liked
              triviaRow(
                context: context,
                mainContext: widget.mainContext,
                title: "Liked",
                icon: CupertinoIcons.heart_fill,
                trivias: likedTrivias,
                user: widget.user,
              ),
              // Bookmarked
              triviaRow(
                context: context,
                mainContext: widget.mainContext,
                title: "Bookmarked",
                icon: Icons.bookmark,
                trivias: bookmarkTrivias,
                user: widget.user,
              ),
              // End
              const SizedBox(height: 50),
            ],
          );
        }),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(
          bottom: 35,
          right: 10,
        ),
        child: FloatingActionButton(
          onPressed: () => Navigator.push(
            widget.mainContext,
            MaterialPageRoute(
              builder: (context) => TriviaAdd(user: widget.user),
            ),
          ),
          backgroundColor: CustomColor.primary,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

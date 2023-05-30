import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:triviazilla/src/features/trivia/add.dart';
import 'package:triviazilla/src/services/helpers.dart';

import '../../model/user_model.dart';
import '../../widgets/typography/page_title_icon.dart';
import '../../widgets/carousel/trivia_row.dart';

class TriviaMenu extends StatelessWidget {
  final BuildContext mainContext;
  final UserModel user;

  const TriviaMenu({
    super.key,
    required this.mainContext,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
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
            mainContext: mainContext,
            title: "Created Trivia",
          ),
          // Liked
          triviaRow(
            context: context,
            mainContext: mainContext,
            title: "Liked",
            icon: CupertinoIcons.heart_fill,
          ),
          // Bookmarked
          triviaRow(
            context: context,
            mainContext: mainContext,
            title: "Bookmarked",
            icon: Icons.bookmark,
          ),
          // End
          const SizedBox(height: 50),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(
          bottom: 35,
          right: 10,
        ),
        child: FloatingActionButton(
          onPressed: () => Navigator.push(
            mainContext,
            MaterialPageRoute(
              builder: (context) => TriviaAdd(user: user),
            ),
          ),
          backgroundColor: CustomColor.primary,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

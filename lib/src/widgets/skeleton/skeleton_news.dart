import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:triviazilla/src/widgets/skeleton/skeleton_news_card_main.dart';
import 'package:shimmer/shimmer.dart';

class SkeletonNews extends StatelessWidget {
  const SkeletonNews({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(
            left: 20.0,
            top: 10,
            bottom: 10,
          ),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.05,
            width: MediaQuery.of(context).size.height * 0.05,
            child: Shimmer.fromColors(
              baseColor: CupertinoColors.systemGrey,
              highlightColor: CupertinoColors.systemGrey2,
              child: Container(
                width: MediaQuery.of(context).size.height * 0.05,
                height: MediaQuery.of(context).size.height * 0.05,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
        ),
      ),
      body: ListView(
        children: [
          skeletonNewsCardMain(context: context),
          skeletonNewsCardMain(context: context),
          skeletonNewsCardMain(context: context),
          skeletonNewsCardMain(context: context),
          skeletonNewsCardMain(context: context),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../services/helpers.dart';
import '../../widgets/typography/page_title_icon.dart';

class Record extends StatelessWidget {
  const Record({super.key});

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
                  title: "Record",
                  icon: const Icon(
                    Icons.list,
                    size: 20,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    'View all answer result here. Swipe the tile for action.',
                    style: TextStyle(),
                  ),
                ),
              ],
            ),
          ),
          // Record
          Column(
            children: [
              Slidable(
                key: const ValueKey(0),
                endActionPane: ActionPane(
                  motion: const ScrollMotion(),
                  children: [
                    SlidableAction(
                      onPressed: (context) {},
                      backgroundColor: CustomColor.secondary,
                      foregroundColor: Colors.white,
                      icon: Icons.remove_red_eye,
                      label: 'View',
                    ),
                    SlidableAction(
                      onPressed: (context) {},
                      backgroundColor: CustomColor.danger,
                      foregroundColor: Colors.white,
                      icon: Icons.delete,
                      label: 'Delete',
                    ),
                  ],
                ),
                child: ListTile(
                  shape: const Border(
                    bottom: BorderSide(
                      color: CustomColor.neutral2,
                    ),
                  ),
                  title: Text(
                    "Missisipi Goddamn",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Text("10/10"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

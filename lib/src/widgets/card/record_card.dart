import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import '../../features/start/result.dart';
import '../../services/helpers.dart';
import '../modal/trivia_modal.dart';

Widget recordCard({
  required BuildContext context,
}) =>
    Card(
      elevation: 4,
      child: ListTile(
        title: Text(
          "Favorite Rhinosaurus Ranked",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(timeAgo(DateTime.now())),
        trailing: PopupMenuButton(
          icon: const Icon(
            Icons.more_vert,
            color: CupertinoColors.systemGrey,
          ),
          onSelected: (value) {
            if (value == 'Result') {
              Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.topToBottom,
                  child: StartTriviaResult(),
                ),
              );
            } else if (value == 'Trivia') {
              // showTriviaModal(context: context); TODO
            } else if (value == 'Delete') {
              showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: const Text(
                      'Are you sure you want to delete this record?'),
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
                      onPressed: () {
                        // TODO delete
                      },
                      child: const Text(
                        'OK',
                        style: TextStyle(color: CustomColor.danger),
                      ),
                    ),
                  ],
                ),
              );
            }
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry>[
            const PopupMenuItem(
              value: 'Result',
              child: Text("View Result"),
            ),
            const PopupMenuItem(
              value: 'Trivia',
              child: Text("View Trivia"),
            ),
            const PopupMenuItem(
              value: 'Delete',
              child: Text(
                "Delete Record",
                style: TextStyle(color: CustomColor.danger),
              ),
            ),
          ],
        ),
      ),
    );

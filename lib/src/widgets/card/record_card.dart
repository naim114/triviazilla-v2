import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:page_transition/page_transition.dart';
import 'package:triviazilla/src/model/user_model.dart';

import '../../features/start/result.dart';
import '../../model/record_trivia_model.dart';
import '../../services/helpers.dart';
import '../../services/record_service.dart';
import '../modal/trivia_modal.dart';

Widget recordCard({
  required BuildContext context,
  required RecordTriviaModel record,
  required UserModel user,
}) =>
    Card(
      elevation: 4,
      child: ListTile(
        title: Text(
          record.trivia.title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(timeAgo(record.createdAt)),
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
                  child: StartTriviaResult(
                    record: record,
                    trivia: record.trivia,
                    user: user,
                  ),
                ),
              );
            } else if (value == 'Trivia') {
              showTriviaModal(
                context: context,
                trivia: record.trivia,
                user: user,
              );
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
                      onPressed: () async {
                        Navigator.pop(context);
                        Navigator.pop(context);
                        Fluttertoast.showToast(msg: "Deleting record..");

                        final result =
                            await RecordServices().delete(record: record);

                        if (result) {
                          Fluttertoast.showToast(msg: "Record deleted!!");
                        }
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

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:page_transition/page_transition.dart';
import '../../services/helpers.dart';
import '../../widgets/modal/trivia_modal.dart';
import '../start/result.dart';

class RecordList extends StatelessWidget {
  const RecordList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back,
            color: CustomColor.neutral2,
          ),
        ),
        title: Text(
          "Record",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: getColorByBackground(context),
          ),
        ),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
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
                      showTriviaModal(context: context);
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
            ),
          ),
        ],
      ),
    );
  }
}

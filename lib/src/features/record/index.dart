import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../services/helpers.dart';

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
              onTap: () {
                print('go');
              },
              shape: const Border(
                bottom: BorderSide(
                  color: CustomColor.neutral2,
                ),
              ),
              title: Text(
                "Missisipi Goddamn",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              trailing: Text("10/10"),
              subtitle: Text(timeAgo(DateTime.now())),
            ),
          ),
        ],
      ),
    );
  }
}

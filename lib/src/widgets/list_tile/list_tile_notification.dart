import 'package:flutter/material.dart';
import 'package:triviazilla/src/model/notification_model.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

import '../../services/helpers.dart';

Widget listTileNotification({
  required void Function(BuildContext) onDelete,
  required void Function() onTap,
  required NotificationModel noti,
}) =>
    GestureDetector(
      onTap: onTap,
      child: Slidable(
        key: const ValueKey(0),
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: onDelete,
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
            noti.title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(DateFormat('dd/MM/yyyy').format(noti.createdAt)),
          trailing: (noti.unread)
              ? const Icon(
                  Icons.circle,
                  size: 10,
                  color: CustomColor.secondary,
                )
              : const SizedBox.shrink(),
        ),
      ),
    );

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:triviazilla/src/features/admin/notification/add.dart';
import 'package:triviazilla/src/features/notification/notification_view.dart';
import 'package:triviazilla/src/services/notification_services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import '../../../model/notification_model.dart';
import '../../../model/user_model.dart';
import '../../../services/helpers.dart';

class AdminPanelNotification extends StatefulWidget {
  const AdminPanelNotification({
    super.key,
    required this.currentUser,
    required this.notiList,
    required this.notifyRefresh,
  });

  final UserModel currentUser;
  final List<NotificationModel> notiList;
  final Function(bool refresh) notifyRefresh;

  @override
  State<AdminPanelNotification> createState() => _AdminPanelNotificationState();
}

class _AdminPanelNotificationState extends State<AdminPanelNotification> {
  List<dynamic> filteredData = [];

  final searchController = TextEditingController();

  int _currentSortColumn = 0;
  bool _isAscending = true;

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _onSearchTextChanged(String text) {
    setState(() {
      filteredData = text.isEmpty
          ? widget.notiList
          : widget.notiList
              .where((noti) =>
                  noti.title.toLowerCase().contains(text.toLowerCase()))
              .toList();
    });
  }

  @override
  void initState() {
    filteredData = widget.notiList;
    super.initState();
  }

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
          "Manage Notifications",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: getColorByBackground(context),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => AddNotification(
                    currentUser: widget.currentUser,
                  ),
                ),
              );
              widget.notifyRefresh(true);
            },
            icon: Icon(
              Icons.notification_add,
              color: getColorByBackground(context),
            ),
          ),
        ],
      ),
      body: ListView(children: [
        const Padding(
          padding: EdgeInsets.only(
            left: 10.0,
            right: 10.0,
            bottom: 10.0,
          ),
          child: Text(
            'View all notification here. Click button at top right to send notification to all or specific users. Search notifications by typing to the textbox. View or Delete notification by clicking on the actions button.',
            textAlign: TextAlign.justify,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: searchController,
            decoration: const InputDecoration(
              hintText: 'Search...',
              border: OutlineInputBorder(),
            ),
            onChanged: _onSearchTextChanged,
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              DataTable(
                sortColumnIndex: _currentSortColumn,
                sortAscending: _isAscending,
                columns: <DataColumn>[
                  DataColumn(
                    label: const Text('Title'),
                    onSort: (columnIndex, _) {
                      setState(() {
                        _currentSortColumn = columnIndex;
                        if (_isAscending == true) {
                          _isAscending = false;
                          widget.notiList.sort((itemA, itemB) =>
                              itemA.title.compareTo(itemB.title));
                        } else {
                          _isAscending = true;
                          widget.notiList.sort((itemA, itemB) =>
                              itemB.title.compareTo(itemA.title));
                        }
                      });
                    },
                  ),
                  DataColumn(
                    label: const Text('Created By'),
                    onSort: (columnIndex, _) {
                      setState(() {
                        _currentSortColumn = columnIndex;
                        if (_isAscending == true) {
                          _isAscending = false;
                          widget.notiList.sort((itemA, itemB) => itemA
                              .author!.email
                              .compareTo(itemB.author!.email));
                        } else {
                          _isAscending = true;
                          widget.notiList.sort((itemA, itemB) => itemB
                              .author!.email
                              .compareTo(itemA.author!.email));
                        }
                      });
                    },
                  ),
                  DataColumn(
                    label: const Text('Created At'),
                    onSort: (columnIndex, _) {
                      setState(() {
                        _currentSortColumn = columnIndex;
                        if (_isAscending == true) {
                          _isAscending = false;
                          widget.notiList.sort((itemA, itemB) =>
                              itemB.createdAt.compareTo(itemA.createdAt));
                        } else {
                          _isAscending = true;
                          widget.notiList.sort((itemA, itemB) =>
                              itemA.createdAt.compareTo(itemB.createdAt));
                        }
                      });
                    },
                  ),
                  const DataColumn(
                    label: Text('To'),
                  ),
                  const DataColumn(
                    label: Text('Actions'),
                  ),
                ],
                rows: List.generate(filteredData.length, (index) {
                  final NotificationModel noti = filteredData[index];
                  return DataRow(
                    cells: [
                      DataCell(SizedBox(
                        width: 350,
                        child: Text(
                          noti.title,
                          overflow: TextOverflow.ellipsis,
                        ),
                      )),
                      DataCell(Text(noti.author!.email)),
                      DataCell(Text(
                          DateFormat('dd/MM/yyyy').format(noti.createdAt))),
                      DataCell(Text("${noti.receiversCount} people")),
                      DataCell(
                        Row(
                          children: [
                            // View
                            IconButton(
                              icon: const Icon(Icons.remove_red_eye),
                              onPressed: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => NotificationView(
                                    notification: noti,
                                  ),
                                ),
                              ),
                            ),
                            // Delete
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => showDialog<String>(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  title: const Text('Delete Notification?'),
                                  content: const Text(
                                      'Are you sure you want to delete this notification? Deleted data may can\'t be retrieved back. Select OK to confirm.'),
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
                                        final result =
                                            await NotificationServices()
                                                .deleteBy(
                                                    groupId: noti.groupId);

                                        if (result == true && context.mounted) {
                                          Navigator.pop(context);
                                          Fluttertoast.showToast(
                                              msg:
                                                  "Deleted all this type of notification");
                                        }

                                        widget.notifyRefresh(true);
                                      },
                                      child: const Text(
                                        'OK',
                                        style: TextStyle(
                                          color: CustomColor.danger,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}

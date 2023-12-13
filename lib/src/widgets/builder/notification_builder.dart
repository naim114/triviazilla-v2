import 'package:flutter/material.dart';
import 'package:triviazilla/src/model/notification_model.dart';
import 'package:triviazilla/src/services/helpers.dart';
import 'package:triviazilla/src/services/notification_services.dart';

import '../../features/admin/notification/index.dart';
import '../../model/user_model.dart';

class NotificationBuilder extends StatefulWidget {
  final UserModel currentUser;
  final String pushTo;

  const NotificationBuilder({
    super.key,
    required this.pushTo,
    required this.currentUser,
  });

  @override
  State<NotificationBuilder> createState() => _NotificationBuilderState();
}

class _NotificationBuilderState extends State<NotificationBuilder> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  List<NotificationModel> dataList = List.empty(growable: true);
  bool loading = true;

  Future<void> _refreshData() async {
    try {
      // Call the asynchronous operation to fetch data
      final List<NotificationModel> fetchedData =
          (await NotificationServices().getAll())
              .whereType<NotificationModel>()
              .toList();

      // Update the state with the fetched data and call setState to rebuild the UI
      setState(() {
        loading = false;
        dataList = fetchedData;
      });

      // Trigger a refresh of the RefreshIndicator widget
      _refreshIndicatorKey.currentState?.show();
    } catch (e) {
      print("Get All:  ${e.toString()}");
    }
  }

  @override
  void initState() {
    _refreshData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Scaffold(body: Center(child: CircularProgressIndicator()))
        : RefreshIndicator(
            key: _refreshIndicatorKey,
            onRefresh: _refreshData,
            child: Builder(
              builder: (context) {
                if (widget.pushTo == 'AdminPanelNotification') {
                  List<NotificationModel> uniqueNotiList = dataList
                      .groupBy((noti) => noti.groupId)
                      .values
                      .map((group) => group.toSet().toList()[0])
                      .toList();

                  return AdminPanelNotification(
                    currentUser: widget.currentUser,
                    notiList: uniqueNotiList,
                    notifyRefresh: (refresh) {
                      _refreshData();
                    },
                  );
                } else {
                  return const Scaffold(
                      body: Center(child: CircularProgressIndicator()));
                }
              },
            ),
          );
  }
}

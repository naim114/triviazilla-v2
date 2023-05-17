import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:triviazilla/src/model/user_model.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../model/notification_model.dart';
import '../../services/helpers.dart';
import '../../services/notification_services.dart';
import '../../widgets/list_tile/list_tile_notification.dart';
import '../../widgets/typography/page_title_icon.dart';
import 'notification_view.dart';

class Notifications extends StatefulWidget {
  const Notifications(
      {super.key, required this.mainContext, required this.user});
  final BuildContext mainContext;
  final UserModel? user;

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  List<NotificationModel> notiList = List.empty(growable: true);
  bool loading = true;

  Future<void> _refreshData() async {
    try {
      // Call the asynchronous operation to fetch data
      final List<NotificationModel> fetchedData =
          (await NotificationServices().getBy('receiver', widget.user!.id))
              .whereType<NotificationModel>()
              .toList();

      // Update the state with the fetched data and call setState to rebuild the UI
      setState(() {
        loading = false;
        notiList = fetchedData;
      });

      // Trigger a refresh of the RefreshIndicator widget
      _refreshIndicatorKey.currentState?.show();
    } catch (e) {
      print("Error Get Notification:  ${e.toString()}");
    }

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  @override
  Widget build(BuildContext context) {
    return widget.user == null || loading
        ? const Scaffold(body: Center(child: CircularProgressIndicator()))
        : RefreshIndicator(
            key: _refreshIndicatorKey,
            onRefresh: _refreshData,
            child: Scaffold(
              body: Builder(
                builder: (context) {
                  return ListView(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(
                          top: 25,
                          left: 25,
                          right: 25,
                          bottom: 10,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            pageTitleIcon(
                              context: context,
                              title: "Notification",
                              icon: const Icon(
                                CupertinoIcons.bell_fill,
                                size: 20,
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Text(
                                'View all your notifications. Slide notification for action.',
                                style: TextStyle(),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: List.generate(notiList.length, (index) {
                          NotificationModel noti = notiList[index];
                          return listTileNotification(
                            onDelete: (context) {
                              showDialog<String>(
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
                                                .delete(notification: noti);

                                        print("Delete: $result");

                                        if (result == true && context.mounted) {
                                          Navigator.pop(context);
                                          Fluttertoast.showToast(
                                              msg: "Notification Deleted");
                                          _refreshData();
                                        }
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
                              );
                            },
                            onTap: () async {
                              final result = await NotificationServices()
                                  .read(notification: noti);

                              print("Read: $result");

                              if (context.mounted) {
                                Navigator.push(
                                  widget.mainContext,
                                  MaterialPageRoute(
                                    builder: (context) => NotificationView(
                                      notification: noti,
                                    ),
                                  ),
                                );
                                _refreshData();
                              }
                            },
                            noti: noti,
                          );
                        }),
                      ),
                    ],
                  );
                },
              ),
            ),
          );
  }
}

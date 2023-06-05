import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:triviazilla/src/widgets/builder/notification_builder.dart';
import 'package:triviazilla/src/widgets/builder/user_builder.dart';

import '../../model/user_model.dart';
import '../../services/helpers.dart';
import '../../widgets/builder/news_builder.dart';
import '../../widgets/builder/trivia_builder.dart';
import '../../widgets/list_tile/list_tile_icon.dart';

class AdminPanel extends StatelessWidget {
  const AdminPanel({super.key, required this.currentUser});
  final UserModel currentUser;

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
          "Admin Panel",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: getColorByBackground(context),
          ),
        ),
      ),
      body: ListView(
        children: [
          listTileIcon(
            context: context,
            icon: CupertinoIcons.group_solid,
            title: "Users",
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => UsersBuilder(
                  currentUser: currentUser,
                  pushTo: 'AdminPanelUsers',
                ),
              ),
            ),
          ),
          listTileIcon(
            context: context,
            icon: Icons.notifications,
            title: "Notification",
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => NotificationBuilder(
                  pushTo: 'AdminPanelNotification',
                  currentUser: currentUser,
                ),
              ),
            ),
          ),
          listTileIcon(
            context: context,
            icon: Icons.newspaper,
            title: "News",
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => NewsBuilder(
                  currentUser: currentUser,
                  pushTo: 'AdminPanelNews',
                ),
              ),
            ),
          ),
          listTileIcon(
            context: context,
            icon: Icons.lightbulb_circle,
            title: "Trivia",
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => TriviaBuilder(
                  currentUser: currentUser,
                  pushTo: 'AdminPanelTrivia',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

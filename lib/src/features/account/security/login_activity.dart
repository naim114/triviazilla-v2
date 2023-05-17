import 'package:flutter/material.dart';
import 'package:triviazilla/src/model/user_model.dart';
import 'package:triviazilla/src/services/user_activity_services.dart';

import '../../../model/user_activity_model.dart';
import '../../../services/helpers.dart';
import '../../../widgets/list_tile/list_tile_activity.dart';

class LoginActivity extends StatelessWidget {
  final UserModel user;

  const LoginActivity({super.key, required this.user});

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
          "Login Activity",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: getColorByBackground(context),
          ),
        ),
      ),
      body: FutureBuilder<List<UserActivityModel?>>(
        future: UserActivityServices()
            .getByFromUser('activityType', 'sign_in', user),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.error != null) {
            print(snapshot.error.toString());
          } else if (!snapshot.hasData) {
            return const Center(child: Text("No data to display"));
          }

          List<UserActivityModel?>? dataList = snapshot.data ?? [];

          return ListView(
            children: List.generate(
              dataList.length,
              (index) {
                UserActivityModel? activity = dataList.elementAt(index);

                return activity == null
                    ? const SizedBox()
                    : listTileActivity(
                        context: context,
                        activity: activity,
                        signInFormat: true,
                      );
              },
            ),
          );
        },
      ),
    );
  }
}

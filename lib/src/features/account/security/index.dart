import 'package:flutter/material.dart';
import 'package:triviazilla/src/features/account/security/login_activity.dart';
import 'package:triviazilla/src/features/account/security/update_email.dart';
import 'package:triviazilla/src/features/account/security/update_password.dart';
import 'package:triviazilla/src/model/user_model.dart';

import '../../../services/helpers.dart';
import '../../../widgets/list_tile/list_tile_icon.dart';

class Security extends StatelessWidget {
  const Security({super.key, required this.user});

  final UserModel user;

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
          "Security",
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
            icon: Icons.email,
            title: "Update Email",
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => UpdateEmail(user: user),
              ),
            ),
          ),
          listTileIcon(
            context: context,
            icon: Icons.key,
            title: "Update Password",
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => UpdatePassword(user: user),
              ),
            ),
          ),
          listTileIcon(
            context: context,
            icon: Icons.pin_drop,
            title: "Login activity",
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => LoginActivity(user: user),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:triviazilla/src/services/helpers.dart';

Widget listTileIconDashboard({
  Color iconColor = CustomColor.primary,
  required String title,
  required String subtitle,
  required IconData icon,
}) =>
    ListTile(
      leading: Icon(
        icon,
        color: iconColor,
        size: 56,
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 24,
        ),
      ),
      subtitle: Text(
        subtitle,
      ),
    );

import 'package:flutter/material.dart';

import '../../services/helpers.dart';

Widget cardIcon({
  Color color = CustomColor.primary,
  Color fontColor = Colors.white,
  Color iconColor = Colors.white,
  required String title,
  required String subtitle,
  required IconData icon,
}) =>
    Card(
      color: color,
      elevation: 4,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              leading: Icon(
                icon,
                color: iconColor,
                size: 56,
              ),
              title: Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: fontColor,
                ),
              ),
              subtitle: Text(
                subtitle,
                style: TextStyle(
                  color: fontColor,
                  fontSize: 16,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
        ],
      ),
    );

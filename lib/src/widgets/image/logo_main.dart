import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/app_settings_model.dart';

Widget logoMain({
  required BuildContext context,
  double height = 100,
}) {
  final appSettings = Provider.of<AppSettingsModel?>(context);

  return appSettings == null
      ? const Center(child: CircularProgressIndicator())
      : CachedNetworkImage(
          imageUrl: appSettings.logoMainURL,
          fit: BoxFit.contain,
          height: height,
          placeholder: (context, url) =>
              const Center(child: CircularProgressIndicator()),
          errorWidget: (context, url, error) => Image.asset(
            'assets/images/default_logo_main.png',
            fit: BoxFit.contain,
            height: height,
          ),
        );
}

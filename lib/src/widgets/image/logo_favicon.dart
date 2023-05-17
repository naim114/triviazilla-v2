import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/app_settings_model.dart';

Widget logoFavicon({
  required BuildContext context,
  double height = 30,
}) {
  final appSettings = Provider.of<AppSettingsModel?>(context);

  return appSettings == null
      ? const Center(child: CircularProgressIndicator())
      : CachedNetworkImage(
          imageUrl: appSettings.logoFaviconURL,
          fit: BoxFit.contain,
          height: height,
          placeholder: (context, url) => Image.asset(
            'assets/images/default_logo_favicon.png',
            fit: BoxFit.contain,
            height: height,
          ),
          errorWidget: (context, url, error) => Image.asset(
            'assets/images/default_logo_favicon.png',
            fit: BoxFit.contain,
            height: height,
          ),
        );
}

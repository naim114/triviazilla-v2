import 'package:flutter/material.dart';
import 'package:triviazilla/src/features/account/about/libraries.dart';
import '../../../model/app_settings_model.dart';
import '../../../services/app_settings_services.dart';
import '../../../services/helpers.dart';
import '../../../widgets/list_tile/list_tile_icon.dart';

class AppAbout extends StatelessWidget {
  const AppAbout({super.key});
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
          "About",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: getColorByBackground(context),
          ),
        ),
      ),
      body: StreamBuilder<AppSettingsModel?>(
        stream: AppSettingsServices().getAppSettingsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting ||
              !snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          } else {
            AppSettingsModel? appSettings = snapshot.data;
            return appSettings == null
                ? const Center(child: CircularProgressIndicator())
                : ListView(
                    children: [
                      listTileIcon(
                        context: context,
                        icon: Icons.open_in_new_outlined,
                        title: "Copyright",
                        onTap: () => goToURL(
                          context: context,
                          url: Uri.parse(appSettings.urlCopyright),
                        ),
                      ),
                      listTileIcon(
                        context: context,
                        icon: Icons.open_in_new_outlined,
                        title: "Privacy Policy",
                        onTap: () => goToURL(
                          context: context,
                          url: Uri.parse(appSettings.urlPrivacyPolicy),
                        ),
                      ),
                      listTileIcon(
                        context: context,
                        icon: Icons.open_in_new_outlined,
                        title: "Terms & Conditions",
                        onTap: () => goToURL(
                          context: context,
                          url: Uri.parse(appSettings.urlTermCondition),
                        ),
                      ),
                      listTileIcon(
                        context: context,
                        icon: Icons.open_in_new_outlined,
                        title: "Libraries",
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const Libraries(),
                          ),
                        ),
                      ),
                    ],
                  );
          }
        },
      ),
    );
  }
}

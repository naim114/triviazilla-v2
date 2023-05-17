import 'dart:io';

import 'package:flutter/material.dart';
import 'package:triviazilla/src/model/app_settings_model.dart';
import 'package:triviazilla/src/services/app_settings_services.dart';
import 'package:triviazilla/src/widgets/editor/single_input_editor.dart';
import 'package:triviazilla/src/widgets/editor/image_uploader.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../services/helpers.dart';

class AppSettings extends StatelessWidget {
  const AppSettings({super.key});

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
          "Application Settings",
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
                      ListTile(
                        title: const Text("Application name"),
                        trailing: Text(appSettings.applicationName),
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => SingleInputEditor(
                              appBarTitle: 'Edit Application Name',
                              textFieldLabel: 'Application Name',
                              onCancel: () => Navigator.pop(context),
                              onConfirm: (value) async {
                                final result = await AppSettingsServices()
                                    .update(
                                        fieldName: 'applicationName',
                                        value: value);

                                if (result == true) {
                                  Fluttertoast.showToast(
                                      msg:
                                          "Application name updated to $value");
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                      ListTile(
                        title: const Text("Copyright URL"),
                        trailing: Text(appSettings.urlCopyright),
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => SingleInputEditor(
                              appBarTitle: 'Edit Copyright URL',
                              textFieldLabel: 'Copyright URL',
                              onCancel: () => Navigator.pop(context),
                              onConfirm: (value) async {
                                final result = await AppSettingsServices()
                                    .update(
                                        fieldName: 'urlCopyright',
                                        value: value);

                                if (result == true) {
                                  Fluttertoast.showToast(
                                      msg: "Copyright URL updated to $value");
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                      ListTile(
                        title: const Text("Privacy Policy URL"),
                        trailing: Text(appSettings.urlPrivacyPolicy),
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => SingleInputEditor(
                              appBarTitle: 'Edit Privacy Policy URL',
                              textFieldLabel: 'Privacy Policy URL',
                              onCancel: () => Navigator.pop(context),
                              onConfirm: (value) async {
                                final result = await AppSettingsServices()
                                    .update(
                                        fieldName: 'urlPrivacyPolicy',
                                        value: value);

                                if (result == true) {
                                  Fluttertoast.showToast(
                                      msg:
                                          "Privacy Policy URL updated to $value");
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                      ListTile(
                        title: const Text("Terms & Condition URL"),
                        trailing: Text(appSettings.urlTermCondition),
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => SingleInputEditor(
                              appBarTitle: 'Edit Terms & Condition URL',
                              textFieldLabel: 'Terms & Condition URL',
                              onCancel: () => Navigator.pop(context),
                              onConfirm: (value) async {
                                final result = await AppSettingsServices()
                                    .update(
                                        fieldName: 'urlTermCondition',
                                        value: value);

                                if (result == true) {
                                  Fluttertoast.showToast(
                                      msg:
                                          "Terms & Condition URL updated to $value");
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                      FutureBuilder<File?>(
                          future: downloadFile(appSettings.logoMainURL),
                          builder: (context, snapshot) {
                            return snapshot.data == null
                                ? const Center(
                                    child: CircularProgressIndicator())
                                : ListTile(
                                    title: const Text("Logo Main"),
                                    trailing: const Text(
                                      "Tap to change logo",
                                      style: TextStyle(
                                          fontStyle: FontStyle.italic),
                                    ),
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => ImageUploader(
                                            appBarTitle: "Upload Logo Main",
                                            fit: null,
                                            imageFile: snapshot.data,
                                            height: 300,
                                            width: 300,
                                            onCancel: () =>
                                                Navigator.pop(context),
                                            onConfirm: (imageFile,
                                                uploaderContext) async {
                                              final result =
                                                  await AppSettingsServices()
                                                      .updateLogoMain(
                                                          imageFile: imageFile,
                                                          appSettings:
                                                              appSettings);

                                              if (context.mounted) {
                                                Navigator.pop(uploaderContext);
                                              }

                                              if (result == true) {
                                                Fluttertoast.showToast(
                                                    msg: "Main Logo Updated!");
                                              }
                                            },
                                          ),
                                        ),
                                      );
                                    },
                                  );
                          }),
                      FutureBuilder<File?>(
                          future: downloadFile(appSettings.logoFaviconURL),
                          builder: (context, snapshot) {
                            return snapshot.data == null
                                ? const Center(
                                    child: CircularProgressIndicator())
                                : ListTile(
                                    title: const Text("Logo Favicon"),
                                    trailing: const Text(
                                      "Tap to change logo favicon",
                                      style: TextStyle(
                                          fontStyle: FontStyle.italic),
                                    ),
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => ImageUploader(
                                            appBarTitle: "Upload Logo Favicon",
                                            fit: null,
                                            imageFile: snapshot.data,
                                            height: 300,
                                            width: 300,
                                            onCancel: () =>
                                                Navigator.pop(context),
                                            onConfirm: (imageFile,
                                                uploaderContext) async {
                                              final result =
                                                  await AppSettingsServices()
                                                      .updateLogoFavicon(
                                                          imageFile: imageFile,
                                                          appSettings:
                                                              appSettings);

                                              if (context.mounted) {
                                                Navigator.pop(uploaderContext);
                                              }

                                              if (result == true) {
                                                Fluttertoast.showToast(
                                                    msg: "Icon Logo Updated!");
                                              }
                                            },
                                          ),
                                        ),
                                      );
                                    },
                                  );
                          }),
                    ],
                  );
          }
        },
      ),
    );
  }
}

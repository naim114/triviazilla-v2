import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:triviazilla/src/model/app_settings_model.dart';
import 'package:triviazilla/src/services/user_activity_services.dart';
import 'package:triviazilla/src/services/user_services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:path/path.dart' as path;

class AppSettingsServices {
  final CollectionReference<Map<String, dynamic>> _collectionRef =
      FirebaseFirestore.instance.collection('Settings');
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  static final DeviceInfoPlugin _deviceInfoPlugin = DeviceInfoPlugin();
  final NetworkInfo _networkInfo = NetworkInfo();

  Stream<AppSettingsModel> getAppSettingsStream() {
    return _collectionRef.doc('application').snapshots().map((snapshot) {
      return AppSettingsModel.fromMap(snapshot.data()!);
    });
  }

  Future update({
    required String fieldName,
    required String value,
  }) async {
    try {
      // update user on db
      _collectionRef.doc('application').update({
        fieldName: value,
      }).then((value) => print("Application Settings Updated"));

      await UserServices()
          .get(_auth.currentUser!.uid)
          .then((currentUser) async {
        print("Get current user");
        if (currentUser != null) {
          await UserActivityServices()
              .add(
                user: currentUser,
                description:
                    "Update application setings. $fieldName to $value.",
                activityType: "application_settings_update",
                networkInfo: _networkInfo,
                deviceInfoPlugin: _deviceInfoPlugin,
              )
              .then((value) => print("Activity Added"));
          return true;
        }
      });

      return true;
    } catch (e) {
      print("Error occured: ${e.toString()}");

      Fluttertoast.showToast(msg: e.toString());

      return false;
    }
  }

  // update logo main
  Future updateLogoMain({
    required File imageFile,
    required AppSettingsModel appSettings,
  }) async {
    try {
      print("Previous file exist");

      // delete previous file
      final Reference ref =
          _firebaseStorage.ref().child(appSettings.logoMainPath);
      await ref.delete();

      print("Previous file deleted");

      // UPLOAD TO FIREBASE STORAGE
      // Get file extension
      String extension = path.extension(imageFile.path);
      print("Extension: $extension");

      // Create the file metadata
      final metadata = SettableMetadata(contentType: "image/jpeg");

      // Create a reference to the file path in Firebase Storage
      final storageRef = _firebaseStorage
          .ref()
          .child('settings/application/logo_main$extension');

      // Upload the file to Firebase Storage
      final uploadTask = storageRef.putFile(imageFile, metadata);

      uploadTask.snapshotEvents.listen((TaskSnapshot taskSnapshot) {
        switch (taskSnapshot.state) {
          case TaskState.running:
            final progress = 100.0 *
                (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
            print("Upload is $progress% complete.");
            break;
          case TaskState.paused:
            print("Upload is paused.");
            break;
          case TaskState.canceled:
            print("Upload was canceled");
            break;
          case TaskState.error:
            // Handle unsuccessful uploads
            print("Upload encounter error");
            throw Exception();
          case TaskState.success:
            // Handle successful uploads on complete
            print("Logo Main uploaded");
            break;
        }
      });

      // Get the download URL of the uploaded file
      final downloadUrl =
          await uploadTask.then((TaskSnapshot taskSnapshot) async {
        final url = await taskSnapshot.ref.getDownloadURL();
        return url;
      });

      print("URL: $downloadUrl");

      // UPDATE ON FIRESTORE
      // update user on db
      _collectionRef.doc('application').update({
        'logoMainPath': 'settings/application/logo_main$extension',
        'logoMainURL': downloadUrl,
        'updated_at': DateTime.now(),
      }).then((value) => print("Logo Main Path Updated on Firestore"));

      await UserServices()
          .get(_auth.currentUser!.uid)
          .then((currentUser) async {
        print("Get current user");
        if (currentUser != null) {
          await UserActivityServices()
              .add(
                user: currentUser,
                description: "Update Logo Main",
                activityType: "user_update_logo_main",
                networkInfo: _networkInfo,
                deviceInfoPlugin: _deviceInfoPlugin,
              )
              .then((value) => print("Activity Added"));
          return true;
        }
      });

      return true;
    } catch (e) {
      print("Error occured: ${e.toString()}");
      Fluttertoast.showToast(msg: e.toString());

      return false;
    }
  }

  // update logo favicon
  Future updateLogoFavicon({
    required File imageFile,
    required AppSettingsModel appSettings,
  }) async {
    try {
      print("Previous file exist");

      // delete previous file
      final Reference ref =
          _firebaseStorage.ref().child(appSettings.logoFaviconPath);
      await ref.delete();

      print("Previous file deleted");

      // UPLOAD TO FIREBASE STORAGE
      // Get file extension
      String extension = path.extension(imageFile.path);
      print("Extension: $extension");

      // Create the file metadata
      final metadata = SettableMetadata(contentType: "image/jpeg");

      // Create a reference to the file path in Firebase Storage
      final storageRef = _firebaseStorage
          .ref()
          .child('settings/application/logo_favicon$extension');

      // Upload the file to Firebase Storage
      final uploadTask = storageRef.putFile(imageFile, metadata);

      uploadTask.snapshotEvents.listen((TaskSnapshot taskSnapshot) {
        switch (taskSnapshot.state) {
          case TaskState.running:
            final progress = 100.0 *
                (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
            print("Upload is $progress% complete.");
            break;
          case TaskState.paused:
            print("Upload is paused.");
            break;
          case TaskState.canceled:
            print("Upload was canceled");
            break;
          case TaskState.error:
            // Handle unsuccessful uploads
            print("Upload encounter error");
            throw Exception();
          case TaskState.success:
            // Handle successful uploads on complete
            print("Logo Favicon uploaded");
            break;
        }
      });

      // Get the download URL of the uploaded file
      final downloadUrl =
          await uploadTask.then((TaskSnapshot taskSnapshot) async {
        final url = await taskSnapshot.ref.getDownloadURL();
        return url;
      });

      print("URL: $downloadUrl");

      // UPDATE ON FIRESTORE
      // update user on db
      _collectionRef.doc('application').update({
        'logoFaviconPath': 'settings/application/logo_favicon$extension',
        'logoFaviconURL': downloadUrl,
        'updated_at': DateTime.now(),
      }).then((value) => print("Logo Favicon Path Updated on Firestore"));

      await UserServices()
          .get(_auth.currentUser!.uid)
          .then((currentUser) async {
        print("Get current user");
        if (currentUser != null) {
          await UserActivityServices()
              .add(
                user: currentUser,
                description: "Update Logo Favicon",
                activityType: "user_update_logo_favicon",
                networkInfo: _networkInfo,
                deviceInfoPlugin: _deviceInfoPlugin,
              )
              .then((value) => print("Activity Added"));
          return true;
        }
      });

      return true;
    } catch (e) {
      print("Error occured: ${e.toString()}");
      Fluttertoast.showToast(msg: e.toString());

      return false;
    }
  }
}

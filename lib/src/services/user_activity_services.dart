import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:triviazilla/src/model/user_activity_model.dart';
import 'package:triviazilla/src/services/user_services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:async';
import 'dart:developer' as developer;
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:network_info_plus/network_info_plus.dart';

import '../model/user_model.dart';

class UserActivityServices {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final CollectionReference _collectionRef =
      FirebaseFirestore.instance.collection('UserActivity');

  // get all
  Future<List<UserActivityModel?>> getAll() async {
    // Get docs from collection reference
    QuerySnapshot querySnapshot =
        await _collectionRef.orderBy('createdAt', descending: true).get();

    if (querySnapshot.docs.isNotEmpty) {
      List<DocumentSnapshot> docList = querySnapshot.docs;

      List<Future<UserActivityModel?>> futures = docList
          .map((doc) => UserActivityServices().fromDocumentSnapshot(doc))
          .toList();

      return await Future.wait(futures);
    } else {
      return List.empty();
    }
  }

  // get
  Future<UserActivityModel?> get(String id) {
    return _collectionRef.doc(id).get().then((DocumentSnapshot doc) {
      if (doc.exists) {
        return UserActivityServices().fromDocumentSnapshot(doc);
      } else {
        print('Document does not exist on the database');
        return null;
      }
    });
  }

  // getBy
  Future<List<UserActivityModel?>> getBy(String fieldName, String value) async {
    List<UserActivityModel?> dataList = List.empty(growable: true);

    QuerySnapshot querySnapshot =
        await _collectionRef.orderBy('createdAt', descending: true).get();

    final List<QueryDocumentSnapshot<Object?>> allDoc =
        querySnapshot.docs.toList();

    for (var doc in allDoc) {
      if (doc.get(fieldName) == value) {
        UserActivityModel? activity =
            await UserActivityServices().fromDocumentSnapshot(doc);

        if (activity != null) {
          dataList.add(activity);
        }
      }
    }

    return dataList;
  }

  // getByFromUser
  Future<List<UserActivityModel?>> getByFromUser(
      String fieldName, String value, UserModel user) async {
    List<UserActivityModel?> dataList = List.empty(growable: true);

    QuerySnapshot querySnapshot =
        await _collectionRef.orderBy('createdAt', descending: true).get();

    final List<QueryDocumentSnapshot<Object?>> allDoc =
        querySnapshot.docs.toList();

    for (var doc in allDoc) {
      if (doc.get('user') == user.id && doc.get(fieldName) == value) {
        UserActivityModel? activity =
            await UserActivityServices().fromDocumentSnapshot(doc);

        if (activity != null) {
          dataList.add(activity);
        }
      }
    }

    return dataList;
  }

  // convert DocumentSnapshot to model object
  Future<UserActivityModel?> fromDocumentSnapshot(
      DocumentSnapshot<Object?> doc) async {
    return UserActivityModel(
      id: doc.get('id'),
      user: await UserServices().get(doc.get('user')),
      description: doc.get('description'),
      activityType: doc.get('activityType'),
      createdAt: doc.get('createdAt').toDate(),
      updatedAt: doc.get('updatedAt').toDate(),
      deletedAt: doc.get('deletedAt') == null
          ? doc.get('deletedAt')
          : doc.get('deletedAt').toDate(),
      wifiName: doc.get('wifiName'),
      wifiBSSID: doc.get('wifiBSSID'),
      wifiIPv4: doc.get('wifiIPv4'),
      wifiIPv6: doc.get('wifiIPv6'),
      wifiGatewayIP: doc.get('wifiGatewayIP'),
      wifiBroadcast: doc.get('wifiBroadcast'),
      wifiSubmask: doc.get('wifiSubmask'),
      deviceInfo: doc.get('deviceInfo'),
    );
  }

  // convert QueryDocumentSnapshot to model object
  Future<UserActivityModel?> fromQueryDocumentSnapshot(
      QueryDocumentSnapshot<Object?> doc) async {
    return UserActivityModel(
      id: doc.get('id'),
      user: await UserServices().get(doc.get('user')),
      description: doc.get('description'),
      activityType: doc.get('activityType'),
      createdAt: doc.get('createdAt').toDate(),
      updatedAt: doc.get('updatedAt').toDate(),
      deletedAt: doc.get('deletedAt') == null
          ? doc.get('deletedAt')
          : doc.get('deletedAt').toDate(),
      wifiName: doc.get('wifiName'),
      wifiBSSID: doc.get('wifiBSSID'),
      wifiIPv4: doc.get('wifiIPv4'),
      wifiIPv6: doc.get('wifiIPv6'),
      wifiGatewayIP: doc.get('wifiGatewayIP'),
      wifiBroadcast: doc.get('wifiBroadcast'),
      wifiSubmask: doc.get('wifiSubmask'),
      deviceInfo: doc.get('deviceInfo'),
    );
  }

  // add activity
  Future add({
    required UserModel user,
    required String description,
    required String activityType,
    required NetworkInfo? networkInfo,
    required DeviceInfoPlugin deviceInfoPlugin,
  }) async {
    Map<String, dynamic> deviceInfo =
        await UserActivityServices().getDeviceInfo(deviceInfoPlugin);

    if (networkInfo == null || (deviceInfo['isPhysicalDevice'] == false)) {
      try {
        dynamic add = await _collectionRef.add({
          'createdAt': DateTime.now(),
          'deletedAt': null,
        }).then((docRef) {
          _db
              .collection("UserActivity")
              .doc(docRef.id)
              .set(UserActivityModel(
                id: docRef.id,
                user: user,
                description: description,
                activityType: activityType,
                createdAt: DateTime.now(),
                updatedAt: DateTime.now(),
                deviceInfo: deviceInfo['deviceInfo'],
              ).toJson())
              .then((value) => print("User Activity Setted"));

          print("User Activity Added");
        });

        print(add.toString());

        return true;
      } catch (e) {
        if (e.toString().contains(
            "MissingPluginException(No implementation found for method wifiName on channel dev.fluttercommunity.plus/network_info)")) {
          print(e.toString());
        } else {
          print(e.toString());
          Fluttertoast.showToast(msg: e.toString());
        }
      }
      return false;
    } else {
      try {
        Map<String, String?> connectionInfo =
            await UserActivityServices().getNetworkInfo(networkInfo);

        dynamic add = await _collectionRef.add({
          'createdAt': DateTime.now(),
          'updatedAt': DateTime.now(),
          'deletedAt': null,
        }).then((docRef) {
          _db
              .collection("UserActivity")
              .doc(docRef.id)
              .set(UserActivityModel(
                id: docRef.id,
                user: user,
                description: description,
                activityType: activityType,
                createdAt: DateTime.now(),
                updatedAt: DateTime.now(),
                wifiName: connectionInfo['wifiName'],
                wifiBSSID: connectionInfo['wifiBSSID'],
                wifiIPv4: connectionInfo['wifiIPv4'],
                wifiIPv6: connectionInfo['wifiIPv6'],
                wifiGatewayIP: connectionInfo['wifiGatewayIP'],
                wifiBroadcast: connectionInfo['wifiBroadcast'],
                wifiSubmask: connectionInfo['wifiSubmask'],
                deviceInfo: deviceInfo['deviceInfo'],
              ).toJson())
              .then((value) => print("User Activity Setted"));

          print("User Activity Added");
        });

        print(add.toString());

        return true;
      } catch (e) {
        print(e.toString());
        Fluttertoast.showToast(msg: e.toString());
      }
      return false;
    }
  }

  // get network info
  Future<Map<String, String?>> getNetworkInfo(NetworkInfo networkInfo) async {
    String? wifiName,
        wifiBSSID,
        wifiIPv4,
        wifiIPv6,
        wifiGatewayIP,
        wifiBroadcast,
        wifiSubmask;

    try {
      if (!kIsWeb && Platform.isIOS) {
        var status = await networkInfo.getLocationServiceAuthorization();
        if (status == LocationAuthorizationStatus.notDetermined) {
          status = await networkInfo.requestLocationServiceAuthorization();
        }
        if (status == LocationAuthorizationStatus.authorizedAlways ||
            status == LocationAuthorizationStatus.authorizedWhenInUse) {
          wifiName = await networkInfo.getWifiName();
        } else {
          wifiName = await networkInfo.getWifiName();
        }
      } else {
        wifiName = await networkInfo.getWifiName();
      }
    } on PlatformException catch (e) {
      developer.log('Failed to get Wifi Name', error: e);
      wifiName = 'Failed to get Wifi Name';
    }

    try {
      if (!kIsWeb && Platform.isIOS) {
        var status = await networkInfo.getLocationServiceAuthorization();
        if (status == LocationAuthorizationStatus.notDetermined) {
          status = await networkInfo.requestLocationServiceAuthorization();
        }
        if (status == LocationAuthorizationStatus.authorizedAlways ||
            status == LocationAuthorizationStatus.authorizedWhenInUse) {
          wifiBSSID = await networkInfo.getWifiBSSID();
        } else {
          wifiBSSID = await networkInfo.getWifiBSSID();
        }
      } else {
        wifiBSSID = await networkInfo.getWifiBSSID();
      }
    } on PlatformException catch (e) {
      developer.log('Failed to get Wifi BSSID', error: e);
      wifiBSSID = 'Failed to get Wifi BSSID';
    }

    try {
      wifiIPv4 = await networkInfo.getWifiIP();
    } on PlatformException catch (e) {
      developer.log('Failed to get Wifi IPv4', error: e);
      wifiIPv4 = 'Failed to get Wifi IPv4';
    }

    try {
      if (!Platform.isWindows) {
        wifiIPv6 = await networkInfo.getWifiIPv6();
      }
    } on PlatformException catch (e) {
      developer.log('Failed to get Wifi IPv6', error: e);
      wifiIPv6 = 'Failed to get Wifi IPv6';
    }

    try {
      if (!Platform.isWindows) {
        wifiSubmask = await networkInfo.getWifiSubmask();
      }
    } on PlatformException catch (e) {
      developer.log('Failed to get Wifi submask address', error: e);
      wifiSubmask = 'Failed to get Wifi submask address';
    }

    try {
      if (!Platform.isWindows) {
        wifiBroadcast = await networkInfo.getWifiBroadcast();
      }
    } on PlatformException catch (e) {
      developer.log('Failed to get Wifi broadcast', error: e);
      wifiBroadcast = 'Failed to get Wifi broadcast';
    }

    try {
      if (!Platform.isWindows) {
        wifiGatewayIP = await networkInfo.getWifiGatewayIP();
      }
    } on PlatformException catch (e) {
      developer.log('Failed to get Wifi gateway address', error: e);
      wifiGatewayIP = 'Failed to get Wifi gateway address';
    }

    return {
      'wifiName': wifiName,
      'wifiBSSID': wifiBSSID,
      'wifiIPv4': wifiIPv4,
      'wifiIPv6': wifiIPv6,
      'wifiGatewayIP': wifiBroadcast,
      'wifiBroadcast': wifiGatewayIP,
      'wifiSubmask': wifiSubmask,
    };
  }

  // get device info
  Future<Map<String, dynamic>> getDeviceInfo(
      DeviceInfoPlugin deviceInfoPlugin) async {
    var deviceData = <String, dynamic>{};

    try {
      if (kIsWeb) {
        deviceData = _readWebBrowserInfo(await deviceInfoPlugin.webBrowserInfo);
      } else {
        if (Platform.isAndroid) {
          deviceData =
              _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
        } else if (Platform.isIOS) {
          deviceData = _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
        } else if (Platform.isLinux) {
          deviceData = _readLinuxDeviceInfo(await deviceInfoPlugin.linuxInfo);
        } else if (Platform.isMacOS) {
          deviceData = _readMacOsDeviceInfo(await deviceInfoPlugin.macOsInfo);
        } else if (Platform.isWindows) {
          deviceData =
              _readWindowsDeviceInfo(await deviceInfoPlugin.windowsInfo);
        }
      }
    } on PlatformException {
      deviceData = <String, dynamic>{
        'Error:': 'Failed to get platform version.'
      };
    }

    return deviceData;
  }

  // read device info
  Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
    return <String, dynamic>{
      'deviceInfo':
          "Android (${build.hardware} / ${build.brand} / ${build.model} / Release Ver. ${build.version.release})",
      'version.securityPatch': build.version.securityPatch,
      'version.sdkInt': build.version.sdkInt,
      'version.release': build.version.release,
      'version.previewSdkInt': build.version.previewSdkInt,
      'version.incremental': build.version.incremental,
      'version.codename': build.version.codename,
      'version.baseOS': build.version.baseOS,
      'board': build.board,
      'bootloader': build.bootloader,
      'brand': build.brand,
      'device': build.device,
      'display': build.display,
      'fingerprint': build.fingerprint,
      'hardware': build.hardware,
      'host': build.host,
      'id': build.id,
      'manufacturer': build.manufacturer,
      'model': build.model,
      'product': build.product,
      'supported32BitAbis': build.supported32BitAbis,
      'supported64BitAbis': build.supported64BitAbis,
      'supportedAbis': build.supportedAbis,
      'tags': build.tags,
      'type': build.type,
      'isPhysicalDevice': build.isPhysicalDevice,
      'systemFeatures': build.systemFeatures,
      'displaySizeInches':
          ((build.displayMetrics.sizeInches * 10).roundToDouble() / 10),
      'displayWidthPixels': build.displayMetrics.widthPx,
      'displayWidthInches': build.displayMetrics.widthInches,
      'displayHeightPixels': build.displayMetrics.heightPx,
      'displayHeightInches': build.displayMetrics.heightInches,
      'displayXDpi': build.displayMetrics.xDpi,
      'displayYDpi': build.displayMetrics.yDpi,
      'serialNumber': build.serialNumber,
    };
  }

  Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
    return <String, dynamic>{
      'deviceInfo': "IOS (${data.name} / ${data.model})",
      'name': data.name,
      'systemName': data.systemName,
      'systemVersion': data.systemVersion,
      'model': data.model,
      'localizedModel': data.localizedModel,
      'identifierForVendor': data.identifierForVendor,
      'isPhysicalDevice': data.isPhysicalDevice,
      'utsname.sysname:': data.utsname.sysname,
      'utsname.nodename:': data.utsname.nodename,
      'utsname.release:': data.utsname.release,
      'utsname.version:': data.utsname.version,
      'utsname.machine:': data.utsname.machine,
    };
  }

  Map<String, dynamic> _readLinuxDeviceInfo(LinuxDeviceInfo data) {
    return <String, dynamic>{
      'deviceInfo': "Linux (${data.name} / ${data.version})",
      'name': data.name,
      'version': data.version,
      'id': data.id,
      'idLike': data.idLike,
      'versionCodename': data.versionCodename,
      'versionId': data.versionId,
      'prettyName': data.prettyName,
      'buildId': data.buildId,
      'variant': data.variant,
      'variantId': data.variantId,
      'machineId': data.machineId,
      'isPhysicalDevice': false,
    };
  }

  Map<String, dynamic> _readWebBrowserInfo(WebBrowserInfo data) {
    return <String, dynamic>{
      'deviceInfo':
          "Browser (${describeEnum(data.browserName)} / ${describeEnum(data.browserName)})",
      'browserName': describeEnum(data.browserName),
      'appCodeName': data.appCodeName,
      'appName': data.appName,
      'appVersion': data.appVersion,
      'deviceMemory': data.deviceMemory,
      'language': data.language,
      'languages': data.languages,
      'platform': data.platform,
      'product': data.product,
      'productSub': data.productSub,
      'userAgent': data.userAgent,
      'vendor': data.vendor,
      'vendorSub': data.vendorSub,
      'hardwareConcurrency': data.hardwareConcurrency,
      'maxTouchPoints': data.maxTouchPoints,
      'isPhysicalDevice': false,
    };
  }

  Map<String, dynamic> _readMacOsDeviceInfo(MacOsDeviceInfo data) {
    return <String, dynamic>{
      'deviceInfo':
          "Mac OS (${data.computerName} / ${data.hostName} / ${data.model})",
      'computerName': data.computerName,
      'hostName': data.hostName,
      'arch': data.arch,
      'model': data.model,
      'kernelVersion': data.kernelVersion,
      'osRelease': data.osRelease,
      'activeCPUs': data.activeCPUs,
      'memorySize': data.memorySize,
      'cpuFrequency': data.cpuFrequency,
      'systemGUID': data.systemGUID,
      'isPhysicalDevice': false,
    };
  }

  Map<String, dynamic> _readWindowsDeviceInfo(WindowsDeviceInfo data) {
    return <String, dynamic>{
      'deviceInfo': "Windows (${data.computerName} / ${data.majorVersion})",
      'deviceId': data.deviceId,
      'numberOfCores': data.numberOfCores,
      'computerName': data.computerName,
      'systemMemoryInMegabytes': data.systemMemoryInMegabytes,
      'userName': data.userName,
      'majorVersion': data.majorVersion,
      'minorVersion': data.minorVersion,
      'buildNumber': data.buildNumber,
      'platformId': data.platformId,
      'csdVersion': data.csdVersion,
      'servicePackMajor': data.servicePackMajor,
      'servicePackMinor': data.servicePackMinor,
      'suitMask': data.suitMask,
      'productType': data.productType,
      'reserved': data.reserved,
      'buildLab': data.buildLab,
      'buildLabEx': data.buildLabEx,
      'digitalProductId': data.digitalProductId,
      'displayVersion': data.displayVersion,
      'editionId': data.editionId,
      'installDate': data.installDate,
      'productId': data.productId,
      'productName': data.productName,
      'registeredOwner': data.registeredOwner,
      'releaseId': data.releaseId,
      'isPhysicalDevice': false,
    };
  }
}

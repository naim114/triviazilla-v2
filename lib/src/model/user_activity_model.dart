import 'package:triviazilla/src/model/user_model.dart';

class UserActivityModel {
  final String id;
  final UserModel? user;
  final String description;
  final String activityType;

  // connection info
  final String? wifiName;
  final String? wifiBSSID;
  final String? wifiIPv4;
  final String? wifiIPv6;
  final String? wifiGatewayIP;
  final String? wifiBroadcast;
  final String? wifiSubmask;

  // device info
  final String? deviceInfo;

  // date
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  UserActivityModel({
    required this.id,
    this.user,
    required this.description,
    required this.activityType,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    this.wifiName,
    this.wifiBSSID,
    this.wifiIPv4,
    this.wifiIPv6,
    this.wifiGatewayIP,
    this.wifiBroadcast,
    this.wifiSubmask,
    this.deviceInfo,
  });

  @override
  String toString() {
    return 'UserModel(id: $id, user: $user, description: $description, activityType: $activityType, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt, wifiName: $wifiName, wifiBSSID: $wifiBSSID, wifiIPv4: $wifiIPv4, wifiIPv6: $wifiIPv6, wifiGatewayIP: $wifiGatewayIP, wifiBroadcast: $wifiBroadcast, wifiSubmask: $wifiSubmask, deviceInfo: $deviceInfo)';
  }

  UserActivityModel.fromJson(Map<String, Object?> json)
      : this(
          id: json['id']! as String,
          user: json['user']! as UserModel,
          description: json['description']! as String,
          activityType: json['activityType']! as String,
          createdAt: json['createdAt']! as DateTime,
          updatedAt: json['updatedAt']! as DateTime,
          deletedAt: json['deletedAt']! as DateTime,
          wifiName: json['wifiName'] as String,
          wifiBSSID: json['wifiBSSID'] as String,
          wifiIPv4: json['wifiIPv4'] as String,
          wifiIPv6: json['wifiIPv6'] as String,
          wifiGatewayIP: json['wifiGatewayIP'] as String,
          wifiBroadcast: json['wifiBroadcast'] as String,
          wifiSubmask: json['wifiSubmask'] as String,
          deviceInfo: json['deviceInfo'] as String,
        );

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'user': user!.id,
      'description': description,
      'activityType': activityType,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'deletedAt': deletedAt,
      'wifiName': wifiName,
      'wifiBSSID': wifiBSSID,
      'wifiIPv4': wifiIPv4,
      'wifiIPv6': wifiIPv6,
      'wifiGatewayIP': wifiGatewayIP,
      'wifiBroadcast': wifiBroadcast,
      'wifiSubmask': wifiSubmask,
      'deviceInfo': deviceInfo,
    };
  }
}

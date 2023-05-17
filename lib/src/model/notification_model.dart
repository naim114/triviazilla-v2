import 'package:triviazilla/src/model/user_model.dart';

class NotificationModel {
  final String id;
  final String groupId;
  final String title;
  final UserModel? author;
  final UserModel? receiver;
  final String jsonContent;
  final int receiversCount;
  final bool unread;

  // date
  final DateTime createdAt;
  final DateTime updatedAt;

  NotificationModel({
    required this.id,
    required this.groupId,
    required this.title,
    required this.author,
    required this.receiver,
    required this.jsonContent,
    required this.createdAt,
    required this.updatedAt,
    required this.receiversCount,
    this.unread = true,
  });

  @override
  String toString() {
    return 'NotificationModel(id: $id, groupId: $groupId, title: $title, author: $author, receiver: $receiver, receiversCount: $receiversCount, jsonContent: $jsonContent, createdAt: $createdAt, updatedAt: $updatedAt, unread: $unread)';
  }

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'groupId': groupId,
      'title': title,
      'author': author!.id,
      'receiver': receiver!.id,
      'receiversCount': receiversCount,
      'jsonContent': jsonContent,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'unread': unread,
    };
  }
}

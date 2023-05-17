import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:triviazilla/src/model/notification_model.dart';
import 'package:triviazilla/src/services/user_activity_services.dart';
import 'package:triviazilla/src/services/user_services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:network_info_plus/network_info_plus.dart';

import '../model/user_model.dart';

class NotificationServices {
  final CollectionReference _collectionRef =
      FirebaseFirestore.instance.collection('Notification');
  final FirebaseAuth _auth = FirebaseAuth.instance;

  static final DeviceInfoPlugin _deviceInfoPlugin = DeviceInfoPlugin();
  final NetworkInfo _networkInfo = NetworkInfo();

  // convert DocumentSnapshot to model object
  Future<NotificationModel?> fromDocumentSnapshot(
      DocumentSnapshot<Object?> doc) async {
    return NotificationModel(
      id: doc.get('id'),
      groupId: doc.get('groupId'),
      unread: doc.get('unread'),
      title: doc.get('title'),
      author: await UserServices().get(doc.get('author')),
      receiver: await UserServices().get(doc.get('receiver')),
      receiversCount: doc.get('receiversCount'),
      jsonContent: doc.get('jsonContent'),
      createdAt: doc.get('createdAt').toDate(),
      updatedAt: doc.get('updatedAt').toDate(),
    );
  }

  // convert QueryDocumentSnapshot to model object
  Future<NotificationModel?> fromQueryDocumentSnapshot(
      QueryDocumentSnapshot<Object?> doc) async {
    return NotificationModel(
      id: doc.get('id'),
      groupId: doc.get('groupId'),
      title: doc.get('title'),
      unread: doc.get('unread'),
      author: await UserServices().get(doc.get('author')),
      receiver: await UserServices().get(doc.get('receiver')),
      receiversCount: doc.get('receiversCount'),
      jsonContent: doc.get('jsonContent'),
      createdAt: doc.get('createdAt').toDate(),
      updatedAt: doc.get('updatedAt').toDate(),
    );
  }

  // get all notification
  Future<List<NotificationModel?>> getAll() async {
    // Get docs from collection reference
    QuerySnapshot querySnapshot = await _collectionRef.get();

    if (querySnapshot.docs.isNotEmpty) {
      List<DocumentSnapshot> docList = querySnapshot.docs;

      List<Future<NotificationModel?>> futures = docList
          .map((doc) => NotificationServices().fromDocumentSnapshot(doc))
          .toList();

      return await Future.wait(futures);
    } else {
      return List.empty();
    }
  }

  // get user by id
  Future<NotificationModel?> get(String id) {
    return _collectionRef.doc(id).get().then((DocumentSnapshot doc) {
      if (doc.exists) {
        return NotificationServices().fromDocumentSnapshot(doc);
      } else {
        print('Document does not exist on the database');
        return null;
      }
    });
  }

  // get user by group id
  Future<List<NotificationModel?>> getByGroupId(String groupId) async {
    List<NotificationModel?> dataList = List.empty(growable: true);

    QuerySnapshot querySnapshot = await _collectionRef.get();

    final List<QueryDocumentSnapshot<Object?>> allDoc =
        querySnapshot.docs.toList();

    for (var doc in allDoc) {
      if (doc.get('groupId') == groupId) {
        NotificationModel? user =
            await NotificationServices().fromDocumentSnapshot(doc);

        if (user != null) {
          dataList.add(user);
        }
      }
    }

    return dataList;
  }

  // get notification by custom field
  Future<List<NotificationModel?>> getBy(String fieldName, String value) async {
    List<NotificationModel?> dataList = List.empty(growable: true);

    QuerySnapshot querySnapshot = await _collectionRef.get();

    final List<QueryDocumentSnapshot<Object?>> allDoc =
        querySnapshot.docs.toList();

    for (var doc in allDoc) {
      if (doc.get(fieldName) == value) {
        NotificationModel? noti =
            await NotificationServices().fromDocumentSnapshot(doc);

        if (noti != null) {
          dataList.add(noti);
        }
      }
    }

    return dataList;
  }

  Future add({
    required String title,
    required String jsonContent,
    required UserModel author,
    required int receiversCount,
    required List<UserModel> receivers,
  }) async {
    try {
      final String groupId =
          DateFormat('yyyyMMddHHmmss').format(DateTime.now());

      print("Group Id: $groupId");

      for (UserModel receiver in receivers) {
        await _collectionRef.add({
          'createdAt': DateTime.now(),
          'updatedAt': DateTime.now(),
          'deletedAt': null,
        }).then((docRef) {
          _collectionRef
              .doc(docRef.id)
              .set(NotificationModel(
                id: docRef.id,
                groupId: groupId,
                title: title,
                author: author,
                receiver: receiver,
                receiversCount: receiversCount,
                jsonContent: jsonContent,
                createdAt: DateTime.now(),
                updatedAt: DateTime.now(),
              ).toJson())
              .then((value) => print("Notification Sent to ${receiver.email}"));
        });
      }

      await UserServices()
          .get(_auth.currentUser!.uid)
          .then((currentUser) async {
        print("Get current user");
        if (currentUser != null) {
          UserModel? user = await UserServices().get(currentUser.id);

          if (user != null) {
            await UserActivityServices()
                .add(
                  user: currentUser,
                  description:
                      "Post Notification (Title: $title) to ${receivers.length} people.",
                  activityType: "notification_add",
                  networkInfo: _networkInfo,
                  deviceInfoPlugin: _deviceInfoPlugin,
                )
                .then((value) => print("Activity Added"));
            return true;
          }
        }
      });

      return true;
    } catch (e) {
      print(e.toString());
      Fluttertoast.showToast(msg: e.toString());
      return false;
    }
  }

  Future read({
    required NotificationModel notification,
  }) async {
    try {
      dynamic result = _collectionRef.doc(notification.id).update({
        'unread': false,
        'updatedAt': DateTime.now(),
      }).then((value) => print("Notification Read"));

      print(result.toString());

      await UserServices()
          .get(_auth.currentUser!.uid)
          .then((currentUser) async {
        print("Get current user");
        if (currentUser != null) {
          await UserActivityServices()
              .add(
                user: currentUser,
                description: "Read Notification (Title: ${notification.title})",
                activityType: "notification_read",
                networkInfo: _networkInfo,
                deviceInfoPlugin: _deviceInfoPlugin,
              )
              .then((value) => print("Activity Added"));
        }
      });

      return true;
    } catch (e) {
      print(e.toString());

      return false;
    }
  }

  Future delete({
    required NotificationModel notification,
  }) async {
    try {
      final delete = _collectionRef.doc(notification.id).delete();

      print("Delete Notification: $delete");

      await UserServices()
          .get(_auth.currentUser!.uid)
          .then((currentUser) async {
        print("Get current user");
        if (currentUser != null) {
          await UserActivityServices()
              .add(
                user: currentUser,
                description:
                    "Delete Notification (Title: ${notification.title})",
                activityType: "notification_delete",
                networkInfo: _networkInfo,
                deviceInfoPlugin: _deviceInfoPlugin,
              )
              .then((value) => print("Activity Added"));
        }
      });

      return true;
    } catch (e) {
      print(e.toString());
      Fluttertoast.showToast(msg: e.toString());

      return false;
    }
  }

  Future deleteBy({
    required String groupId,
  }) async {
    try {
      List<NotificationModel?> notiList =
          await NotificationServices().getByGroupId(groupId);

      for (var notification in notiList) {
        if (notification != null) {
          final delete = _collectionRef.doc(notification.id).delete();

          print("Delete Notification: $delete");
        }
      }

      await UserServices()
          .get(_auth.currentUser!.uid)
          .then((currentUser) async {
        print("Get current user");
        if (currentUser != null) {
          await UserActivityServices()
              .add(
                user: currentUser,
                description:
                    "Delete Notification Group (Title: ${notiList.first!.title})",
                activityType: "notification_delete_all_group",
                networkInfo: _networkInfo,
                deviceInfoPlugin: _deviceInfoPlugin,
              )
              .then((value) => print("Activity Added"));
        }
      });

      return true;
    } catch (e) {
      print(e.toString());
      Fluttertoast.showToast(msg: e.toString());

      return false;
    }
  }
}

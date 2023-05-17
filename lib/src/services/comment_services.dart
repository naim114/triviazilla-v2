import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:triviazilla/src/model/comment_model.dart';
import 'package:triviazilla/src/model/news_model.dart';
import 'package:triviazilla/src/services/news_services.dart';
import 'package:triviazilla/src/services/user_activity_services.dart';
import 'package:triviazilla/src/services/user_services.dart';
import '../model/user_model.dart';

class CommentServices {
  final CollectionReference _collectionRef =
      FirebaseFirestore.instance.collection('Comment');
  final FirebaseAuth _auth = FirebaseAuth.instance;

  static final DeviceInfoPlugin _deviceInfoPlugin = DeviceInfoPlugin();
  final NetworkInfo _networkInfo = NetworkInfo();

  // convert DocumentSnapshot to model object
  Future<CommentModel?> fromDocumentSnapshot(
      DocumentSnapshot<Object?> doc) async {
    return CommentModel(
      id: doc.get('id'),
      news: await NewsService().get(doc.get('news')),
      text: doc.get('text'),
      author: await UserServices().get(doc.get('author')),
      createdAt: doc.get('createdAt').toDate(),
    );
  }

  // convert QueryDocumentSnapshot to model object
  Future<CommentModel?> fromQueryDocumentSnapshot(
      QueryDocumentSnapshot<Object?> doc) async {
    return CommentModel(
      id: doc.get('id'),
      news: await NewsService().get(doc.get('news')),
      text: doc.get('text'),
      author: await UserServices().get(doc.get('author')),
      createdAt: doc.get('createdAt').toDate(),
    );
  }

  // get all
  Future<List<CommentModel?>> getAll() async {
    // Get docs from collection reference
    QuerySnapshot querySnapshot =
        await _collectionRef.orderBy('createdAt', descending: true).get();

    if (querySnapshot.docs.isNotEmpty) {
      List<DocumentSnapshot> docList = querySnapshot.docs;

      List<Future<CommentModel?>> futures = docList
          .map((doc) => CommentServices().fromDocumentSnapshot(doc))
          .toList();

      return await Future.wait(futures);
    } else {
      return List.empty();
    }
  }

  // get by custom field
  Future<List<CommentModel?>> getByNews(NewsModel news) async {
    List<CommentModel?> dataList = List.empty(growable: true);

    List<CommentModel?> all = await CommentServices().getAll();

    for (var comment in all) {
      if (comment != null &&
          comment.news != null &&
          comment.news!.id == news.id) {
        dataList.add(comment);
      }
    }

    return dataList;
  }

  // add
  Future add({
    required String text,
    required UserModel author,
    required NewsModel news,
  }) async {
    try {
      dynamic add = await _collectionRef.add({
        'createdAt': DateTime.now(),
      }).then((docRef) async {
        _collectionRef
            .doc(docRef.id)
            .set(CommentModel(
              id: docRef.id,
              news: news,
              text: text,
              author: author,
              createdAt: DateTime.now(),
            ).toJson())
            .then((value) => print("Comment Added"));
      });

      print("Add Comment: $add");

      // activity log
      await UserActivityServices()
          .add(
            user: author,
            description:
                "Post comment (Text: $text) on News (ID: ${news.id}, Title: ${news.title})",
            activityType: "comment_add",
            networkInfo: _networkInfo,
            deviceInfoPlugin: _deviceInfoPlugin,
          )
          .then((value) => print("Activity Added"));

      return true;
    } catch (e) {
      print(e.toString());
      Fluttertoast.showToast(msg: e.toString());
      return false;
    }
  }

  Future delete({
    required CommentModel comment,
  }) async {
    try {
      final delete = _collectionRef.doc(comment.id).delete();

      print("Delete News: $delete");

      // activity log
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
                      "Delete comment (Text: ${comment.text}) on News (ID: ${comment.news!.id}, Title: ${comment.news!.title})",
                  activityType: "comment_delete",
                  networkInfo: _networkInfo,
                  deviceInfoPlugin: _deviceInfoPlugin,
                )
                .then((value) => print("Activity Added"));
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
}

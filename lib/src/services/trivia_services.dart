import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:search_page/search_page.dart';
import 'package:triviazilla/src/model/record_trivia_model.dart';
import 'package:triviazilla/src/model/trivia_model.dart';
import 'package:triviazilla/src/model/user_model.dart';
import 'package:triviazilla/src/services/record_service.dart';
import 'package:triviazilla/src/services/user_activity_services.dart';
import 'package:triviazilla/src/services/user_services.dart';
import 'package:path/path.dart' as path;

import '../model/question_model.dart';
import '../widgets/card/trivia_card_simple.dart';
import 'helpers.dart';

class TriviaServices {
  final CollectionReference _collectionRef =
      FirebaseFirestore.instance.collection('Trivia');
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  static final DeviceInfoPlugin _deviceInfoPlugin = DeviceInfoPlugin();
  final NetworkInfo _networkInfo = NetworkInfo();

  // convert DocumentSnapshot to model object
  Future<TriviaModel> fromDocumentSnapshot(
      DocumentSnapshot<Object?> doc) async {
    List<QuestionModel> questions =
        (doc.get('questions') as List<dynamic>).map((json) {
      return QuestionModel.fromJson(json as Map<String, dynamic>);
    }).toList();

    return TriviaModel(
      id: doc.get('id'),
      title: doc.get('title'),
      description: doc.get('description'),
      author: await UserServices().get(doc.get('author')),
      imgPath: doc.get('imgPath'),
      imgURL: doc.get('imgURL'),
      category: doc.get('category'),
      tag: doc.get('tag') == null ? null : jsonDecode(doc.get('tag')),
      likedBy:
          doc.get('likedBy') == null ? null : jsonDecode(doc.get('likedBy')),
      bookmarkBy: doc.get('bookmarkBy') == null
          ? null
          : jsonDecode(doc.get('bookmarkBy')),
      createdAt: doc.get('createdAt').toDate(),
      updatedAt: doc.get('updatedAt').toDate(),
      questions: questions,
    );
  }

  // convert QueryDocumentSnapshot to model object
  Future<TriviaModel> fromQueryDocumentSnapshot(
      QueryDocumentSnapshot<Object?> doc) async {
    List<QuestionModel> questions =
        (doc.get('questions') as List<dynamic>).map((json) {
      return QuestionModel.fromJson(json as Map<String, dynamic>);
    }).toList();

    return TriviaModel(
      id: doc.get('id'),
      title: doc.get('title'),
      description: doc.get('description'),
      author: await UserServices().get(doc.get('author')),
      imgPath: doc.get('imgPath'),
      imgURL: doc.get('imgURL'),
      category: doc.get('category'),
      tag: doc.get('tag') == null ? null : jsonDecode(doc.get('tag')),
      likedBy:
          doc.get('likedBy') == null ? null : jsonDecode(doc.get('likedBy')),
      bookmarkBy: doc.get('bookmarkBy') == null
          ? null
          : jsonDecode(doc.get('bookmarkBy')),
      createdAt: doc.get('createdAt').toDate(),
      updatedAt: doc.get('updatedAt').toDate(),
      questions: questions,
    );
  }

  // convert map to model object
  Future<TriviaModel> fromMap(Map<String, dynamic> map) async {
    List<QuestionModel> questions =
        (map['questions'] as List<dynamic>).map((json) {
      return QuestionModel.fromJson(json as Map<String, dynamic>);
    }).toList();

    return TriviaModel(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      author: await UserServices().get(map['author']),
      imgPath: map['imgPath'],
      imgURL: map['imgURL'],
      category: map['category'],
      tag: map['tag'] == null ? null : jsonDecode(map['tag']),
      likedBy: map['likedBy'] == null ? null : jsonDecode(map['likedBy']),
      bookmarkBy:
          map['bookmarkBy'] == null ? null : jsonDecode(map['bookmarkBy']),
      createdAt: map['createdAt'].toDate(),
      updatedAt: map['updatedAt'].toDate(),
      questions: questions,
    );
  }

  // get all
  Future<List<TriviaModel>> getAll() async {
    // Get docs from collection reference
    QuerySnapshot querySnapshot =
        await _collectionRef.orderBy('createdAt', descending: true).get();

    if (querySnapshot.docs.isNotEmpty) {
      List<DocumentSnapshot> docList = querySnapshot.docs;

      List<Future<TriviaModel>> futures = docList
          .map((doc) => TriviaServices().fromDocumentSnapshot(doc))
          .whereType<Future<TriviaModel>>()
          .toList();

      return await Future.wait(futures);
    } else {
      return List.empty();
    }
  }

  // get by id
  Future<TriviaModel> get(String id) {
    return _collectionRef.doc(id).get().then((DocumentSnapshot doc) {
      return TriviaServices().fromDocumentSnapshot(doc);
    });
  }

  // get by user
  Future<List<TriviaModel>> getByUser(UserModel user) async {
    List<TriviaModel> allTrivia = await TriviaServices().getAll();
    List<TriviaModel> result = List.empty(growable: true);

    for (var trivia in allTrivia) {
      if (user.id == trivia.author!.id) {
        result.add(trivia);
      }
    }

    return result;
  }

  // add
  Future<bool> add({
    required String title,
    required String description,
    required UserModel author,
    required List<Map<String, dynamic>> question,
    String? category,
    List<String>? tags,
    File? coverImageFile,
  }) async {
    try {
      dynamic add = await _collectionRef.add({
        'createdAt': DateTime.now(),
        'updatedAt': DateTime.now(),
      }).then((docRef) async {
        if (coverImageFile != null) {
          // with cover image
          print("Cover included");

          // UPLOAD TO FIREBASE STORAGE
          // Get file extension
          String extension = path.extension(coverImageFile.path);
          print("Extension: $extension");

          // Create the file metadata
          final metadata = SettableMetadata(contentType: "image/jpeg");

          // Create a reference to the file path in Firebase Storage
          final storageRef = _firebaseStorage
              .ref()
              .child('trivia/cover/${docRef.id}$extension');

          // Upload the file to Firebase Storage
          final uploadTask = storageRef.putFile(coverImageFile, metadata);

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
                print("News thumbnail uploaded");
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
          _collectionRef.doc(docRef.id).set({
            'id': docRef.id,
            'title': title,
            'description': description,
            'author': author.id,
            'imgPath': 'trivia/cover/${docRef.id}$extension',
            'imgURL': downloadUrl,
            'category': category,
            'tag': tags == null ? null : jsonEncode(tags),
            'likedBy': null,
            'bookmarkBy': null,
            'createdAt': DateTime.now(),
            'updatedAt': DateTime.now(),
            'questions': question,
          }).then((value) => print("Trivia Added"));
        } else {
          _collectionRef.doc(docRef.id).set({
            'id': docRef.id,
            'title': title,
            'description': description,
            'author': author.id,
            'category': category,
            'imgPath': null,
            'imgURL': null,
            'tag': tags == null ? null : jsonEncode(tags),
            'likedBy': null,
            'bookmarkBy': null,
            'createdAt': DateTime.now(),
            'updatedAt': DateTime.now(),
            'questions': question,
          }).then((value) => print("Trivia Added"));
        }
      });

      print("Add Trivia: $add");

      // Activity Log
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
                  description: "Add Trivia (Title: $title)",
                  activityType: "trivia_add",
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

  // edit
  Future<bool> edit({
    required TriviaModel trivia,
    required String title,
    required String description,
    required UserModel author,
    required List<Map<String, dynamic>> question,
    String? category,
    List<String>? tags,
    File? coverImageFile,
  }) async {
    try {
      if (coverImageFile != null) {
        // w cover
        // if previous cover exist
        if (trivia.imgPath != null && trivia.imgURL != null) {
          print("Previous file exist");

          // delete previous file
          final Reference ref = _firebaseStorage.ref().child(trivia.imgPath!);
          await ref.delete();

          print("Previous file deleted");
        }

        // UPLOAD TO FIREBASE STORAGE
        // Get file extension
        String extension = path.extension(coverImageFile.path);
        print("Extension: $extension");

        // Create the file metadata
        final metadata = SettableMetadata(contentType: "image/jpeg");

        // Create a reference to the file path in Firebase Storage
        final storageRef =
            _firebaseStorage.ref().child('trivia/cover/${trivia.id}$extension');

        // Upload the file to Firebase Storage
        final uploadTask = storageRef.putFile(coverImageFile, metadata);

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
              print("News thumbnail uploaded");
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
        dynamic result = _collectionRef.doc(trivia.id).update({
          'title': title,
          'description': description,
          'imgPath': 'trivia/cover/${trivia.id}$extension',
          'imgURL': downloadUrl,
          'category': category,
          'tag': tags == null ? null : jsonEncode(tags),
          'updatedAt': DateTime.now(),
          'questions': question,
        }).then((value) => print("Trivia Edited"));

        print("Update Trivia: $result");
      } else {
        // w/o cover

        // UPDATE ON FIRESTORE
        dynamic result = _collectionRef.doc(trivia.id).update({
          'title': title,
          'description': description,
          'category': category,
          'imgPath': null,
          'imgURL': null,
          'tag': tags == null ? null : jsonEncode(tags),
          'updatedAt': DateTime.now(),
          'questions': question,
        }).then((value) => print("Trivia Edited"));

        print("Update Trivia: $result");
      }

      // Activity Log
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
                  description: "Edit Trivia (Title: $title)",
                  activityType: "trivia_edit",
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

  // delete
  Future delete({
    required TriviaModel trivia,
  }) async {
    try {
      // if previous cover exist
      if (trivia.imgPath != null && trivia.imgURL != null) {
        print("Previous file exist");

        // delete previous file
        final Reference ref = _firebaseStorage.ref().child(trivia.imgPath!);
        await ref.delete();

        print("Previous file deleted");
      }

      // delete trivia record
      List<RecordTriviaModel> records =
          await RecordServices().getByTrivia(trivia);

      for (var i = 0; i < records.length; i++) {
        final deleteRecord = await RecordServices().delete(
          record: records[i],
          log: false,
        );

        print("Delete Record $i: $deleteRecord");
      }

      final delete = _collectionRef.doc(trivia.id).delete();

      print("Delete News: $delete");

      // Activity Log
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
                  description: "Delete Trivia (Title: ${trivia.title})",
                  activityType: "trivia_delete",
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

  Future<int> getPlayCount({
    required TriviaModel trivia,
  }) async {
    List<RecordTriviaModel> records =
        await RecordServices().getByTrivia(trivia);

    return records.length;
  }

  // like
  Future<bool> like({
    required TriviaModel trivia,
    required UserModel user,
  }) async {
    try {
      final List<dynamic> likedBy =
          trivia.likedBy ?? List.empty(growable: true);

      likedBy.add(user.id);

      dynamic result = _collectionRef.doc(trivia.id).update({
        'likedBy': jsonEncode(likedBy),
      }).then((value) => print("Trivia Liked"));

      print("Like News: $result");

      await UserServices()
          .get(_auth.currentUser!.uid)
          .then((currentUser) async {
        print("Get current user");
        if (currentUser != null) {
          await UserActivityServices()
              .add(
                user: currentUser,
                description: "Like Trivia (Title: ${trivia.title})",
                activityType: "trivia_like",
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

  // unlike
  Future<bool> unlike({
    required TriviaModel trivia,
    required UserModel user,
  }) async {
    try {
      final List<dynamic> likedBy =
          trivia.likedBy ?? List.empty(growable: true);

      if (likedBy.contains(user.id)) {
        likedBy.remove(user.id);

        dynamic result = _collectionRef.doc(trivia.id).update({
          'likedBy': jsonEncode(likedBy),
        }).then((value) => print("Trivia Unliked"));

        print("Unlike Trivia: $result");
      }

      await UserServices()
          .get(_auth.currentUser!.uid)
          .then((currentUser) async {
        print("Get current user");
        if (currentUser != null) {
          await UserActivityServices()
              .add(
                user: currentUser,
                description: "Unlike Trivia (Title: ${trivia.title})",
                activityType: "trivia_unlike",
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

  // is user like this trivia
  bool isLike({
    required TriviaModel trivia,
    required UserModel user,
  }) {
    if (trivia.likedBy != null) {
      for (String id in trivia.likedBy!) {
        if (id == user.id) {
          return true;
        }
      }
    }

    return false;
  }

  // bookmark
  Future<bool> bookmark({
    required TriviaModel trivia,
    required UserModel user,
  }) async {
    try {
      final List<dynamic> bookmarkBy =
          trivia.likedBy ?? List.empty(growable: true);

      bookmarkBy.add(user.id);

      dynamic result = _collectionRef.doc(trivia.id).update({
        'bookmarkBy': jsonEncode(bookmarkBy),
      }).then((value) => print("Trivia Bookmarked"));

      print("Bookmarked News: $result");

      await UserServices()
          .get(_auth.currentUser!.uid)
          .then((currentUser) async {
        print("Get current user");
        if (currentUser != null) {
          await UserActivityServices()
              .add(
                user: currentUser,
                description: "Bookmarked Trivia (Title: ${trivia.title})",
                activityType: "trivia_bookmark",
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

  // unbookmark
  Future<bool> unbookmark({
    required TriviaModel trivia,
    required UserModel user,
  }) async {
    try {
      final List<dynamic> bookmarkBy =
          trivia.bookmarkBy ?? List.empty(growable: true);

      if (bookmarkBy.contains(user.id)) {
        bookmarkBy.remove(user.id);

        dynamic result = _collectionRef.doc(trivia.id).update({
          'bookmarkBy': jsonEncode(bookmarkBy),
        }).then((value) => print("Trivia Unbookmarked"));

        print("Unbookmark Trivia: $result");
      }

      await UserServices()
          .get(_auth.currentUser!.uid)
          .then((currentUser) async {
        print("Get current user");
        if (currentUser != null) {
          await UserActivityServices()
              .add(
                user: currentUser,
                description: "Unbookmark Trivia (Title: ${trivia.title})",
                activityType: "trivia_unbookmark",
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

  // is user bookmarked this trivia
  bool isBookmark({
    required TriviaModel trivia,
    required UserModel user,
  }) {
    if (trivia.bookmarkBy != null) {
      for (String id in trivia.bookmarkBy!) {
        if (id == user.id) {
          return true;
        }
      }
    }

    return false;
  }

  Future search({
    required BuildContext context,
    required UserModel user,
    String? query,
  }) async {
    List<TriviaModel?> trivias = await TriviaServices().getAll();

    if (context.mounted) {
      return showSearch(
        context: context,
        query: query,
        delegate: SearchPage(
          barTheme: Theme.of(context).brightness == Brightness.dark
              ? ThemeData(
                  inputDecorationTheme: const InputDecorationTheme(
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                  textTheme: Theme.of(context).textTheme.apply(
                        bodyColor: Colors.white,
                        displayColor: Colors.white,
                      ),
                  scaffoldBackgroundColor: CustomColor.neutral1,
                  appBarTheme: const AppBarTheme(
                    backgroundColor: CustomColor.neutral1,
                  ),
                )
              : ThemeData(
                  inputDecorationTheme: const InputDecorationTheme(
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                  textTheme: Theme.of(context).textTheme.apply(
                        bodyColor: CustomColor.neutral1,
                        displayColor: CustomColor.neutral1,
                      ),
                  scaffoldBackgroundColor: Colors.white,
                  appBarTheme: const AppBarTheme(
                    backgroundColor: Colors.white,
                    iconTheme: IconThemeData(color: CupertinoColors.systemGrey),
                  ),
                ),
          onQueryUpdate: print,
          items: trivias,
          searchLabel: 'Search trivia',
          suggestion: const Center(
            child: Text('Search trivia by title, categories, author, ...'),
          ),
          failure: const Center(
            child: Text('No trivia found :('),
          ),
          filter: (trivia) {
            return [
              trivia!.title,
              DateFormat('dd/MM/yyyy').format(trivia.createdAt),
              trivia.author!.name,
              trivia.author!.email,
              trivia.category,
              trivia.description,
              ...?trivia.tag == null
                  ? null
                  : trivia.tag!.map((e) => e.toString()).toList(),
            ];
          },
          builder: (trivia) => Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 5,
            ),
            child: triviaCardSimple(
              context: context,
              trivia: trivia,
              user: user,
            ),
          ),
        ),
      );
    }
  }
}

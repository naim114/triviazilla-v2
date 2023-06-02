import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:triviazilla/src/services/trivia_services.dart';
import 'package:triviazilla/src/services/user_activity_services.dart';
import 'package:triviazilla/src/services/user_services.dart';

import '../model/question_model.dart';
import '../model/record_trivia_model.dart';
import '../model/trivia_model.dart';
import '../model/user_model.dart';

class RecordServices {
  final CollectionReference _collectionRef =
      FirebaseFirestore.instance.collection('Record');
  final FirebaseAuth _auth = FirebaseAuth.instance;

  static final DeviceInfoPlugin _deviceInfoPlugin = DeviceInfoPlugin();
  final NetworkInfo _networkInfo = NetworkInfo();

  // convert DocumentSnapshot to model object
  Future<RecordTriviaModel> fromDocumentSnapshot(
      DocumentSnapshot<Object?> doc) async {
    List<QuestionModel> questions =
        (doc.get('questions') as List<dynamic>).map((json) {
      return QuestionModel.fromJson(json as Map<String, dynamic>);
    }).toList();

    return RecordTriviaModel(
      id: doc.get('id'),
      createdAt: doc.get('createdAt').toDate(),
      updatedAt: doc.get('updatedAt').toDate(),
      questions: questions,
      answerBy: await UserServices().get(doc.get('answerBy')),
      trivia: await TriviaServices().get(doc.get('trivia')),
      correctCount: doc.get('correctCount'),
      score: doc.get('score'),
    );
  }

  // convert QueryDocumentSnapshot to model object
  Future<RecordTriviaModel> fromQueryDocumentSnapshot(
      QueryDocumentSnapshot<Object?> doc) async {
    List<QuestionModel> questions =
        (doc.get('questions') as List<dynamic>).map((json) {
      return QuestionModel.fromJson(json as Map<String, dynamic>);
    }).toList();

    return RecordTriviaModel(
      id: doc.get('id'),
      createdAt: doc.get('createdAt').toDate(),
      updatedAt: doc.get('updatedAt').toDate(),
      questions: questions,
      answerBy: await UserServices().get(doc.get('answerBy')),
      trivia: await TriviaServices().get(doc.get('trivia')),
      correctCount: doc.get('correctCount'),
      score: doc.get('score'),
    );
  }

  // convert map to model object
  Future<RecordTriviaModel> fromMap(Map<String, dynamic> map) async {
    List<QuestionModel> questions =
        (map['questions'] as List<dynamic>).map((json) {
      return QuestionModel.fromJson(json as Map<String, dynamic>);
    }).toList();

    return RecordTriviaModel(
      id: map['id'],
      createdAt: map['createdAt'].toDate(),
      updatedAt: map['updatedAt'].toDate(),
      questions: questions,
      answerBy: await UserServices().get(map['answerBy']),
      trivia: await TriviaServices().get(map['trivia']),
      correctCount: map['correctCount'],
      score: map['score'],
    );
  }

  // get all
  Future<List<RecordTriviaModel>> getAll() async {
    // Get docs from collection reference
    QuerySnapshot querySnapshot =
        await _collectionRef.orderBy('createdAt', descending: true).get();

    if (querySnapshot.docs.isNotEmpty) {
      List<DocumentSnapshot> docList = querySnapshot.docs;

      List<Future<RecordTriviaModel>> futures = docList
          .map((doc) => RecordServices().fromDocumentSnapshot(doc))
          .whereType<Future<RecordTriviaModel>>()
          .toList();

      return await Future.wait(futures);
    } else {
      return List.empty();
    }
  }

  // get by id
  Future<RecordTriviaModel> get(String id) {
    return _collectionRef.doc(id).get().then((DocumentSnapshot doc) {
      return RecordServices().fromDocumentSnapshot(doc);
    });
  }

  // get by user
  Future<List<RecordTriviaModel>> getByUser(UserModel user) async {
    List<RecordTriviaModel> allTrivia = await RecordServices().getAll();
    List<RecordTriviaModel> result = List.empty(growable: true);

    for (var trivia in allTrivia) {
      if (user.id == trivia.answerBy!.id) {
        result.add(trivia);
      }
    }

    if (result.isNotEmpty) {
      result.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    }

    return result;
  }

  // get by trivia
  Future<List<RecordTriviaModel>> getByTrivia(TriviaModel trivia) async {
    List<RecordTriviaModel> records = await RecordServices().getAll();
    List<RecordTriviaModel> result = List.empty(growable: true);

    for (var record in records) {
      if (record.trivia.id == trivia.id) {
        result.add(record);
      }
    }

    result.sort((a, b) => b.score.compareTo(a.score));

    return result;
  }

  Future<RecordTriviaModel?> add({
    required TriviaModel trivia,
    required UserModel user,
    required List<QuestionModel> questions,
    required int score,
    required int correctCount,
  }) async {
    try {
      DocumentReference result = await _collectionRef.add({
        'createdAt': DateTime.now(),
        'updatedAt': DateTime.now(),
      }).then((docRef) {
        _collectionRef.doc(docRef.id).set({
          'id': docRef.id,
          'trivia': trivia.id,
          'answerBy': user.id,
          'questions': questions.map((q) => q.toMap()).toList(),
          'score': score,
          'correctCount': correctCount,
          'createdAt': DateTime.now(),
          'updatedAt': DateTime.now(),
        }).then((value) => print("Record Added"));

        return docRef;
      });

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
                  description:
                      "Add Record (Trivia: ${trivia.title}, User: ${user.email})",
                  activityType: "record_add",
                  networkInfo: _networkInfo,
                  deviceInfoPlugin: _deviceInfoPlugin,
                )
                .then((value) => print("Activity Added"));
          }
        }
      });

      RecordTriviaModel newTrivia =
          await result.get().then((DocumentSnapshot doc) {
        return RecordServices().fromDocumentSnapshot(doc);
      });

      print("Added Record: $newTrivia");

      return newTrivia;
    } catch (e) {
      print(e.toString());

      return null;
    }
  }

  Future<bool> delete({
    required RecordTriviaModel record,
    bool log = true,
  }) async {
    try {
      final delete = _collectionRef.doc(record.id).delete();

      print("Delete Record: $delete");

      if (log) {
        await UserServices()
            .get(_auth.currentUser!.uid)
            .then((currentUser) async {
          print("Get current user");
          if (currentUser != null) {
            await UserActivityServices()
                .add(
                  user: currentUser,
                  description:
                      "Delete Record (Trivia: ${record.trivia.title}, User: ${record.answerBy!.email})",
                  activityType: "record_delete",
                  networkInfo: _networkInfo,
                  deviceInfoPlugin: _deviceInfoPlugin,
                )
                .then((value) => print("Activity Added"));
          }
        });
      }

      return true;
    } catch (e) {
      print(e.toString());
      Fluttertoast.showToast(msg: e.toString());

      return false;
    }
  }
}

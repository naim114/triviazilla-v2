import 'package:flutter/material.dart';
import 'package:triviazilla/src/model/user_model.dart';
import 'package:triviazilla/src/services/record_service.dart';
import '../../model/record_trivia_model.dart';
import '../../services/helpers.dart';
import '../../widgets/card/record_card.dart';

class RecordList extends StatelessWidget {
  final UserModel user;
  const RecordList({super.key, required this.user});

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
          "Record",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: getColorByBackground(context),
          ),
        ),
      ),
      body: FutureBuilder<List<RecordTriviaModel>>(
          future: RecordServices().getByUser(user),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            return ListView(
              children: List.generate(
                snapshot.data!.length,
                (index) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: recordCard(
                    context: context,
                    record: snapshot.data![index],
                    user: user,
                  ),
                ),
              ),
            );
          }),
    );
  }
}

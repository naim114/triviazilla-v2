import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../services/helpers.dart';

class RecordAnswer extends StatelessWidget {
  const RecordAnswer({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text("Answer Review"),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          ExpansionTile(
            leading: const Icon(
              CupertinoIcons.clear_circled,
              color: CustomColor.danger,
            ),
            title: Text(
              "What is the man that killed rhino?",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: CustomColor.neutral1,
              ),
            ),
            children: [
              ListTile(
                title: Text(
                  "Your Answer :",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                subtitle: Text("2"),
              ),
              ListTile(
                title: Text(
                  "Correct Answer :",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("2"),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import '../../model/notification_model.dart';
import '../../services/helpers.dart';

class NotificationView extends StatelessWidget {
  final NotificationModel notification;

  const NotificationView({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    final controller = QuillController(
      document: Document.fromJson(jsonDecode(notification.jsonContent)),
      selection: const TextSelection.collapsed(offset: 0),
    );

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
          notification.title,
          style: TextStyle(
            color: getColorByBackground(context),
          ),
        ),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 5,
            ),
            child: QuillEditor(
              controller: controller,
              readOnly: true,
              autoFocus: false,
              expands: false,
              focusNode: FocusNode(),
              padding: const EdgeInsets.all(0),
              scrollController: ScrollController(),
              scrollable: true,
              showCursor: false,
            ),
          ),
        ],
      ),
    );
  }
}

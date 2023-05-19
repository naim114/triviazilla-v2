import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:triviazilla/src/widgets/builder/user_builder.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:fluttertoast/fluttertoast.dart';

import '../../model/user_model.dart';
import '../../services/helpers.dart';

class NotificationEditor extends StatefulWidget {
  final QuillController controller;
  final BuildContext context;
  final Function(
    QuillController quillController,
    List<UserModel> receiverList,
    String title,
  ) onPost;
  final UserModel currentUser;
  final String? title;
  final String appBarTitle;

  const NotificationEditor({
    super.key,
    required this.controller,
    required this.context,
    this.appBarTitle = "Add/Edit Notification",
    required this.onPost,
    required this.currentUser,
    this.title,
  });

  @override
  State<NotificationEditor> createState() => _NotificationEditorState();
}

class _NotificationEditorState extends State<NotificationEditor> {
  List<UserModel> receiverList = List.empty();
  final TextEditingController titleController = TextEditingController();

  bool _submitted = false;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _submitted = false;
    titleController.text = widget.title ?? "";
  }

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }

  bool post() {
    setState(() => _submitted = true);
    Navigator.pop(context);

    if (titleController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Title can't be empty");

      return false;
    } else if (receiverList.isEmpty) {
      Fluttertoast.showToast(msg: "Notification can't be send to no one");

      return false;
    }

    setState(() => _loading = true);

    Future.delayed(const Duration(seconds: 1), () {
      widget.onPost(widget.controller, receiverList, titleController.text);
      // Navigator.pop(context);
    });

    return true;
  }

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
          widget.appBarTitle,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: getColorByBackground(context),
          ),
        ),
        actions: _loading
            ? []
            : [
                TextButton(
                  onPressed: () => showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: const Text('Post Notification?'),
                      content: const Text(
                          'Post notifications? Select OK to confirm.'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(
                              color: CupertinoColors.systemGrey,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: post,
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  ),
                  child: const Text("Post"),
                )
              ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                ListTile(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => UsersBuilder(
                        currentUser: widget.currentUser,
                        pushTo: 'UsersPicker',
                        onPost: (userList, pickerContext) {
                          setState(() => receiverList = userList);
                          Navigator.pop(pickerContext);
                        },
                      ),
                    ),
                  ),
                  title: Text.rich(
                    TextSpan(
                      style: const TextStyle(fontSize: 16),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Send to: ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: getColorByBackground(context),
                          ),
                        ),
                        TextSpan(
                            text: receiverList.isEmpty
                                ? "None"
                                : "${receiverList.length} people(s)"),
                      ],
                    ),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios_rounded),
                  shape: const Border(
                    bottom: BorderSide(
                      width: 1,
                      color: CupertinoColors.systemGrey,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(15),
                    labelText: 'Title',
                    hintText: 'Enter title for this notification',
                    focusColor: CupertinoColors.systemGrey,
                    hoverColor: CupertinoColors.systemGrey,
                    errorText: _submitted == true & titleController.text.isEmpty
                        ? "Title can't be empty"
                        : null,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: QuillToolbar.basic(controller: widget.controller),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 5,
                  ),
                  child: QuillEditor.basic(
                    controller: widget.controller,
                    readOnly: false,
                  ),
                ),
              ],
            ),
    );
  }
}

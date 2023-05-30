import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:textfield_tags/textfield_tags.dart';
import 'package:triviazilla/src/widgets/editor/question_editor.dart';

import '../../services/helpers.dart';
import 'image_uploader.dart';
import '../modal/error_alert.dart';

class TriviaEditor extends StatefulWidget {
  const TriviaEditor({
    super.key,
    required this.onPost,
    this.thumbnailFile,
    this.title,
    this.description,
    this.category,
    this.tags,
  });

  final File? thumbnailFile;
  final String? title;
  final String? description;
  final String? category;
  final List<String>? tags;

  final Function(
    File? coverImageFile,
    String title,
    String description,
    String? category,
    List<String>? tags,
    List<Map<String, dynamic>> question,
  ) onPost;

  @override
  State<TriviaEditor> createState() => _TriviaEditorState();
}

class _TriviaEditorState extends State<TriviaEditor> {
  File? _coverImageFile;

  bool _loading = false;

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextfieldTagsController _tagController = TextfieldTagsController();

  List<Map<String, dynamic>> question = List.empty(growable: true);

  bool post() {
    Navigator.pop(context);

    if (titleController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Title can't be empty");

      return false;
    } else if (descController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Description can't be empty");

      return false;
    } else if (question.isEmpty) {
      Fluttertoast.showToast(msg: "Questions can't be empty");

      return false;
    }

    setState(() => _loading = true);

    Future.delayed(const Duration(seconds: 1), () {
      widget.onPost(
        _coverImageFile,
        titleController.text,
        descController.text,
        categoryController.text,
        _tagController.getTags,
        question,
      );
    });

    Navigator.pop(context);

    return true;
  }

  @override
  void dispose() {
    titleController.dispose();
    descController.dispose();
    categoryController.dispose();
    _tagController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    titleController.text = widget.title ?? "";
    descController.text = widget.description ?? "";
    _coverImageFile = widget.thumbnailFile;
    titleController.text = widget.title ?? "";
    descController.text = widget.description ?? "";
    categoryController.text = widget.category ?? "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            "Cancel",
            style: TextStyle(color: CupertinoColors.systemGrey),
          ),
        ),
        leadingWidth: 70,
        centerTitle: true,
        title: Text(
          "Create Trivia",
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
                    builder: (BuildContext context) {
                      if (titleController.text.isEmpty) {
                        return errorAlert(
                          "Title can't be empty",
                          "Title can't be empty. Please enter title under Trivia Details",
                          context,
                        );
                      } else if (descController.text.isEmpty) {
                        return errorAlert(
                          "Description can't be empty",
                          "Description can't be empty. Please enter description under Trivia Details",
                          context,
                        );
                      } else if (question.isEmpty) {
                        return errorAlert(
                          "Questions can't be empty",
                          "Questions can't be empty. Click on 'Add Question' to add questions.",
                          context,
                        );
                      } else {
                        return AlertDialog(
                          title: const Text('Create Trivia?'),
                          content: Text(
                              "${categoryController.text.isEmpty ? "No category included. Include it at Category/Tag section needed. " : ''}${_tagController.getTags == null ? "No tags included. Include it at Category/Tag section needed. " : ""}Select OK to confirm."),
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
                        );
                      }
                    },
                  ),
                  child: const Text("Create"),
                )
              ],
      ),
      floatingActionButton: ElevatedButton(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => QuestionEditor(
              onConfirm: (Map<String, dynamic> newQuestion) {
                print('question: $newQuestion');

                setState(() {
                  question.add(newQuestion);
                });
              },
            ),
          ),
        ),
        child: const Text(
          "Add Question",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: ListView(
          children: [
            // Cover Image
            GestureDetector(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ImageUploader(
                    appBarTitle: "Upload Cover Image",
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: MediaQuery.of(context).size.height * 0.25,
                    onCancel: () => Navigator.of(context).pop(),
                    onConfirm: (imageFile, uploaderContext) {
                      setState(() {
                        _coverImageFile = imageFile;
                      });
                    },
                  ),
                ),
              ),
              child: _coverImageFile != null
                  ? Image.file(
                      _coverImageFile!,
                      height: MediaQuery.of(context).size.height * 0.3,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      height: MediaQuery.of(context).size.height * 0.3,
                      decoration: const BoxDecoration(
                        color: CupertinoColors.inactiveGray,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.camera_alt,
                            color: Colors.grey[800],
                          ),
                          Text(
                            "Tap to add cover image",
                            style: TextStyle(color: Colors.grey[800]),
                          ),
                        ],
                      ),
                    ),
            ),
            const SizedBox(height: 10),
            // Details
            ExpansionTile(
              initiallyExpanded: true,
              title: const Text("Trivia Details",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(15),
                    labelText: 'Title',
                    hintText: 'Enter title for this question',
                    focusColor: CupertinoColors.systemGrey,
                    hoverColor: CupertinoColors.systemGrey,
                  ),
                ),
                TextField(
                  controller: descController,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(15),
                    labelText: 'Description',
                    hintText: 'Enter description for this question',
                    focusColor: CupertinoColors.systemGrey,
                    hoverColor: CupertinoColors.systemGrey,
                  ),
                ),
              ],
            ),
            // Category/Tag
            ExpansionTile(
              initiallyExpanded: true,
              title: const Text(
                "Category/Tag",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              children: [
                TextField(
                  controller: categoryController,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(15),
                    labelText: 'Category',
                    hintText:
                        'Enter category for this question (e.g. politics, sports)',
                    focusColor: CupertinoColors.systemGrey,
                    hoverColor: CupertinoColors.systemGrey,
                  ),
                ),
                TextFieldTags(
                  textfieldTagsController: _tagController,
                  textSeparators: const [' ', ','],
                  initialTags: widget.tags,
                  letterCase: LetterCase.normal,
                  validator: (String tag) {
                    if (_tagController.getTags!.contains(tag)) {
                      return '$tag already entered';
                    }
                    return null;
                  },
                  inputfieldBuilder:
                      (context, tec, fn, error, onChanged, onSubmitted) {
                    return ((context, sc, tags, onTagDelete) {
                      return Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: TextField(
                          controller: tec,
                          focusNode: fn,
                          decoration: InputDecoration(
                            helperText: 'Type tags and enter',
                            hintText: _tagController.hasTags ? '' : "Enter tag",
                            errorText: error,
                            prefixIcon: tags.isNotEmpty
                                ? Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: ConstrainedBox(
                                      constraints: BoxConstraints(
                                        minWidth: 0,
                                        maxWidth:
                                            MediaQuery.of(context).size.width *
                                                0.7,
                                      ),
                                      child: SingleChildScrollView(
                                        controller: sc,
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                            children: tags.map((String tag) {
                                          return Container(
                                            decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(20.0),
                                              ),
                                              color: CustomColor.primary,
                                            ),
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 5.0),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10.0,
                                                vertical: 5.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                InkWell(
                                                  child: Text(
                                                    "#$tag",
                                                    style: const TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                                const SizedBox(width: 4.0),
                                                InkWell(
                                                  child: const Icon(
                                                    Icons.cancel,
                                                    size: 14.0,
                                                    color: Color.fromARGB(
                                                        255, 233, 233, 233),
                                                  ),
                                                  onTap: () {
                                                    onTagDelete(tag);
                                                  },
                                                )
                                              ],
                                            ),
                                          );
                                        }).toList()),
                                      ),
                                    ),
                                  )
                                : null,
                          ),
                          onChanged: onChanged,
                          onSubmitted: onSubmitted,
                        ),
                      );
                    });
                  },
                ),
              ],
            ),
            // Question
            const Padding(
              padding: EdgeInsets.only(left: 15, right: 15, top: 20),
              child: Text(
                'Questions',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            Column(
              children: List.generate(
                question.length,
                (index) => Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
                  child: Card(
                    elevation: 4,
                    child: ListTile(
                      minLeadingWidth: 80,
                      title: Text(
                        question[index]['text'],
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        "${question[index]['answers'].length} Answer(s)",
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => QuestionEditor(
                                  question: question[index],
                                  onConfirm:
                                      (Map<String, dynamic> newQuestion) {
                                    print('question: $newQuestion');

                                    setState(() {
                                      question[index] = newQuestion;
                                    });
                                  },
                                ),
                              ),
                            ),
                            icon: const Icon(Icons.edit),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                question.removeAt(index);
                              });
                            },
                            icon: const Icon(Icons.delete),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

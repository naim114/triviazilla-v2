import 'package:flutter/material.dart';
import 'package:triviazilla/src/widgets/appbar/appbar_confirm_cancel.dart';

class SingleInputEditor extends StatefulWidget {
  final String appBarTitle;
  final String textFieldLabel;
  final void Function() onCancel;
  final void Function(String value) onConfirm;
  final String description;

  const SingleInputEditor({
    super.key,
    required this.appBarTitle,
    required this.textFieldLabel,
    required this.onCancel,
    required this.onConfirm,
    this.description = "Tap on top right to confirm changes.",
  });

  @override
  State<SingleInputEditor> createState() => _SingleInputEditorState();
}

class _SingleInputEditorState extends State<SingleInputEditor> {
  final TextEditingController inputController = TextEditingController();
  bool _submitted = false;

  @override
  void dispose() {
    inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarConfirmCancel(
        context: context,
        onCancel: widget.onCancel,
        onConfirm: () {
          setState(() => _submitted = true);
          if (inputController.text.isNotEmpty) {
            widget.onConfirm(inputController.text);
            Navigator.pop(context);
          }
        },
        title: widget.appBarTitle,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0),
        child: ListView(
          children: [
            Text(widget.description),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: TextField(
                controller: inputController,
                decoration: InputDecoration(
                  labelText: widget.textFieldLabel,
                  errorText: _submitted == true && inputController.text.isEmpty
                      ? "Field can't be empty"
                      : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

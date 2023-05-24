import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:theme_mode_handler/theme_picker_dialog.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class CustomColor {
  static const primary = Color(0xFFF28500);
  static const secondary = Color(0xFFFF9D26);
  static const neutral1 = Color(0xFF1C1243);
  static const neutral2 = Color(0xFFA29EB6);
  static const neutral3 = Color(0xFFEFF1F3);
  static const danger = Color(0xFFFE4A49);
  static const success = Color(0xFF47C272);
  static const darkerBg = Color(0xFF242526);
  static const darkBg = Color(0xFF3A3B3C);
}

bool isDarkTheme(context) {
  return Theme.of(context).brightness == Brightness.dark ? true : false;
}

Color getColorByBackground(context) {
  return isDarkTheme(context) ? Colors.white : CustomColor.neutral1;
}

void selectThemeMode(BuildContext context) async {
  final newThemeMode = await showThemePickerDialog(context: context);
  debugPrint(newThemeMode.toString());
}

Future<void> goToURL({
  required Uri url,
  required BuildContext context,
}) async {
  if (!await launchUrl(url)) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Could not launch $url'),
    ));
    throw Exception('Could not launch $url');
  }
}

bool validateEmail(TextEditingController emailController) {
  const pattern = r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
      r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
      r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
      r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
      r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
      r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
      r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])';
  final regex = RegExp(pattern);

  return regex.hasMatch(emailController.text);
}

bool validatePassword(TextEditingController passwordController) {
  RegExp regex =
      RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');

  return regex.hasMatch(passwordController.text);
}

extension ListExtension<E> on List<E> {
  Map<K, List<E>> groupBy<K>(K Function(E) keyFunction) {
    return Map.fromEntries(
      groupByMapEntries(keyFunction),
    );
  }

  Iterable<MapEntry<K, List<E>>> groupByMapEntries<K>(
      K Function(E) keyFunction) sync* {
    final groups = <K, List<E>>{};
    for (final element in this) {
      final key = keyFunction(element);
      if (!groups.containsKey(key)) {
        groups[key] = <E>[];
      }
      groups[key]!.add(element);
    }
    yield* groups.entries;
  }
}

Future<File?> downloadFile(String url) async {
  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    final tempDir = await getTemporaryDirectory();
    final filePath = '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}';
    final file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return file;
  }
  return null;
}

String timeAgo(DateTime dateTime) {
  final now = DateTime.now();
  final difference = now.difference(dateTime);

  if (difference.inDays > 365) {
    final years = (difference.inDays / 365).floor();
    return '$years year${years > 1 ? "s" : ""} ago';
  } else if (difference.inDays > 30) {
    final months = (difference.inDays / 30).floor();
    return '$months month${months > 1 ? "s" : ""} ago';
  } else if (difference.inDays > 0) {
    final days = difference.inDays;
    return '$days day${days > 1 ? "s" : ""} ago';
  } else if (difference.inHours > 0) {
    final hours = difference.inHours;
    return '$hours hour${hours > 1 ? "s" : ""} ago';
  } else if (difference.inMinutes > 0) {
    final minutes = difference.inMinutes;
    return '$minutes minute${minutes > 1 ? "s" : ""} ago';
  } else {
    return 'Just now';
  }
}

class customMsg {
  static const List<String> trueGIF = [
    'https://media.giphy.com/media/ummeQH0c3jdm2o3Olp/giphy.gif',
    'https://media.giphy.com/media/3ofT5PzgI9FSn8vPaw/giphy.gif',
    'https://media.giphy.com/media/x88e1awUi05by/giphy.gif',
    'https://media.giphy.com/media/UAXK9VGoJTbdcPgmcJ/giphy.gif',
    'https://media.giphy.com/media/xHMIDAy1qkzNS/giphy.gif',
    'https://media.giphy.com/media/j6ZReIODqJXh5sPLVq/giphy.gif',
    'https://media.giphy.com/media/FlrJh58XGTaAo/giphy.gif',
    'https://media.giphy.com/media/Z6f7vzq3iP6Mw/giphy.gif',
    'https://media.giphy.com/media/ci0uDcGQtBh0k/giphy.gif',
    'https://media.giphy.com/media/5fMlYckytHM4g/giphy.gif',
    'https://media.giphy.com/media/8Odq0zzKM596g/giphy.gif',
  ];
  static const List<String> trueWord = [
    'Correct!',
    'Nice one!',
    'Nooooooice',
    'Awesome!!',
    'That\'s correct!',
    'Good Job 👍',
    'OH YEAHHH',
    'Hands up 🙌 '
  ];

  static const List<String> falseGIF = [
    'https://media.giphy.com/media/l4pLY0zySvluEvr0c/giphy.gif',
    'https://media.giphy.com/media/ceeN6U57leAhi/giphy.gif',
    'https://media.giphy.com/media/l4FGuhL4U2WyjdkaY/giphy.gif',
    'https://media.giphy.com/media/9GJ34PEVM5JnCkfPPf/giphy.gif',
    'https://media.giphy.com/media/KCfpWuNnTcLbc3aLvZ/giphy.gif',
    'https://media.giphy.com/media/fH6jipGcugrKrx45az/giphy.gif',
    'https://media.giphy.com/media/Vlw1Dzb1pU0qN3hzOu/giphy.gif',
    'https://media.giphy.com/media/Vlw1Dzb1pU0qN3hzOu/giphy.gif',
    'https://media.giphy.com/media/oQjsQmQKlFDcQ/giphy.gif',
    'https://media.giphy.com/media/l1IY5J4Cfw8JLi40M/giphy.gif',
  ];
  static const List<String> falseWord = [
    'Incorrect',
    'Wrong!!',
    'Try Again!',
    '👎 👎 👎 👎 👎',
    'That\'s just wrong... try again',
    'Come on, you better than this!',
    'Try again... and again... and again...',
    'False!!'
  ];

  static const List<String> lateGIF = [
    'https://media.giphy.com/media/n72ltcBMBhqiQ/giphy.gif',
    'https://media.giphy.com/media/y0DI4w3LGA12w/giphy.gif',
    'https://media.giphy.com/media/psaxnXPg4sfOilpRkN/giphy.gif',
    'https://media.giphy.com/media/3oz8xEgf0wV8UGL5y8/giphy.gif',
    'https://media.giphy.com/media/O4PNDmchDN81Nr4Xib/giphy.gif',
    'https://media.giphy.com/media/fUwOs80ja3sTPpjndh/giphy.gif',
  ];

  static const List<String> lateWord = [
    'Too Late...',
    'Times Up!',
    'Ran out of time!',
    'Times Up!! Missed the boat!!',
    "Well, aren't you just a master of timing!",
    "Better late than never, but in your case, definitely not better.",
    "Too Slow. Try again.",
  ];
}

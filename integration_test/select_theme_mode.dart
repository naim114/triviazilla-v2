import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:triviazilla/main.dart';
import 'package:firebase_core/firebase_core.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;

  group('theme handler integration test', () {
    testWidgets(
      'verify toggle button can be clicked and theme change accordingly',
      (tester) async {
        // Make sure to add `key: Key(option.label)` on SimpleDialogOption() inside \AppData\Local\Pub\Cache\hosted\pub.dev\theme_mode_handler-3.0.0\lib\theme_picker_dialog.dart
        // Initialize Firebase (check if it's not already initialized)
        if (Firebase.apps.isEmpty) {
          await Firebase.initializeApp();
        }

        await tester.pumpWidget(const MyApp());

        await tester.pumpAndSettle(const Duration(seconds: 5));

        // Finding theme button
        debugPrint('finding theme_button button');

        final Finder themeButtonFinder = find.byKey(const Key('theme_button'));

        expect(themeButtonFinder, findsOneWidget);

        // Get the current theme
        final ThemeData originalTheme =
            Theme.of(tester.element(themeButtonFinder));

        debugPrint(
            "initial theme: ${originalTheme.brightness == Brightness.dark ? "Dark Mode" : "Light Mode"}");

        // Tap on the theme button
        await tester.tap(themeButtonFinder);
        await tester.pumpAndSettle();

        // Verify that the dialog is displayed
        expect(find.byType(SimpleDialog), findsOneWidget);

        // Find and tap on the desired theme option in the dialog
        final Finder themeOptionFinder = find.text('Dark');
        expect(themeOptionFinder, findsOneWidget);
        await tester.tap(themeOptionFinder);
        await tester.pumpAndSettle();

        // Verify that the theme has changed
        final ThemeData newTheme = Theme.of(tester.element(themeButtonFinder));

        debugPrint(
            "current theme: ${newTheme.brightness == Brightness.dark ? "Dark Mode" : "Light Mode"}");

        // You can customize this expectation based on your theme logic
        expect(newTheme, isNot(originalTheme));
      },
    );
  });
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:triviazilla/src/model/app_settings_model.dart';
import 'package:triviazilla/src/model/user_model.dart';
import 'package:triviazilla/src/services/app_settings_services.dart';
import 'package:triviazilla/src/services/auth_services.dart';
import 'package:triviazilla/src/services/helpers.dart';
import 'package:triviazilla/wrapper.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:theme_mode_handler/theme_mode_handler.dart';
import 'src/theme/theme_mode_manager.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  MaterialColor primaryColorShades = const MaterialColor(
    0xFF643FDB,
    <int, Color>{
      50: Color.fromRGBO(100, 63, 219, .1),
      100: Color.fromRGBO(100, 63, 219, .2),
      200: Color.fromRGBO(100, 63, 219, .3),
      300: Color.fromRGBO(100, 63, 219, .4),
      400: Color.fromRGBO(100, 63, 219, .5),
      500: Color.fromRGBO(100, 63, 219, .6),
      600: Color.fromRGBO(100, 63, 219, .7),
      700: Color.fromRGBO(100, 63, 219, .8),
      800: Color.fromRGBO(100, 63, 219, .9),
      900: Color.fromRGBO(100, 63, 219, 1),
    },
  );

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<UserModel?>.value(
          initialData: null,
          lazy: true,
          value: AuthService().onAuthStateChanged,
          catchError: (context, error) {
            print('An error occurred: $error');
            return null;
          },
          updateShouldNotify: (previous, current) {
            print('Previous Stream UserModel: ${previous.toString()}');
            print('Current Stream UserModel: ${current.toString()}');
            return true;
          },
        ),
        StreamProvider<AppSettingsModel?>.value(
          initialData: null,
          lazy: true,
          value: AppSettingsServices().getAppSettingsStream(),
          catchError: (context, error) {
            print('An error occurred: $error');
            return null;
          },
          updateShouldNotify: (previous, current) {
            print('Previous Stream AppSettingsModel: ${previous.toString()}');
            print('Current Stream AppSettingsModel: ${current.toString()}');
            return true;
          },
        ),
      ],
      child: ThemeModeHandler(
        manager: MyThemeModeManager(),
        placeholderWidget: MaterialApp(
          home: Scaffold(
            body: Center(
              child: LoadingAnimationWidget.flickr(
                leftDotColor: CustomColor.primary,
                rightDotColor: CustomColor.secondary,
                size: 50,
              ),
            ),
          ),
        ),
        builder: (ThemeMode themeMode) => MaterialApp(
          themeMode: themeMode,
          // DARK THEME
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            fontFamily: GoogleFonts.poppins().fontFamily,
            primarySwatch: primaryColorShades,
            primaryColor: CustomColor.primary,
            textTheme: Theme.of(context).textTheme.apply(
                  bodyColor: Colors.white,
                  displayColor: Colors.white,
                ),
            scaffoldBackgroundColor: CustomColor.neutral1,
            appBarTheme: const AppBarTheme(
                backgroundColor: CustomColor.neutral1,
                // titleTextStyle: TextStyle(fontWeight: FontWeight.bold),
                iconTheme: IconThemeData(
                  color: CustomColor.neutral2,
                )),
            inputDecorationTheme: const InputDecorationTheme(
              fillColor: CustomColor.neutral1,
              filled: true,
            ),
          ),
          // LIGHT THEME
          theme: ThemeData(
            brightness: Brightness.light,
            fontFamily: GoogleFonts.poppins().fontFamily,
            primarySwatch: primaryColorShades,
            primaryColor: CustomColor.primary,
            textTheme: Theme.of(context).textTheme.apply(
                  bodyColor: CustomColor.neutral1,
                  displayColor: CustomColor.neutral1,
                ),
            scaffoldBackgroundColor: Colors.white,
            appBarTheme: const AppBarTheme(
                backgroundColor: Colors.white,
                // titleTextStyle: TextStyle(fontWeight: FontWeight.bold),
                iconTheme: IconThemeData(
                  color: CustomColor.neutral2,
                )),
            iconTheme: const IconThemeData(
              color: CustomColor.neutral1,
            ),
            iconButtonTheme: const IconButtonThemeData(
              style: ButtonStyle(
                  iconColor: MaterialStatePropertyAll(CustomColor.neutral1)),
            ),
          ),
          home: const Wrapper(),
        ),
      ),
    );
  }
}

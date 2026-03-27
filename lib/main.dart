import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:men2r_app/l10n/app_localizations.dart';


import 'models/services/hive_service.dart';

import 'controllers/theme_controller.dart';
import 'controllers/locale_controller.dart';
import 'controllers/role_controller.dart';
import 'controllers/course_controller.dart';
import 'controllers/tutor_controller.dart';


import 'views/splash_screen.dart';
import 'views/settings_screen.dart';
import 'views/courses/course_list_page.dart';
import 'views/courses/course_details_screen.dart';
import 'views/courses/course_form_screen.dart';
import 'views/tutors/tutor_list_page.dart';
import 'views/tutors/tutor_details_screen.dart';
import 'views/tutors/tutor_form_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  
  final hiveService = HiveService();
  await hiveService.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeController()),
        ChangeNotifierProvider(create: (_) => LocaleController()),
        ChangeNotifierProvider(create: (_) => RoleController()),
        ChangeNotifierProvider(create: (_) => CourseController()),
        ChangeNotifierProvider(create: (_) => TutorController()),
        Provider.value(value: hiveService), 
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeCtrl = context.watch<ThemeController>();
    final localeCtrl = context.watch<LocaleController>();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: themeCtrl.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      darkTheme: ThemeData.dark(useMaterial3: true),
      locale: localeCtrl.locale,
      
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''),
        Locale('ru', ''),
      ],

      
      initialRoute: '/', 
      routes: {
        '/': (context) => const SplashScreen(),
        '/courses': (context) => const CourseListPage(),
        '/tutors': (context) => const TutorListPage(),
        '/settings': (context) => const SettingsScreen(),
        '/course_add': (context) => const CourseFormScreen(),
        '/tutor_add': (context) => const TutorFormScreen(),
      },

      
      onGenerateRoute: (settings) {
        if (settings.name == '/course_details') {
          return MaterialPageRoute(builder: (_) => const CourseDetailsScreen(), settings: settings);
        }
        if (settings.name == '/course_form') {
          return MaterialPageRoute(builder: (_) => const CourseFormScreen(), settings: settings);
        }
        if (settings.name == '/tutor_details') {
          return MaterialPageRoute(builder: (_) => const TutorDetailsScreen(), settings: settings);
        }
        if (settings.name == '/tutor_form') {
          return MaterialPageRoute(builder: (_) => const TutorFormScreen(), settings: settings);
        }
        return null;
      },
    );
  }
}
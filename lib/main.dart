import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quran_progress_tracker_app/attendence.dart';
import 'app_page_1.dart';
import 'control_panel_attendance.dart';
import 'control_panel_daily_report.dart';
import 'control_panel_education_level.dart';
import 'control_panel_for_add&delete_classroom.dart';
import 'control_panel_monthly_topper.dart';
import 'daily_report.dart';
import 'firebase_options.dart';

Future<void> main() async {
 

  WidgetsFlutterBinding.ensureInitialized();
   await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp,DeviceOrientation.portraitDown]);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Quran Hifz Tracker',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: SplashScreen());
  }
}

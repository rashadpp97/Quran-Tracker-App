import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quran_progress_tracker_app/view/Admin_panel/admins_panel_page.dart';
import 'package:quran_progress_tracker_app/view/Students_panel/attendence.dart';
import 'package:quran_progress_tracker_app/view/Admin_panel/register/sign_up_page.dart';
import 'view/Admin_panel/control_panel_std_name_list.dart';
import 'view/Students_panel/login_screen_page.dart';
import 'view/second_page.dart';
import 'view/Students_panel/monthly_topper.dart';
import 'view/first_screen.dart';
import 'view/Teachers_panel/control_panel_attendance.dart';
import 'view/Teachers_panel/control_panel_daily_report.dart';
import 'view/Admin_panel/control_panel_education_level.dart';
import 'view/Admin_panel/control_panel_daily_report.dart';
import 'view/Admin_panel/control_panel_monthly_topper.dart';
import 'view/Students_panel/daily_report.dart';
import 'firebase_options.dart';
import 'view/Students_panel/std_performanse_page.dart';
import 'view/std_name_list_page.dart';


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

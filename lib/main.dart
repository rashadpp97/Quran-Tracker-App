import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:quran_progress_tracker_app/view/Admin_panel/edit_monthly_topper.dart';
import 'package:quran_progress_tracker_app/view/Students_panel/login_page.dart';
import 'package:quran_progress_tracker_app/view/Students_panel/monthly_topper.dart';
import 'package:quran_progress_tracker_app/view_model/admin_provider.dart';
import 'view/Admin_panel/edit_daily_report.dart';
import 'view/Admin_panel/edit_std_name_list.dart';
import 'view/Admin_panel/register/add_student.dart';
import 'view/Admin_panel/register/sign_up_page.dart';
import 'view/Students_data_screen.dart/std_data_screen.dart';
import 'view/Students_panel/profile_form.dart';
import 'view/Splash_screen/first_splash_screen.dart';
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
    return MultiProvider(
     providers: [
        ChangeNotifierProvider(create: (_) => AdminProvider()),
      ],
      child: MaterialApp(
        
          debugShowCheckedModeBanner: false,
          title: 'Quran Hifz Tracker App',
          theme: ThemeData(primarySwatch: Colors.blue),
          home: SplashScreen()),
    );
  }
}

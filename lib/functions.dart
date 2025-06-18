import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quran_progress_tracker_app/view/Admin_panel/admins_panel_page.dart';
import 'package:quran_progress_tracker_app/view_model/credential_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'view/Students_panel/profile_form.dart';
import 'view/Students_panel/std_performanse_page.dart';
import 'view/Teachers_panel/teachers_panel_page.dart';

class Functions {
  static Future<void> loginUser(String email, String password, BuildContext context,
      UserRole user) async {
    print(email);
    print(password);

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter email and password")),
      );
      return;
    }

    try {
      context.read<UserRoleProvider>().getUserRole(email);
      // Sign in using Firebase Auth
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      context.read<CredentialProvider>().setEmail(email);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);


      if (context.read<UserRoleProvider>().userRole == user) {
        
         if (user == UserRole.teacher) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const TeachersPanelPage()),
          );
        }
        else if (user == UserRole.admin) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const AdminsPanelPage()),
          );
        }
      }
      else if (user == UserRole.student) {
        // await context.read<UserRoleProvider>().isNewStudent(email) ?
        //   Navigator.pushReplacement(
        //     context,
        //     MaterialPageRoute(builder: (_) => const ProfileFormPage()),
        //   ):Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(
        //     builder: (_) => StudentsPerformancePage(
        //       name: _usernameController.text.trim(),
        //       className: _selectedClass,
        //       image: '',
        //     ),
        //   ),
        // );
        //TODO: Check if the student is new or old
        }
      else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("You are not authorized to access this page.")),
        );
      }
    } on FirebaseAuthException catch (e) {
      String message = "Login failed";
      print(e);
      if (e.code == 'user-not-found') message = "User not found.";
      if (e.code == 'wRrong-password') message = "Wrong password.";

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    }
  }
}

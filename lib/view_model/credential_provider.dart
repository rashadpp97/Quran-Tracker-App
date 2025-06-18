import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CredentialProvider extends ChangeNotifier {
  String? _email;

  String? get email => _email;

  void setEmail(String email) {
    _email = email;
    print("Email set to: $_email");
    notifyListeners();
  }

  void clearCredentials() {
    _email = null;
    notifyListeners();
  }
}

enum UserRole {
  admin,
  student,
  teacher,
}

class UserRoleProvider extends ChangeNotifier {
  UserRole? _userRole;

  UserRole? get userRole => _userRole;

  void getUserRole(String email) {
    // Get The Role of the User from Firebase (Admin, Student, Teacher)
    print('Fetching user role for email: $email');
    FirebaseFirestore.instance
        .collection('Role')
        .doc("Access")
        .get()
        .then((doc) {
      // Check if the document exists
      // Its Conttaining the Role Like Admin, Student, Teacher in Array

      if (doc.exists) {
        print("Document data: ${doc.data()}");
        doc.data()?.forEach((key, value) {
          print("Key: $key, Value: $value");
          if (value is List && key == 'Admin' && value.contains(email)) {
            print("Admin Role Found");
            _userRole =
                UserRole.admin; // Set the user role based on the document data
          } else if (value is List &&
              key == "Teacher" &&
              value.contains(email)) {
            _userRole = UserRole
                .teacher; // Set the user role based on the document data
          }
        });
      } else {
        _userRole =
            UserRole.student; // Default to student if user does not exist
      }
    }).catchError((error) {
      print("Error fetching user role: $error");
      _userRole = UserRole.student; // Default to student on error
      notifyListeners();
    });
    notifyListeners();
  }

  // Checking if the student is new student or not by checking if the email is in the database
  // In Students Collection randomly created document and if there is a document with the email then it is an old student
  Future<bool> isNewStudent(String email) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('Students')
          .where('email', isEqualTo: email)
          .get();

      if (snapshot.docs.isEmpty) {
        print("New student detected");
        return true; // New student
      } else {
        print("Existing student detected");
        return false; // Existing student
      }
    } catch (e) {
      print("Error checking new student status: $e");
      return false; // Default to false on error
    }
  }


  void clearUserRole() {
    _userRole = null;
    notifyListeners();
  }
}
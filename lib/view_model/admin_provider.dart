

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';



class AdminProvider with ChangeNotifier { 
   final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;
  registerNewStudent(String email, String password,context) async {
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      _user = _auth.currentUser;
      print(_user!.uid);
            ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Successfully student added.')));
      // await _user?.updateDisplayName(name);
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }




  
}

// ignore_for_file: unused_field, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quran_progress_tracker_app/view/Admin_panel/register/sign_up_page.dart';
import 'package:quran_progress_tracker_app/view/Students_panel/std_performanse_page.dart';

import '../../Students_panel/login_screen_page.dart';


class SignUpPage extends StatefulWidget {
  const SignUpPage(
      {super.key,

  required this.studentName,
  // required this.studentId,
  required this.className,
  required this.image
  }
  );
      
  final String studentName;
  // final String studentId;
  final String className;
  final String image;

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  // Controllers for TextFields
  FirebaseAuth auth = FirebaseAuth.instance;
   TextEditingController _usernameController = TextEditingController();
   TextEditingController _emailController = TextEditingController();
   TextEditingController _passwordController = TextEditingController();
  
  // final usernameController = TextEditingController();
  // final emailController = TextEditingController();
  // final passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> signUp() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim());
      
      if (context.mounted) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (_) => LoginScreen(studentName: '',className: '',image: '',
                    )));
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Sign up failed: $e")));
      }
    }
  }

  // Toggle for password visibility
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios, // iOS-style back button icon
              color: Colors.black, // Set the color of the icon
            ),
            onPressed: () {
              // Navigate to StudentDetailsApp
              Navigator.pop(context);
            }),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                // Background curved container
                Container(
                  height: 220,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/qaf picture.jpg'),
                      fit: BoxFit.fill,
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(50),
                      bottomRight: Radius.circular(50),
                    ),
                  ),
                ),
                // Circular logo
                Positioned(
                  top: 150,
                  left: (screenSize.width / 2) - 60,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color.fromARGB(255, 73, 93, 72),
                        width: 4,
                      ),
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Image.asset(
                        'assets/soq_logo.png', // Replace with your image path
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 80), // Adjust height for spacing
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Username input
                  Text(
                    "User Name",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      hintText: "User Name",
                      prefixIcon: Icon(Icons.person),
                      border: UnderlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Email Address",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      hintText: "Email",
                      prefixIcon: Icon(Icons.email),
                      border: UnderlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 20),
                  // Password input
                  Text(
                    "Password",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  TextField(
                    controller: _passwordController,
                    obscureText: !_isPasswordVisible,
                    decoration: InputDecoration(
                      hintText: "password",
                      prefixIcon: Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                      border: UnderlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 40),
                  // Login button
                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        // Get the user input
                        String username = _emailController.text;
                        String password = _passwordController.text;

                        // Basic validation
                        if (username.isEmpty || password.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Please fill in both fields."),
                            ),
                          );
                          return;
                        }
                        
                        try {
                          // You may want to handle Firebase authentication here
                          // For now, I'll comment it out since it has empty credentials
                          /*
                          await FirebaseAuth.instance.signInWithEmailAndPassword(
                            email: username, 
                            password: password,
                          );
                          */
                          
                          // Show success message
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Login successful!"),
                              duration: Duration(seconds: 1),
                            ),
                          );
                          
                          // Navigate to the StudentsPerformancePage after successful login
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => StudentsPerformancePage(
                                name: widget.studentName,
                                className: widget.className,
                                image: widget.image,
                              ),
                            ),
                          );
                        } catch (e) {
                          // Show error message if authentication fails
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Authentication failed: ${e.toString()}"),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF0D47A1),
                        padding:
                            EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        "Sign Up",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                    // Sign UP option
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Already have an account?"),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginScreen(studentName: '', className: '', image: '',),
                                ),
                              );
                            },
                            child: const Text(
                              "Login",
                              style: TextStyle(
                                color: Color(0xFF0D47A1),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quran_progress_tracker_app/view/Admin_panel/register/sign_up_page.dart';
// import 'signup_screen.dart';
import 'std_performanse_page.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen(
      {super.key,

  required this.studentName,
  // required this.studentId,
  required this.className,
  required this.image, });
      
  final String studentName;
  // final String studentId;
  final String className;
  final String image;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Controllers for TextFields
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> login() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => StudentsPerformancePage(name: '', className: '', image: '',)));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Login failed: $e")));
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
                    "Email Address",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      hintText: "Email",
                      prefixIcon: Icon(Icons.person),
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
                        "Login",
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
                          const Text("Don't have an account?"),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SignUpPage(studentName: '', className: '', image: '',),
                                ),
                              );
                            },
                            child: const Text(
                              "Sign Up",
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

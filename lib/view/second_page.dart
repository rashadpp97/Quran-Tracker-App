import 'package:flutter/material.dart';
import 'package:quran_progress_tracker_app/view/Admin_panel/admins_panel_page.dart';

import 'std_name_list_page.dart';
import 'Students_panel/login_screen_page.dart';
import 'Teachers_panel/teachers_panel_page.dart';

class MainOptionPage extends StatelessWidget {
  const MainOptionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Creative Reader\'s Publication',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: [
          // Top banner with logo
          Stack(
            clipBehavior: Clip
                .none, // Ensures the CircleAvatar can extend outside the Stack
            children: [
              // Background Container with curved edges
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

              // Logo with outline positioned above the container
              Positioned(
                top: 150, // Move the CircleAvatar upward
                left: (screenSize.width / 2)-60,
                child: Container(
                  width: 120, // Diameter of the outline
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color.fromARGB(
                          255, 73, 93, 72), // Outline color
                      width: 5, // Outline thickness
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 110,
                    backgroundColor: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0), // Reduced padding
                      child: Image.asset(
                        'assets/soq_logo.png', // Replace with your logo path
                        fit: BoxFit.contain, // Ensures the image fits well
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 100),

          // "Choose your option" text
          Text(
            'Choose your option',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: const Color.fromARGB(255, 44, 129, 199),
            ),
          ),

          SizedBox(height: 30),

          // Options for Student, Teacher, and Guest
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildOptionCard(
                      icon: Icons.school,
                      label: 'Student',
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginScreen(studentName: '', className: '', image: '',)));
                      },
                    ),
                    _buildOptionCard(
                      icon: Icons.person,
                      label: "Teacher's Panel",
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TeachersPanelPage()));
                      },
                    ),
                  ],
                ),
                SizedBox(height: 20),
                _buildOptionCard(
                  icon: Icons.person_outline,
                  label: "Admin's Panel",
                  onTap: () {
                    Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AdminsPanelPage()));
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget for each option card
  Widget _buildOptionCard(
      {required IconData icon,
      required String label,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 20, 95, 156),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white, size: 50),
          ),
          SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(fontSize: 16, color: Colors.black),
          ),
        ],
      ),
    );
  }
}

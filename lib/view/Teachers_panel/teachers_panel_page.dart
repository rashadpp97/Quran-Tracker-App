import 'package:flutter/material.dart';
import '../second_page.dart';
import 'edit_attendance.dart';
import 'edit_daily_report.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const TeachersPanelPage(),
    );
  }
}

class TeachersPanelPage extends StatelessWidget {
  const TeachersPanelPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
         toolbarHeight: 30,
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios, // iOS-style back button icon
              color: Colors.black, // Set the color of the icon
              size: 18,
            ),
            onPressed: () {
              // Navigate to StudentDetailsApp
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MainOptionPage(),
                ),
              );
            }),
      ),
      body: Column(
        children: [
          // Profile Section
          Stack(
            clipBehavior: Clip.none,
            children: [
              // Background Container with curved edges
              Container(
                height: 220,
                decoration: const BoxDecoration(
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
            ],
          ),

          const SizedBox(height: 40),
          // Header Text
          const Text(
            'CONTROL PANEL OF',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF6A11CB),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'STUDENTS REPORT',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2575FC),
            ),
          ),
          const SizedBox(height: 25),

          // Button Grid
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                children: [
                  _buildModernButton(
                    icon: Icons.assessment,
                    label: 'Daily Report',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => DailyReportControlPage()),
                      );
                    },
                  ),
                  _buildModernButton(
                    icon: Icons.calendar_month,
                    label: 'Attendance',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AttendanceControlPage()),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

Widget _buildModernButton({
  required IconData icon,
  required String label,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF001F3F), // Deep Navy Blue
            Color(0xFF3D9970), // Dark Green
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF001F3F).withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 2,
              ),
            ),
            child: Icon(
              icon,
              size: 32,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    ),
  );
}
}

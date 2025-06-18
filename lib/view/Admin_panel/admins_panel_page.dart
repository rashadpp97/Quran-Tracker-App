// import 'package:flutter/material.dart';
// import '../Splash_screen/second_page.dart';
// import 'edit_education_level.dart';
// import 'edit_daily_report.dart';
// import 'edit_monthly_topper.dart';
// import 'edit_std_name_list.dart';
// import 'register/add_student.dart';

// class AdminsPanelPage extends StatelessWidget {
//   const AdminsPanelPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         toolbarHeight: 30,
//         leading: IconButton(
//             icon: Icon(
//               Icons.arrow_back_ios, // iOS-style back button icon
//               color: Colors.black, // Set the color of the icon
//               size: 18,
//             ),
//             onPressed: () {
//               // Navigate to StudentDetailsApp
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => const MainOptionPage(),
//                 ),
//               );
//             }),
//       ),
//       body: SingleChildScrollView(
//         child: SizedBox(
//           height: /** The Size of buttons to avoid overflow */,
//           child: Column(
//             children: [
//               // Profile Section
//               // Stack(
//               //   clipBehavior: Clip.none,
//               //   children: [
//               //     // Background Container with curved edges
//               //     Container(
//               //       height: 220,
//               //       decoration: const BoxDecoration(
//               //         image: DecorationImage(
//               //           image: AssetImage('assets/qaf picture.jpg'),
//               //           fit: BoxFit.fill,
//               //         ),
//               //         borderRadius: BorderRadius.only(
//               //           bottomLeft: Radius.circular(50),
//               //           bottomRight: Radius.circular(50),
//               //         ),
//               //       ),
//               //     ),
//               //   ],
//               // ),
//               Container(
//                 height: 220,
//                 decoration: const BoxDecoration(
//                   image: DecorationImage(
//                     image: AssetImage('assets/qaf picture.jpg'),
//                     fit: BoxFit.fill,
//                   ),
//                   borderRadius: BorderRadius.only(
//                     bottomLeft: Radius.circular(50),
//                     bottomRight: Radius.circular(50),
//                   ),
//                 ),
//               ),

//               const SizedBox(height: 40),
//               // Header Text
//               const Text(
//                 'CONTROL PANEL OF',
//                 style: TextStyle(
//                   fontSize: 28,
//                   fontWeight: FontWeight.bold,
//                   color: Color(0xFF6A11CB),
//                 ),
//               ),
//               const SizedBox(height: 8),
//               const Text(
//                 'STUDENTS REPORT',
//                 style: TextStyle(
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                   color: Color(0xFF2575FC),
//                 ),
//               ),
//               const SizedBox(height: 25),

//               // Button Grid
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 20),
//                 child: GridView.count(
//                   crossAxisCount: 2,
//                   crossAxisSpacing: 20,
//                   mainAxisSpacing: 20,
//                   shrinkWrap: true,
//                   physics: const NeverScrollableScrollPhysics(),
//                   children: [
//                     _buildEnhancedButton(
//                       icon: Icons.insert_chart,
//                       title: 'Daily Report',
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) =>
//                                   ClassAddAndDeleteControlPage()),
//                         );
//                       },
//                     ),
//                     _buildEnhancedButton(
//                       icon: Icons.emoji_events,
//                       title: 'Monthly Topper',
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) => MonthlyTopperControlPage()),
//                         );
//                       },
//                     ),
//                     _buildEnhancedButton(
//                       icon: Icons.school,
//                       title: 'Education Level',
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) => EducationLevelControlPage()),
//                         );
//                       },
//                     ),
//                     _buildEnhancedButton(
//                       icon: Icons.group,
//                       title: 'Students Name List',
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) =>
//                                   StudentsNameListControlPage()),
//                         );
//                       },
//                     ),
//                     _buildEnhancedButton(
//                       icon: Icons.person_add,
//                       title: 'Add Student',
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) => AddStudentPage()),
//                         );
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildEnhancedButton({
//     required IconData icon,
//     required String title,
//     required VoidCallback onTap,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//             colors: [
//               Color(0xFF001F3F), // Deep Navy Blue
//               Color(0xFF3D9970), // Dark Green
//             ],
//           ),
//           borderRadius: BorderRadius.circular(24),
//           boxShadow: [
//             BoxShadow(
//               color: Color(0xFF001F3F).withOpacity(0.3),
//               spreadRadius: 1,
//               blurRadius: 20,
//               offset: Offset(0, 8),
//             ),
//           ],
//         ),
//         child: ClipRRect(
//           borderRadius: BorderRadius.circular(24),
//           child: Stack(
//             children: [
//               // Background pattern/effect
//               Positioned(
//                 bottom: -20,
//                 right: -20,
//                 child: Opacity(
//                   opacity: 0.1,
//                   child: Icon(
//                     icon,
//                     size: 120,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//               // Content
//               Padding(
//                 padding: const EdgeInsets.all(18.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     // Icon with glow effect
//                     Container(
//                       padding: const EdgeInsets.all(12),
//                       decoration: BoxDecoration(
//                         color: Colors.white.withOpacity(0.2),
//                         borderRadius: BorderRadius.circular(14),
//                       ),
//                       child: Icon(
//                         icon,
//                         color: Colors.white,
//                         size: 24,
//                       ),
//                     ),
//                     // Title with small arrow indicator
//                     Row(
//                       children: [
//                         Expanded(
//                           child: Text(
//                             title,
//                             style: const TextStyle(
//                               color: Colors.white,
//                               fontWeight: FontWeight.bold,
//                               fontSize: 16,
//                             ),
//                           ),
//                         ),
//                         const Icon(
//                           Icons.arrow_forward_ios_rounded,
//                           color: Colors.white,
//                           size: 12,
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import '../Splash_screen/second_page.dart';
import 'edit_education_level.dart';
import 'edit_daily_report.dart';
import 'edit_monthly_topper.dart';
import 'edit_std_name_list.dart';
import 'register/add_student.dart';

class AdminsPanelPage extends StatelessWidget {
  const AdminsPanelPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 30,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
            size: 18,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const MainOptionPage(),
              ),
            );
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header image
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
              const SizedBox(height: 40),

              // Heading
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

              // Buttons
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _buildEnhancedButton(
                      icon: Icons.insert_chart,
                      title: 'Daily Report',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ClassAddAndDeleteControlPage(),
                          ),
                        );
                      },
                    ),
                    _buildEnhancedButton(
                      icon: Icons.emoji_events,
                      title: 'Monthly Topper',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MonthlyTopperControlPage(),
                          ),
                        );
                      },
                    ),
                    _buildEnhancedButton(
                      icon: Icons.school,
                      title: 'Education Level',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EducationLevelControlPage(),
                          ),
                        );
                      },
                    ),
                    _buildEnhancedButton(
                      icon: Icons.group,
                      title: 'Students Name List',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => StudentsNameListControlPage(),
                          ),
                        );
                      },
                    ),
                    _buildEnhancedButton(
                      icon: Icons.person_add,
                      title: 'Add Student',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddStudentPage(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEnhancedButton({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 140, // Fixed height for consistent button size
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF001F3F),
              Color(0xFF3D9970),
            ],
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF001F3F).withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            children: [
              Positioned(
                bottom: -20,
                right: -20,
                child: Opacity(
                  opacity: 0.1,
                  child: Icon(
                    icon,
                    size: 120,
                    color: Colors.white,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(
                        icon,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        const Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Colors.white,
                          size: 12,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

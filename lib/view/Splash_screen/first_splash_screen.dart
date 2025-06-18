// import 'package:flutter/material.dart';

// import 'second_page.dart';

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _logoScaleAnimation;
//   late Animation<double> _logoOpacityAnimation;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       duration: const Duration(seconds: 1),
//       vsync: this,
//     );

//     _logoScaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
//       CurvedAnimation(
//         parent: _controller,
//         curve: Curves.easeOutBack,
//       ),
//     );

//     _logoOpacityAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
//       CurvedAnimation(
//         parent: _controller,
//         curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
//       ),
//     );

//     _controller.forward();

//     // Navigate to home screen after delay
//     Future.delayed(const Duration(seconds: 2), () {
//       // Navigate to your home screen here
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) =>  MainOptionPage()),
//       );
//     });
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           // Top curved decoration
//           Positioned(
//             top: -100,
//             left: -130,
//             child: Container(
//               width: 300,
//               height: 200,
//               decoration: const BoxDecoration(
//                 color: Color(0xFF40E0D0),
//                 shape: BoxShape.circle,
//               ),
//             ),
//           ),

//           // Bottom curved decoration
//           Positioned(
//             bottom: -270,
//             left: 1,
//             right: 0,
//             child: Container(
//               height: 400,
//               width: 600,
//               decoration: const BoxDecoration(
//                 color: Color.fromARGB(255, 22, 22, 114),
//                 shape: BoxShape.circle,
//                 // borderRadius: BorderRadius.vertical(top: Radius.circular(100)),
//               ),
//             ),
//           ),

//           // Main content
//           Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 // Animated logo
//                 AnimatedBuilder(
//                   animation: _controller,
//                   builder: (context, child) {
//                     return Transform.scale(
//                       scale: _logoScaleAnimation.value,
//                       child: Opacity(
//                         opacity: _logoOpacityAnimation.value,
//                         child: child,
//                       ),
//                     );
//                   },
//                   child: Column(
//                     children: [
//                       // Logo icon
//                       Stack(
//                         alignment: Alignment.center,
//                         children: [
//                           Container(
//                             width: 100,
//                             height: 100,
//                             decoration: BoxDecoration(
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: Colors.black.withOpacity(
//                                       0.5), // Shadow color with transparency
//                                   blurRadius: 10.0, // Softness of the shadow
//                                   offset: Offset(4.0,
//                                       4.0), // Horizontal and vertical offsets
//                                 ),
//                               ],
//                               shape:
//                                   BoxShape.rectangle, // Shape of the container
//                             ),
//                             child: ClipRRect(
//                               borderRadius: BorderRadius.circular(
//                                   8.0), // Optional: Rounded corners
//                               child: Image.asset(
//                                 "assets/school of Qur,an logo.png",
//                                 width: 100,
//                                 height: 100,
//                                 fit: BoxFit.fill,
//                               ),
//                             ),
//                           ),

//                           // Icon(
//                           //   Icons.book,
//                           //   size: 100,
//                           //   color: Colors.blue[700],
//                           // ),
//                           // const Padding(
//                           //   padding: EdgeInsets.only(top: 10),
//                           //   child: Icon(
//                           //     Icons.school,
//                           //     size: 40,
//                           //     color: Color(0xFF40E0D0),
//                           //   ),
//                           // ),
//                         ],
//                       ),
//                       const SizedBox(height: 20),
//                       // App name
//                       const Text(
//                         "SCHOOL OF QUR'AN RESIDENTIAL",
//                         style: TextStyle(
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.blue,
//                           shadows: [
//                             Shadow(
//                               offset: Offset(
//                                   2.0, 2.0), // Horizontal and vertical offsets
//                               blurRadius: 5.0, // Softness of the shadow
//                               color: Colors
//                                   .black, // Shadow color with transparency
//                             ),
//                           ],
//                         ),
//                       ),
//                       const Text(
//                         'CAMPUS',
//                         style: TextStyle(
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.blue,
//                           shadows: [
//                             Shadow(
//                               offset: Offset(4.0, 4.0),
//                               blurRadius: 10.0,
//                               color: Colors.black26,
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           // Powered by text
//           Positioned(
//             bottom: 10,
//             left: 0,
//             right: 0,
//             child: Center(
//               child: Text(
//                 "Jami'a Al-Hind Al-Islamiyya\n  Wadi Al-Hikma Mini Ooty\n             Malappuram",
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 16,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'second_page.dart';
import 'package:shared_preferences/shared_preferences.dart'; // if using shared preferences

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoOpacityAnimation;

  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _logoScaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutBack,
      ),
    );

    _logoOpacityAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    _controller.forward();

    checkLoginStatusAndNavigate();
  }

  Future<void> checkLoginStatusAndNavigate() async {
    // Simulated delay for splash animation
    await Future.delayed(const Duration(seconds: 2));

    // Replace this with your actual login check logic
    final prefs = await SharedPreferences.getInstance();
    bool isLogged = prefs.getBool('isLoggedIn') ?? false;

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>  MainOptionPage(),
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: -100,
            left: -130,
            child: Container(
              width: 300,
              height: 200,
              decoration: const BoxDecoration(
                color: Color(0xFF40E0D0),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -270,
            left: 1,
            right: 0,
            child: Container(
              height: 400,
              width: 600,
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 22, 22, 114),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _logoScaleAnimation.value,
                      child: Opacity(
                        opacity: _logoOpacityAnimation.value,
                        child: child,
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.5),
                                  blurRadius: 10.0,
                                  offset: Offset(4.0, 4.0),
                                ),
                              ],
                              shape: BoxShape.rectangle,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.asset(
                                "assets/school of Qur,an logo.png",
                                width: 100,
                                height: 100,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "SCHOOL OF QUR'AN RESIDENTIAL",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                          shadows: [
                            Shadow(
                              offset: Offset(2.0, 2.0),
                              blurRadius: 5.0,
                              color: Colors.black,
                            ),
                          ],
                        ),
                      ),
                      const Text(
                        'CAMPUS',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                          shadows: [
                            Shadow(
                              offset: Offset(4.0, 4.0),
                              blurRadius: 10.0,
                              color: Colors.black26,
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
          Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                "Jami'a Al-Hind Al-Islamiyya\n  Wadi Al-Hikma Mini Ooty\n             Malappuram",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

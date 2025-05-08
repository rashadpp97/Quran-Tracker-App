import 'dart:math';

import 'package:flutter/material.dart';
import 'dart:math' as math;

class MonthlyData {
  final String month;
  final String year;
  final List<HifzStudent> students;

  MonthlyData({
    required this.month,
    required this.year,
    required this.students,
  });
}

class HifzStudent {
  final String name;
  final int points;
  final String AssetImage;
  final LinearGradient gradient;

  HifzStudent({
    required this.name,
    required this.points,
    required this.AssetImage,
    required this.gradient,
  });
}

class MonthlyTopperPage extends StatefulWidget {
  const MonthlyTopperPage({super.key, required List<HifzStudent> students});

  @override
  _MonthlyTopperPageState createState() => _MonthlyTopperPageState();
}

class _MonthlyTopperPageState extends State<MonthlyTopperPage>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _shimmerController;
   int _currentMonthIndex = 0;
  
  final List<MonthlyData> academicYear = [
    MonthlyData(
      month: "December",
      year: "2024",
      students: [
        HifzStudent(
          name: "Fouzan",
          points: 920,
          AssetImage: "assets/Fouzan Sidhique.png",
          gradient: const LinearGradient(
            colors: [Color(0xFF1E88E5), Color(0xFF64B5F6)],
          ),
        ),
    HifzStudent(
      name: "Hadi",
      points: 950,
      AssetImage: "assets/Hadi Hassan.png",
      gradient: const LinearGradient(
        colors: [Color(0xFF7B1FA2), Color(0xFFBA68C8)],
      ),
    ),
    HifzStudent(
      name: "Basheer",
      points: 890,
      AssetImage: "assets/Basheer.png",
      gradient: const LinearGradient(
        colors: [Color(0xFF388E3C), Color(0xFF81C784)],
      ),
    ),
    HifzStudent(
      name: "Muad",
      points: 870,
      AssetImage: "assets/Muad.png",
      gradient: const LinearGradient(
        colors: [Color(0xFFE64A19), Color(0xFFFF8A65)],
      ),
    ),
    HifzStudent(
      name: "Adhil",
      points: 850,
      AssetImage: "assets/Adhil.png",
      gradient: const LinearGradient(
        colors: [Color(0xFFC62828), Color(0xFFE57373)],
      ),
    ),
  ]
  ),
   MonthlyData(
      month: "January",
      year: "2025",
      students: [
        HifzStudent(
          name: "Faris",
          points: 960,
          AssetImage: "assets/Faris.png",
          gradient: const LinearGradient(
            colors: [Color(0xFF1E88E5), Color(0xFF64B5F6)],
          ),
        ),
    HifzStudent(
      name: "Yahya",
      points: 980,
      AssetImage: "assets/Yahya.png",
      gradient: const LinearGradient(
        colors: [Color(0xFF7B1FA2), Color(0xFFBA68C8)],
      ),
    ),
    HifzStudent(
      name: "Faheem c",
      points: 940,
      AssetImage: "assets/Faheem_c.png",
      gradient: const LinearGradient(
        colors: [Color(0xFF388E3C), Color(0xFF81C784)],
      ),
    ),
    HifzStudent(
      name: "Azim ck",
      points: 915,
      AssetImage: "assets/Azim_ck.png",
      gradient: const LinearGradient(
        colors: [Color(0xFFE64A19), Color(0xFFFF8A65)],
      ),
    ),
    HifzStudent(
      name: "Zayan",
      points: 903,
      AssetImage: "assets/Zayan.png",
      gradient: const LinearGradient(
        colors: [Color(0xFFC62828), Color(0xFFE57373)],
      ),
    ),
  ]
  ),
     MonthlyData(
      month: "February",
      year: "2025",
      students: [
        HifzStudent(
          name: "",
          points: 0,
          AssetImage: "",
          gradient: const LinearGradient(
            colors: [Color(0xFF1E88E5), Color(0xFF64B5F6)],
          ),
        ),
    HifzStudent(
      name: "",
      points: 0,
      AssetImage: "",
      gradient: const LinearGradient(
        colors: [Color(0xFF7B1FA2), Color(0xFFBA68C8)],
      ),
    ),
    HifzStudent(
      name: "",
      points: 0,
      AssetImage: "",
      gradient: const LinearGradient(
        colors: [Color(0xFF388E3C), Color(0xFF81C784)],
      ),
    ),
    HifzStudent(
      name: "",
      points: 0,
      AssetImage: "",
      gradient: const LinearGradient(
        colors: [Color(0xFFE64A19), Color(0xFFFF8A65)],
      ),
    ),
    HifzStudent(
      name: "",
      points: 0,
      AssetImage: "",
      gradient: const LinearGradient(
        colors: [Color(0xFFC62828), Color(0xFFE57373)],
      ),
    ),
  ]
  ),
     MonthlyData(
      month: "March",
      year: "2025",
      students: [
        HifzStudent(
          name: "",
          points: 0,
          AssetImage: "",
          gradient: const LinearGradient(
            colors: [Color(0xFF1E88E5), Color(0xFF64B5F6)],
          ),
        ),
    HifzStudent(
      name: "",
      points: 0,
      AssetImage: "",
      gradient: const LinearGradient(
        colors: [Color(0xFF7B1FA2), Color(0xFFBA68C8)],
      ),
    ),
    HifzStudent(
      name: "",
      points: 0,
      AssetImage: "",
      gradient: const LinearGradient(
        colors: [Color(0xFF388E3C), Color(0xFF81C784)],
      ),
    ),
    HifzStudent(
      name: "",
      points: 0,
      AssetImage: "",
      gradient: const LinearGradient(
        colors: [Color(0xFFE64A19), Color(0xFFFF8A65)],
      ),
    ),
    HifzStudent(
      name: "",
      points: 0,
      AssetImage: "",
      gradient: const LinearGradient(
        colors: [Color(0xFFC62828), Color(0xFFE57373)],
      ),
    ),
  ]
  ),
    MonthlyData(
      month: "April",
      year: "2025",
      students: [
        HifzStudent(
          name: "",
          points: 0,
          AssetImage: "",
          gradient: const LinearGradient(
            colors: [Color(0xFF1E88E5), Color(0xFF64B5F6)],
          ),
        ),
    HifzStudent(
      name: "",
      points: 0,
      AssetImage: "",
      gradient: const LinearGradient(
        colors: [Color(0xFF7B1FA2), Color(0xFFBA68C8)],
      ),
    ),
    HifzStudent(
      name: "",
      points: 0,
      AssetImage: "",
      gradient: const LinearGradient(
        colors: [Color(0xFF388E3C), Color(0xFF81C784)],
      ),
    ),
    HifzStudent(
      name: "",
      points: 0,
      AssetImage: "",
      gradient: const LinearGradient(
        colors: [Color(0xFFE64A19), Color(0xFFFF8A65)],
      ),
    ),
    HifzStudent(
      name: "",
      points: 0,
      AssetImage: "",
      gradient: const LinearGradient(
        colors: [Color(0xFFC62828), Color(0xFFE57373)],
      ),
    ),
  ]
  ),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..forward();

    _shimmerController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  void _nextMonth() {
    setState(() {
      if (_currentMonthIndex < academicYear.length - 1) {
        _currentMonthIndex++;
      }
    });
  }

  void _previousMonth() {
    setState(() {
      if (_currentMonthIndex > 0) {
        _currentMonthIndex--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios, // iOS-style back button icon
              color: Colors.black, // Set the color of the icon
            ),
            onPressed: () {
              // Navigate to StudentDetailsApp
              Navigator.pop(context);
            }),
            actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today, color: Colors.black),
            onPressed: () {
              _showMonthPicker(context);
            },
          ),
        ],
            ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1A237E),  // Deep Indigo
              Color(0xFF0D47A1),  // Deep Blue
            ],
          ),
        ),
           child: Column(
          children: [
            _buildMonthNavigator(),
            Expanded(
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  // _buildHeader(),
                  _buildTopThree(),
                  _buildRemainingStudents(),
                ],
              ),
            ),
          ],
        ),
        // child: CustomScrollView(
        //   physics: const BouncingScrollPhysics(),
        //   slivers: [
        //     _buildHeader(),
        //     _buildTopThree(),
        //     _buildRemainingStudents(),
        //   ],
        // ),
      ),
    );
  }

  Widget _buildMonthNavigator() {
    final currentData = academicYear[_currentMonthIndex];
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      color: Colors.white.withOpacity(0.1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: _currentMonthIndex > 0 ? _previousMonth : null,
          ),
          Text(
            "${currentData.month} ${currentData.year}",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios, color: Colors.white),
            onPressed: _currentMonthIndex < academicYear.length - 1
                ? _nextMonth
                : null,
          ),
        ],
      ),
    );
  }

  void _showMonthPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Month'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: academicYear.length,
              itemBuilder: (context, index) {
                final monthData = academicYear[index];
                return ListTile(
                  title: Text('${monthData.month} ${monthData.year}'),
                  onTap: () {
                    setState(() {
                      _currentMonthIndex = index;
                    });
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  // Widget _buildHeader() {
  //   return SliverAppBar(
  //     expandedHeight: 100,
  //     floating: false,
  //     pinned: true,
  //     // backgroundColor: Colors.transparent,
  //     flexibleSpace: FlexibleSpaceBar(
  //       title: ShaderMask(
  //         shaderCallback: (bounds) => const LinearGradient(
  //           colors: [Colors.white, Color(0xFFFFD700)],
  //         ).createShader(bounds),
  //         child: const Text(
  //           'Hifz Champions',
  //           style: TextStyle(
  //             fontSize: 25,
  //             fontWeight: FontWeight.bold,
  //             color: Colors.white,
  //           ),
  //         ),
  //       ),
  //       background: AnimatedBuilder(
  //         animation: _shimmerController,
  //         builder: (context, child) {
  //           return Container(
  //             decoration: BoxDecoration(
  //               gradient: LinearGradient(
  //                 begin: Alignment(-1.0 + _shimmerController.value * 2, 0),
  //                 end: Alignment(-0.2 + _shimmerController.value * 2, 0),
  //                 colors: const [
  //                   Colors.transparent,
  //                   Colors.white10,
  //                   Colors.transparent,
  //                 ],
  //               ),
  //             ),
  //           );
  //         },
  //       ),
  //     ),
  //   );
  // }

  Widget _buildTopThree() {
    final currentStudents = academicYear[_currentMonthIndex].students;
    return SliverToBoxAdapter(
      child: Container(
        height: 400,
        padding: const EdgeInsets.only(top: 10),
        child: Stack(
          alignment: Alignment.center,
          children: [
            _buildAnimatedBackground(),
            for (var i = 0; i < min(3, currentStudents.length); i++)
              _buildTopPosition(currentStudents[i], i),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedBackground() {
    return AnimatedBuilder(
      animation: _shimmerController,
      builder: (context, child) {
        return Transform.rotate(
          angle: _shimmerController.value * 2 * math.pi,
          child: Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [
                  Colors.white.withOpacity(0.1),
                  Colors.transparent,
                ],
                stops: const [0.2, 1.0],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTopPosition(HifzStudent student, int index) {
    final positions = [
      const Offset(-120, 40),  // Second place
      const Offset(0, -30),    // First place
      const Offset(120, 40),   // Third place
    ];

    final sizes = [140.0, 180.0, 140.0];
    final delays = [300, 0, 600];
    final rotations = [-0.1, 0.0, 0.1];

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 1200 + delays[index]),
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        return Transform.translate(
          offset: positions[index] * value,
          child: Transform.rotate(
            angle: rotations[index] * value,
            child: _buildTopStudentCard(student, index, sizes[index] * value),
          ),
        );
      },
    );
  }

  Widget _buildTopStudentCard(HifzStudent student, int index, double size) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: student.gradient,
            boxShadow: [
              BoxShadow(
                color: student.gradient.colors.first.withOpacity(0.3),
                blurRadius: 15,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Stack(
            children: [
              ClipOval(
                child: Image.asset(
                  student.AssetImage,
                  width: size,
                  height: size,
                  fit: BoxFit.cover,
                ),
              ),
              if (index == 1)
                Positioned(
                  top: -6,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.0, end: 1.0),
                      duration: const Duration(milliseconds: 1500),
                      curve: Curves.elasticOut,
                      builder: (context, value, child) {
                        return Transform.scale(
                          scale: value,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFFFFD700), Color(0xFFFFA000)],
                              ),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 8,
                                ),
                              ],
                            ),
                            child: const Text(
                              '👑 CHAMPION',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(
          student.name,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                color: Colors.black26,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            gradient: student.gradient,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: student.gradient.colors.first.withOpacity(0.3),
                blurRadius: 8,
              ),
            ],
          ),
          child: Text(
            '${student.points} Points',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }

   Widget _buildRemainingStudents() {
    final currentStudents = academicYear[_currentMonthIndex].students;
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          if (index < 3) return const SizedBox.shrink();
          if (index >= currentStudents.length) return null;
          final student = currentStudents[index];
          
          return TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: Duration(milliseconds: 600 + (index * 200)),
            curve: Curves.easeOut,
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: _buildStudentListItem(student, index),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildStudentListItem(HifzStudent student, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white.withOpacity(0.1),
              Colors.white.withOpacity(0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white.withOpacity(0.1),
          ),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.all(12),
          leading: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: student.gradient,
              boxShadow: [
                BoxShadow(
                  color: student.gradient.colors.first.withOpacity(0.3),
                  blurRadius: 8,
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 30,
              backgroundColor: Colors.transparent,
              child: ClipOval(
                child: Image.network(
                  student.AssetImage,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          title: Text(
            student.name,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
    
          trailing: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              gradient: student.gradient,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              '${student.points} Points',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

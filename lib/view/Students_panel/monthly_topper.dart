import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class MonthlyData {
  final String month;
  String year; // Not final since we need to update it
  final List<HifzStudent> students;

  MonthlyData({
    required this.month,
    required this.year,
    required this.students,
  });
}

class HifzStudent {
  String name;
  int points;
  String assetImage; // String path to image
  final LinearGradient gradient;

  HifzStudent({
    required this.name,
    required this.points,
    required this.assetImage,
    required this.gradient,
  });
}

class MonthlyTopperPage extends StatefulWidget {
  const MonthlyTopperPage({super.key, required List students});

  @override
  _MonthlyTopperPageState createState() => _MonthlyTopperPageState();
}

class _MonthlyTopperPageState extends State<MonthlyTopperPage>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _shimmerController;
  late List<HifzStudent> currentStudents;
  int _currentMonthIndex = 0;

  // Add a variable to track the selected year
  String _selectedYear = "2025"; // Default year

  // Create a more comprehensive list of months with proper initialization
  final List<MonthlyData> academicYear = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..forward();

    _shimmerController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();

    // Initialize the academic year with all months
    _initializeAcademicYear();
    currentStudents = academicYear[_currentMonthIndex].students;

    // Load saved data if available
    _loadSavedData();
  }

  // New method to load saved data
  Future<void> _loadSavedData() async {
    try {
      final savedData = await StudentDataService.loadData();
      if (savedData != null && savedData.isNotEmpty) {
        setState(() {
          // Replace the initialized academic year with saved data
          academicYear.clear();
          academicYear.addAll(savedData);
          _selectedYear = academicYear[0].year; // Get year from saved data
          
         // Find the current month index based on the selected year
          _currentMonthIndex = _findCurrentMonthIndex(); 
      
        });
      }
    } catch (e) {
      debugPrint('Error loading saved data: $e');
    }
  }

  // Helper to find the current month index
  int _findCurrentMonthIndex() {
    // Default to January of the selected year
    int index = academicYear.indexWhere(
      (month) => month.year == _selectedYear && month.month == 'January'
    );
    
    // If not found, return 0 or the first available month
    return index != -1 ? index : 0;
  }

  void _initializeAcademicYear() {
    // Create a list of all months
    List<String> months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];

    // First, add the existing data (January and February with students)
    academicYear
        .add(MonthlyData(month: "January", year: _selectedYear, students: [
      HifzStudent(
        name: "Fouzan",
        points: 920,
        assetImage: "assets/Fouzan Sidhique.png",
        gradient: const LinearGradient(
          colors: [Color(0xFF1E88E5), Color(0xFF64B5F6)],
        ),
      ),
      HifzStudent(
        name: "Hadi",
        points: 950,
        assetImage: "assets/Hadi Hassan.png",
        gradient: const LinearGradient(
          colors: [Color(0xFF7B1FA2), Color(0xFFBA68C8)],
        ),
      ),
      HifzStudent(
        name: "Basheer",
        points: 890,
        assetImage: "assets/Basheer.png",
        gradient: const LinearGradient(
          colors: [Color(0xFF388E3C), Color(0xFF81C784)],
        ),
      ),
      HifzStudent(
        name: "Muad",
        points: 870,
        assetImage: "assets/Muad.png",
        gradient: const LinearGradient(
          colors: [Color(0xFFE64A19), Color(0xFFFF8A65)],
        ),
      ),
      HifzStudent(
        name: "Adhil",
        points: 850,
        assetImage: "assets/Adhil.png",
        gradient: const LinearGradient(
          colors: [
            Color.fromARGB(255, 225, 221, 104),
            Color.fromARGB(255, 206, 203, 43)
          ],
        ),
      ),
    ]));

    academicYear
        .add(MonthlyData(month: "February", year: _selectedYear, students: [
      HifzStudent(
        name: "Faris",
        points: 960,
        assetImage: "assets/Faris.png",
        gradient: const LinearGradient(
          colors: [Color(0xFF1E88E5), Color(0xFF64B5F6)],
        ),
      ),
      HifzStudent(
        name: "Yahya",
        points: 980,
        assetImage: "assets/Yahya.png",
        gradient: const LinearGradient(
          colors: [Color(0xFF7B1FA2), Color(0xFFBA68C8)],
        ),
      ),
      HifzStudent(
        name: "Faheem c",
        points: 940,
        assetImage: "assets/Faheem_c.png",
        gradient: const LinearGradient(
          colors: [Color(0xFF388E3C), Color(0xFF81C784)],
        ),
      ),
      HifzStudent(
        name: "Azim ck",
        points: 915,
        assetImage: "assets/Azim_ck.png",
        gradient: const LinearGradient(
          colors: [Color(0xFFE64A19), Color(0xFFFF8A65)],
        ),
      ),
      HifzStudent(
        name: "Zayan",
        points: 903,
        assetImage: "assets/Zayan.png",
        gradient: const LinearGradient(
          colors: [
            Color.fromARGB(255, 225, 221, 104),
            Color.fromARGB(255, 206, 203, 43)
          ],
        ),
      ),
    ]));

    // Add remaining months with empty student lists
    for (int i = 2; i < months.length; i++) {
      academicYear
          .add(MonthlyData(month: months[i], year: _selectedYear, students: [
        HifzStudent(
          name: "",
          points: 0,
          assetImage: "",
          gradient: const LinearGradient(
            colors: [Color(0xFF1E88E5), Color(0xFF64B5F6)],
          ),
        ),
        HifzStudent(
          name: "",
          points: 0,
          assetImage: "",
          gradient: const LinearGradient(
            colors: [Color(0xFF7B1FA2), Color(0xFFBA68C8)],
          ),
        ),
        HifzStudent(
          name: "",
          points: 0,
          assetImage: "",
          gradient: const LinearGradient(
            colors: [Color(0xFF388E3C), Color(0xFF81C784)],
          ),
        ),
        HifzStudent(
          name: "",
          points: 0,
          assetImage: "",
          gradient: const LinearGradient(
            colors: [Color(0xFFE64A19), Color(0xFFFF8A65)],
          ),
        ),
        HifzStudent(
          name: "",
          points: 0,
          assetImage: "",
          gradient: const LinearGradient(
            colors: [
              Color.fromARGB(255, 225, 221, 104),
            Color.fromARGB(255, 206, 203, 43)
            ],
          ),
        ),
      ]));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  // Fix the month navigation to handle year changes
  void _nextMonth() {
    setState(() {
      if (_currentMonthIndex < academicYear.length - 1) {
        // Check if next month is in a different year
        final currentMonthData = academicYear[_currentMonthIndex];
        final nextMonthData = academicYear[_currentMonthIndex + 1];
        
        if (currentMonthData.year != nextMonthData.year) {
          // We're moving to a new year
          _selectedYear = nextMonthData.year;
        }
        
        _currentMonthIndex++;
      } else {
        // We need to create a new year
        int nextYear = int.parse(_selectedYear) + 1;
        String nextYearStr = nextYear.toString();
        
        // Initialize new year data
        _initializeNewYear(nextYearStr);
        
        // Find January of next year
        int newIndex = academicYear.indexWhere(
          (month) => month.year == nextYearStr && month.month == "January"
        );
        
        if (newIndex != -1) {
          _currentMonthIndex = newIndex;
          _selectedYear = nextYearStr;
        }
      }
      
      currentStudents = academicYear[_currentMonthIndex].students;
    });
  }

 void _previousMonth() {
    setState(() {
      if (_currentMonthIndex > 0) {
        // Check if previous month is in a different year
        final currentMonthData = academicYear[_currentMonthIndex];
        final prevMonthData = academicYear[_currentMonthIndex - 1];
        
        if (currentMonthData.year != prevMonthData.year) {
          // We're moving to the previous year
          _selectedYear = prevMonthData.year;
        }
        
        _currentMonthIndex--;
      } else {
        // We need to create a previous year
        int prevYear = int.parse(_selectedYear) - 1;
        String prevYearStr = prevYear.toString();
        
        // Initialize previous year data
        _initializeEmptyPreviousYear(prevYearStr);
        
        // Find December of previous year
        int newIndex = academicYear.indexWhere(
          (month) => month.year == prevYearStr && month.month == "December"
        );
        
        if (newIndex != -1) {
          _currentMonthIndex = newIndex;
          _selectedYear = prevYearStr;
        }
      }
      
      currentStudents = academicYear[_currentMonthIndex].students;
    });
  }

  // Implementation for _initializeNewYear method
  void _initializeNewYear(String newYear) {
    List<String> months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];

    // Update the selected year
    _selectedYear = newYear;

    // Create new entries for each month of the new year
    for (String month in months) {
      academicYear.add(MonthlyData(month: month, year: newYear, students: [
        HifzStudent(
          name: "",
          points: 0,
          assetImage: "",
          gradient: const LinearGradient(
            colors: [Color(0xFF1E88E5), Color(0xFF64B5F6)],
          ),
        ),
        HifzStudent(
          name: "",
          points: 0,
          assetImage: "",
          gradient: const LinearGradient(
            colors: [Color(0xFF7B1FA2), Color(0xFFBA68C8)],
          ),
        ),
        HifzStudent(
          name: "",
          points: 0,
          assetImage: "",
          gradient: const LinearGradient(
            colors: [Color(0xFF388E3C), Color(0xFF81C784)],
          ),
        ),
        HifzStudent(
          name: "",
          points: 0,
          assetImage: "",
          gradient: const LinearGradient(
            colors: [Color(0xFFE64A19), Color(0xFFFF8A65)],
          ),
        ),
        HifzStudent(
          name: "",
          points: 0,
          assetImage: "",
          gradient: const LinearGradient(
            colors: [
               Color.fromARGB(255, 225, 221, 104),
            Color.fromARGB(255, 206, 203, 43)
            ],
          ),
        ),
      ]));
    }

    // Save the updated data
    StudentDataService.saveData(academicYear);
  }

  // Implementation for _initializeOrLoadPreviousYear method
  void _initializeOrLoadPreviousYear(String prevYear) {
    // Check if data for this year already exists in our service
    _loadPreviousYearData(prevYear);
  }

  // Helper method to load previous year data
  Future<void> _loadPreviousYearData(String year) async {
    try {
      final savedData = await StudentDataService.loadData();

      if (savedData != null) {
        // Check if the year exists in saved data
        final yearData =
            savedData.where((month) => month.year == year).toList();

        if (yearData.isNotEmpty) {
          // If data for this year exists, use it
          setState(() {
            academicYear.insertAll(0, yearData);
            _selectedYear = year;
          });
          return;
        }
      }

      // If no data found, initialize new year data
      _initializeEmptyPreviousYear(year);
    } catch (e) {
      debugPrint('Error loading previous year data: $e');
      _initializeEmptyPreviousYear(year);
    }
  }

  // Helper method to initialize empty previous year
  void _initializeEmptyPreviousYear(String year) {
    List<String> months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];

    List<MonthlyData> previousYearData = [];

    // Create empty data for each month of the previous year
    for (String month in months) {
      previousYearData.add(MonthlyData(month: month, year: year, students: [
        HifzStudent(
          name: "",
          points: 0,
          assetImage: "",
          gradient: const LinearGradient(
            colors: [Color(0xFF1E88E5), Color(0xFF64B5F6)],
          ),
        ),
        HifzStudent(
          name: "",
          points: 0,
          assetImage: "",
          gradient: const LinearGradient(
            colors: [Color(0xFF7B1FA2), Color(0xFFBA68C8)],
          ),
        ),
        HifzStudent(
          name: "",
          points: 0,
          assetImage: "",
          gradient: const LinearGradient(
            colors: [Color(0xFF388E3C), Color(0xFF81C784)],
          ),
        ),
        HifzStudent(
          name: "",
          points: 0,
          assetImage: "",
          gradient: const LinearGradient(
            colors: [Color(0xFFE64A19), Color(0xFFFF8A65)],
          ),
        ),
        HifzStudent(
          name: "",
          points: 0,
          assetImage: "",
          gradient: const LinearGradient(
            colors: [
               Color.fromARGB(255, 225, 221, 104),
            Color.fromARGB(255, 206, 203, 43)
            ],
          ),
        ),
      ]));
    }

    setState(() {
      academicYear.insertAll(0, previousYearData);
      _selectedYear = year;
    });

    // Save the updated data
    StudentDataService.saveData(academicYear);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios, // iOS-style back button icon
              color: Colors.black, // Set the color of the icon
            ),
            onPressed: () {
              // Navigate to StudentDetailsApp
              Navigator.pop(context);
            }),
        title: ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [Colors.blue, Colors.purple],
          ).createShader(bounds),
          child: const Text(
            'STAR OF THE MONTH',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1A237E), // Deep Indigo
              Color(0xFF0D47A1), // Deep Blue
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
                  _buildTopThree(),
                  _buildRemainingStudents(),
                ],
              ),
            ),
          ],
        ),
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
             onPressed: _previousMonth,
          ),
          GestureDetector(
            onTap: () => _showYearPicker(context),
            child: Row(
              children: [
                Text(
                  "${currentData.month} ${currentData.year}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 5),
                const Icon(Icons.arrow_drop_down, color: Colors.white),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios, color: Colors.white),
           onPressed: _nextMonth,
          ),
        ],
      ),
    );
  }

  // Enhanced Year Picker with better UI
  void _showYearPicker(BuildContext context) {
    // Generate list of years from 2020 to 2040
    List<String> years =
        List.generate(31, (index) => (2020 + index).toString());

    // Get the current year from the academicYear data
    String selectedYear = _selectedYear;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 8,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF1A237E), // Deep Indigo
                      Color(0xFF3949AB), // Indigo
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Stylish header
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.calendar_today,
                            color: Colors.white,
                          ),
                          SizedBox(width: 10),
                          Text(
                            'Select Academic Year',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(color: Colors.indigo, thickness: 1),

                    // Year grid
                    Container(
                      height: 300,
                      width: 300,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 1.5,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemCount: years.length,
                        itemBuilder: (context, index) {
                          final year = years[index];
                          final isSelected = year == selectedYear;

                          return InkWell(
                            onTap: () async {
                              // Update local selected year first
                              setDialogState(() {
                                selectedYear = year;
                              });

                              // Close the dialog
                              Navigator.pop(context);

                              // Update the year in our state
                              _updateYearForAllMonths(year);

                              // Show feedback with animation
                              _showYearSelectedAnimation(context, year);
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? Colors.white
                                    : Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: isSelected
                                    ? [
                                        BoxShadow(
                                          color: Colors.white.withOpacity(0.3),
                                          blurRadius: 8,
                                          spreadRadius: 2,
                                        )
                                      ]
                                    : null,
                              ),
                              child: Center(
                                child: Text(
                                  year,
                                  style: TextStyle(
                                    color: isSelected
                                        ? const Color(0xFF1A237E)
                                        : Colors.white,
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    // Cancel button
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Text(
                          'CANCEL',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // Show animation when year is selected
  void _showYearSelectedAnimation(BuildContext context, String year) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 10),
            Text('Year changed to $year',
                style: const TextStyle(fontSize: 16)),
          ],
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  // Update year for all months in academicYear
  void _updateYearForAllMonths(String newYear) {
    // Find the month index for the current month name but in the new year
    final currentMonthName = academicYear[_currentMonthIndex].month;
    
    setState(() {
      // First check if we already have this year's data
      bool yearExists = academicYear.any((data) => data.year == newYear);
      
      if (!yearExists) {
        // Add the new year's data
        if (int.parse(newYear) < int.parse(_selectedYear)) {
          _initializeEmptyPreviousYear(newYear);
        } else {
          _initializeNewYear(newYear);
        }
      }
      
      // Find the month index in the new year
      int newMonthIndex = academicYear.indexWhere(
        (data) => data.year == newYear && data.month == currentMonthName
      );
      
      if (newMonthIndex != -1) {
        _currentMonthIndex = newMonthIndex;
        _selectedYear = newYear;
        currentStudents = academicYear[_currentMonthIndex].students;
      }
    });
    
    // Save updated data
    StudentDataService.saveData(academicYear);
  }

  Widget _buildTopThree() {
    // Sort students by points in descending order
    final sortedStudents = List<HifzStudent>.from(currentStudents)
      ..sort((a, b) => b.points.compareTo(a.points));

    // Take top 3 students (or less if not enough valid students)
    final validStudents =
        sortedStudents.where((s) => s.name.isNotEmpty && s.points > 0).toList();
    final topThree = validStudents.take(3).toList();

    // If less than 3 valid students, pad with empty spots
    while (topThree.length < 3) {
      topThree.add(HifzStudent(
        name: "",
        points: 0,
        assetImage: "",
        gradient: const LinearGradient(
          colors: [Colors.grey, Colors.blueGrey],
        ),
      ));
    }

    return SliverToBoxAdapter(
      child: Container(
        height: 250,
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // 2nd Place (Left)
            if (topThree.length > 1) _buildWinner(topThree[1], 2, 0.85),

            // 1st Place (Middle)
            if (topThree.isNotEmpty) _buildWinner(topThree[0], 1, 1.14),

            // 3rd Place (Right)
            if (topThree.length > 2) _buildWinner(topThree[2], 3, 0.85),
          ],
        ),
      ),
    );
  }

  Widget _buildWinner(HifzStudent student, int position, double scale) {
    // Return empty container if student name is empty (no data)
    if (student.name.isEmpty) {
      return SizedBox(
        width: 101 * scale,
        height: 201 * scale,
        child: Center(
          child: Text(
            "No - $position",
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 14,
            ),
          ),
        ),
      );
    }

    Color medalColor;
    String asset;

    switch (position) {
      case 1:
        medalColor = Colors.amber;
        asset = "assets/gold_medal.png";
        break;
      case 2:
        medalColor = const Color(0xFFC0C0C0); // Silver
        asset = "assets/silver_medal.png";
        break;
      default:
        medalColor = const Color(0xFFCD7F32); // Bronze
        asset = "assets/bronze_medal.png";
        break;
    }

    return SizedBox(
      width: 100 * scale,
      height: 220 * scale,
      child: Column(
        children: [
          // Medal icon
          Container(
            width: 40 * scale,
            height: 40 * scale,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: medalColor,
              boxShadow: [
                BoxShadow(
                  color: medalColor.withOpacity(0.5),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Center(
              child: Text(
                "$position",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18 * scale,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Avatar
          Hero(
            tag: "student_${student.name}",
            child: Container(
              width: 80 * scale,
              height: 80 * scale,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: student.gradient,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: ClipOval(
                child: student.assetImage.isNotEmpty
                    ? Image.asset(
                        student.assetImage,
                        fit: BoxFit.cover,
                      )
                    : Icon(
                        Icons.person,
                        size: 40 * scale,
                        color: Colors.white.withOpacity(0.8),
                      ),
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Name and points
          Text(
            student.name,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16 * scale,
            ),
            textAlign: TextAlign.center,
            // maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 5),
          // Points,
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
                color: student.gradient.colors.first.withOpacity(0.7),
            ),
            child: Text(
              "${student.points} points",
              style: TextStyle(
                 color: Colors.white,
                  fontWeight: FontWeight.w300,
                  fontSize: 14 * scale,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRemainingStudents() {
    // Sort students by points in descending order
    final sortedStudents = List<HifzStudent>.from(currentStudents)
      ..sort((a, b) => b.points.compareTo(a.points));

    // Get students starting from position 4 (index 3)
    final validStudents =
        sortedStudents.where((s) => s.name.isNotEmpty && s.points > 0).toList();

    // Skip top 3 or just show all if less than or equal to 3
    final remainingStudents =
        validStudents.length > 3 ? validStudents.sublist(3) : [];

    if (remainingStudents.isEmpty) {
      return SliverToBoxAdapter(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              "No additional students to display for ${academicYear[_currentMonthIndex].month}",
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: SliverList(
        delegate: SliverChildListDelegate([
          // Header for the list
          if (remainingStudents.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: const Text(
                "OTHER TOP PERFORMERS",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),

          // List of remaining students
          ...List.generate(remainingStudents.length, (index) {
            final student = remainingStudents[index];
            return _buildStudentListItem(
                student, index + 4); // Start from position 4
          }),
        ]),
      ),
    );
  }
  
  Widget _buildStudentListItem(HifzStudent student, int position) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white.withOpacity(0.1),
        ),
        child: ListTile(
          // onTap: () => _showStudentEditDialog(position - (position > 3 ? 4 : 0)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 5, vertical: 6),
          leading: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Position number
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: student.gradient.colors.first.withOpacity(0.7),
                ),
                child: Center(
                  child: Text(
                    "$position",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Student avatar
              Hero(
                tag: "list_student_${student.name}",
                child: Container(
                  width: 55,
                  height: 55,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: student.gradient,
                  ),
                  child: ClipOval(
                    child: student.assetImage.isNotEmpty
                        ? Image.asset(
                            student.assetImage,
                            fit: BoxFit.cover,
                          )

                        : const Icon(
                            Icons.person,
                            size: 30,
                            color: Colors.white,
                          ),
                  ),
                ),
              ),
            ],
          ),

          title: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      student.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),


              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 4,
                  horizontal: 12,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: student.gradient.colors.first.withOpacity(0.7),
                ),
                child: Text(
                  "${student.points} points",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),            ],
          ),
        ),
      ),
    );

  }
  // Show dialog to edit student data
  void _showStudentEditDialog(int studentIndex) {
    final student = currentStudents[studentIndex];
    
    // Controllers for text fields
    TextEditingController nameController = TextEditingController(text: student.name);
    TextEditingController pointsController = TextEditingController(text: student.points.toString());
    TextEditingController imagePathController = TextEditingController(text: student.assetImage);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit Student"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: "Student Name",
                    hintText: "Enter student name",
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: pointsController,
                  decoration: const InputDecoration(
                    labelText: "Points",
                    hintText: "Enter points scored",
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: imagePathController,
                  decoration: const InputDecoration(
                    labelText: "Image Path",
                    hintText: "assets/student_name.png",
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("CANCEL"),
            ),
            ElevatedButton(
              onPressed: () {
                // Validate and save data
                final newName = nameController.text.trim();
                final newPointsText = pointsController.text.trim();
                final newImagePath = imagePathController.text.trim();

                if (newName.isNotEmpty && newPointsText.isNotEmpty) {
                  try {
                    final newPoints = int.parse(newPointsText);
                    
                    setState(() {
                      // Update student data
                      currentStudents[studentIndex].name = newName;
                      currentStudents[studentIndex].points = newPoints;
                      currentStudents[studentIndex].assetImage = newImagePath;
                      
                      // Save the updated data
                      StudentDataService.saveData(academicYear);
                    });
                    
                    // Close dialog
                    Navigator.pop(context);
                    
                    // Show success message
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Student data updated successfully')),
                    );
                  } catch (e) {
                    // Show error for invalid points
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please enter a valid number for points')),
                    );
                  }
                } else {
                  // Show error for empty fields
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Name and points cannot be empty')),
                  );
                }
              },
              child: const Text("SAVE"),
            ),
          ],
        );
      },
    );
  }
}

// Service to save and load student data using local storage
class StudentDataService {
  // Save data to local storage
  static Future<void> saveData(List<MonthlyData> data) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/hifz_student_data.json');
      
      // Convert data to JSON
      final jsonData = jsonEncode(data.map((month) => {
        'month': month.month,
        'year': month.year,
        'students': month.students.map((student) => {
          'name': student.name,
          'points': student.points,
          'assetImage': student.assetImage,
          'gradient': {
            'colors': [
              student.gradient.colors[0].value,
              student.gradient.colors[1].value,
            ],
          },
        }).toList(),
      }).toList());
      
      // Write to file
      await file.writeAsString(jsonData);
      debugPrint('Data saved successfully');
    } catch (e) {
      debugPrint('Error saving data: $e');
    }
  }

  // Load data from local storage
  static Future<List<MonthlyData>?> loadData() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/hifz_student_data.json');
      
      // Check if file exists
      if (!await file.exists()) {
        debugPrint('No saved data found');
        return null;
      }
      
      // Read file
      final jsonString = await file.readAsString();
      final List<dynamic> jsonData = jsonDecode(jsonString);
      
      // Convert JSON to MonthlyData
      final data = jsonData.map<MonthlyData>((monthJson) {
        final studentsList = (monthJson['students'] as List).map<HifzStudent>((studentJson) {
          final gradientColors = (studentJson['gradient']['colors'] as List)
              .map<Color>((colorValue) => Color(colorValue as int))
              .toList();
          
          return HifzStudent(
            name: studentJson['name'] as String,
            points: studentJson['points'] as int,
            assetImage: studentJson['assetImage'] as String,
            gradient: LinearGradient(
              colors: gradientColors,
            ),
          );
        }).toList();
        
        return MonthlyData(
          month: monthJson['month'] as String,
          year: monthJson['year'] as String,
          students: studentsList,
        );
      }).toList();
      
      debugPrint('Data loaded successfully');
      return data;
    } catch (e) {
      debugPrint('Error loading data: $e');
      return null;
    }
  }
}
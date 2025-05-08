import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class MonthlyData {
  final String month;
  late final String year;
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
  String assetImage; // Changed from AssetImage to assetImage for Dart naming conventions
  final LinearGradient gradient;

  HifzStudent({
    required this.name,
    required this.points,
    required this.assetImage, // Changed from AssetImage
    required this.gradient,
  });
}

class MonthlyTopperControlPage extends StatefulWidget {
  const MonthlyTopperControlPage({super.key}); // Added Key? for null safety

  @override
  _MonthlyTopperPageState createState() => _MonthlyTopperPageState();
}

class _MonthlyTopperPageState extends State<MonthlyTopperControlPage>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _shimmerController;
  late List<HifzStudent> currentStudents;
  int _currentMonthIndex = 0;
  final ImagePicker _picker = ImagePicker();
  
  // Add a variable to track the selected year
  String _selectedYear = "2025"; // Default year

  // Create a more comprehensive list of months with proper initialization
  final List<MonthlyData> academicYear = [];

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

    // Initialize the academic year with all months
    _initializeAcademicYear();
    currentStudents = academicYear[_currentMonthIndex].students;
  }

  void _initializeAcademicYear() {
    // Create a list of all months
    List<String> months = [
      'January', 'February', 'March', 'April',
      'May', 'June', 'July', 'August',
      'September', 'October', 'November', 'December'
    ];

    // First, add the existing data (January and February with students)
    academicYear.add(
      MonthlyData(month: "January", year: _selectedYear, students: [
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
            colors: [Color(0xFFC62828), Color(0xFFE57373)],
          ),
        ),
      ])
    );

    academicYear.add(
      MonthlyData(month: "February", year: _selectedYear, students: [
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
            colors: [Color(0xFFC62828), Color(0xFFE57373)],
          ),
        ),
      ])
    );

    // Add remaining months with empty student lists
    for (int i = 2; i < months.length; i++) {
      academicYear.add(
        MonthlyData(month: months[i], year: _selectedYear, students: [
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
              colors: [Color(0xFFC62828), Color(0xFFE57373)],
            ),
          ),
        ])
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  Future<void> _editStudent(HifzStudent student) async {
    final TextEditingController nameController =
        TextEditingController(text: student.name);
    final TextEditingController pointsController =
        TextEditingController(text: student.points.toString());

    String? validatePoints(String? value) {
      if (value == null || value.isEmpty) return 'Points cannot be empty';
      if (int.tryParse(value) == null) return 'Please enter a valid number';
      if (int.parse(value) < 0) return 'Points cannot be negative';
      if (int.parse(value) > 2000) return 'Points cannot exceed 2000';
      return null;
    }

    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Edit Student Details'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: student.gradient,
                          ),
                          child: ClipOval(
                            child: student.assetImage.startsWith('assets/')
                                ? Image.asset(
                                    student.assetImage,
                                    fit: BoxFit.cover,
                                  )
                                : student.assetImage.isNotEmpty
                                    ? Image.file(
                                        File(student.assetImage),
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) {
                                          return const Icon(Icons.person, size: 50);
                                        },
                                      )
                                    : const Icon(Icons.person, size: 60),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            child: IconButton(
                              icon: const Icon(Icons.camera_alt),
                              onPressed: () async {
                                await _pickImage(student);
                                setDialogState(() {}); // Refresh dialog UI
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Student Name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: pointsController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Points',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    String? pointsError = validatePoints(pointsController.text);
                    if (pointsError != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(pointsError)),
                      );
                      return;
                    }

                    setState(() {
                      student.name = nameController.text;
                      student.points = int.parse(pointsController.text);
                      
                      // Refresh current students list
                      currentStudents = academicYear[_currentMonthIndex].students;
                    });

                    Navigator.pop(context);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Student details updated successfully'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _pickImage(HifzStudent student) async {
    try {
      final XFile? pickedImage = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        // Get app's local directory
        final directory = await getApplicationDocumentsDirectory();
        final String path = directory.path;
        
        // Create a unique filename
        final String fileName = 'student_${DateTime.now().millisecondsSinceEpoch}.jpg';
        final String localPath = '$path/$fileName';
        
        // Copy the picked image to local storage
        final File localImage = File(pickedImage.path);
        await localImage.copy(localPath);
        
        setState(() {
          student.assetImage = localPath;
        });
        
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Photo updated successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error picking image: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _nextMonth() {
    setState(() {
      if (_currentMonthIndex < academicYear.length - 1) {
        _currentMonthIndex++;
        currentStudents = academicYear[_currentMonthIndex].students;
      }
    });
  }

  void _previousMonth() {
    setState(() {
      if (_currentMonthIndex > 0) {
        _currentMonthIndex--;
        currentStudents = academicYear[_currentMonthIndex].students;
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
            'Hifz Champions',
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
          onPressed: _currentMonthIndex > 0 ? _previousMonth : null,
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
          onPressed: _currentMonthIndex < academicYear.length - 1
              ? _nextMonth
              : null,
        ),
      ],
    ),
  );
}

// Add these methods to handle month navigation correctly
void previousMonth() {
  setState(() {
    _currentMonthIndex--;
    // No need to modify year here as it's handled in the academicYear data
  });
}

void nextMonth() {
  setState(() {
    _currentMonthIndex++;
    // No need to modify year here as it's handled in the academicYear data
  });
}

// Enhanced Year Picker with better UI
void _showYearPicker(BuildContext context) {
  // Generate list of years from 2020 to 2040
  List<String> years = List<String>.generate(
    21, (index) => (2020 + index).toString()
  );
  
  // Get the current year from the academicYear data
  String selectedYear = academicYear[_currentMonthIndex].year;
  
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
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                          onTap: () {
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
                                  color: isSelected ? const Color(0xFF1A237E) : Colors.white,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
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
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
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

// New method to update the year for all months
void _updateYearForAllMonths(String year) {
  setState(() {
    // Update all month entries with the new year
    for (var i = 0; i < academicYear.length; i++) {
      academicYear[i].year = year;
    }
    
    // Make sure we're updating the UI by forcing a rebuild
    _selectedYear = year; // Make sure we're tracking the selected year
    
    // Trigger a rebuild of the UI
    if (mounted) {
      setState(() {}); // Empty setState to ensure UI refresh
    }
  });
}

// Show an animated confirmation for year selection
void _showYearSelectedAnimation(BuildContext context, String year) {
  late final OverlayEntry overlayEntry;
  overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      bottom: 100,
      left: 0,
      right: 0,
      child: Center(
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 600),
          curve: Curves.elasticOut,
          builder: (context, value, child) {
            return Transform.scale(
              scale: value,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF43A047), Color(0xFF66BB6A)],
                  ),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Year $year Selected',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          onEnd: () {
            Future.delayed(const Duration(seconds: 1), () {
              overlayEntry.remove();
            });
          },
        ),
      ),
    ),
  );

  // Add the overlay to the screen
  Overlay.of(context).insert(overlayEntry);
}

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
          angle: _shimmerController.value * 2 * pi,
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
      const Offset(-115, 40), // Second place
      const Offset(0, -40), // First place
      const Offset(115, 40), // Third place
    ];

    final sizes = [140.0, 180.0, 140.0];
    final delays = [300, 0, 500];
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
        Stack(
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
                    child: student.assetImage.isEmpty
                        ? Center(  // Added Center widget here
                            child: Icon(
                              Icons.person, 
                              size: 60, 
                              color: Colors.white70
                            )
                          )
                        : student.assetImage.startsWith('assets/')
                            ? Image.asset(
                                student.assetImage,
                                width: size,
                                height: size,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Center(  // Added Center widget here
                                    child: Icon(
                                      Icons.person, 
                                      size: 60, 
                                      color: Colors.white70
                                    )
                                  );
                                },
                              )
                            : Image.file(
                                File(student.assetImage),
                                width: size,
                                height: size,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Center(  // Added Center widget here
                                    child: Icon(
                                      Icons.person, 
                                      size: 60, 
                                      color: Colors.white70
                                    )
                                  );
                                },
                              ),
                  ),
                  // Edit button
                  Positioned(
                    right: size * 0.2,
                    bottom: 0,
                    child: CircleAvatar(
                      radius: size * 0.10,
                      backgroundColor: Colors.white,
                      child: IconButton(
                        iconSize: size * 0.10,
                        padding: EdgeInsets.zero,
                        icon: const Icon(Icons.edit, color: Colors.black),
                        onPressed: () => _editStudent(student),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (index == 1) // Champion crown
              Positioned(
                top: 0,
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
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color.fromARGB(255, 230, 198, 13), Color.fromARGB(255, 214, 141, 16)],
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
                            '👑 TOPPER',
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
        const SizedBox(height: 16),
        Text(
          student.name.isEmpty ? "No Data" : student.name,
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
    final students = academicYear[_currentMonthIndex].students;
    
    // Check if we have more than 3 students to display
    if (students.length <= 3) {
      return SliverToBoxAdapter(child: Container());
    }
    
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final actualIndex = index + 3; // Skip the top 3
          if (actualIndex >= students.length) return null;
          
          final student = students[actualIndex];
          return _buildRankCard(student, actualIndex + 1);
        },
        childCount: students.length - 3,
      ),
    );
  }

  Widget _buildRankCard(HifzStudent student, int rank) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white.withOpacity(0.1),
                  Colors.white.withOpacity(0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.white.withOpacity(0.1),
                width: 1,
              ),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              leading: Stack(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: student.gradient,
                    ),
                    child: ClipOval(
                      child: student.assetImage.isEmpty
                          ? const Icon(Icons.person, size: 40, color: Colors.white70)
                          : student.assetImage.startsWith('assets/')
                              ? Image.asset(
                                  student.assetImage,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(Icons.person, size: 40, color: Colors.white70);
                                  },
                                )
                              : Image.file(
                                  File(student.assetImage),
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(Icons.person, size: 40, color: Colors.white70);
                                  },
                                ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      radius: 12,
                      backgroundColor: Colors.white,
                      child: Text(
                        rank.toString(),
                        style: TextStyle(
                          color: student.gradient.colors.first,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              title: Text(
                student.name.isEmpty ? "No Data" : student.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              subtitle: Text(
                '${student.points} Points',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 14,
                ),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.edit, color: Colors.white),
                onPressed: () => _editStudent(student),
              ),
            ),
          ),
        );
      },
    );
  }
}

// Main app for the Monthly Topper feature
class MonthlyTopperApp extends StatelessWidget {
  const MonthlyTopperApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hifz Champions',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MonthlyTopperControlPage(),
    );
  }
}

// Optional: Add a persistence layer to save student data

class StudentDataService {
  static const String _storageKey = 'hifz_champions_data';
  
  // Save all academic year data
  static Future<void> saveData(List<MonthlyData> academicYear) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$_storageKey.json');
      
      // Convert to JSON serializable format
      final data = academicYear.map((month) => {
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
            ]
          }
        }).toList(),
      }).toList();
      
      // Write to file
      await file.writeAsString(jsonEncode(data));
    } catch (e) {
      print('Error saving data: $e');
    }
  }
  
  // Load all academic year data
  static Future<List<MonthlyData>?> loadData() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$_storageKey.json');
      
      if (!await file.exists()) {
        return null;
      }
      
      final contents = await file.readAsString();
      final List<dynamic> jsonData = jsonDecode(contents);
      
      // Convert from JSON to our object model
      return jsonData.map<MonthlyData>((monthData) {
        return MonthlyData(
          month: monthData['month'],
          year: monthData['year'],
          students: (monthData['students'] as List).map<HifzStudent>((studentData) {
            return HifzStudent(
              name: studentData['name'],
              points: studentData['points'],
              assetImage: studentData['assetImage'],
              gradient: LinearGradient(
                colors: [
                  Color(studentData['gradient']['colors'][0]),
                  Color(studentData['gradient']['colors'][1]),
                ],
              ),
            );
          }).toList(),
        );
      }).toList();
    } catch (e) {
      print('Error loading data: $e');
      return null;
    }
  }
}

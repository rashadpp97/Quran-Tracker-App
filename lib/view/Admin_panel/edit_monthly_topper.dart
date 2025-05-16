import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';


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

class MonthlyTopperControlPage extends StatefulWidget {
  const MonthlyTopperControlPage({super.key});

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
            Color.fromARGB(255, 168, 99, 111),
            Color.fromARGB(255, 214, 122, 164)
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
            Color.fromARGB(255, 168, 99, 111),
            Color.fromARGB(255, 214, 122, 164)
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
              Color.fromARGB(255, 168, 99, 111),
              Color.fromARGB(255, 214, 122, 164)
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

  // Initialize the image picker in your class
final ImagePicker picker = ImagePicker();

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
                          child: _buildStudentImage(student),
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
                              await _showImageSourceDialog(student, setDialogState);
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
                    currentStudents =
                        academicYear[_currentMonthIndex].students;

                    // Save updated data
                    StudentDataService.saveData(academicYear);
                  });

                  Navigator.pop(context);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Student details updated successfully'),
                      backgroundColor: Colors.lightBlueAccent,
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

// Helper method to build the student image
Widget _buildStudentImage(HifzStudent student) {
  // Check if the student has a custom image path
  if (student.assetImage.startsWith('assets/')) {
    // Asset image
    return Image.asset(
      student.assetImage,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return const Icon(Icons.person, size: 60, color: Colors.white70);
      },
    );
  } else if (student.assetImage.isNotEmpty) {
    // File image (previously picked)
    return Image.file(
      File(student.assetImage),
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        print("Error loading image: $error");
        return const Icon(Icons.person, size: 60, color: Colors.white70);
      },
    );
  } else {
    // Default placeholder
    return const Icon(Icons.person, size: 60, color: Colors.white70);
  }
}

// Show a dialog to choose between camera and gallery
Future<void> _showImageSourceDialog(HifzStudent student, StateSetter setDialogState) async {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Select Image Source'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              GestureDetector(
                child: const ListTile(
                  leading: Icon(Icons.photo_camera),
                  title: Text('Take a Photo'),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(student, ImageSource.camera, setDialogState);
                },
              ),
              const Divider(),
              GestureDetector(
                child: const ListTile(
                  leading: Icon(Icons.photo_library),
                  title: Text('Choose from Gallery'),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(student, ImageSource.gallery, setDialogState);
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}

// Enhanced image picking function
Future<void> _pickImage(HifzStudent student, ImageSource source, StateSetter setDialogState) async {
  try {
    // Check for permissions first
    PermissionStatus status;
    
    if (source == ImageSource.camera) {
      status = await Permission.camera.request();
    } else {
      status = await Permission.photos.request();
    }
    
    if (status.isGranted) {
      // Permission granted, proceed with picking
      final XFile? pickedImage = await _picker.pickImage(
        source: source,
        imageQuality: 80, // Reduce quality for better performance
        maxWidth: 800,    // Limit image size
      );
      
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
          // Save updated data
          StudentDataService.saveData(academicYear);
        });
        
        // Also update the dialog UI
        setDialogState(() {});

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Photo updated successfully'),
            backgroundColor: Colors.lightBlueAccent,
          ),
        );
      }
    } else if (status.isPermanentlyDenied) {
      // Permissions permanently denied, navigate to settings
      await openAppSettings();
    } else {
      // Permission denied but not permanently
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Permission denied to access media'),
          backgroundColor: Colors.redAccent,
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

  // Fix the month navigation to handle year changes
  // Fixed month navigation to handle year changes
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
              Color.fromARGB(255, 168, 99, 111),
              Color.fromARGB(255, 214, 122, 164)
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
              Color.fromARGB(255, 168, 99, 111),
              Color.fromARGB(255, 214, 122, 164)
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
        List.generate(21, (index) => (2020 + index).toString());

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


  // Show an animated confirmation for year selection
  // void _showYearSelectedAnimation(BuildContext context, String year) {
  //   late final OverlayEntry overlayEntry;
  //   overlayEntry = OverlayEntry(
  //     builder: (context) => Positioned(
  //       bottom: 100,
  //       left: 0,
  //       right: 0,
  //       child: Center(
  //         child: TweenAnimationBuilder<double>(
  //           tween: Tween(begin: 0.0, end: 1.0),
  //           duration: const Duration(milliseconds: 600),
  //           curve: Curves.elasticOut,
  //           builder: (context, value, child) {
  //             return Transform.scale(
  //               scale: value,
  //               child: Container(
  //                 padding:
  //                     const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
  //                 decoration: BoxDecoration(
  //                   gradient: const LinearGradient(
  //                     colors: [Color(0xFF43A047), Color(0xFF66BB6A)],
  //                   ),
  //                   borderRadius: BorderRadius.circular(30),
  //                   boxShadow: [
  //                     BoxShadow(
  //                       color: Colors.black.withOpacity(0.3),
  //                       blurRadius: 10,
  //                       spreadRadius: 1,
  //                     ),
  //                   ],
  //                 ),
  //                 child: Row(
  //                   mainAxisSize: MainAxisSize.min,
  //                   children: [
  //                     const Icon(
  //                       Icons.check_circle,
  //                       color: Colors.white,
  //                     ),
  //                     const SizedBox(width: 10),
  //                     Text(
  //                       'Year $year Selected',
  //                       style: const TextStyle(
  //                         color: Colors.white,
  //                         fontWeight: FontWeight.bold,
  //                         fontSize: 16,
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             );
  //           },
  //           onEnd: () {
  //             Future.delayed(const Duration(milliseconds: 2000), () {
  //               overlayEntry.remove();
  //             });
  //           },
  //         ),
  //       ),
  //     ),
  //   );

  //   Overlay.of(context).insert(overlayEntry);
  // }

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

    return GestureDetector(
      onTap: () => _editStudent(student),
      child: SizedBox(
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
                  child: student.assetImage.startsWith('assets/')
                      ? Image.asset(
                          student.assetImage,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              Icons.person,
                              size: 40 * scale,
                              color: Colors.white,
                            );
                          },
                        )
                      : student.assetImage.isNotEmpty
                          ? Image.file(
                              File(student.assetImage),
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(
                                  Icons.person,
                                  size: 40 * scale,
                                  color: Colors.white,
                                );
                              },
                            )
                          : Icon(
                              Icons.person,
                              size: 40 * scale,
                              color: Colors.white,
                            ),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Name
            Text(
              student.name,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16 * scale,
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 5),

            // Points
            Container(
              padding: EdgeInsets.symmetric(
                vertical: 3 * scale,
                horizontal: 10 * scale,
              ),
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
    final remainingStudents =
        validStudents.length > 3 ? validStudents.sublist(3) : <HifzStudent>[];

    return SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: SliverList(
        delegate: SliverChildListDelegate([
          // Header for the list
          if (remainingStudents.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: const Text(
                "Other Top Performers",
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

          // Add Student Button (only show if there are less than 10 students)
          if (validStudents.length < 15)
            Container(
              margin: const EdgeInsets.symmetric(vertical: 16),
              child: ElevatedButton.icon(
                onPressed: _addNewStudent,
                icon: const Icon(Icons.person_add, color: Colors.white),
                label: const Text("Add Student"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),
        ]),
      ),
    );
  }

  Widget _buildStudentListItem(HifzStudent student, int position) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: GestureDetector(
        onTap: () => _editStudent(student),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(0.1),
                Colors.white.withOpacity(0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
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
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Student avatar
              Container(
                width: 55,
                height: 55,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: student.gradient,
                ),
                child: ClipOval(
                  child: student.assetImage.startsWith('assets/')
                      ? Image.asset(
                          student.assetImage,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.person,
                              size: 30,
                              color: Colors.white,
                            );
                          },
                        )
                      : student.assetImage.isNotEmpty
                          ? Image.file(
                              File(student.assetImage),
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(
                                  Icons.person,
                                  size: 30,
                                  color: Colors.white,
                                );
                              },
                            )
                          : const Icon(
                              Icons.person,
                              size: 30,
                              color: Colors.white,
                            ),
                ),
              ),
              const SizedBox(width: 16),

              // Student details
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
                    // const SizedBox(height: 4),
                    // Container(
                    //   width: 100,
                    //   height: 6,
                    //   decoration: BoxDecoration(
                    //     borderRadius: BorderRadius.circular(10),
                    //     color: Colors.white.withOpacity(0.1),
                    //   ),
                    //   // child: Stack(
                    //   //   children: [
                    //   //     Container(
                    //   //       width: (student.points / 1000) * 100, // Scale points to width
                    //   //       decoration: BoxDecoration(
                    //   //         borderRadius: BorderRadius.circular(10),
                    //   //         gradient: LinearGradient(
                    //   //           colors: [
                    //   //             Colors.blue,
                    //   //             Colors.purple,
                    //   //           ],
                    //   //         ),
                    //   //       ),
                    //   //     ),
                    //   //   ],
                    //   // ),
                    // ),
                  ],
                ),
              ),

              // Points
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _addNewStudent() {
    // Create a new student with default values
    final newStudent = HifzStudent(
      name: "",
      points: 0,
      assetImage: "",
      gradient: LinearGradient(
        colors: [
          Colors.primaries[Random().nextInt(Colors.primaries.length)],
          Colors.primaries[Random().nextInt(Colors.primaries.length)],
        ],
      ),
    );

    // Add the new student to the current month
    setState(() {
      academicYear[_currentMonthIndex].students.add(newStudent);
      currentStudents = academicYear[_currentMonthIndex].students;
    });

    // Open edit dialog for the new student
    _editStudent(newStudent);

    // Save the updated data
    StudentDataService.saveData(academicYear);
  }
}

// Service class for managing student data persistence
class StudentDataService {
  static const String _storageKey = "monthly_topper_data";

  // Convert MonthlyData to JSON
  static Map<String, dynamic> _monthlyDataToJson(MonthlyData data) {
    return {
      'month': data.month,
      'year': data.year,
      'students':
          data.students.map((student) => _studentToJson(student)).toList(),
    };
  }

  // Convert HifzStudent to JSON
  static Map<String, dynamic> _studentToJson(HifzStudent student) {
    return {
      'name': student.name,
      'points': student.points,
      'assetImage': student.assetImage,
      'gradient': {
        'colors': [
          (student.gradient.colors[0] as Color).value,
          (student.gradient.colors[1] as Color).value,
        ],
      },
    };
  }

  // Convert JSON to MonthlyData
  static MonthlyData _jsonToMonthlyData(Map<String, dynamic> json) {
    return MonthlyData(
      month: json['month'],
      year: json['year'],
      students: (json['students'] as List)
          .map((studentJson) => _jsonToStudent(studentJson))
          .toList(),
    );
  }

  // Convert JSON to HifzStudent
  static HifzStudent _jsonToStudent(Map<String, dynamic> json) {
    final gradientMap = json['gradient'] as Map<String, dynamic>;
    final colorsList = (gradientMap['colors'] as List).cast<int>();

    return HifzStudent(
      name: json['name'],
      points: json['points'],
      assetImage: json['assetImage'],
      gradient: LinearGradient(
        colors: colorsList.map((value) => Color(value)).toList(),
      ),
    );
  }

  // Save data to local storage
  static Future<void> saveData(List<MonthlyData> data) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$_storageKey.json');

      final jsonList =
          data.map((monthData) => _monthlyDataToJson(monthData)).toList();
      await file.writeAsString(jsonEncode(jsonList));

      debugPrint('Data saved successfully');
    } catch (e) {
      debugPrint('Error saving data: $e');
      throw Exception('Failed to save data: $e');
    }
  }

  // Load data from local storage
  static Future<List<MonthlyData>?> loadData() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$_storageKey.json');

      if (!await file.exists()) {
        debugPrint('No saved data found');
        return null;
      }

      final jsonString = await file.readAsString();
      final jsonList = jsonDecode(jsonString) as List;

      return jsonList.map((json) => _jsonToMonthlyData(json)).toList();
    } catch (e) {
      debugPrint('Error loading data: $e');
      throw Exception('Failed to load data: $e');
    }
  }

  // Delete all saved data (for debugging/testing)
  static Future<void> clearData() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$_storageKey.json');

      if (await file.exists()) {
        await file.delete();
        debugPrint('Data cleared successfully');
      }
    } catch (e) {
      debugPrint('Error clearing data: $e');
      throw Exception('Failed to clear data: $e');
    }
  }
}

// Optional: Create a main app entry point class
class HifzChampionsApp extends StatelessWidget {
  const HifzChampionsApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hifz Champions',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Poppins',
      ),
      home: const MonthlyTopperControlPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

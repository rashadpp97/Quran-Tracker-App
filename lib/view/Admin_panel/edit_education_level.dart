import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:quran_progress_tracker_app/view/Admin_panel/admins_panel_page.dart';

void main() {
  runApp(const EducationLevelControlPage());
}

class EducationLevelControlPage extends StatelessWidget {
  const EducationLevelControlPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hifz Progress Tracker',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: const Color(0xFFF8F9FD),
      ),
      home: const StudentListPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Student {
  String name;
  // final String id;
  String className;
  List<HifzData> hifzData;
  int totalJuzCompleted;
  Map<String, bool> attendance; // Added missing field

  Student({
    required this.name,
    // required this.id,
    required this.className,
    required this.hifzData,
    required this.totalJuzCompleted,
    required this.attendance, // Added required parameter
  });
}

class ClassData {
  final String name;
  final int studentCount;
  final List<Student> students;

  ClassData({
    required this.name,
    required this.studentCount,
    required this.students,
  });
}

class StudentListPage extends StatefulWidget {
  const StudentListPage({super.key});

  @override
  _StudentListPageState createState() => _StudentListPageState();
}

class _StudentListPageState extends State<StudentListPage> {
  late List<ClassData> classes;
  String selectedClass = ''; // Added missing variable
  
  final Map<String, List<String>> classStudents = {
    'حلقة أبي بكر الصديق': [
      'AFTHAB',
      'BILAL',
      'AZMI JUNAID',
      'HADI HASSAN',
      'HAMIZ HARSHAD',
      'MUHAMMED ARSHAD',
      'YAHYA',
      "ABDUL MUA'D",
      'FARIS AHMED',
    ],
    'حلقة عمر بن الخطاب': [
      'SALMAN FARIS',
      'IHTHISHAM',
      'NAHAN',
      'ABDULLA HAMDAN',
      'MISHAB SHAFI',
      'MUHAMMED FAHEEM C',
      'UZAIR',
      'FADI MUHAMMED',
      'HAFEEZ',
      'AJWAD'
    ],
    'حلقة عثمان بن عفان': [
      'MUHAMMED FAHEEM K',
      'ABDURAHMAN KHALID',
      'ABDULLA M',
      'ADIL SALEEM',
      'SHAYAN',
      'AZIM CK',
      'ABDULLA ZAKI',
      'FAAZ',
      'AMLAH IBNU SHAREEF',
      'MUHAMMED SHAYAN',
    ],
    'حلقة علي بن أبي طالب': [
      "MUA'D ANWAR",
      'AZIM E',
      'BASHEER',
      'HANI SADIQUE',
      'MISBAH',
      'ADNAN',
      'SULTHAN IBNU AKBAR',
      'HANOOR',
      'IBRAHIM',
      'AJSAL AMEEN',
      'THWALHA'
    ],
    'حلقة سعد بن أبي وقاص': [
      'AHMED JAZIM',
      'MUHAMMED SALIH',
      'EESA ABDULLA',
      'RAIHAN',
      'FAHEEM IBNU SATHAR',
      'FOUZAN SIDHIQUE',
      'IHSAN',
      'AJMAL MANAF',
      'AASWIL HAQ',
    ]
  };

  late List<Student> students;

  @override
  void initState() {
    super.initState();
    students = _initializeStudents();
    _initializeClasses(); // Added call to initialize classes
    // Set initial selected class
    if (classStudents.isNotEmpty) {
      selectedClass = classStudents.keys.first;
    }
  }

  void _initializeClasses() {
    classes = classStudents.entries.map((entry) {
      final className = entry.key;
      final studentNames = entry.value;
      final studentCount = studentNames.length;

      return ClassData(
        name: className,
        studentCount: studentCount,
        students: List.generate(
          studentCount,
          (index) => Student(
            name: studentNames[index],
            className: className,
            attendance: {},
            hifzData: [], // Added missing field
            totalJuzCompleted: 0, // Added missing field
          ),
        ),
      );
    }).toList();
  }

  List<Student> _initializeStudents() {
    List<Student> initializedStudents = [];
    // int idCounter = 1;

    classStudents.forEach((className, studentNames) {
      for (String name in studentNames) {
        initializedStudents.add(
          Student(
            name: name,
            // id: idCounter.toString().padLeft(3, '0'),
            className: className,
            totalJuzCompleted: 0,
            attendance: {}, // Added missing field value
            hifzData: [
              HifzData('Center', 0, const Color(0xFF6B48FF)),
              HifzData('Year 1', 0, const Color(0xFF4CAF50)),
              HifzData('Year 2', 0, const Color(0xFFFF6B6B)),
              HifzData('Year 3', 0, const Color(0xFF48C9FF)),
              HifzData('Year 4', 0, const Color(0xFFFFBE0B)),
              HifzData('Year 5', 0, const Color.fromARGB(255, 255, 72, 228)),
            ],
          ),
        );
        // idCounter++;
      }
    });

    return initializedStudents;
  }

  void _addClass(String className) {
    setState(() {
      classStudents[className] = [];
      _initializeClasses(); // Re-initialize classes after adding
    });
  }

  void _addStudent(String className, String studentName) {
    setState(() {
      classStudents[className]?.add(studentName);

      // Add the student to the students list
      students.add(
        Student(
          name: studentName,
          className: className,
          totalJuzCompleted: 0,
          attendance: {}, // Added missing field value
          hifzData: [
            HifzData('Center', 0, const Color(0xFF6B48FF)),
            HifzData('Year 1', 0, const Color(0xFF4CAF50)),
            HifzData('Year 2', 0, const Color(0xFFFF6B6B)),
            HifzData('Year 3', 0, const Color(0xFF48C9FF)),
            HifzData('Year 4', 0, const Color(0xFFFFBE0B)),
            HifzData('Year 5', 0, const Color.fromARGB(255, 255, 72, 228)),
          ],
        ),
      );
    });
  }

  void _editStudent(Student student, String newName) {
    setState(() {
      // Update the student's name in the students list
      student.name = newName;

      // Update the student's name in the classStudents map
      final classNamesList = classStudents[student.className];
      if (classNamesList != null) {
        final index = classNamesList.indexOf(student.name);
        if (index != -1) {
          classNamesList[index] = newName;
        }
      }
    });
  }

  void _deleteStudent(Student student) {
    setState(() {
      // Remove the student from the students list
      students.removeWhere(
          (s) => s.name == student.name && s.className == student.className);

      // Remove the student from the classStudents map
      classStudents[student.className]?.remove(student.name);
    });
  }

  // New method to remove a class
  void _removeClass(String className) {
    setState(() {
      classStudents.remove(className);
      _initializeClasses();
      
      // If the deleted class was selected, select the first available class
      if (selectedClass == className && classes.isNotEmpty) {
        selectedClass = classes.first.name;
      }
      
      _updateAttendanceCounts(); // Remove this line or implement the method
    });
  }

  // Added missing method
  void _updateAttendanceCounts() {
    // Implementation depends on what this method is supposed to do
    // This is just a placeholder
  }

  void _showAddClassDialog() {
    final TextEditingController classNameController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add New Class'),
          content: TextField(
            controller: classNameController,
            decoration: const InputDecoration(
              labelText: 'Class Name',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (classNameController.text.isNotEmpty) {
                  _addClass(classNameController.text);
                  Navigator.pop(context);
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _showAddStudentDialog(String className) {
    final TextEditingController studentNameController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Student to $className'),
          content: TextField(
            controller: studentNameController,
            decoration: const InputDecoration(
              labelText: 'Student Name',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (studentNameController.text.isNotEmpty) {
                  _addStudent(className, studentNameController.text);
                  Navigator.pop(context);
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _showEditStudentDialog(Student student) {
    final TextEditingController studentNameController =
        TextEditingController(text: student.name);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Student'),
          content: TextField(
            controller: studentNameController,
            decoration: const InputDecoration(
              labelText: 'Student Name',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (studentNameController.text.isNotEmpty) {
                  _editStudent(student, studentNameController.text);
                  Navigator.pop(context);
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  // Dialog to confirm class deletion
  void _showDeleteClassDialog(String className) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Class'),
          content: Text('Are you sure you want to delete "$className"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              onPressed: () {
                _removeClass(className);
                Navigator.pop(context);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: classStudents.length,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon:
                const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AdminsPanelPage()),
              );
            },
          ),
          title: const Text(
            'Students List',
            style:
                TextStyle(fontWeight: FontWeight.w600, color: Colors.white70),
          ),
          bottom: TabBar(
            isScrollable: true,
            indicatorColor: Colors.white,
            indicatorWeight: 3,
            tabs: classStudents.keys
                .map((className) => Tab(
                      child: Text(
                        className,
                        style:
                            const TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ))
                .toList(),
          ),
          // flexibleSpace: Container(
          //   decoration: const BoxDecoration(
          //     gradient: LinearGradient(
          //       colors: [Color(0xFF00796B), Color(0xFF009688)],
          //       begin: Alignment.topLeft,
          //       end: Alignment.bottomRight,
          //     ),
          //   ),
          // ),
          actions: [
            IconButton(
              icon: const Icon(Icons.add_circle, color: Colors.white),
              onPressed: _showAddClassDialog,
              tooltip: 'Add New Class',
            ),
            // Fixed conditional check for classes
            if (classStudents.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.white, size: 18),
              onPressed: () => _showDeleteClassDialog(selectedClass),
              tooltip: 'Delete Current Class',
            ),
          ],
          backgroundColor: const Color(0xFF1E3C72),
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.teal.shade50,
                Colors.grey.shade50,
              ],
            ),
          ),
          child: TabBarView(
            children: classStudents.keys.map((className) {
              final classStudentsList = students
                  .where((student) => student.className == className)
                  .toList();
              return Stack(
                children: [
                  Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: classStudentsList.length,
                          itemBuilder: (context, index) {
                            final student = classStudentsList[index];
                            return Card(
                              elevation: 4,
                              margin: const EdgeInsets.only(bottom: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 12,
                                ),
                                leading: CircleAvatar(
                                  backgroundColor: Colors.indigo.shade100,
                                  child: Text(
                                    student.name.isNotEmpty ? student.name[0] : '',
                                    style: TextStyle(
                                      color: Colors.indigo.shade700,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                title: Text(
                                  student.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.indigo.shade50,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        '${student.totalJuzCompleted} Juz',
                                        style: TextStyle(
                                          color: Colors.indigo.shade700,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    PopupMenuButton<String>(
                                      icon: const Icon(Icons.more_vert),
                                      onSelected: (value) {
                                        if (value == 'edit') {
                                          _showEditStudentDialog(student);
                                        } else if (value == 'delete') {
                                          _deleteStudent(student);
                                        }
                                      },
                                      itemBuilder: (context) => [
                                        const PopupMenuItem(
                                          value: 'edit',
                                          child: Row(
                                            children: [
                                              Icon(Icons.edit),
                                              SizedBox(width: 8),
                                              Text('Edit'),
                                            ],
                                          ),
                                        ),
                                        const PopupMenuItem(
                                          value: 'delete',
                                          child: Row(
                                            children: [
                                              Icon(Icons.delete,
                                                  color: Colors.red),
                                              SizedBox(width: 8),
                                              Text('Delete',
                                                  style: TextStyle(
                                                      color: Colors.red)),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          HifzGraphPage(student: student),
                                    ),
                                  ).then((_) => setState(() {}));
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    bottom: 16,
                    right: 16,
                    child: FloatingActionButton(
                      onPressed: () => _showAddStudentDialog(className),
                      backgroundColor: Colors.indigo.shade900,
                      child: const Icon(Icons.person_add, color: Colors.white),
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class HifzGraphPage extends StatefulWidget {
  final Student student;

  const HifzGraphPage({super.key, required this.student});

  @override
  _HifzGraphPageState createState() => _HifzGraphPageState();
}

class _HifzGraphPageState extends State<HifzGraphPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  final List<Color> progressColors = [
    const Color(0xFF6B48FF), // Teal
    const Color(0xFF4CAF50),
    const Color(0xFFFF6B6B),
    const Color(0xFF48C9FF),
    const Color(0xFFFFBE0B), // Deep Orange
    const Color.fromARGB(255, 255, 72, 228),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();

    for (int i = 0; i < widget.student.hifzData.length; i++) {
      widget.student.hifzData[i] = HifzData(
        widget.student.hifzData[i].year,
        widget.student.hifzData[i].juzCount,
        progressColors[i],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          '${widget.student.name}\'S PROGRESS',
          style: const TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        // flexibleSpace: Container(
        //   decoration: const BoxDecoration(
        //     gradient: LinearGradient(
        //       colors: [Color(0xFF00796B), Color(0xFF009688)],
        //       begin: Alignment.topLeft,
        //       end: Alignment.bottomRight,
        //     ),
        //   ),
        // ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white),
            onPressed: () => _showUpdateProgressDialog(context),
          ),
        ],
       backgroundColor: const Color(0xFF1E3C72),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.teal.shade50,
              Colors.grey.shade50,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildProgressCard(),
                const SizedBox(height: 20),
                _buildBarChart(),
                const SizedBox(height: 20),
                _buildLegend(),
                const SizedBox(height: 20),
                _buildPieChart(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showUpdateProgressDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Update Progress'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: widget.student.hifzData.map((data) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: [
                      Text(data.year),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextFormField(
                          initialValue: data.juzCount.toString(),
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Juz Count',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            final newCount = int.tryParse(value) ?? 0;
                            setState(() {
                              data.juzCount = newCount;
                              _updateTotalJuzCount();
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {}); // Refresh the UI
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _updateTotalJuzCount() {
    widget.student.totalJuzCompleted = widget.student.hifzData
        .map((data) => data.juzCount)
        .reduce((value, element) => value + element);
  }

  Widget _buildProgressCard() {
    return Card(
      elevation: 8,
      shadowColor: Colors.indigo,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [Colors.white, Colors.indigo.shade50],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              'Total Hifz Progress',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.indigo.shade700,
              ),
            ),
            const SizedBox(height: 20),
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      height: 150,
                      width: 150,
                      child: CircularProgressIndicator(
                        value: _animation.value *
                            (widget.student.totalJuzCompleted / 30),
                        strokeWidth: 15,
                        backgroundColor: Colors.grey.shade200,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.indigo.shade400),
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${(_animation.value * widget.student.totalJuzCompleted).toInt()}',
                          style: TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                            color: Colors.indigo.shade700,
                          ),
                        ),
                        Text(
                          'Juz Completed',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.indigo.shade600,
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBarChart() {
    return Card(
      elevation: 8,
      shadowColor: Colors.indigo,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            colors: [Colors.white, Color(0xFFF7F9FF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              'Juz Distribution by Year',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C3E50),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 300,
              child: AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      maxY: 10,
                      barTouchData: BarTouchData(
                        enabled: true,
                        touchTooltipData: BarTouchTooltipData(
                          tooltipRoundedRadius: 8,
                        ),
                      ),
                      titlesData: FlTitlesData(
                        show: true,
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 3.0),
                                child: Text(
                                  widget.student.hifzData[value.toInt()].year,
                                  style: const TextStyle(
                                    color: Color(0xFF7F8C8D),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              return Text(
                                value.toInt().toString(),
                                style: const TextStyle(
                                  color: Color(0xFF7F8C8D),
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            },
                          ),
                        ),
                        topTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                        rightTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                      ),
                      gridData: FlGridData(show: false),
                      borderData: FlBorderData(show: false),
                      barGroups:
                          widget.student.hifzData.asMap().entries.map((entry) {
                        return BarChartGroupData(
                          x: entry.key,
                          barRods: [
                            BarChartRodData(
                              toY: entry.value.juzCount * _animation.value,
                              color: entry.value.color,
                              width: 35,
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(6),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
    }

  Widget _buildLegend() {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Hifz Legend',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C3E50),
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 16.0,
              runSpacing: 12.0,
              children: widget.student.hifzData.map((data) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: data.color,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${data.year}: ${data.juzCount} Juz',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPieChart() {
    return Card(
      elevation: 8,
      shadowColor: Colors.indigo,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            colors: [Colors.white, Color(0xFFF7F9FF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              'Juz Distribution Overview',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C3E50),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 300,
              child: AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  final List<PieChartSectionData> sections = [];
                  
                  // Calculate total for percentage
                  final total = widget.student.hifzData
                      .fold(0, (sum, data) => sum + data.juzCount);
                  
                  // Only show sectors for non-zero juz counts
                  for (int i = 0; i < widget.student.hifzData.length; i++) {
                    final data = widget.student.hifzData[i];
                    if (data.juzCount > 0) {
                      sections.add(
                        PieChartSectionData(
                          color: data.color,
                          value: data.juzCount.toDouble(),
                          title: '${(data.juzCount / total * 100).toStringAsFixed(1)}%',
                          radius: 100 * _animation.value,
                          titleStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      );
                    }
                  }
                  
                  if (sections.isEmpty) {
                    return const Center(
                      child: Text(
                        'No progress data available',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                        ),
                      ),
                    );
                  }
                  
                  return PieChart(
                    PieChartData(
                      sections: sections,
                      centerSpaceRadius: 0,
                      sectionsSpace: 2,
                      pieTouchData: PieTouchData(
                        touchCallback: (FlTouchEvent event, pieTouchResponse) {
                          // Handle touch events if needed
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

class HifzData {
  final String year;
  int juzCount;
  final Color color;

  HifzData(this.year, this.juzCount, this.color);
}

// Additional pages for complete application

// class AdminsPanelPage extends StatelessWidget {
//   const AdminsPanelPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Admin Panel',
//           style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white70),
//         ),
//         backgroundColor: const Color(0xFF1E3C72),
//       ),
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [
//               Colors.teal.shade50,
//               Colors.grey.shade50,
//             ],
//           ),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: GridView.count(
//             crossAxisCount: 2,
//             crossAxisSpacing: 16,
//             mainAxisSpacing: 16,
//             children: [
//               _buildMenuCard(
//                 context,
//                 'Student Management',
//                 Icons.people,
//                 Colors.indigo,
//                 () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => const StudentListPage(),
//                     ),
//                   );
//                 },
//               ),
//               _buildMenuCard(
//                 context,
//                 'Attendance',
//                 Icons.calendar_today,
//                 Colors.teal,
//                 () {
//                   // Navigate to attendance page
//                   // Implement as needed
//                 },
//               ),
//               _buildMenuCard(
//                 context,
//                 'Reports',
//                 Icons.bar_chart,
//                 Colors.amber,
//                 () {
//                   // Navigate to reports page
//                   // Implement as needed
//                 },
//               ),
//               _buildMenuCard(
//                 context,
//                 'Settings',
//                 Icons.settings,
//                 Colors.blueGrey,
//                 () {
//                   // Navigate to settings page
//                   // Implement as needed
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildMenuCard(BuildContext context, String title, IconData icon, 
//       MaterialColor color, VoidCallback onTap) {
//     return Card(
//       elevation: 6,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//       child: InkWell(
//         onTap: onTap,
//         borderRadius: BorderRadius.circular(15),
//         child: Container(
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(15),
//             gradient: LinearGradient(
//               colors: [color.shade50, Colors.white],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//           ),
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(
//                 icon,
//                 size: 48,
//                 color: color.shade700,
//               ),
//               const SizedBox(height: 12),
//               Text(
//                 title,
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   color: color.shade800,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

class AttendanceTrackingPage extends StatefulWidget {
  final Student student;

  const AttendanceTrackingPage({super.key, required this.student});

  @override
  _AttendanceTrackingPageState createState() => _AttendanceTrackingPageState();
}

class _AttendanceTrackingPageState extends State<AttendanceTrackingPage> {
  late DateTime _selectedDate;
  final Map<DateTime, bool> _attendance = {};

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _loadAttendance();
  }

  void _loadAttendance() {
    // Convert string-based attendance data to DateTime-based
    widget.student.attendance.forEach((dateStr, isPresent) {
      final parts = dateStr.split('-');
      if (parts.length == 3) {
        try {
          final date = DateTime(
            int.parse(parts[0]),
            int.parse(parts[1]),
            int.parse(parts[2]),
          );
          _attendance[date] = isPresent;
        } catch (e) {
          // Handle parsing errors
        }
      }
    });
  }

  void _saveAttendance() {
    // Convert DateTime-based attendance back to string-based for storage
    final Map<String, bool> attendanceData = {};
    _attendance.forEach((date, isPresent) {
      final dateStr = '${date.year}-${date.month}-${date.day}';
      attendanceData[dateStr] = isPresent;
    });
    
    setState(() {
      widget.student.attendance = attendanceData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.student.name}\'s Attendance',
          style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.white70),
        ),
        backgroundColor: const Color(0xFF1E3C72),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.teal.shade50,
              Colors.grey.shade50,
            ],
          ),
        ),
        child: Column(
          children: [
            // Calendar widget would go here
            // Implement according to your calendar package
            
            const SizedBox(height: 20),
            
            // Attendance controls
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.check_circle, color: Colors.green),
                    label: const Text('Present'),
                    onPressed: () {
                      setState(() {
                        _attendance[_selectedDate] = true;
                        _saveAttendance();
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.green.shade600,
                    ),
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.cancel, color: Colors.red),
                    label: const Text('Absent'),
                    onPressed: () {
                      setState(() {
                        _attendance[_selectedDate] = false;
                        _saveAttendance();
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.red.shade600,
                    ),
                  ),
                ],
              ),
            ),
            
            // Attendance history
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: _attendance.length,
                    itemBuilder: (context, index) {
                      final date = _attendance.keys.elementAt(index);
                      final isPresent = _attendance[date]!;
                      
                      return ListTile(
                        leading: Icon(
                          isPresent ? Icons.check_circle : Icons.cancel,
                          color: isPresent ? Colors.green : Colors.red,
                        ),
                        title: Text(
                          '${date.day}/${date.month}/${date.year}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          isPresent ? 'Present' : 'Absent',
                          style: TextStyle(
                            color: isPresent ? Colors.green.shade700 : Colors.red.shade700,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

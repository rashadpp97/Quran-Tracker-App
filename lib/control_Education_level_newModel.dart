import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

void main() {
  runApp(const NewEducationLevelControlPage());
}

class NewEducationLevelControlPage extends StatelessWidget {
  const NewEducationLevelControlPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hifz Progress Tracker',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: const Color(0xFFF8F9FD),
      ),
      home: const StudentListPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Student {
  String name;
  String className;
  List<HifzData> hifzData;
  int totalJuzCompleted;

  Student({
    required this.name,
    required this.className,
    required this.hifzData,
    required this.totalJuzCompleted,
  });
}

class StudentListPage extends StatefulWidget {
  const StudentListPage({super.key});

  @override
  _StudentListPageState createState() => _StudentListPageState();
}

class _StudentListPageState extends State<StudentListPage> {
  // Using a Map to store class names and their students
  final Map<String, List<String>> classStudents = {
    'حلقة أبي بكر الصديق': [
      'AFTHAB', 'BILAL', 'AZMI JUNAID', 'HADI HASSAN', 'HAMIZ HARSHAD',
      'MUHAMMED ARSHAD', 'YAHYA', "ABDUL MUA'D", 'FARIS AHMED',
    ],
    'حلقة عمر بن الخطاب': [
      'SALMAN FARIS', 'IHTHISHAM', 'NAHAN', 'ABDULLA HAMDAN', 'MISHAB SHAFI',
      'MUHAMMED FAHEEM C', 'UZAIR', 'FADI MUHAMMED', 'HAFEEZ', 'AJWAD'
    ],
    'حلقة عثمان بن عفان': [
      'MUHAMMED FAHEEM K', 'ABDURAHMAN KHALID', 'ABDULLA M', 'ADIL SALEEM',
      'SHAYAN', 'AZIM CK', 'ABDULLA ZAKI', 'FAAZ', 'AMLAH IBNU SHAREEF',
      'MUHAMMED SHAYAN',
    ],
    'حلقة علي بن أبي طالب': [
      "MUA'D ANWAR", 'AZIM E', 'BASHEER', 'HANI SADIQUE', 'MISBAH', 'ADNAN',
      'SULTHAN IBNU AKBAR', 'HANOOR', 'IBRAHIM', 'AJSAL AMEEN', 'THWALHA'
    ],
    'حلقة سعد بن أبي وقاص': [
      'AHMED JAZIM', 'MUHAMMED SALIH', 'EESA ABDULLA', 'RAIHAN',
      'FAHEEM IBNU SATHAR', 'FOUZAN SIDHIQUE', 'IHSAN', 'AJMAL MANAF',
      'AASWIL HAQ',
    ]
  };

  late List<Student> students;

  @override
  void initState() {
    super.initState();
    students = _initializeStudents();
  }

  List<Student> _initializeStudents() {
    List<Student> initializedStudents = [];

    classStudents.forEach((className, studentNames) {
      for (String name in studentNames) {
        initializedStudents.add(
          Student(
            name: name,
            className: className,
            totalJuzCompleted: 0,
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
      }
    });

    return initializedStudents;
  }

  void _addClass(String className) {
    setState(() {
      classStudents[className] = [];
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
      students.removeWhere((s) => s.name == student.name && s.className == student.className);
      
      // Remove the student from the classStudents map
      classStudents[student.className]?.remove(student.name);
    });
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
    final TextEditingController studentNameController = TextEditingController(text: student.name);
    
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

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: classStudents.length,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AdminsPanelPage()),
              );
            },
          ),
          title: const Text(
            'Students List', 
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.white70
            ),
          ),
          bottom: TabBar(
            isScrollable: true,
            indicatorColor: Colors.white,
            indicatorWeight: 3,
            tabs: classStudents.keys.map((className) => 
              Tab(
                child: Text(
                  className,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white
                  ),
                ),
              )
            ).toList(),
          ),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF00796B), Color(0xFF009688)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.add_circle, color: Colors.white),
              onPressed: _showAddClassDialog,
              tooltip: 'Add New Class',
            ),
          ],
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
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton.icon(
                      onPressed: () => _showAddStudentDialog(className),
                      icon: const Icon(Icons.person_add),
                      label: const Text('Add Student'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                    ),
                  ),
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
                              backgroundColor: Colors.teal.shade100,
                              child: Text(
                                student.name.isNotEmpty ? student.name[0] : '',
                                style: TextStyle(
                                  color: Colors.teal.shade700,
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
                                    color: Colors.teal.shade50,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    '${student.totalJuzCompleted} Juz',
                                    style: TextStyle(
                                      color: Colors.teal.shade700,
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
                                          Icon(Icons.delete, color: Colors.red),
                                          SizedBox(width: 8),
                                          Text('Delete', style: TextStyle(color: Colors.red)),
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
                                  builder: (context) => HifzGraphPage(student: student),
                                ),
                              ).then((_) => setState(() {
                                // Refresh the state when returning from the graph page
                                // This ensures any changes made are reflected in the list
                              }));
                            },
                          ),
                        );
                      },
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

class HifzData {
  final String label;
  final double value;
  final Color color;

  HifzData(this.label, this.value, this.color);
}

class HifzGraphPage extends StatefulWidget {
  final Student student;

  const HifzGraphPage({super.key, required this.student});

  @override
  _HifzGraphPageState createState() => _HifzGraphPageState();
}

class _HifzGraphPageState extends State<HifzGraphPage> {
  final List<String> _years = ['Center', 'Year 1', 'Year 2', 'Year 3', 'Year 4', 'Year 5'];
  final List<int> _juzValues = List.filled(6, 0);
  int _totalJuzCompleted = 0;

  @override
  void initState() {
    super.initState();
    // Initialize the values from the student's hifz data
    for (int i = 0; i < widget.student.hifzData.length; i++) {
      _juzValues[i] = widget.student.hifzData[i].value.toInt();
    }
    _calculateTotalJuz();
  }

  void _calculateTotalJuz() {
    _totalJuzCompleted = _juzValues.reduce((value, element) => value + element);
    
    // Update the student's total juz completed
    setState(() {
      widget.student.totalJuzCompleted = _totalJuzCompleted;
    });
  }

  void _incrementJuz(int index) {
    setState(() {
      if (_juzValues[index] < 30) {
        _juzValues[index]++;
        // Update the student's hifz data
        widget.student.hifzData[index] = HifzData(
          _years[index],
          _juzValues[index].toDouble(),
          widget.student.hifzData[index].color,
        );
        _calculateTotalJuz();
      }
    });
  }

  void _decrementJuz(int index) {
    setState(() {
      if (_juzValues[index] > 0) {
        _juzValues[index]--;
        // Update the student's hifz data
        widget.student.hifzData[index] = HifzData(
          _years[index],
          _juzValues[index].toDouble(),
          widget.student.hifzData[index].color,
        );
        _calculateTotalJuz();
      }
    });
  }

  List<PieChartSectionData> _getSections() {
    return List.generate(_years.length, (i) {
      final value = _juzValues[i].toDouble();
      final color = widget.student.hifzData[i].color;
      final fontSize = 14.0;
      final radius = 100.0;
      
      return PieChartSectionData(
        color: color,
        value: value,
        title: value > 0 ? '${value.toInt()}' : '',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.student.name}\'s Hifz Progress',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF00796B), Color(0xFF009688)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Student info card
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.teal.shade100,
                        radius: 40,
                        child: Text(
                          widget.student.name.isNotEmpty ? widget.student.name[0] : '',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.teal.shade700,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        widget.student.name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        widget.student.className,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.teal.shade50,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Total Juz Completed: $_totalJuzCompleted / 30',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.teal.shade700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Pie Chart
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Text(
                        'Hifz Progress Distribution',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 300,
                        child: PieChart(
                          PieChartData(
                            sections: _getSections(),
                            centerSpaceRadius: 40,
                            sectionsSpace: 2,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Legend
                      Wrap(
                        spacing: 20,
                        runSpacing: 10,
                        alignment: WrapAlignment.center,
                        children: List.generate(_years.length, (index) {
                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 16,
                                height: 16,
                                decoration: BoxDecoration(
                                  color: widget.student.hifzData[index].color,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(_years[index]),
                            ],
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Input controls
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Text(
                        'Update Hifz Progress',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Input controls for each year
                      ...List.generate(_years.length, (index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Row(
                            children: [
                              Container(
                                width: 16,
                                height: 16,
                                decoration: BoxDecoration(
                                  color: widget.student.hifzData[index].color,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  _years[index],
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey.shade300),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.remove),
                                      onPressed: () => _decrementJuz(index),
                                      color: Colors.teal,
                                      iconSize: 20,
                                    ),
                                    Container(
                                      width: 40,
                                      alignment: Alignment.center,
                                      child: Text(
                                        '${_juzValues[index]}',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.add),
                                      onPressed: () => _incrementJuz(index),
                                      color: Colors.teal,
                                      iconSize: 20,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Save button
              ElevatedButton.icon(
                onPressed: () {
                  // Save changes and return to previous screen
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Progress updated successfully!'),
                      backgroundColor: Colors.teal,
                    ),
                  );
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.save),
                label: const Text('Save Progress'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  textStyle: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AdminsPanelPage extends StatelessWidget {
  const AdminsPanelPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Admin Panel',
          style: TextStyle(color: Colors.white),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF00796B), Color(0xFF009688)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.admin_panel_settings,
                        size: 50,
                        color: Colors.teal,
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Admin Dashboard',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Manage students, classes, and track progress',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _buildAdminCard(
                icon: Icons.people_alt,
                title: 'Manage Students',
                description: 'Add, edit, or remove students',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const StudentListPage(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              _buildAdminCard(
                icon: Icons.insights,
                title: 'Overall Progress',
                description: 'View overall Hifz completion statistics',
                onTap: () {
                  // Navigate to statistics page
                },
              ),
              const SizedBox(height: 12),
              _buildAdminCard(
                icon: Icons.settings,
                title: 'Settings',
                description: 'Configure application settings',
                onTap: () {
                  // Navigate to settings page
                },
              ),
              const SizedBox(height: 12),
              _buildAdminCard(
                icon: Icons.file_download,
                title: 'Export Data',
                description: 'Export student data and progress reports',
                onTap: () {
                  // Export data functionality
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAdminCard({
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.teal.shade50,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  size: 30,
                  color: Colors.teal,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: Colors.teal,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
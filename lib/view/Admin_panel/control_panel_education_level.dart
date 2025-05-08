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

  Student({
    required this.name,
    // required this.id,
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
      students.removeWhere(
          (s) => s.name == student.name && s.className == student.className);

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
                                    student.name[0],
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
              'Overall Progress Distribution',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C3E50),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 250,
              child: AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return PieChart(
                    PieChartData(
                      sectionsSpace: 2,
                      centerSpaceRadius: 40,
                      sections: [
                        PieChartSectionData(
                          value: widget.student.totalJuzCompleted.toDouble(),
                          title:
                              'Completed\n${widget.student.totalJuzCompleted} Juz',
                          color: const Color(0xFF6B48FF),
                          radius: 100 * _animation.value,
                          titleStyle: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        PieChartSectionData(
                          value: (30 - widget.student.totalJuzCompleted)
                              .toDouble(),
                          title:
                              'Remaining\n${30 - widget.student.totalJuzCompleted} Juz',
                          color: const Color(0xFFE0E0E0),
                          radius: 100 * _animation.value,
                          titleStyle: const TextStyle(
                            color: Color(0xFF2C3E50),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Journey Overview',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C3E50),
              ),
            ),
            const SizedBox(height: 16),
            ...widget.student.hifzData.map((data) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: [
                      Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: data.color,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '${data.year}: ${data.juzCount} Juz',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFF2C3E50),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                )),
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

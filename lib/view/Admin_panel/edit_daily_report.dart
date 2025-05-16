import 'package:flutter/material.dart';
import 'admins_panel_page.dart';

void main() {
  runApp(const ClassAddAndDeleteControlPage());
}

class ClassAddAndDeleteControlPage extends StatelessWidget {
  const ClassAddAndDeleteControlPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quran Progress Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: const Color(0xFFF5F6FA),
      ),
      home: const ClassSelectionScreen(),
    );
  }
}

class Student {
  // final String id;
  late String name;
  final int classNumber;
  final YearlyProgress yearlyProgress;

  Student({
    // required this.id,
    required this.name,
    required this.classNumber,
    required this.yearlyProgress,
  });
}

class QuranClass {
  final int classNumber;
  final List<Student> students;

  QuranClass({
    required this.classNumber,
    required this.students,
  });
}

class LessonProgress {
  bool isDefault = true;
  bool completed = false;
  int? lines;
  int? pages;

  int calculatePoints() {
    if (!completed || isDefault) {
      return 0;
    }
    
    if (lines != null) {
      return lines! * 1; // 1 points per line
    } else if (pages != null) {
      return pages! * 1; // 1 points per page
    }
    
    return 0; // Default points if completed with no lines/pages
  }
}

class DailyProgress {
  String date;
  LessonProgress newLesson;
  LessonProgress juzLesson;
  LessonProgress oldLesson;
  LessonProgress juzCompleted;
  LessonProgress juzRevision;
  LessonProgress testPassed;
  LessonProgress testFailed;

  DailyProgress({
    required this.date,
    required this.newLesson,
    required this.juzLesson,
    required this.oldLesson,
    required this.juzCompleted,
    required this.juzRevision,
    required this.testPassed,
    required this.testFailed,
  });

  int calculateDailyPoints() {
    return newLesson.calculatePoints() +
        juzLesson.calculatePoints() +
        oldLesson.calculatePoints() +
        juzRevision.calculatePoints() +
        testPassed.calculatePoints();
  }
}

class MonthlyProgress {
  final String month;
  final List<DailyProgress> dailyProgress;

  MonthlyProgress({
    required this.month,
    required this.dailyProgress,
  });

  int calculateMonthlyPoints() {
    return dailyProgress.fold(
        0, (sum, daily) => sum + daily.calculateDailyPoints());
  }
}

class YearlyProgress {
  final String year;
  List<MonthlyProgress> monthlyProgress;

  YearlyProgress({
    required this.year,
    required this.monthlyProgress,
  });

  int calculateYearlyPoints() {
    return monthlyProgress.fold(
        0, (sum, month) => sum + month.calculateMonthlyPoints());
  }
}

class ClassSelectionScreen extends StatefulWidget {
  const ClassSelectionScreen({super.key});

  @override
  State<ClassSelectionScreen> createState() => _ClassSelectionScreenState();
}

class AddClassDialog extends StatefulWidget {
  final Function(String className, List<String> students) onClassAdded;

  const AddClassDialog({
    super.key,
    required this.onClassAdded,
  });

  @override
  State<AddClassDialog> createState() => _AddClassDialogState();
}

class _AddClassDialogState extends State<AddClassDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _classNameController = TextEditingController();
  final List<TextEditingController> _studentControllers = [
    TextEditingController()
  ];

  @override
  void dispose() {
    _classNameController.dispose();
    for (var controller in _studentControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add New Class'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _classNameController,
                decoration: const InputDecoration(
                  labelText: 'Class Name',
                  hintText: 'Enter class name',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a class name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              const Text('Students:'),
              ...List.generate(
                _studentControllers.length,
                (index) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _studentControllers[index],
                          decoration: InputDecoration(
                            labelText: 'Student ${index + 1}',
                            hintText: 'Enter student name',
                          ),
                          validator: (value) {
                            if (index == 0 &&
                                (value == null || value.isEmpty)) {
                              return 'Please enter at least one student';
                            }
                            return null;
                          },
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline),
                        onPressed: () {
                          if (_studentControllers.length > 1) {
                            setState(() {
                              _studentControllers[index].dispose();
                              _studentControllers.removeAt(index);
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _studentControllers.add(TextEditingController());
                  });
                },
                child: const Text('Add Student'),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final students = _studentControllers
                  .where((controller) => controller.text.isNotEmpty)
                  .map((controller) => controller.text)
                  .toList();

              widget.onClassAdded(_classNameController.text, students);
              Navigator.pop(context);
            }
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}

class _ClassSelectionScreenState extends State<ClassSelectionScreen> {
  late List<QuranClass> classes;
  final List<String> classNames = [
    'حلقة أبي بكر الصديق',
    'حلقة عمر بن الخطاب',
    'حلقة عثمان بن عفان',
    'حلقة علي بن أبي طالب',
    'حلقة سعد بن أبي وقاص'
  ];

  @override
  void initState() {
    super.initState();
    classes = _generateClasses();
  }

  void _deleteClass(int index) {
    setState(() {
      classes.removeAt(index);
      if (index < classNames.length) {
        classNames.removeAt(index);
      }
      // Reassign class numbers
      for (int i = 0; i < classes.length; i++) {
        classes[i] = QuranClass(
          classNumber: i + 1,
          students: classes[i]
              .students
              .map((student) => Student(
                    // id: 'S${i + 1}${student.id.substring(3)}',
                    name: student.name,
                    classNumber: i + 1,
                    yearlyProgress: student.yearlyProgress,
                  ))
              .toList(),
        );
      }
    });
  }

  List<QuranClass> _generateClasses() {
    final classNames = [
      'حلقة أبي بكر الصديق',
      'حلقة عمر بن الخطاب',
      'حلقة عثمان بن عفان',
      'حلقة علي بن أبي طالب',
      'حلقة سعد بن أبي وقاص'
    ];

    final studentNames = {
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
        'SULTHAN'
      ],
      'حلقة عمر بن الخطاب': [
        "MUA'D ANWAR",
        'AZIM E',
        'BASHEER',
        'HANI SADIQUE',
        'MISBAH',
        'ADNAN',
        'HANOOR',
        'IBRAHIM',
        'AJSAL AMEEN',
        'THWALHA'
      ],
      'حلقة عثمان بن عفان': [
        'AHMED JAZIM',
        'MUHAMMED SALIH',
        'EESA ABDULLA',
        'RAIHAN',
        'FAHEEM IBNU SATHAR',
        'FOUZAN SIDHIQUE',
        'IHSAN',
        'AJMAL MANAF',
        'AASWIL HAQ'
      ],
      'حلقة علي بن أبي طالب': [
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
      'حلقة سعد بن أبي وقاص': [
        'MUHAMMED FAHEEM K',
        'ABDURAHMAN KHALID',
        'ABDULLA M',
        'ADIL SALEEM',
        'SHAYAN',
        'AZIM CK',
        'ABDULLA ZAKI',
        'FAAZ',
        'AMLAH',
        'MUHAMMED SHAYAN',
      ]
    };

    List<QuranClass> classes = [];
    for (int c = 0; c < classNames.length; c++) {
      List<Student> students = [];
      final className = classNames[c];
      final classStudents = studentNames[className]!;

      for (int s = 0; s < classStudents.length; s++) {
        students.add(Student(
          // id: 'S${c + 1}${(s + 1).toString().padLeft(2, '0')}',
          name: classStudents[s],
          classNumber: c + 1,
          yearlyProgress: _generateYearlyProgress(),
        ));
      }
      classes.add(QuranClass(
        classNumber: c + 1,
        students: students,
      ));
    }
    return classes;
  }

  YearlyProgress _generateYearlyProgress() {
    List<MonthlyProgress> months = [];
    final monthNames = [
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

    for (int m = 0; m < 12; m++) {
      List<DailyProgress> days = [];
      final daysInMonth = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31][m];

      for (int d = 1; d <= daysInMonth; d++) {
        days.add(DailyProgress(
          date:
              '${d.toString().padLeft(2, '0')}-${(m + 1).toString().padLeft(2, '0')}-2025',
          newLesson: LessonProgress(),
          juzLesson: LessonProgress(),
          oldLesson: LessonProgress(),
          juzCompleted: LessonProgress(),
          juzRevision: LessonProgress(),
          testPassed: LessonProgress(),
          testFailed: LessonProgress(),
        ));
      }

      months.add(MonthlyProgress(
        month: monthNames[m],
        dailyProgress: days,
      ));
    }

    return YearlyProgress(
      year: '',
      monthlyProgress: months,
    );
  }

  Widget _buildClassCard(BuildContext context, int index) {
    final quranClass = classes[index];
    String className = index < classNames.length
        ? classNames[index]
        : "Class ${quranClass.classNumber}";

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Stack(
        children: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => StudentListScreen(
                    quranClass: quranClass,
                    className: className,
                  ),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 56),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E3C72).withOpacity(0.1),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          spreadRadius: 2,
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(16),
                    child: const Icon(
                      Icons.school,
                      size: 48,
                      color: Color(0xFF1E3C72),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    className,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1E3C72),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${quranClass.students.length} Students',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert),
              onSelected: (value) {
                if (value == 'edit') {
                  // Implement _showEditClassDialog method
                  _showEditClassDialog(context, index);
                } else if (value == 'delete') {
                  _showDeleteConfirmation(context, index);
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
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Class'),
          content: const Text('Are you sure you want to delete this class?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _deleteClass(index);
                Navigator.pop(context);
              },
              child: const Text('Delete',
                  style: TextStyle(color: Colors.redAccent)),
            ),
          ],
        );
      },
    );
  }

// You'll need to implement this method to handle class editing
  void _showEditClassDialog(BuildContext context, int index) {
    final TextEditingController classNameController = TextEditingController(
        text: index < classNames.length
            ? classNames[index]
            : "Class ${classes[index].classNumber}");

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Class'),
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
                  _editClass(index, classNameController.text);
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

  void _editClass(int index, String newClassName) {
    setState(() {
      if (index < classNames.length) {
        classNames[index] = newClassName;
      } else {
        // If for some reason the class name wasn't in the list, add it
        while (classNames.length <= index) {
          classNames.add("Class ${classNames.length + 1}");
        }
        classNames[index] = newClassName;
      }
    });
  }

  void _showAddClassDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AddClassDialog(
        onClassAdded: (className, students) {
          setState(() {
            final newClassNumber = classes.length + 1;
            final newStudents = students.asMap().entries.map((entry) {
              return Student(
                // id: 'S$newClassNumber${(entry.key + 1).toString().padLeft(2, '0')}',
                name: entry.value,
                classNumber: newClassNumber,
                yearlyProgress: _generateYearlyProgress(),
              );
            }).toList();

            // Add the new class name to the classNames list
            classNames.add(className);

            classes.add(QuranClass(
              classNumber: newClassNumber,
              students: newStudents,
            ));
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
            size: 18,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AdminsPanelPage(),
              ),
            );
          },
        ),
        title: const Text(
          'Please select your Class',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1E3C72),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddClassDialog(context),
        backgroundColor: const Color(0xFF1E3C72),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                childAspectRatio: 1.5,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
              ),
              itemCount: classes.length,
              itemBuilder: (context, index) => _buildClassCard(context, index),
            ),
          ),
        ],
      ),
    );
  }
}

class StudentListScreen extends StatefulWidget {
  final QuranClass quranClass;
  final String className;

  const StudentListScreen({
    super.key,
    required this.quranClass,
    required this.className,
  });

  @override
  State<StudentListScreen> createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
            size: 18,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.className,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1E3C72),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: widget.quranClass.students.length,
        itemBuilder: (context, index) {
          final student = widget.quranClass.students[index];
          return _buildStudentCard(context, student, index);
        },
      ),
    );
  }

  Widget _buildStudentCard(BuildContext context, Student student, int index) {
  return Card(
    margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    child: InkWell(
      // Make the entire card tappable
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProgressTrackingScreen(student: student),
          ),
        );
      },
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: const Color(0xFF1E3C72),
          child: Text(
            student.name.isNotEmpty ? student.name[0].toUpperCase() : '?',
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          student.name,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            color: Color(0xFF1E3C72), // Optional: Make the text color match your theme
          ),
        ),
        // Optional: Add a subtle hint that this is clickable
        subtitle: const Text(
          "Tap to view progress",
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
        trailing: SizedBox(
          width: 48, // Reduced width as we only have the menu button now
          child: PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            padding: EdgeInsets.zero,
            onSelected: (value) {
              if (value == 'edit') {
                _editStudent(context, student, index);
              } else if (value == 'delete') {
                _deleteStudent(context, student, index);
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem<String>(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(Icons.edit),
                    SizedBox(width: 8),
                    Text('Edit'),
                  ],
                ),
              ),
              const PopupMenuItem<String>(
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
        ),
      ),
    ),
  );
}

// Alternative version without subtitle if you prefer a cleaner look
Widget _buildStudentCardSimple(BuildContext context, Student student, int index) {
  return Card(
    margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    child: InkWell(
      // Make the entire card tappable
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProgressTrackingScreen(student: student),
          ),
        );
      },
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: const Color(0xFF1E3C72),
          child: Text(
            student.name.isNotEmpty ? student.name[0].toUpperCase() : '?',
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        title: Row(
          children: [
            Text(
              student.name,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(width: 4),
            const Icon(
              Icons.arrow_forward,
              size: 16,
              color: Colors.grey,
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert),
          padding: EdgeInsets.zero,
          onSelected: (value) {
            if (value == 'edit') {
              _editStudent(context, student, index);
            } else if (value == 'delete') {
              _deleteStudent(context, student, index);
            }
          },
          itemBuilder: (BuildContext context) => [
            const PopupMenuItem<String>(
              value: 'edit',
              child: Row(
                children: [
                  Icon(Icons.edit),
                  SizedBox(width: 8),
                  Text('Edit'),
                ],
              ),
            ),
            const PopupMenuItem<String>(
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
      ),
    ),
  );
}

  void _editStudent(BuildContext context, Student student, int index) {
    // final TextEditingController nameController = TextEditingController(text: student.name);
    final nameController = TextEditingController(text: student.name);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Student'),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(labelText: 'Student Name'),
          autofocus: true, // Automatically focus the text field
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Update the student name
              final updatedName = nameController.text.trim();
              if (updatedName.isNotEmpty) {
                setState(() {
                  widget.quranClass.students[index].name = updatedName;
                });
              }
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _deleteStudent(BuildContext context, Student student, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Student'),
        content: Text('Are you sure you want to delete ${student.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                // Remove the student from the list
                widget.quranClass.students.removeAt(index);
              });
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class ProgressTrackingScreen extends StatefulWidget {
  final Student student;

  const ProgressTrackingScreen({super.key, required this.student});

  @override
  State<ProgressTrackingScreen> createState() => _ProgressTrackingScreenState();
}

class _ProgressTrackingScreenState extends State<ProgressTrackingScreen> {
  int selectedMonthIndex = DateTime.now().month - 1;
  int selectedYear = DateTime.now().year;
  bool showYearPicker = false;
  
  // Store year-specific progress data
  late YearlyProgress currentYearProgress;
  
  // Map to cache yearly progress data to avoid regenerating it
  final Map<int, YearlyProgress> yearDataCache = {};
  
  @override
  void initState() {
    super.initState();
    // Initialize with the current year's data
    _loadYearData(selectedYear);
  }

  // Method to load year-specific data
  void _loadYearData(int year) {
    setState(() {
      // Check cache first to avoid regenerating data if we've already loaded it
      if (yearDataCache.containsKey(year)) {
        currentYearProgress = yearDataCache[year]!;
      } else {
        // Get data for this year from student records or create new data
        YearlyProgress? yearData = widget.student.getYearlyProgressForYear(year);
        
        if (yearData != null) {
          // If data exists for this year, use it
          currentYearProgress = yearData;
        } else {
          // If no data exists for this year, create a new instance with proper year dates
          currentYearProgress = _createEmptyYearProgress(year);
        }
        
        // Cache the data for future use
        yearDataCache[year] = currentYearProgress;
      }
    });
  }

  // Create new empty year progress data with correct dates for the specified year
  YearlyProgress _createEmptyYearProgress(int year) {
    List<String> months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    
    // Create monthly progress objects with year-specific dates
    List<MonthlyProgress> monthlyProgress = [];
    
    for (int i = 0; i < months.length; i++) {
      // Create appropriate number of days for each month
      int daysInMonth = _getDaysInMonth(i + 1, year);
      List<DailyProgress> dailyProgress = [];
      
      for (int day = 1; day <= daysInMonth; day++) {
        // Format day and month numbers with leading zeros
        String formattedDay = day.toString().padLeft(2, '0');
        String formattedMonth = (i + 1).toString().padLeft(2, '0');
        
        // Create date string in the format "dd-mm-yyyy"
        String dateString = "$formattedDay-$formattedMonth-$year";
        
        // Create empty daily progress with default lesson status
        dailyProgress.add(
          DailyProgress(
            date: dateString,
            newLesson: LessonProgress(),
            juzLesson: LessonProgress(), 
            oldLesson: LessonProgress(),
            juzCompleted: LessonProgress(),
            juzRevision: LessonProgress(),
            testPassed: LessonProgress(),
            testFailed: LessonProgress(),
          ),
        );
      }
      
      monthlyProgress.add(
        MonthlyProgress(
          month: months[i],
          dailyProgress: dailyProgress,
        ),
      );
    }
    
    return YearlyProgress(monthlyProgress: monthlyProgress, year: '');
  }
  
  // Helper function to get the correct number of days in a month for a specific year
  int _getDaysInMonth(int month, int year) {
    if (month == 2) {
      // February - check for leap year
      if ((year % 4 == 0 && year % 100 != 0) || year % 400 == 0) {
        return 29; // Leap year
      } else {
        return 28; // Non-leap year
      }
    } else if ([4, 6, 9, 11].contains(month)) {
      return 30; // April, June, September, November
    } else {
      return 31; // All other months have 31 days
    }
  }
 
  // Method to update the year and fetch relevant data
  void _updateSelectedYear(int year) {
    setState(() {
      selectedYear = year;
      showYearPicker = false;
      // Load data for the selected year
      _loadYearData(year);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get the data for the selected year and month
    final selectedMonth = currentYearProgress.monthlyProgress[selectedMonthIndex];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
            size: 18,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          '${widget.student.name}\'S PROGRESS - $selectedYear',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF1E3C72),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              children: [
                _buildYearlySummary(),
                if (showYearPicker) _buildYearSelector(),
                _buildMonthSelector(),
                _buildMonthlySummary(selectedMonth),
              ],
            ),
          ),
          _buildDailyProgressList(selectedMonth),
        ],
      ),
    );
  }

  Widget _buildYearlySummary() {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Yearly Summary',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      showYearPicker = !showYearPicker;
                    });
                  },
                  child: Row(
                    children: [
                      Text(
                        '$selectedYear',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E3C72),
                        ),
                      ),
                      Icon(
                        showYearPicker
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        color: const Color(0xFF1E3C72),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              // Now uses the current year's data
              'Total Points: ${currentYearProgress.calculateYearlyPoints()}',
              style: const TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E3C72),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildYearSelector() {
    // Create a list of years from 2020 to 2040
    final List<int> years = List.generate(21, (index) => 2020 + index);
    
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: 200,
        padding: const EdgeInsets.all(8),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            childAspectRatio: 1.5,
          ),
          itemCount: years.length,
          itemBuilder: (context, index) {
            final year = years[index];
            final isSelected = selectedYear == year;
            
            return GestureDetector(
              onTap: () {
                _updateSelectedYear(year);
              },
              child: Container(
                margin: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF1E3C72) : Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: const Color(0xFF1E3C72),
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Center(
                  child: Text(
                    year.toString(),
                    style: TextStyle(
                      color: isSelected ? Colors.white : const Color(0xFF1E3C72),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildMonthSelector() {
    return SizedBox(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 12,
        itemBuilder: (context, index) {
          final month = currentYearProgress.monthlyProgress[index];
          final isSelected = selectedMonthIndex == index;

          return GestureDetector(
            onTap: () => setState(() => selectedMonthIndex = index),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF1E3C72) : Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  month.month.substring(0, 3),
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMonthlySummary(MonthlyProgress month) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              '${month.month} $selectedYear Summary',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Monthly Points: ${month.calculateMonthlyPoints()}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E3C72),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDailyProgressList(MonthlyProgress month) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final daily = month.dailyProgress[index];
          return _buildDailyProgressCard(daily);
        },
        childCount: month.dailyProgress.length,
      ),
    );
  }

  Widget _buildDailyProgressCard(DailyProgress daily) {
    // Extract the date display string - the date should already have the correct year
    String displayDate = daily.date;
    
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  displayDate,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E3C72).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Points: ${daily.calculateDailyPoints()}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E3C72),
                    ),
                  ),
                ),
              ],
            ),
            const Divider(),
            _buildLessonGrid(daily),
          ],
        ),
      ),
    );
  }

  Widget _buildLessonGrid(DailyProgress daily) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildLessonStatus('New Lesson', daily.newLesson),
            _buildLessonStatus('Juz Lesson', daily.juzLesson),
            _buildLessonStatus('Old Lesson', daily.oldLesson),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildLessonStatus('Juz Completed', daily.juzCompleted),
            _buildLessonStatus('Juz Revision', daily.juzRevision),
            _buildLessonStatus('Test Passed', daily.testPassed),
            _buildLessonStatus('Test Failed', daily.testFailed),
          ],
        ),
      ],
    );
  }

  Widget _buildLessonStatus(String title, LessonProgress lesson) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 12),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => _showLessonOptionsDialog(lesson, title),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Icon(
                  lesson.isDefault
                      ? Icons.circle_outlined
                      : lesson.completed
                          ? Icons.check_circle
                          : Icons.cancel,
                  color: lesson.isDefault
                      ? Colors.grey
                      : lesson.completed
                          ? Colors.green
                          : Colors.red,
                  size: 28,
                ),
                if (lesson.completed &&
                    title != 'Juz Completed' &&
                    title != 'Test Failed' &&
                    (lesson.lines != null || lesson.pages != null)) ...[
                  const SizedBox(height: 4),
                  Text(
                    lesson.lines != null
                        ? '${lesson.lines} lines'
                        : '${lesson.pages} pages',
                    style: const TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${lesson.calculatePoints()} points',
                    style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showLessonOptionsDialog(LessonProgress lesson, String lessonType) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Update $lessonType'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildOptionColumn(
                    icon: Icons.check_circle,
                    iconColor: Colors.green,
                    label: 'Completed',
                    onTap: () {
                      setState(() {
                        lesson.isDefault = false;
                        lesson.completed = true;
                      });
                      Navigator.pop(context);
                      if (lessonType != 'Juz Completed' &&
                          lessonType != 'Test Failed') {
                        if (lessonType == 'New Lesson') {
                          _showLineInputDialog(lesson);
                        } else {
                          _showPageInputDialog(lesson);
                        }
                      }
                    },
                  ),
                  _buildOptionColumn(
                    icon: Icons.cancel,
                    iconColor: Colors.red,
                    label: 'Not Done',
                    onTap: () {
                      setState(() {
                        lesson.isDefault = false;
                        lesson.completed = false;
                        lesson.lines = null;
                        lesson.pages = null;
                      });
                      Navigator.pop(context);
                    },
                  ),
                  _buildOptionColumn(
                    icon: Icons.remove_circle,
                    iconColor: Colors.grey,
                    label: 'Empty',
                    onTap: () {
                      setState(() {
                        lesson.isDefault = true;
                        lesson.completed = true;
                        lesson.lines = null;
                        lesson.pages = null;
                      });
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOptionColumn({
    required IconData icon,
    required Color iconColor,
    required String label,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        IconButton(
          icon: Icon(
            icon,
            color: iconColor,
            size: 40,
          ),
          onPressed: onTap,
        ),
        Text(label),
      ],
    );
  }

  void _showLineInputDialog(LessonProgress lesson) {
    final TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter Lines Read'),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Number of Lines',
              hintText: 'Enter number of lines read',
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
                setState(() {
                  lesson.lines = int.tryParse(controller.text) ?? 0;
                });
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _showPageInputDialog(LessonProgress lesson) {
    final TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter Pages Completed'),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Number of Pages',
              hintText: 'Enter number of pages completed',
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
                setState(() {
                  lesson.pages = int.tryParse(controller.text) ?? 0;
                });
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}

// Extension on Student class to handle year-specific data
extension StudentExtension on Student {
  YearlyProgress? getYearlyProgressForYear(int year) {
    // In a real app, this would retrieve year-specific data from a database
    // For now, if it's the current year, return the existing data
    if (year == DateTime.now().year) {
      return yearlyProgress;
    }
    
    // For other years, you would fetch from your database
    // For this implementation, we'll return null to let the UI create empty data
    return null;
  }
}


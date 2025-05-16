import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:table_calendar/table_calendar.dart';

// Models
class Student {
  final String name;
  final String className;
  Map<DateTime, String> attendance;

  Student({
    required this.name,
    required this.className,
    required this.attendance,
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

class AttendanceData {
  final String category;
  final int count;
  final Color color;

  AttendanceData(this.category, this.count, this.color);
}

// Constants - Now mutable for editing
Map<String, List<String>> classStudents = {
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

class AttendanceControlPage extends StatefulWidget {
  const AttendanceControlPage({super.key});

  @override
  State<AttendanceControlPage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendanceControlPage> {
  DateTime focusedDay = DateTime.now();
  DateTime? selectedDay;
  String selectedClass = 'حلقة أبي بكر الصديق';
  late List<ClassData> classes;
  Map<String, Map<String, int>> attendanceCounts = {};
  // Add variable to track if year selector is showing
  bool showYearSelector = false;

  @override
  void initState() {
    super.initState();
    _initializeClasses();
    selectedDay = focusedDay;
    _updateAttendanceCounts();
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
          ),
        ),
      );
    }).toList();
  }

  void _updateAttendanceCounts() {
    if (selectedDay == null) return;

    for (var classData in classes) {
      int presentCount = 0;
      int absentCount = 0;
      int leaveCount = 0;

      for (var student in classData.students) {
        String? status = student.attendance[selectedDay!];
        if (status == 'Present') presentCount++;
        if (status == 'Absent') absentCount++;
        if (status == 'Leave') leaveCount++;
      }

      attendanceCounts[classData.name] = {
        'Present': presentCount,
        'Absent': absentCount,
        'Leave': leaveCount,
      };
    }
    setState(() {});
  }

  // New method to add a class
  void _addClass(String className) {
    if (classStudents.containsKey(className)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Class "$className" already exists')),
      );
      return;
    }

    setState(() {
      classStudents[className] = [];
      _initializeClasses();
      selectedClass = className;
    });
  }

  // New method to add a student to a class
  void _addStudent(String className, String studentName) {
    if (studentName.isEmpty) return;
    
    setState(() {
      classStudents[className]?.add(studentName);
      _initializeClasses();
      _updateAttendanceCounts();
    });
  }

  // New method to remove a student from a class
  void _removeStudent(String className, String studentName) {
    setState(() {
      classStudents[className]?.remove(studentName);
      _initializeClasses();
      _updateAttendanceCounts();
    });
  }

  // New method to edit a student's name
  void _editStudentName(String className, String oldName, String newName) {
    if (newName.isEmpty) return;
    
    setState(() {
      int index = classStudents[className]?.indexOf(oldName) ?? -1;
      if (index != -1) {
        classStudents[className]?[index] = newName;
        _initializeClasses();
      }
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
      
      _updateAttendanceCounts();
    });
  }

  // Dialog to add a new class
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
              hintText: 'Enter class name',
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

  // Dialog to add a new student
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
              hintText: 'Enter student name',
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

  // Dialog to edit/delete a student
  void _showEditStudentDialog(String className, String studentName) {
    final TextEditingController nameController = TextEditingController(text: studentName);
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Student'),
          content: TextField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: 'Student Name',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              onPressed: () {
                _removeStudent(className, studentName);
                Navigator.pop(context);
              },
              child: const Text('Delete'),
            ),
            TextButton(
              onPressed: () {
                if (nameController.text.isNotEmpty && nameController.text != studentName) {
                  _editStudentName(className, studentName, nameController.text);
                  Navigator.pop(context);
                } else {
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

  Widget _buildCalendarCell(DateTime day) {
    ClassData currentClass =
        classes.firstWhere((classData) => classData.name == selectedClass);

    Map<String, int> statusCounts = {
      'Present': 0,
      'Absent': 0,
      'Leave': 0,
    };

    for (var student in currentClass.students) {
      String? status = student.attendance[day];
      if (status != null) {
        statusCounts[status] = (statusCounts[status] ?? 0) + 1;
      }
    }

    String? dominantStatus;
    int maxCount = 0;
    statusCounts.forEach((status, count) {
      if (count > maxCount) {
        maxCount = count;
        dominantStatus = status;
      }
    });

    if (dominantStatus == null) {
      return Center(
        child: Text(
          '${day.day}',
          style: const TextStyle(color: Colors.black),
        ),
      );
    }

    final colors = {
      'Present': Colors.green,
      'Absent': Colors.orange,
      'Leave': Colors.red,
    };

    return Container(
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: colors[dominantStatus]!.withOpacity(0.7),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          '${day.day}',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

 Widget _buildStudentAttendanceRow(Student student) {
  String? todayStatus = student.attendance[selectedDay!];
  final statusColors = {
    'Present': Colors.green,
    'Absent': Colors.orange,
    'Leave': Colors.red,
  };
  Color statusColor = statusColors[todayStatus] ?? Colors.grey;

  return Card(
    margin: const EdgeInsets.symmetric(vertical: 4),
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Leading avatar
          CircleAvatar(
            backgroundColor: Colors.purple[100],
            child: Text(
              student.name.isNotEmpty ? student.name[0] : '?',
              style: const TextStyle(
                color: Colors.purple,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Student name - full visibility
          Expanded(
            child: Text(
              student.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
              softWrap: true, // Allows multi-line text
              maxLines: 2, // Ensures text doesn't overflow vertically
              overflow: TextOverflow.visible, // No cutting off text
            ),
          ),

          // Status and actions - Flexible to prevent overflow
          Row(
            mainAxisSize: MainAxisSize.min, // Prevents forcing extra space
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  todayStatus ?? 'Not Marked',
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
              const SizedBox(width: 3),
              IconButton(
                icon: const Icon(Icons.edit, size: 20),
                onPressed: () => _showStudentAttendanceDialog(student),
              ),
              IconButton(
                icon: const Icon(Icons.more_vert, size: 20),
                onPressed: () => _showEditStudentDialog(student.className, student.name),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

  Widget _buildStatisticsCards() {
    Map<String, int> counts = attendanceCounts[selectedClass] ??
        {
          'Present': 0,
          'Absent': 0,
          'Leave': 0,
        };

    final statusColors = {
      'Present': Colors.green,
      'Absent': Colors.orange,
      'Leave': Colors.red,
    };

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: statusColors.entries.map((entry) {
        return _buildStatisticCard(
          '${counts[entry.key] ?? 0}',
          entry.key,
          entry.value,
        );
      }).toList(),
    );
  }

  Widget _buildStatisticCard(String count, String label, Color color) {
    return Container(
      width: 65,
      height: 70,
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(25),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            count,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  void _showStudentAttendanceDialog(Student student) {
    if (!mounted) return;

    final statusIcons = {
      'Present': const Icon(Icons.check_circle, color: Colors.green),
      'Absent': const Icon(Icons.cancel, color: Colors.orange),
      'Leave': const Icon(Icons.event_busy, color: Colors.red),
    };

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) => AlertDialog(
        title: Text(
          'Mark Attendance for ${student.name}',
          style: const TextStyle(fontSize: 16),
          overflow: TextOverflow.ellipsis,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: statusIcons.entries.map((entry) {
            return ListTile(
                title: Text(entry.key),
                leading: entry.value,
                onTap: () {
                  Navigator.of(dialogContext).pop();
                  _updateStudentAttendance(student, entry.key);
                });
          }).toList(),
        ),
      ),
    );
  }

  void _showClassAttendanceDialog(BuildContext context, DateTime day) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Mark Class Attendance for ${day.day}/${day.month}/${day.year}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildBulkAttendanceButton('Present', Colors.green, day),
                _buildBulkAttendanceButton('Absent', Colors.orange, day),
                _buildBulkAttendanceButton('Leave', Colors.red, day),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBulkAttendanceButton(String status, Color color, DateTime day) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(16),
      ),
      onPressed: () {
        setState(() {
          ClassData currentClass = classes
              .firstWhere((classData) => classData.name == selectedClass);

          for (var student in currentClass.students) {
            student.attendance[day] = status;
          }
          _updateAttendanceCounts();
        });
        Navigator.pop(context);
      },
      child: Text(
        status,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  void _updateStudentAttendance(Student student, String status) {
    setState(() {
      student.attendance[selectedDay!] = status;
      _updateAttendanceCounts();
    });
  }

  String _getMonthName(int month) {
    const monthNames = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return monthNames[month - 1];
  }

  // New method to build year selector grid
  Widget _buildYearSelector() {
    // Create a list of years from 2020 to 2040
    List<int> years = List.generate(21, (index) => 2020 + index);
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.purple),
                  onPressed: () {
                    setState(() {
                      showYearSelector = false;
                    });
                  },
                ),
                const Text(
                  'Select Year',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple,
                  ),
                ),
                const SizedBox(width: 48), // Balance the close button
              ],
            ),
          ),
          const Divider(height: 1),
          Container(
            constraints: const BoxConstraints(maxHeight: 220),
            child: GridView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                childAspectRatio: 1.5,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: years.length,
              itemBuilder: (context, index) {
                final year = years[index];
                final isSelected = focusedDay.year == year;
                
                return InkWell(
                  onTap: () {
                    setState(() {
                      // Update the focused day to the first day of the selected year
                      // but keep the same month
                      focusedDay = DateTime(year, focusedDay.month, 1);
                      showYearSelector = false;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.purple : Colors.purple.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      year.toString(),
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black87,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 35,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 16),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.black, size: 18),
            onPressed: _showAddClassDialog,
            tooltip: 'Add New Class',
          ),
          if (classes.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.redAccent, size: 18),
              onPressed: () => _showDeleteClassDialog(selectedClass),
              tooltip: 'Delete Current Class',
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 180,
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
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: classes.map((classData) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: ChoiceChip(
                            label: Text(
                              classData.name,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 12),
                            ),
                            selected: selectedClass == classData.name,
                            onSelected: (selected) {
                              setState(() {
                                selectedClass = classData.name;
                                _updateAttendanceCounts();
                              });
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Card(
                    margin: const EdgeInsets.only(top: 10),
                    color: const Color(0xFFF8F0FF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 16, horizontal: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.chevron_left,
                                    color: Colors.purple),
                                onPressed: () {
                                  setState(() {
                                    // Modified this section to extend back to 2020
                                    if (focusedDay.year == 2020 &&
                                        focusedDay.month <= 1) {
                                      return;
                                    }
                                    focusedDay = DateTime(
                                        focusedDay.year, focusedDay.month - 1);
                                  });
                                },
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    showYearSelector = !showYearSelector;
                                  });
                                },
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      '${_getMonthName(focusedDay.month)} ${focusedDay.year}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.purple,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    const Icon(
                                      Icons.calendar_today_outlined,
                                      size: 16,
                                      color: Colors.purple,
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.chevron_right,
                                    color: Colors.purple),
                                onPressed: () {
                                  setState(() {
                                    // Modified this section to extend to 2040
                                    if (focusedDay.year == 2040 &&
                                        focusedDay.month >= 12) {
                                      return;
                                    }
                                    focusedDay = DateTime(
                                        focusedDay.year, focusedDay.month + 1);
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        // Year selector (conditionally displayed)
                        if (showYearSelector) _buildYearSelector(),
                        TableCalendar(
                          focusedDay: focusedDay,
                          // Modified date range here
                          firstDay: DateTime(2020, 1, 1),
                          lastDay: DateTime(2040, 12, 31),
                          selectedDayPredicate: (day) =>
                              isSameDay(selectedDay, day),
                          calendarFormat: CalendarFormat.month,
                          headerVisible: false,
                          daysOfWeekHeight: 40,
                          rowHeight: 40,
                          calendarStyle: const CalendarStyle(
                            defaultTextStyle: TextStyle(color: Colors.black87),
                            weekendTextStyle: TextStyle(color: Colors.black87),
                            outsideTextStyle: TextStyle(color: Colors.grey),
                            todayDecoration: BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                            ),
                            selectedDecoration: BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                            ),
                          ),
                          daysOfWeekStyle: const DaysOfWeekStyle(
                            weekdayStyle: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                            ),
                            weekendStyle: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          onDaySelected: (selected, focused) {
                            // Modified date range check here
                            if (!selected.isBefore(DateTime(2020, 1, 1)) &&
                                !selected.isAfter(DateTime(2040, 12, 31))) {
                              setState(() {
                                selectedDay = selected;
                                focusedDay = focused;
                                _showClassAttendanceDialog(context, selected);
                              });
                            }
                          },
                          calendarBuilders: CalendarBuilders(
                            defaultBuilder: (context, day, focusedDay) {
                              return _buildCalendarCell(day);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  'Daily Report - $selectedClass',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.person_add),
                                onPressed: () => _showAddStudentDialog(selectedClass),
                                tooltip: 'Add Student',
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          _buildStatisticsCards(),
                          const SizedBox(height: 16),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              children: [
                                ListTile(
                                  title: Text(
                                    'Attendance For ${selectedDay?.day ?? ""}/${selectedDay?.month ?? ""}/${selectedDay?.year ?? ""}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                const Divider(height: 1),
                                if (selectedClass.isNotEmpty && classes.isNotEmpty)
                                  ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: classes
                                        .firstWhere(
                                            (c) => c.name == selectedClass)
                                        .students
                                        .length,
                                    itemBuilder: (context, index) {
                                      Student student = classes
                                          .firstWhere(
                                              (c) => c.name == selectedClass)
                                          .students[index];
                                      return _buildStudentAttendanceRow(student);
                                    },
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Attendance Chart Widget
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Attendance Summary',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            height: 200,
                            child: SfCircularChart(
                              legend: Legend(
                                isVisible: true,
                                position: LegendPosition.bottom,
                              ),
                              series: <CircularSeries>[
                                DoughnutSeries<AttendanceData, String>(
                                  dataSource: [
                                    AttendanceData(
                                      'Present',
                                      attendanceCounts[selectedClass]?['Present'] ?? 0,
                                      Colors.green,
                                    ),
                                    AttendanceData(
                                      'Absent',
                                      attendanceCounts[selectedClass]?['Absent'] ?? 0,
                                      Colors.orange,
                                    ),
                                    AttendanceData(
                                      'Leave',
                                      attendanceCounts[selectedClass]?['Leave'] ?? 0,
                                      Colors.red,
                                    ),
                                  ],
                                  xValueMapper: (AttendanceData data, _) => data.category,
                                  yValueMapper: (AttendanceData data, _) => data.count,
                                  pointColorMapper: (AttendanceData data, _) => data.color,
                                  dataLabelSettings: const DataLabelSettings(
                                    isVisible: true,
                                    labelPosition: ChartDataLabelPosition.outside,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

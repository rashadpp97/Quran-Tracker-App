import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quran_progress_tracker_app/view/Teachers_panel/teachers_panel_page.dart';

void main() {
  runApp(const DailyReportControlPage());
}

class DailyReportControlPage extends StatelessWidget {
  const DailyReportControlPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quran Progress Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: const Color(0xFFF5F6FA),
      ),
      home: ProgressTrackingScreen(student: _createSampleStudent()),
    );
  }

  Student _createSampleStudent() {
    return Student(
      id: 'student_001', // Added unique ID for Firestore
      name: 'Sample Student',
      classNumber: 1,
      yearlyProgress: _generateYearlyProgress(),
    );
  }

  YearlyProgress _generateYearlyProgress() {
    List<MonthlyProgress> months = [];
    final monthNames = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];

    for (int m = 0; m < 12; m++) {
      List<DailyProgress> days = [];
      final daysInMonth = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31][m];

      for (int d = 1; d <= daysInMonth; d++) {
        days.add(DailyProgress(
          date: '${d.toString().padLeft(2, '0')}-${(m + 1).toString().padLeft(2, '0')}-2025',
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
      year: '2025',
      monthlyProgress: months,
    );
  }
}

class Student {
  String id; // Added for Firestore document ID
  String name;
  int classNumber;
  YearlyProgress yearlyProgress;

  Student({
    required this.id,
    required this.name,
    required this.classNumber,
    required this.yearlyProgress,
  });

  // Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'classNumber': classNumber,
      'yearlyProgress': yearlyProgress.toMap(),
    };
  }

  // Create from Firestore document
  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      classNumber: map['classNumber'] ?? 0,
      yearlyProgress: YearlyProgress.fromMap(map['yearlyProgress'] ?? {}),
    );
  }
}

class LessonProgress {
  bool completed;
  bool isDefault;
  int? lines;
  int? pages;
  bool isRead;
  // bool hasHifzLesson;

  LessonProgress({
    this.completed = false,
    this.isDefault = true,
    this.lines,
    this.pages,
    this.isRead = false,
    // this.hasHifzLesson = false,
  });

  int calculatePoints() {
    if (!completed) return 0;
    if (lines != null) return lines!;
    if (pages != null) return pages!;
    return 0;
  }

  // Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'completed': completed,
      'isDefault': isDefault,
      'lines': lines,
      'pages': pages,
      'isRead': isRead,
      // 'hasHifzLesson': hasHifzLesson,
    };
  }

  // Create from Firestore document
  factory LessonProgress.fromMap(Map<String, dynamic> map) {
    return LessonProgress(
      completed: map['completed'] ?? false,
      isDefault: map['isDefault'] ?? true,
      lines: map['lines'],
      pages: map['pages'],
      isRead: map['isRead'] ?? false,
      // hasHifzLesson: map['hasHifzLesson'] ?? false,
    );
  }
}

class DailyProgress {
  final String date;
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
        testPassed.calculatePoints();
  }

  // Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'newLesson': newLesson.toMap(),
      'juzLesson': juzLesson.toMap(),
      'oldLesson': oldLesson.toMap(),
      'juzCompleted': juzCompleted.toMap(),
      'juzRevision': juzRevision.toMap(),
      'testPassed': testPassed.toMap(),
      'testFailed': testFailed.toMap(),
    };
  }

  // Create from Firestore document
  factory DailyProgress.fromMap(Map<String, dynamic> map) {
    return DailyProgress(
      date: map['date'] ?? '',
      newLesson: LessonProgress.fromMap(map['newLesson'] ?? {}),
      juzLesson: LessonProgress.fromMap(map['juzLesson'] ?? {}),
      oldLesson: LessonProgress.fromMap(map['oldLesson'] ?? {}),
      juzCompleted: LessonProgress.fromMap(map['juzCompleted'] ?? {}),
      juzRevision: LessonProgress.fromMap(map['juzRevision'] ?? {}),
      testPassed: LessonProgress.fromMap(map['testPassed'] ?? {}),
      testFailed: LessonProgress.fromMap(map['testFailed'] ?? {}),
    );
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

  // Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'month': month,
      'dailyProgress': dailyProgress.map((daily) => daily.toMap()).toList(),
    };
  }

  // Create from Firestore document
  factory MonthlyProgress.fromMap(Map<String, dynamic> map) {
    return MonthlyProgress(
      month: map['month'] ?? '',
      dailyProgress: (map['dailyProgress'] as List<dynamic>?)
              ?.map((daily) => DailyProgress.fromMap(daily))
              .toList() ??
          [],
    );
  }
}

class YearlyProgress {
  final String year;
  final List<MonthlyProgress> monthlyProgress;

  YearlyProgress({
    required this.year,
    required this.monthlyProgress,
  });

  int calculateYearlyPoints() {
    return monthlyProgress.fold(
        0, (sum, month) => sum + month.calculateMonthlyPoints());
  }

  // Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'year': year,
      'monthlyProgress': monthlyProgress.map((month) => month.toMap()).toList(),
    };
  }

  // Create from Firestore document
  factory YearlyProgress.fromMap(Map<String, dynamic> map) {
    return YearlyProgress(
      year: map['year'] ?? '',
      monthlyProgress: (map['monthlyProgress'] as List<dynamic>?)
              ?.map((month) => MonthlyProgress.fromMap(month))
              .toList() ??
          [],
    );
  }
}

// Firestore Service Class
class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Save student progress to Firestore
  Future<void> saveStudentProgress(Student student, int year) async {
    try {
      await _firestore
          .collection('students')
          .doc(student.id)
          .collection('yearly_progress')
          .doc(year.toString())
          .set(student.yearlyProgress.toMap());
    } catch (e) {
      throw Exception('Failed to save student progress: $e');
    }
  }

  // Load student progress from Firestore
  Future<YearlyProgress?> loadStudentProgress(String studentId, int year) async {
    try {
      final doc = await _firestore
          .collection('students')
          .doc(studentId)
          .collection('yearly_progress')
          .doc(year.toString())
          .get();

      if (doc.exists) {
        return YearlyProgress.fromMap(doc.data()!);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to load student progress: $e');
    }
  }

  // Save student basic info
  Future<void> saveStudentInfo(Student student) async {
    try {
      await _firestore.collection('students').doc(student.id).set({
        'id': student.id,
        'name': student.name,
        'classNumber': student.classNumber,
      });
    } catch (e) {
      throw Exception('Failed to save student info: $e');
    }
  }

  // Load student basic info
  Future<Student?> loadStudentInfo(String studentId) async {
    try {
      final doc = await _firestore.collection('students').doc(studentId).get();
      if (doc.exists) {
        final data = doc.data()!;
        return Student(
          id: data['id'],
          name: data['name'],
          classNumber: data['classNumber'],
          yearlyProgress: YearlyProgress(year: '2025', monthlyProgress: []),
        );
      }
      return null;
    } catch (e) {
      throw Exception('Failed to load student info: $e');
    }
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
  bool isLoading = false;
  bool hasUnsavedChanges = false;

  late YearlyProgress currentYearProgress;
  final Map<int, YearlyProgress> yearDataCache = {};
  final FirestoreService _firestoreService = FirestoreService();

  @override
  void initState() {
    super.initState();
    _loadYearData(selectedYear);
  }

  Future<void> _loadYearData(int year) async {
    setState(() {
      isLoading = true;
    });

    try {
      if (yearDataCache.containsKey(year)) {
        setState(() {
          currentYearProgress = yearDataCache[year]!;
          isLoading = false;
        });
        return;
      }

      // Try to load from Firestore first
      YearlyProgress? firestoreData = await _firestoreService.loadStudentProgress(
        widget.student.id,
        year,
      );

      if (firestoreData != null) {
        setState(() {
          currentYearProgress = firestoreData;
          yearDataCache[year] = firestoreData;
          isLoading = false;
        });
      } else {
        // Create new empty year if no data exists
        YearlyProgress newYearProgress = _createEmptyYearProgress(year);
        setState(() {
          currentYearProgress = newYearProgress;
          yearDataCache[year] = newYearProgress;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      _showErrorDialog('Failed to load data: $e');
    }
  }

  Future<void> _saveCurrentYearData() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Create a temporary student object with current year's data
      Student tempStudent = Student(
        id: widget.student.id,
        name: widget.student.name,
        classNumber: widget.student.classNumber,
        yearlyProgress: currentYearProgress,
      );

      await _firestoreService.saveStudentProgress(tempStudent, selectedYear);
      await _firestoreService.saveStudentInfo(tempStudent);

      setState(() {
        isLoading = false;
        hasUnsavedChanges = false;
      });

      _showSuccessDialog('Data saved successfully!');
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      _showErrorDialog('Failed to save data: $e');
    }
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Success'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  YearlyProgress _createEmptyYearProgress(int year) {
    List<String> months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];

    List<MonthlyProgress> monthlyProgress = [];

    for (int i = 0; i < months.length; i++) {
      int daysInMonth = _getDaysInMonth(i + 1, year);
      List<DailyProgress> dailyProgress = [];

      for (int day = 1; day <= daysInMonth; day++) {
        String formattedDay = day.toString().padLeft(2, '0');
        String formattedMonth = (i + 1).toString().padLeft(2, '0');
        String dateString = "$formattedDay-$formattedMonth-$year";

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

    return YearlyProgress(monthlyProgress: monthlyProgress, year: year.toString());
  }

  int _getDaysInMonth(int month, int year) {
    if (month == 2) {
      if ((year % 4 == 0 && year % 100 != 0) || year % 400 == 0) {
        return 29;
      } else {
        return 28;
      }
    } else if ([4, 6, 9, 11].contains(month)) {
      return 30;
    } else {
      return 31;
    }
  }

  void _updateSelectedYear(int year) {
    setState(() {
      selectedYear = year;
      showYearPicker = false;
    });
    _loadYearData(year);
  }

  void _markAsChanged() {
    setState(() {
      hasUnsavedChanges = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Loading...'),
          backgroundColor: const Color(0xFF1E3C72),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final selectedMonth = currentYearProgress.monthlyProgress[selectedMonthIndex];

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
              MaterialPageRoute(builder: (context) => const TeachersPanelPage()),
            );
          },
        ),
        centerTitle: true,
        title: Text(
          'PROGRESS - $selectedYear${hasUnsavedChanges ? ' ' : ''}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF1E3C72),
        actions: [
          if (hasUnsavedChanges)
            IconButton(
              icon: const Icon(Icons.save, color: Colors.white),
              onPressed: _saveCurrentYearData,
            ),
        ],
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
                _buildSubmitButton(),
              ],
            ),
          ),
          _buildDailyProgressList(selectedMonth),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      margin: const EdgeInsets.all(16),
      child: ElevatedButton(
        onPressed: isLoading ? null : _saveCurrentYearData,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1E3C72),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.cloud_upload,color: Colors.white),
                  const SizedBox(width: 8),
                  Text(
                    hasUnsavedChanges ? 'Save to Firestore' : 'Data Saved',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
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
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
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
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text('Update $lessonType'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Status options
                    RadioListTile<String>(
                      title: const Text('Empty'),
                      value: 'default',
                      groupValue: lesson.isDefault
                          ? 'default'
                          : lesson.completed
                              ? 'completed'
                              : 'failed',
                      onChanged: (value) {
                        setDialogState(() {
                          lesson.isDefault = true;
                          lesson.completed = false;
                          lesson.lines = null;
                          lesson.pages = null;
                        });
                      },
                    ),
                    RadioListTile<String>(
                      title: const Text('Completed'),
                      value: 'completed',
                      groupValue: lesson.isDefault
                          ? 'default'
                          : lesson.completed
                              ? 'completed'
                              : 'failed',
                      onChanged: (value) {
                        setDialogState(() {
                          lesson.isDefault = false;
                          lesson.completed = true;
                        });
                      },
                    ),
                    RadioListTile<String>(
                      title: const Text('Failed'),
                      value: 'failed',
                      groupValue: lesson.isDefault
                          ? 'default'
                          : lesson.completed
                              ? 'completed'
                              : 'failed',
                      onChanged: (value) {
                        setDialogState(() {
                          lesson.isDefault = false;
                          lesson.completed = false;
                          lesson.lines = null;
                          lesson.pages = null;
                        });
                      },
                    ),
                    
                    // Show input fields only for completed lessons and specific lesson types
                    if (!lesson.isDefault && 
                        lesson.completed && 
                        lessonType != 'Juz Completed' && 
                        lessonType != 'Test Failed') ...[
                      const Divider(),
                      const Text(
                        'Progress Details:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      
                      // Lines input
                      TextFormField(
                        initialValue: lesson.lines?.toString() ?? '',
                        decoration: const InputDecoration(
                          labelText: 'Lines',
                          border: OutlineInputBorder(),
                          hintText: 'Enter number of lines',
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          setDialogState(() {
                            if (value.isEmpty) {
                              lesson.lines = null;
                            } else {
                              final parsed = int.tryParse(value);
                              if (parsed != null) {
                                lesson.lines = parsed;
                                lesson.pages = null; // Clear pages when lines is set
                              }
                            }
                          });
                        },
                      ),
                      const SizedBox(height: 10),
                      
                      const Text('OR', textAlign: TextAlign.center),
                      const SizedBox(height: 10),
                      
                      // Pages input
                      TextFormField(
                        initialValue: lesson.pages?.toString() ?? '',
                        decoration: const InputDecoration(
                          labelText: 'Pages',
                          border: OutlineInputBorder(),
                          hintText: 'Enter number of pages',
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          setDialogState(() {
                            if (value.isEmpty) {
                              lesson.pages = null;
                            } else {
                              final parsed = int.tryParse(value);
                              if (parsed != null) {
                                lesson.pages = parsed;
                                lesson.lines = null; // Clear lines when pages is set
                              }
                            }
                          });
                        },
                      ),
                      // const SizedBox(height: 10),
                      
                      // Additional options
                      // CheckboxListTile(
                      //   title: const Text('Is Read'),
                      //   value: lesson.isRead,
                      //   onChanged: (value) {
                      //     setDialogState(() {
                      //       lesson.isRead = value ?? false;
                      //     });
                      //   },
                      // ),
                      // CheckboxListTile(
                      //   title: const Text('Has Hifz Lesson'),
                      //   value: lesson.hasHifzLesson,
                      //   onChanged: (value) {
                      //     setDialogState(() {
                      //       lesson.hasHifzLesson = value ?? false;
                      //     });
                      //   },
                      // ),
                    ],
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
                    _markAsChanged();
                    setState(() {}); // Refresh the main UI
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E3C72),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
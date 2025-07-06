import 'package:flutter/material.dart';


// Data model for a single lesson
class LessonProgress {
  bool completed;
  late final int? lines; // For new lesson
  late final int? pages; // For juz and old lessons

  LessonProgress({
    required this.completed,
    this.lines,
    this.pages,
  });

  Map<String, dynamic> toMap() {
    return {
      'completed': completed,
      'rows': lines,
    };
  }

  int calculatePoints() {
    if (!completed) return 0;
    if (lines != null) return lines!; // 1 point per line for new lesson
    if (pages != null) return pages!; // 1 point per page for juz/old lessons
    return 0;
  }
}

// Data model for daily progress
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
        oldLesson.calculatePoints();
  }
}

// Data model for monthly progress
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

  int calculateTotalNewLessons() {
    return dailyProgress
        .where((d) => d.newLesson.completed)
        .fold(0, (sum, d) => sum + (d.newLesson.lines ?? 0));
  }

  int calculateTotalJuzLessons() {
    return dailyProgress.where((d) => d.juzLesson.completed).length;
  }

  int calculateTotalOldLessons() {
    return dailyProgress.where((d) => d.oldLesson.completed).length;
  }
}

// Data model for yearly progress
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
}

class ProgressTracker extends StatefulWidget {
  const ProgressTracker({super.key});

  @override
  State<ProgressTracker> createState() => _ProgressTrackerState();
}

class _ProgressTrackerState extends State<ProgressTracker>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late YearlyProgress yearlyData;
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
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutBack,
    );
    _controller.forward();

    // Initialize with sample data for the current year
    _loadYearlyData(selectedYear);
  }

  void _loadYearlyData(int year) {
    // Check if we already have this year's data cached
    if (yearDataCache.containsKey(year)) {
      setState(() {
        yearlyData = yearDataCache[year]!;
      });
      return;
    }

    // Generate new data for this year
    final data = _generateSampleYearData(year);
    yearDataCache[year] = data;
    
    setState(() {
      yearlyData = data;
    });
  }

  YearlyProgress _generateSampleYearData([int? year]) {
    final selectedYear = year ?? DateTime.now().year;
    final List<MonthlyProgress> months = [];
    final List<String> monthNames = [
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
      final List<DailyProgress> days = [];
      
      // Calculate days in month, accounting for leap years
      int daysInMonth;
      if (m == 1) { // February
        if ((selectedYear % 4 == 0 && selectedYear % 100 != 0) || selectedYear % 400 == 0) {
          daysInMonth = 29; // Leap year
        } else {
          daysInMonth = 28; // Non-leap year
        }
      } else {
        daysInMonth = [31, 0, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31][m];
      }

      for (int d = 1; d <= daysInMonth; d++) {
        days.add(DailyProgress(
          date:
              '${d.toString().padLeft(2, '0')}-${(m + 1).toString().padLeft(2, '0')}-$selectedYear',
          newLesson: LessonProgress(completed: false, lines: 0),
          juzLesson: LessonProgress(completed: false),
          oldLesson: LessonProgress(completed: false),
          juzCompleted: LessonProgress(completed: false),
          juzRevision: LessonProgress(completed: false),
          testPassed: LessonProgress(completed: false),
          testFailed: LessonProgress(completed: false),
        ));
      }

      months.add(MonthlyProgress(
        month: monthNames[m],
        dailyProgress: days,
      ));
    }

    return YearlyProgress(
      year: '$selectedYear-${selectedYear + 1}',
      monthlyProgress: months,
    );
  }

  void _showYearPickerDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Year'),
          content: Container(
            width: double.maxFinite,
            height: 300,
            child: ListView.builder(
              itemCount: 31, // Years from 2020 to 2050
              itemBuilder: (context, index) {
                final year = 2020 + index;
                return ListTile(
                  title: Text(
                    '$year-${year + 1}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: year == selectedYear ? FontWeight.bold : FontWeight.normal,
                      color: year == selectedYear ? const Color(0xFF1E3C72) : null,
                    ),
                  ),
                  tileColor: year == selectedYear ? const Color(0xFF1E3C72).withOpacity(0.1) : null,
                  onTap: () {
                    setState(() {
                      selectedYear = year;
                      _loadYearlyData(year);
                    });
                    Navigator.of(context).pop();
                  },
                );
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedMonth = yearlyData.monthlyProgress[selectedMonthIndex];

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildAppBar(),
          SliverToBoxAdapter(
            child: Column(
              children: [
                _buildYearlySummary(),
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

  Widget _buildAppBar() {
    return SliverAppBar(
      leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios, // iOS-style back button icon
              color: Colors.white, // Set the color of the icon
            ),
            onPressed: () {
              // Navigate to StudentDetailsApp
              Navigator.pop(context);
            }),
      expandedHeight: 170.0,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true, // Aligns the title to the center
        titlePadding: const EdgeInsets.only(bottom: 16),
        title: Text(
          'DAILY PROGRESS',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20
          ),
        ),
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1E3C72), Color(0xFF2A5298)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Stack(
            children: [
              Align(
                alignment:
                    Alignment.topCenter, // Position icon at the top center
                child: Padding(
                  padding:
                      const EdgeInsets.only(top: 25), // Add spacing from top
                  child: Icon(
                    Icons.auto_stories,
                    size: 80,
                    color: Colors.white.withOpacity(0.3),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildYearlySummary() {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Card(
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
                  const SizedBox(width: 8),
                  // Year selector button
                  GestureDetector(
                    onTap: _showYearPickerDialog,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12, 
                        vertical: 6
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E3C72).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            yearlyData.year,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E3C72),
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.calendar_today_rounded,
                            size: 16,
                            color: Color(0xFF1E3C72),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'Total Points: ${yearlyData.calculateYearlyPoints()}',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E3C72),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMonthSelector() {
    return Container(
      height: 60,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 12,
        itemBuilder: (context, index) {
          final month = yearlyData.monthlyProgress[index];
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
                    offset: const Offset(0, 2),
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
              '${month.month} Summary',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatistic("New Lesson\nTotal points", month.calculateTotalNewLessons(),
                    Colors.blue),
                _buildStatistic('Juz Lesson\nTotal points',
                    month.calculateTotalJuzLessons(), Colors.purple),
                _buildStatistic('Old Lesson\nTotal points', month.calculateTotalOldLessons(),
                    Colors.teal),
              ],
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

  Widget _buildStatistic(String label, int value, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            value.toString(),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
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
                daily.date,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildLessonColumn('New Lesson', daily.newLesson, Colors.blue),
              _buildLessonColumn('Juz Lesson', daily.juzLesson, Colors.purple),
              _buildLessonColumn('Old Lesson', daily.oldLesson, Colors.teal),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildLessonColumn('Juz Completed', daily.juzCompleted, Colors.blue),
              _buildLessonColumn('Juz Revision', daily.juzRevision, Colors.purple),
              _buildLessonColumn('Test Passed', daily.testPassed, Colors.teal),
              _buildLessonColumn('Test Failed', daily.testFailed, Colors.brown),
            ],
          ),
        ],
      ),
    ),
  );
}

Widget _buildLessonColumn(String title, LessonProgress lesson, Color color) {
  return Expanded(
    child: Column(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        // First status indicator without text
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: color.withOpacity(0.5),
              width: 2,
            ),
            color: lesson.completed ? color.withOpacity(0.1) : Colors.transparent,
          ),
          child: lesson.completed
              ? Icon(
                  Icons.check,
                  color: color,
                  size: 24,
                )
              : null,
        ),

        const SizedBox(height: 6),
        // Second status indicator with bold text
        Column(
          children: [
             const SizedBox(height: 8),
          ],
        ),
        if (lesson.lines != null && lesson.completed) ...[
          const SizedBox(height: 4),
          Text(
            '${lesson.lines} lines',
            style: TextStyle(
              color: color,
              fontSize: 12,
            ),
          ),
        ],
        if (lesson.pages != null && lesson.completed) ...[
          const SizedBox(height: 4),
          Text(
            '${lesson.pages} pages',
            style: TextStyle(
              color: color,
              fontSize: 12,
            ),
          ),
        ],
        if (lesson.completed) ...[
          const SizedBox(height: 4),
          Text(
            '${lesson.calculatePoints()} points',
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ],
    ),
  );
}

Widget _buildStatusIndicator(String label, bool completed, Color color) {
  return Column(
    children: [
      Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: color.withOpacity(0.5),
            width: 2,
          ),
          color: completed ? color.withOpacity(0.1) : Colors.transparent,
        ),
        child: completed
            ? Icon(
                Icons.check,
                color: color,
                size: 24,
              )
            : null,
      ),
      const SizedBox(height: 4),
      Text(
        label,
        style: TextStyle(
          fontSize: 12,
          color: Colors.black87,
        ),
        textAlign: TextAlign.center,
      ),
    ],
  );
}

  Widget _buildLessonStatus(String title, LessonProgress lesson, Color color) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 12),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                if (lesson.completed)
                  const Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 28,
                  ),
                if (lesson.lines != null && lesson.completed) ...[
                  const SizedBox(height: 4),
                  Text(
                    '${lesson.lines} lines',
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ],
                if (lesson.pages != null && lesson.completed) ...[
                  const SizedBox(height: 4),
                  Text(
                    '${lesson.pages} pages',
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ],
                if (lesson.completed) ...[
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
}
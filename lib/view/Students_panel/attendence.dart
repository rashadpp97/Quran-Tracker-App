import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:table_calendar/table_calendar.dart';

class AttendancePage extends StatefulWidget {
  const AttendancePage(
      {super.key, required Map<String, List<StudentData>> attendanceData});

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class StudentData {}

class _AttendancePageState extends State<AttendancePage> {
  // Initialize focusedDay to be within the valid range
  DateTime focusedDay = DateTime.now();
  DateTime? selectedDay;

  // Define the valid date range
  final DateTime firstDay = DateTime(2020, 01, 01); // Extended to 2020
  final DateTime lastDay = DateTime(2040, 12, 31); // Extended to 2040

  Map<DateTime, String> attendanceStatus = {};
  int presentCount = 0;
  int leaveCount = 0;
  int absentCount = 0;
  
  // For the attendance chart
  String selectedClass = 'All'; // Default selected class
  Map<String, Map<String, int>> attendanceCounts = {
    'All': {'Present': 0, 'Absent': 0, 'Leave': 0},
  };

  // Year selection
  bool showYearPicker = false;
  final List<int> yearList = List.generate(21, (index) => 2020 + index); // 2020 to 2040

  @override
  void initState() {
    super.initState();
    // Ensure focusedDay is within the valid range
    if (focusedDay.isBefore(firstDay)) {
      focusedDay = firstDay;
    } else if (focusedDay.isAfter(lastDay)) {
      focusedDay = lastDay;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 30,
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios, // iOS-style back button icon
              color: Colors.black, // Set the color of the icon
              size: 18,
            ),
            onPressed: () {
              // Navigate to StudentDetailsApp
              Navigator.pop(context);
            }),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Top Banner Image
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

            const SizedBox(height: 4),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'View Attendance',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: 12),
                  
                  // Year Selector
                  if (showYearPicker)
                    Container(
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 1,
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      child: GridView.builder(
                        padding: const EdgeInsets.all(8),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          childAspectRatio: 1.5,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemCount: yearList.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              setState(() {
                                focusedDay = DateTime(
                                  yearList[index],
                                  focusedDay.month,
                                  focusedDay.day,
                                );
                                showYearPicker = false;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: focusedDay.year == yearList[index]
                                    ? Colors.purple
                                    : Colors.purple.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                '${yearList[index]}',
                                style: TextStyle(
                                  color: focusedDay.year == yearList[index]
                                      ? Colors.white
                                      : Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  
                  // Month Selector with Year button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.chevron_left,
                            color: Colors.purple),
                        onPressed: () {
                          setState(() {
                            final newDate = DateTime(
                              focusedDay.year,
                              focusedDay.month - 1,
                              focusedDay.day,
                            );
                            if (!newDate.isBefore(firstDay)) {
                              focusedDay = newDate;
                            }
                          });
                        },
                      ),
                      Row(
                        children: [
                          Text(
                            '${_monthName(focusedDay.month)} ',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.purple,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                showYearPicker = !showYearPicker;
                              });
                            },
                            child: Row(
                              children: [
                                Text(
                                  '${focusedDay.year}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.purple,
                                  ),
                                ),
                                Icon(
                                  showYearPicker 
                                      ? Icons.arrow_drop_up 
                                      : Icons.arrow_drop_down,
                                  color: Colors.purple,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.chevron_right,
                            color: Colors.purple),
                        onPressed: () {
                          setState(() {
                            final newDate = DateTime(
                              focusedDay.year,
                              focusedDay.month + 1,
                              focusedDay.day,
                            );
                            if (!newDate.isAfter(lastDay)) {
                              focusedDay = newDate;
                            }
                          });
                        },
                      ),
                    ],
                  ),

                  // Calendar
                  Card(
                    child: SingleChildScrollView(
                      child: TableCalendar(
                        focusedDay: focusedDay,
                        firstDay: firstDay,
                        lastDay: lastDay,
                        calendarFormat: CalendarFormat.month,
                        headerVisible: false,
                        calendarStyle: CalendarStyle(
                          todayDecoration: BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                          ),
                        ),
                        onDaySelected: (selected, focused) {
                          setState(() {
                            selectedDay = selected;
                            focusedDay = focused;
                            // _showAttendanceSelection(context, selected);
                          });
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  // Attendance Cards
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatisticCard(
                          '$presentCount', 'Present', Colors.green),
                      _buildStatisticCard(
                          '$leaveCount', 'Leave', Colors.orange),
                      _buildStatisticCard('$absentCount', 'Absent', Colors.red),
                    ],
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

  Widget _buildStatisticCard(String count, String label, Color color) {
    return Container(
      width: 65,
      height: 70,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.only(
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
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarMarker(DateTime day, Color color) {
    return Center(
      child: Container(
        width: 35,
        height: 35,
        decoration: BoxDecoration(
          color: color,
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
      ),
    );
  }

  String _monthName(int month) {
    const months = [
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
    return months[month - 1];
  }
}

class AttendanceData {
  final String category;
  final int count;
  final Color color;

  AttendanceData(this.category, this.count, this.color);
}
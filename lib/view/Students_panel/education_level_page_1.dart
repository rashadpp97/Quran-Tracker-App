import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';


class HifzGraphPage extends StatefulWidget {
  const HifzGraphPage({super.key});

  @override
  _HifzGraphPageState createState() => _HifzGraphPageState();
}

class _HifzGraphPageState extends State<HifzGraphPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  // Colorful data with assigned colors for each year
  final List<HifzData> hifzData = [
    HifzData('Center', 2, const Color(0xFF6B48FF)),
    HifzData('Year 1', 4, const Color(0xFF4CAF50)),
    HifzData('Year 2', 6, const Color(0xFFFF6B6B)),
    HifzData('Year 3', 3, const Color(0xFF48C9FF)),
    HifzData('Year 4', 8, const Color(0xFFFFBE0B)),
    HifzData('Year 5', 4, const Color.fromARGB(255, 255, 72, 228)),
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios, // iOS-style back button icon
              color: const Color.fromARGB(
                  255, 220, 225, 235), // Set the color of the icon
              size: 20,
            ),
            onPressed: () {
              // Navigate to StudentDetailsApp
              Navigator.pop(context);
            }),
        title: const Text('Hifz Journey Visualization',
            style: TextStyle(color: Colors.white)),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF6B48FF), Color(0xFF48C9FF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.indigo.shade50, Colors.blue.shade50],
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

  Widget _buildProgressCard() {
    return Card(
      elevation: 8,
      shadowColor: Colors.blue,
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
              'Total Hifz Progress',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C3E50),
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
                        value: _animation.value * 0.6,
                        strokeWidth: 12,
                        backgroundColor: Colors.grey[200],
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Color(0xFF6B48FF),
                        ),
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${(_animation.value * 10).toInt()}',
                          style: const TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2C3E50),
                          ),
                        ),
                        const Text(
                          'Juz Completed',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color.fromARGB(255, 124, 138, 139),
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
      shadowColor: Colors.blue,
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
                          // tooltipBgColor: Colors.blueGrey,
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
                                  hifzData[value.toInt()].year,
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
                      barGroups: hifzData.asMap().entries.map((entry) {
                        return BarChartGroupData(
                          x: entry.key,
                          barRods: [
                            BarChartRodData(
                              toY: entry.value.juzCount * _animation.value,
                              color: entry.key ==
                                      0 // Replace `regionalKey` with the key for "Regional"
                                  ? Colors
                                      .green // Color for "Regional" Juz value
                                  : entry.value
                                      .color, // Default color for other values
                              width: 35,
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(6),
                              ),
                              gradient: entry.key == 0
                                  ? LinearGradient(
                                      colors: [
                                        Colors.lime, // Top color for "Regional"
                                        Colors
                                            .lime, // Bottom color for "Regional"
                                      ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    )
                                  : LinearGradient(
                                      colors: [
                                        entry.value.color,
                                        entry.value.color,
                                      ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
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
      shadowColor: Colors.blue,
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
                          value: 10,
                          title: 'Completed\n10 Juz',
                          color: const Color(0xFF6B48FF),
                          radius: 100 * _animation.value,
                          titleStyle: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        PieChartSectionData(
                          value: 20,
                          title: 'Remaining\n20 Juz',
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
      shadowColor: Colors.blue.withOpacity(0.4),
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
            ...hifzData.map((data) => Padding(
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
  final int juzCount;
  final Color color;

  const HifzData(this.year, this.juzCount, this.color);
}

import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'attendence.dart';
import 'daily_report.dart';
import 'education_level_page_1.dart';
import 'monthly_topper.dart';

class StudentsPerformancePage1 extends StatefulWidget {
  const StudentsPerformancePage1({
    super.key,
    required this.name,
    required this.className,
    required this.image,
  });

  final String name;
  final String className;
  final String image;

  @override
  State<StudentsPerformancePage1> createState() => _StudentsPerformancePageState();
}

class _StudentsPerformancePageState extends State<StudentsPerformancePage1> with SingleTickerProviderStateMixin {
  late DateTime startDate;
  late DateTime originalTargetDate;
  late DateTime adjustedTargetDate;
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;
  
  // Current student performance metrics
  final int memorizedJuzzCount = 12;
  final int totalJuzz = 30;

  @override
  void initState() {
    super.initState();
    startDate = DateTime.now().subtract(const Duration(days: 30));
    originalTargetDate = DateTime.now().add(const Duration(days: 60));
    adjustedTargetDate = DateTime.now().add(const Duration(days: 90));

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    // Calculate progress percentage
    final double progressPercentage = memorizedJuzzCount / totalJuzz;
    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: progressPercentage,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 56,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
            size: 22,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildProfileHeader(screenSize, isDarkMode),
            const SizedBox(height: 80),
            
            // Student Performance Title
            const Center(
              child: Text(
                'STUDENTS PERFORMANCE',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6A11CB),
                  letterSpacing: 1.2,
                ),
              ),
            ),
            
            const SizedBox(height: 30),
            
            // Grid buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: _buildNavigationGrid(),
            ),

            const SizedBox(height: 30),

            // Progress Card with alternative visualization option
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: _buildProgressCardWithOptions(isDarkMode),
            ),  
          
            const SizedBox(height: 30),

            // Stats Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: _buildStatsCard(isDarkMode),
            ),
          
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(Size screenSize, bool isDarkMode) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        // Header background
        Container(
          height: 230,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/qaf picture.jpg'),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(50),
              bottomRight: Radius.circular(50),
            ),
            boxShadow: [
              BoxShadow(
                color: Color(0x40000000),
                blurRadius: 15,
                spreadRadius: 0,
                offset: Offset(0, 4),
              ),
            ],
          ),
        ),
        
        // Profile image and info
        Positioned(
          top: 145,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 130,
                height: 130,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFF4A5D48),
                    width: 4,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      blurRadius: 15,
                      spreadRadius: 0,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  backgroundColor: const Color(0xFFF5F2F2),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipOval(
                      child: Image.asset(
                        widget.image,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                widget.name,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF4A5D48).withOpacity(0.9),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  widget.className,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNavigationGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 20,
      mainAxisSpacing: 20,
      childAspectRatio: 1.1,
      children: [
        _buildModernButton(
          icon: Icons.assessment,
          label: 'Daily Report',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ProgressTracker()),
          ),
        ),
        _buildModernButton(
          icon: Icons.calendar_month,
          label: 'Attendance',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AttendancePage(attendanceData: {})),
          ),
        ),
        _buildModernButton(
          icon: Icons.emoji_events,
          label: 'Monthly Topper',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MonthlyTopperPage(students: [],)),
          ),
        ),
        _buildModernButton(
          icon: Icons.school,
          label: 'Education Level',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const HifzGraphPage()),
          ),
        ),
      ],
    );
  }

  Widget _buildProgressCardWithOptions(bool isDarkMode) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDarkMode 
              ? [const Color(0xFF1F2040), const Color(0xFF151530)]
              : [Colors.white, const Color(0xFFF0F4F8)],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF001F3F).withOpacity(0.15),
            blurRadius: 20,
            spreadRadius: 0,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(
          color: isDarkMode 
              ? Colors.white.withOpacity(0.1) 
              : Colors.white.withOpacity(0.8),
          width: isDarkMode ? 0.5 : 1.5,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title with animated gradient
            ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [
                  Color(0xFF001F3F),
                  Color(0xFF265C4B),
                  Color(0xFF3D9970),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ).createShader(bounds),
              child: const Row(
                children: [
                  Text(
                    'Learning Progress',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: -0.5,
                    ),
                  ),
                  SizedBox(width: 10),
                  Icon(
                    Icons.auto_awesome,
                    color: Colors.white,
                    size: 20,
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 10),
            Text(
              'Track your memorization journey',
              style: TextStyle(
                fontSize: 15,
                color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            
            const SizedBox(height: 24),

            // Progress visualization with tabs
            DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: isDarkMode ? Colors.black.withOpacity(0.1) : Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TabBar(
                      tabs: const [
                        Tab(text: "3D Visualization"),
                        Tab(text: "Alternative View"),
                      ],
                      labelColor: isDarkMode ? Colors.white : const Color(0xFF001F3F),
                      unselectedLabelColor: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                      indicatorColor: const Color(0xFF3D9970),
                      indicatorSize: TabBarIndicatorSize.tab,
                      dividerColor: Colors.transparent,
                      labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 280,
                    child: TabBarView(
                      children: [
                        // Original 3D Visualization
                        Center(
                          child: AnimatedBuilder(
                            animation: _progressAnimation,
                            builder: (context, child) {
                              return _buildOriginalProgressCircle(isDarkMode);
                            }
                          ),
                        ),
                        
                        // Alternate Visualization (QuranProgressIndicator)
                        Center(
                          child: QuranProgressIndicator(
                            memorizedJuzz: memorizedJuzzCount,
                            totalJuzz: totalJuzz,
                            primaryColor: const Color(0xFF001F3F),
                            secondaryColor: const Color(0xFF3D9970),
                            title: 'Learning Progress',
                            subtitle: 'Track your memorization journey',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Timeline heading with icon
            Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: isDarkMode 
                        ? Colors.white.withOpacity(0.1) 
                        : Colors.grey.withOpacity(0.2),
                    width: 1,
                  ),
                ),
              ),
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF001F3F), Color(0xFF3D9970)],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF3D9970).withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.timeline_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Text(
                    'Your Timeline',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Timeline with animated markers
            _buildTimeline(isDarkMode),
            
            // Date labels with modern design
            Padding(
              padding: const EdgeInsets.only(top: 16, left: 8, right: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildEnhancedDateLabel('Started', '${startDate.day}/${startDate.month}/${startDate.year}', 
                    const Color(0xFF001F3F), isDarkMode),
                  _buildEnhancedDateLabel('Target', '${adjustedTargetDate.day}/${adjustedTargetDate.month}/${adjustedTargetDate.year}', 
                    const Color(0xFF3D9970), isDarkMode),
                ],
              ),
            ),
            
            // Motivational note
            Container(
              margin: const EdgeInsets.only(top: 20),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDarkMode 
                      ? [const Color(0xFF265C4B).withOpacity(0.6), const Color(0xFF001F3F).withOpacity(0.6)]
                      : [const Color(0xFFE6F7FF), const Color(0xFFE6F7FF)],
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDarkMode 
                      ? Colors.white.withOpacity(0.1) 
                      : const Color(0xFF3D9970).withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.lightbulb_outline,
                    color: isDarkMode ? const Color(0xFF3D9970) : const Color(0xFF001F3F),
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Great progress! You\'re on track to complete your memorization goals ahead of schedule.',
                      style: TextStyle(
                        fontSize: 14,
                        color: isDarkMode ? Colors.white : Colors.black87,
                        fontWeight: FontWeight.w500,
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

  Widget _buildOriginalProgressCircle(bool isDarkMode) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Background circle
        Container(
          width: 220,
          height: 220,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isDarkMode ? Colors.black.withOpacity(0.3) : Colors.grey[100],
            boxShadow: [
              BoxShadow(
                color: isDarkMode 
                    ? Colors.black.withOpacity(0.5) 
                    : Colors.grey.withOpacity(0.2),
                blurRadius: 15,
                spreadRadius: 5,
                offset: const Offset(0, 5),
              ),
            ],
          ),
        ),
        
        // Progress circle animation
        TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0.0, end: 2 * math.pi * _progressAnimation.value),
          duration: const Duration(seconds: 2),
          curve: Curves.easeInOut,
          builder: (context, value, child) {
            return CustomPaint(
              size: const Size(220, 220),
              painter: CircleProgressPainter(
                progress: value,
                progressColor: const Color(0xFF3D9970),
                backgroundColor: isDarkMode 
                    ? Colors.white.withOpacity(0.1) 
                    : Colors.grey.withOpacity(0.2),
                strokeWidth: 15,
              ),
            );
          },
        ),
        
        // Center content
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            Text(
              '$memorizedJuzzCount/$totalJuzz',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Juzz Memorized',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '${(_progressAnimation.value * 100).toStringAsFixed(0)}%',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF3D9970),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Complete',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTimeline(bool isDarkMode) {
    return Container(
      height: 100,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Stack(
        children: [
          // Base timeline
          Positioned(
            left: 0,
            right: 0,
            top: 40,
            child: Container(
              height: 6,
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.grey[800] : Colors.grey[300],
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
          
          // Progress timeline
          Positioned(
            left: 0,
            right: 0,
            top: 40,
            child: FractionallySizedBox(
              widthFactor: 0.4, // Adjust based on actual progress
              alignment: Alignment.centerLeft,
              child: Container(
                height: 6,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF001F3F), Color(0xFF3D9970)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(3),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF3D9970).withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Timeline markers
          Positioned(
            left: 0,
            top: 34,
            child: _buildTimelineMarker(
              isDarkMode,
              isActive: true,
              label: 'Start',
            ),
          ),
          
          Positioned(
            left: MediaQuery.of(context).size.width * 0.295,
            top: 34,
            child: _buildTimelineMarker(
              isDarkMode,
              isActive: true,
              label: 'Current',
              isHighlighted: true,
            ),
          ),
          
          Positioned(
            left: MediaQuery.of(context).size.width * 0.5,
            top: 34,
            child: _buildTimelineMarker(
              isDarkMode,
              isActive: false,
              label: 'Original',
            ),
          ),
          
          Positioned(
            right: 0,
            top: 34,
            child: _buildTimelineMarker(
              isDarkMode,
              isActive: false,
              label: 'Target',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineMarker(bool isDarkMode, {required bool isActive, required String label, bool isHighlighted = false}) {
    return Column(
      children: [
        Container(
          width: 18,
          height: 18,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive 
                ? isHighlighted 
                    ? const Color(0xFF3D9970) 
                    : const Color(0xFF001F3F)
                : isDarkMode 
                    ? Colors.grey[700] 
                    : Colors.grey[400],
            border: Border.all(
              color: isDarkMode ? Colors.black : Colors.white,
              width: 3,
            ),
            boxShadow: isActive 
                ? [
                    BoxShadow(
                      color: isHighlighted 
                          ? const Color(0xFF3D9970).withOpacity(0.5) 
                          : const Color(0xFF001F3F).withOpacity(0.3),
                      blurRadius: 8,
                      spreadRadius: 2,
                      offset: const Offset(0, 2),
                    ),
                  ] 
                : null,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal,
            color: isActive 
                ? isHighlighted 
                    ? const Color(0xFF3D9970) 
                    : isDarkMode 
                        ? Colors.white 
                        : Colors.black
                : isDarkMode 
                    ? Colors.grey[500] 
                    : Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildEnhancedDateLabel(String label, String date, Color color, bool isDarkMode) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: color.withOpacity(isDarkMode ? 0.2 : 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: color.withOpacity(isDarkMode ? 0.3 : 0.2),
              width: 1,
            ),
          ),
          child: Text(
            date,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isDarkMode ? Colors.white : color,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatsCard(bool isDarkMode) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDarkMode 
              ? [const Color(0xFF1F2040), const Color(0xFF151530)]
              : [Colors.white, const Color(0xFFF0F4F8)],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF001F3F).withOpacity(0.15),
            blurRadius: 20,
            spreadRadius: 0,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(
          color: isDarkMode 
              ? Colors.white.withOpacity(0.1) 
              : Colors.white.withOpacity(0.8),
          width: isDarkMode ? 0.5 : 1.5,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title with animated gradient
            ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [
                  Color(0xFF001F3F),
                  Color(0xFF265C4B),
                  Color(0xFF3D9970),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ).createShader(bounds),
              child: const Row(
                children: [
                  Text(
                    'Performance Stats',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: -0.5,
                    ),
                  ),
                  SizedBox(width: 10),
                  Icon(
                    Icons.insights,
                    color: Colors.white,
                    size: 20,
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 10),
            Text(
              'Your learning metrics this month',
              style: TextStyle(
                fontSize: 15,
                color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Stats grid
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              childAspectRatio: 1.5,
              children: [
                _buildStatCard(
                  icon: Icons.trending_up,
                  label: 'Daily Progress',
                  value: '1.2 pages',
                  trend: '+0.3',
                  isDarkMode: isDarkMode,
                  trendUp: true,
                ),
                _buildStatCard(
                  icon: Icons.schedule,
                  label: 'Time Spent',
                  value: '45 min',
                  trend: '+5',
                  isDarkMode: isDarkMode,
                  trendUp: true,
                ),
                _buildStatCard(
                  icon: Icons.school,
                  label: 'Accuracy',
                  value: '92%',
                  trend: '+2.5%',
                  isDarkMode: isDarkMode,
                  trendUp: true,
                ),
                _buildStatCard(
                  icon: Icons.extension,
                  label: 'Concepts Mastered',
                  value: '15',
                  trend: '+3',
                  isDarkMode: isDarkMode,
                  trendUp: true,
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // Progress Row
            Row(
              children: [
                Expanded(
                  child: _buildProgressRow(
                    label: 'Weekly Target',
                    current: 8,
                    target: 10,
                    isDarkMode: isDarkMode,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // Recommendation
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDarkMode 
                    ? Colors.white.withOpacity(0.05) 
                    : const Color(0xFF3D9970).withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDarkMode 
                      ? Colors.white.withOpacity(0.1) 
                      : const Color(0xFF3D9970).withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF3D9970).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.tips_and_updates,
                          color: Color(0xFF3D9970),
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Recommendation',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isDarkMode ? Colors.white : Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Increase your daily study time by 15 minutes to meet your weekly target and accelerate your progress.',
                    style: TextStyle(
                      fontSize: 14,
                      color: isDarkMode ? Colors.grey[400] : Colors.grey[700],
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

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required String trend,
    required bool isDarkMode,
    required bool trendUp,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode 
            ? Colors.white.withOpacity(0.05) 
            : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDarkMode 
              ? Colors.white.withOpacity(0.1) 
              : Colors.grey.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: isDarkMode 
            ? null 
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  spreadRadius: 0,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF3D9970).withOpacity(isDarkMode ? 0.2 : 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: const Color(0xFF3D9970),
                  size: 18,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: trendUp 
                      ? const Color(0xFF3D9970).withOpacity(isDarkMode ? 0.2 : 0.1)
                      : Colors.red.withOpacity(isDarkMode ? 0.2 : 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      trendUp ? Icons.arrow_upward : Icons.arrow_downward,
                      color: trendUp ? const Color(0xFF3D9970) : Colors.red,
                      size: 12,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      trend,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: trendUp ? const Color(0xFF3D9970) : Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressRow({
    required String label,
    required int current,
    required int target,
    required bool isDarkMode,
  }) {
    final double progress = current / target;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isDarkMode ? Colors.grey[300] : Colors.grey[700],
              ),
            ),
            Text(
              '$current/$target pages',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: isDarkMode ? Colors.white.withOpacity(0.1) : Colors.grey[200],
            color: const Color(0xFF3D9970),
            minHeight: 10,
          ),
        ),
      ],
    );
  }

  Widget _buildModernButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF6A11CB).withOpacity(0.3),
              blurRadius: 15,
              spreadRadius: 0,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 32,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom painter for the progress circle
class CircleProgressPainter extends CustomPainter {
  final double progress;
  final Color progressColor;
  final Color backgroundColor;
  final double strokeWidth;

  CircleProgressPainter({
    required this.progress,
    required this.progressColor,
    required this.backgroundColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - strokeWidth / 2;

    // Draw background circle
    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, backgroundPaint);

    // Draw progress arc
    final progressPaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2, // Start from top (negative pi/2)
      progress, // End angle
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CircleProgressPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.progressColor != progressColor ||
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}

// Alternative progress indicator
class QuranProgressIndicator extends StatelessWidget {
  final int memorizedJuzz;
  final int totalJuzz;
  final Color primaryColor;
  final Color secondaryColor;
  final String title;
  final String subtitle;

  const QuranProgressIndicator({
    super.key,
    required this.memorizedJuzz,
    required this.totalJuzz,
    required this.primaryColor,
    required this.secondaryColor,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final double percentage = memorizedJuzz / totalJuzz;
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 10),
        
        // Book visualization
        SizedBox(
          height: 160,
          width: 200,
          child: Stack(
            children: [
              // Book Cover
              Center(
                child: Container(
                  width: 160,
                  height: 140,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [primaryColor, secondaryColor],
                    ),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: primaryColor.withOpacity(0.3),
                        blurRadius: 15,
                        spreadRadius: 2,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.menu_book,
                        color: Colors.white,
                        size: 40,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Al-Quran',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        '$memorizedJuzz/$totalJuzz Juzz',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              // Progress overlay
              Positioned(
                top: 10,
                left: 20,
                right: 20,
                bottom: 10,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return ClipPath(
                      clipper: BookProgressClipper(percentage: percentage),
                      child: Container(
                        decoration: BoxDecoration(
                          color: isDarkMode ? Colors.black.withOpacity(0.7) : Colors.white.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 20),
        
        // Progress text
        Text(
          '${(percentage * 100).toStringAsFixed(0)}% Complete',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: secondaryColor,
          ),
        ),
        
        const SizedBox(height: 10),
        
        // Segmented progress bar
        SizedBox(
          height: 20,
          width: 200,
          child: Row(
            children: List.generate(
              totalJuzz,
              (index) => Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 1),
                  decoration: BoxDecoration(
                    color: index < memorizedJuzz 
                        ? secondaryColor 
                        : isDarkMode 
                            ? Colors.white.withOpacity(0.1) 
                            : Colors.grey[200],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// Custom clipper for book progress visualization
class BookProgressClipper extends CustomClipper<Path> {
  final double percentage;
  
  BookProgressClipper({required this.percentage});
  
  @override
  Path getClip(Size size) {
    final path = Path();
    
    // This creates a rect that covers the un-memorized portion
    final coverHeight = size.height * (1 - percentage);
    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, coverHeight);
    path.lineTo(0, coverHeight);
    path.close();
    
    return path;
  }
  
  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}
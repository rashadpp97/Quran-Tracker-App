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
        toolbarHeight: 40,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
            size: 18,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 220,
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
                Positioned(
                  top: 130,
                  left: (screenSize.width / 2) - 60,
                  child: Column(
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color.fromARGB(255, 73, 93, 72),
                            width: 4,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          backgroundColor: const Color.fromARGB(255, 245, 242, 242),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.asset(
                              widget.image,
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        widget.className,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 75),
            
            // Student Performance Title
            const Text(
              'STUDENTS PERFORMANCE',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF6A11CB),
              ),
            ),
            
            const SizedBox(height: 25),
            
            // Grid buttons at the top
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
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
              ),
            ),

            const SizedBox(height: 25),

            // Progress Card with alternative visualization option
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _buildProgressCardWithOptions(isDarkMode),
            ),  
          
            const SizedBox(height: 25),

            // Stats Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _buildStatsCard(isDarkMode),
            ),
          
            const SizedBox(height: 20),
          ],
        ),
      ),
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
            color: const Color(0xFF001F3F).withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
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
        padding: const EdgeInsets.all(20.0),
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
                  SizedBox(width: 8),
                  Icon(
                    Icons.auto_awesome,
                    color: Colors.white,
                    size: 20,
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 8),
            Text(
              'Track your memorization journey',
              style: TextStyle(
                fontSize: 14,
                color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            
            const SizedBox(height: 20),

            // Progress visualization with tabs
            DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  TabBar(
                    tabs: const [
                      Tab(text: "3D Visualization"),
                      Tab(text: "Alternative View"),
                    ],
                    labelColor: isDarkMode ? Colors.white : const Color(0xFF001F3F),
                    unselectedLabelColor: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                    indicatorColor: const Color(0xFF3D9970),
                  ),
                  SizedBox(
                    height: 300,
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
            
            const SizedBox(height: 10),
            
            // Timeline heading with icon
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF001F3F), Color(0xFF3D9970)],
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.timeline_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 12),
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
            
            const SizedBox(height: 15),
            
            // Timeline with animated markers
            _buildTimeline(isDarkMode),
            
            // Date labels with modern design
            Padding(
              padding: const EdgeInsets.only(top: 12, left: 8, right: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildEnhancedDateLabel('Started', '${startDate.day}/${startDate.month}/${startDate.year}', 
                    const Color(0xFF001F3F), isDarkMode),
                  _buildEnhancedDateLabel('Target', '${adjustedTargetDate.day}/${adjustedTargetDate.month}/${adjustedTargetDate.year}', 
                    const Color.fromARGB(255, 13, 86, 53), isDarkMode),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOriginalProgressCircle(bool isDarkMode) {
    return SizedBox(
      width: 200,
      height: 200,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer glow
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF3D9970).withOpacity(0.3),
                  blurRadius: 30,
                  spreadRadius: 5,
                ),
              ],
            ),
          ),
          
          // Frosted glass background
          Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDarkMode 
                    ? [const Color(0xFF27273D), const Color(0xFF1A1A32)]
                    : [Colors.white, const Color(0xFFF0F4F8)],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(isDarkMode ? 0.6 : 0.1),
                  blurRadius: 15,
                  offset: const Offset(5, 5),
                ),
                if (!isDarkMode)
                  const BoxShadow(
                    color: Colors.white,
                    blurRadius: 15,
                    offset: Offset(-5, -5),
                  ),
              ],
            ),
          ),
          
          // Custom progress arc
          CustomPaint(
            size: const Size(180, 180),
            painter: EnhancedProgressArcPainter(
              progress: _progressAnimation.value,
              startColor: const Color(0xFF001F3F),
              middleColor: const Color(0xFF265C4B),
              endColor: const Color(0xFF3D9970),
              strokeWidth: 12,
            ),
          ),
          
          // Juzz counter in center with 3D effect
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: isDarkMode 
                        ? [const Color(0xFF2C2C54), const Color(0xFF232342)]
                        : [Colors.white, const Color(0xFFF0F4F8)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(5, 5),
                    ),
                    if (!isDarkMode)
                      const BoxShadow(
                        color: Colors.white,
                        blurRadius: 10,
                        offset: Offset(-3, -3),
                      ),
                  ],
                  border: Border.all(
                    color: isDarkMode 
                        ? Colors.white.withOpacity(0.1) 
                        : Colors.white,
                    width: 2,
                  ),
                ),
                child: ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [
                      Color(0xFF001F3F),
                      Color(0xFF265C4B),
                      Color(0xFF3D9970),
                    ],
                  ).createShader(bounds),
                  child: Text(
                    '$memorizedJuzzCount',
                    style: const TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Juzz Memorized',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isDarkMode ? Colors.grey[400] : Colors.grey[800],
                ),
              ),
              Text(
                'of $totalJuzz total',
                style: TextStyle(
                  fontSize: 12,
                  color: isDarkMode ? Colors.grey[700] : Colors.grey[700],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildStatsCard(bool isDarkMode) {
    return Container(
      width: double.infinity,
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
            color: const Color(0xFF001F3F).withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
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
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title with icon
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF001F3F), Color(0xFF3D9970)],
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.insights_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Your Progress',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Enhanced stat items with 3D cards
            _buildStatItems(isDarkMode),
            
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
    
 Widget _buildTimeline(bool isDarkMode, {double progress = 0.4}) {
  final width = MediaQuery.of(context).size.width - 40; // Account for card padding
  return SizedBox(
    height: 95,
    width: width,
    child: Stack(
      alignment: Alignment.center,
      children: [
        // Timeline line with 3D effect
        Container(
          height: 8,
          width: width,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFF001F3F), 
                Color(0xFF265C4B), 
                Color(0xFF3D9970)
              ],
            ),
            borderRadius: BorderRadius.circular(4),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF3D9970).withOpacity(0.4),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
        ),
        
        // Start marker
        Positioned(
          left: -2,
          child: _buildEnhancedTimelineMarker(
            const Color(0xFF001F3F),
            Icons.play_arrow_rounded,
            isActive: true,
            isDarkMode: isDarkMode,
          ),
        ),
        
        // Current position marker - now uses progress parameter
        Positioned(
          left: width * progress - 20, // Dynamic positioning based on progress
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF001F3F),
                      Color(0xFF3D9970),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF3D9970).withOpacity(0.4),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.bookmark_rounded,
                      color: Colors.white,
                      size: 16,
                    ),
                    SizedBox(width: 6),
                    Text(
                      'You are here',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              _buildEnhancedTimelineMarker(
                const Color.fromARGB(255, 30, 67, 55),
                Icons.person_rounded,
                isActive: true,
                isDarkMode: isDarkMode,
                withGlow: true,
                size: 40, // Reduced size
              ),
            ],
          ),
        ),
        
        // End marker
        Positioned(
          right: -3,
          child: _buildEnhancedTimelineMarker(
            const Color.fromARGB(255, 14, 84, 53),
            Icons.flag,
            isActive: true,
            isDarkMode: isDarkMode,
          ),
        ),
      ],
    ),
  );
}
  
  Widget _buildStatItems(bool isDarkMode) {
    return Row(
      children: [
        Expanded(
          child: _buildEnhancedStatItem(
            '40%',
            'Complete',
            const Color(0xFF001F3F),
            isDarkMode,
            Icons.check_circle_rounded,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildEnhancedStatItem(
            '18',
            'Remaining',
            const Color(0xFF265C4B),
            isDarkMode,
            Icons.hourglass_bottom_rounded,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildEnhancedStatItem(
            '2.5',
            'Years Left',
            const Color(0xFF3D9970),
            isDarkMode,
            Icons.calendar_today_rounded,
          ),
        ),
      ],
    );
  }

  Widget _buildEnhancedTimelineMarker(
    Color color,
    IconData icon, {
    required bool isActive,
    required bool isDarkMode,
    bool withGlow = false,
    double size = 40,
  }) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: isActive 
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  color.withOpacity(0.9),
                  color.withOpacity(0.7),
                ],
              )
            : null,
        color: isActive 
            ? null 
            : isDarkMode 
                ? const Color(0xFF27273D) 
                : Colors.grey[200],
        shape: BoxShape.circle,
        border: Border.all(
          color: isDarkMode 
              ? Colors.black.withOpacity(0.2) 
              : Colors.white.withOpacity(0.8),
          width: 2,
        ),
        boxShadow: [
          if (withGlow)
            BoxShadow(
              color: color.withOpacity(0.5),
              blurRadius: 15,
              spreadRadius: 5,
            ),
          BoxShadow(
            color: Colors.black.withOpacity(isDarkMode ? 0.3 : 0.1),
            blurRadius: 8,
            offset: const Offset(2, 2),
          ),
          if (!isDarkMode)
            BoxShadow(
              color: Colors.white,
              blurRadius: 8,
              offset: const Offset(-2, -2),
            ),
        ],
      ),
      child: Icon(
        icon,
        color: isActive 
            ? Colors.white 
            : isDarkMode 
                ? Colors.grey[400] 
                : Colors.grey[500],
        size: size * 0.45,
      ),
    );
  }
  
  Widget _buildEnhancedDateLabel(String label, String date, Color color, bool isDarkMode) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                color.withOpacity(0.2),
                color.withOpacity(0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: color.withOpacity(0.3),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            date,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isDarkMode ? color.withOpacity(0.9) : color.withOpacity(0.8),
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildEnhancedStatItem(
    String value, 
    String label, 
    Color color, 
    bool isDarkMode, 
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDarkMode 
              ? [color.withOpacity(0.15), color.withOpacity(0.05)]
              : [color.withOpacity(0.1), color.withOpacity(0.02)],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: color,
                size: 16,
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  value,
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
              fontSize: 12,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
  
  Widget _buildModernButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF001F3F),
              Color(0xFF3D9970),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF001F3F).withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 32,
            ),
            const SizedBox(height: 12),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// Custom painter for enhanced progress arc
class EnhancedProgressArcPainter extends CustomPainter {
  final double progress;
  final Color startColor;
  final Color middleColor;
  final Color endColor;
  final double strokeWidth;

  EnhancedProgressArcPainter({
    required this.progress,
    required this.startColor,
    required this.middleColor,
    required this.endColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const double startAngle = -math.pi / 2;
    final double sweepAngle = 2 * math.pi * progress;
    final Rect rect = Rect.fromCircle(
      center: Offset(size.width / 2, size.height / 2),
      radius: size.width / 2,
    );

    // Create the gradient paint
    final paint = Paint()
      ..shader = SweepGradient(
        center: Alignment.center,
        startAngle: startAngle,
        endAngle: startAngle + 2 * math.pi,
        colors: [startColor, middleColor, endColor],
        stops: const [0.0, 0.5, 1.0],
        transform: GradientRotation(startAngle),
      ).createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth;

    // Draw background arc
    final backgroundPaint = Paint()
      ..color = Colors.grey.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth / 2;

    canvas.drawArc(
      rect,
      startAngle,
      2 * math.pi,
      false,
      backgroundPaint,
    );

    // Draw progress arc
    canvas.drawArc(
      rect,
      startAngle,
      sweepAngle,
      false,
      paint,
    );

    // Add arc end dot
    if (progress > 0.01) {
      final endAngle = startAngle + sweepAngle;
      final endX = rect.center.dx + rect.width / 2 * math.cos(endAngle);
      final endY = rect.center.dy + rect.height / 2 * math.sin(endAngle);

      // Draw glow behind dot
      final glowPaint = Paint()
        ..color = endColor.withOpacity(0.5)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

      canvas.drawCircle(
        Offset(endX, endY),
        strokeWidth * 0.8,
        glowPaint,
      );

      // Draw dot
      final dotPaint = Paint()
        ..color = endColor;

      canvas.drawCircle(
        Offset(endX, endY),
        strokeWidth * 0.6,
        dotPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant EnhancedProgressArcPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.startColor != startColor ||
        oldDelegate.middleColor != middleColor ||
        oldDelegate.endColor != endColor ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}

// QuranProgressIndicator Widget
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
    final double progress = memorizedJuzz / totalJuzz;
    
    
    
// Create the juzz blocks visualization
List<Widget> juzzBlocks = [];

for (int i = 0; i < totalJuzz; i++) {
  bool isMemorized = i < memorizedJuzz;
  juzzBlocks.add(
    Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(3.0),
          child: Container(
            width: 19,
            height: 19,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              gradient: isMemorized
                  ? LinearGradient(
                      colors: [primaryColor, secondaryColor],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : null,
              color: isMemorized
                  ? null
                  : isDarkMode
                      ? Colors.grey[800]
                      : Colors.grey[300],
              boxShadow: [
                if (isMemorized)
                  BoxShadow(
                    color: secondaryColor.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
              ],
              border: Border.all(
                color: isMemorized
                    ? secondaryColor.withOpacity(0.2)
                    : isDarkMode
                        ? Colors.grey[700]!
                        : Colors.grey[400]!,
                width: 1,
              ),
            ),
            child: Center(
              child: isMemorized
                  ? Icon(
                      Icons.check,
                      size: 12,
                      color: Colors.white,
                    )
                  : null,
            ),
          ),
        ),
        Text(
          '${i + 1}',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: isDarkMode ? Colors.white : Colors.black87,
          ),
        ),
      ],
    ),
  );
}

    return Column(
      children: [
        Text(
          '$memorizedJuzz of $totalJuzz Juzz Memorized',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : Colors.black87,
            height: 2.5, // Adjust this value as needed
          ),
        ),
        // const SizedBox(height: 3),
        Text(
          '${(progress * 100).toStringAsFixed(1)}% Complete',
          style: TextStyle(
            fontSize: 14,
            color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
          ),
        ),
        const SizedBox(height: 7),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Wrap(
            alignment: WrapAlignment.center,
            children: juzzBlocks,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          height: 10,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: isDarkMode ? Colors.grey[800] : Colors.grey[300],
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: progress,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: LinearGradient(
                  colors: [primaryColor, secondaryColor],
                ),
                boxShadow: [
                  BoxShadow(
                    color: secondaryColor.withOpacity(0.5),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '0',
              style: TextStyle(
                fontSize: 12,
                color: isDarkMode ? Colors.grey[500] : Colors.grey[600],
              ),
            ),
            Text(
              '$totalJuzz',
              style: TextStyle(
                fontSize: 12,
                color: isDarkMode ? Colors.grey[500] : Colors.grey[600],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
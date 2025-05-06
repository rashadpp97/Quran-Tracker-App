import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:intl/intl.dart'; // Import for date formatting

class ProgressTimeline extends StatefulWidget {
  const ProgressTimeline({super.key});

  @override
  State<ProgressTimeline> createState() =>
      _StudentProgressTimelineWidgetState();
}

class _StudentProgressTimelineWidgetState
    extends State<ProgressTimeline>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;
  late Animation<double> _pulseAnimation;

  // Student data
  final double _originalProgress = 0.45; // 45% of original target completed
  final double _adjustedProgress = 0.30; // 30% of adjusted target completed
  final int _absenceDays = 12;
  final int _daysRemaining = 664;
  final bool _isOnTrack = false;

  // Date calculations
  final DateTime _startDate = DateTime(2024, 1, 1); // JAN 2024
  final DateTime _originalEndDate = DateTime(2027, 1, 1); // JAN 2027

  // Calculate adjusted end date based on absences
  late DateTime _adjustedEndDate;
  late String _adjustedEndDateFormatted;
  late String _originalEndDateFormatted;
  late String _startDateFormatted;
  late String _adjustedEndDateFullFormatted;
  late String _originalEndDateFullFormatted;

  // More vibrant color scheme
  final Color _primaryColor = const Color(0xFF3949AB); // Indigo
  final Color _secondaryColor = const Color(0xFF00BCD4); // Cyan
  final Color _accentColor = const Color(0xFFFF9800); // Orange
  final Color _warningColor = const Color(0xFFE53935); // Red
  final Color _successColor = const Color(0xFF43A047); // Green

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _progressAnimation = Tween<double>(begin: 0.0, end: 0.3).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    // Calculate the adjusted end date
    _calculateAdjustedEndDate();
  }

  void _calculateAdjustedEndDate() {
    // Calculate original duration in days
    final originalDurationDays = _originalEndDate.difference(_startDate).inDays;

    // Calculate impact of absences on timeline
    // For example, each absence could extend the timeline by 1.5 days
    final extensionDays = (_absenceDays * 1.5).round();

    // Calculate adjusted end date
    _adjustedEndDate = _originalEndDate.add(Duration(days: extensionDays));

    // Format the dates
    _adjustedEndDateFormatted = _formatDateBeautiful(_adjustedEndDate);
    _originalEndDateFormatted = _formatDateBeautiful(_originalEndDate);
    _startDateFormatted = _formatDateBeautiful(_startDate);
    
    // Format full dates (dd-mm-yyyy)
    _adjustedEndDateFullFormatted = DateFormat('dd-MM-yyyy').format(_adjustedEndDate);
    _originalEndDateFullFormatted = DateFormat('dd-MM-yyyy').format(_originalEndDate);
  }

  String _formatDateBeautiful(DateTime date) {
    // Format as MMM YYYY (e.g., Jan 2024)
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[date.month - 1]} ${date.year}';
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white,
            _primaryColor.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: _primaryColor.withOpacity(0.15),
            blurRadius: 20,
            spreadRadius: 0,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with title and completion percentage
          _buildHeader(),

          const SizedBox(height: 24),

          // Main progress card with visual summary
          _buildProgressSummaryCard(),

          const SizedBox(height: 24),

          // Timeline track and milestones
          _buildTimelineTrack(),

          const SizedBox(height: 24),

          // Absence indicator with visual impact
          _buildAbsenceIndicator(),

          const SizedBox(height: 20),

          // Status card with days remaining and actionable insights
          _buildStatusCard(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        // Title with attractive gradient
        ShaderMask(
          shaderCallback: (Rect bounds) {
            return LinearGradient(
              colors: [
                _primaryColor,
                _secondaryColor,
                _primaryColor.withBlue(220),
              ],
              stops: const [0.0, 0.5, 1.0],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ).createShader(bounds);
          },
          child: const Text(
            'Learning Journey',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: -0.5,
            ),
          ),
        ),

        const Spacer(),

        // Completion indicator
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                _secondaryColor.withOpacity(0.2),
                _secondaryColor.withOpacity(0.1),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: _secondaryColor.withOpacity(0.3),
                blurRadius: 8,
                spreadRadius: 0,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: _animationController.value * 0.2,
                    child: Icon(
                      Icons.insights,
                      size: 18,
                      color: _secondaryColor,
                    ),
                  );
                },
              ),
              const SizedBox(width: 8),
              Text(
                '${(_adjustedProgress * 100).toInt()}% Complete',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: _primaryColor,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProgressSummaryCard() {
    // Calculate progress difference
    final progressDifference = (_originalProgress - _adjustedProgress) * 100;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: _primaryColor.withOpacity(0.12),
            blurRadius: 10,
            spreadRadius: 0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Progress at a Glance',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade800,
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Visual progress comparison
          Row(
            children: [
              // Original target column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Original Plan',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          height: 90,
                          width: 90,
                          child: CircularProgressIndicator(
                            value: _originalProgress,
                            strokeWidth: 10,
                            backgroundColor: Colors.grey.shade200,
                            valueColor: AlwaysStoppedAnimation<Color>(_accentColor),
                          ),
                        ),
                        Column(
                          children: [
                            Text(
                              '${(_originalProgress * 100).toInt()}%',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: _accentColor,
                              ),
                            ),
                            Text(
                              'complete',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _originalEndDateFullFormatted,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: _accentColor,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Arrow indicator
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    Icon(
                      Icons.arrow_forward,
                      color: Colors.grey.shade400,
                      size: 24,
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _warningColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: _warningColor.withOpacity(0.3)),
                      ),
                      child: Text(
                        '-${progressDifference.toInt()}%',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: _warningColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Current progress column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Current Status',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    AnimatedBuilder(
                      animation: _animationController,
                      builder: (context, child) {
                        final pulseEffect = 1.0 + 0.05 * math.sin(_animationController.value * math.pi * 2);
                        return Transform.scale(
                          scale: pulseEffect,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              SizedBox(
                                height: 90,
                                width: 90,
                                child: CircularProgressIndicator(
                                  value: _adjustedProgress,
                                  strokeWidth: 10,
                                  backgroundColor: Colors.grey.shade200,
                                  valueColor: AlwaysStoppedAnimation<Color>(_secondaryColor),
                                ),
                              ),
                              Column(
                                children: [
                                  Text(
                                    '${(_adjustedProgress * 100).toInt()}%',
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: _primaryColor,
                                    ),
                                  ),
                                  Text(
                                    'complete',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                              if (!_isOnTrack)
                                Positioned(
                                  bottom: 0,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: _warningColor,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Text(
                                      'Behind Schedule',
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        );
                      }
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _adjustedEndDateFullFormatted,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: _primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineTrack() {
    return Column(
      children: [
        // Title with icon
        Row(
          children: [
            Icon(
              Icons.timeline,
              size: 20,
              color: _primaryColor,
            ),
            const SizedBox(width: 8),
            Text(
              'Learning Timeline',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: _primaryColor,
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 16),
        
        // Timeline track with clearer visual hierarchy
        SizedBox(
          height: 100,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Main timeline track
              Positioned(
                top: 40,
                left: 0,
                right: 0,
                child: Container(
                  height: 6,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
              
              // Completed portion
              Positioned(
                top: 40,
                left: 0,
                child: AnimatedBuilder(
                  animation: _progressAnimation,
                  builder: (context, child) {
                    return Container(
                      height: 6,
                      width: MediaQuery.of(context).size.width * 0.8 * _adjustedProgress,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            _secondaryColor,
                            _primaryColor,
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(3),
                        boxShadow: [
                          BoxShadow(
                            color: _secondaryColor.withOpacity(0.3),
                            blurRadius: 4,
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              
              // Start point
              Positioned(
                top: 32,
                left: 0,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: _successColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: _successColor.withOpacity(0.3),
                        blurRadius: 4,
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.play_arrow,
                      size: 12,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              
              // End point
              Positioned(
                top: 32,
                right: 0,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: _primaryColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: _primaryColor.withOpacity(0.3),
                        blurRadius: 4,
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.flag,
                      size: 12,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              
              // Current position with pulsing effect
              Positioned(
                top: 25,
                left: MediaQuery.of(context).size.width * 0.8 * _adjustedProgress - 14,
                child: AnimatedBuilder(
                  animation: _pulseAnimation,
                  builder: (context, child) {
                    return Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: _secondaryColor, width: 3),
                        boxShadow: [
                          BoxShadow(
                            color: _secondaryColor.withOpacity(0.3 + 0.1 * math.sin(_animationController.value * math.pi)),
                            blurRadius: 8,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Icon(
                          Icons.person,
                          size: 18,
                          color: _secondaryColor,
                        ),
                      ),
                    );
                  },
                ),
              ),
              
              // Original target marker
              Positioned(
                top: 50,
                left: MediaQuery.of(context).size.width * 0.8 * _originalProgress - 8,
                child: SizedBox(
                  height: 35,
                  child: Column(
                    children: [
                      Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: _accentColor,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                      ),
                      Container(
                        width: 2,
                        height: 15,
                        color: _accentColor,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: _accentColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: _accentColor, width: 1),
                        ),
                        child: Text(
                          'Target',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: _accentColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        
        // Timeline dates
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _startDateFormatted,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: _successColor,
                ),
              ),
              
              Text(
                _adjustedEndDateFormatted,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: _primaryColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAbsenceIndicator() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _warningColor.withOpacity(0.1),
            _warningColor.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _warningColor.withOpacity(0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: _warningColor.withOpacity(0.15),
            blurRadius: 10,
            spreadRadius: 0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Absence count with visual impact
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  border: Border.all(color: _warningColor, width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: _warningColor.withOpacity(0.2),
                      blurRadius: 8,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$_absenceDays',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: _warningColor,
                        ),
                      ),
                      Text(
                        'days',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: _warningColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 16),

              // Impact information
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Absences Impact",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: _warningColor,
                      ),
                    ),
                    
                    const SizedBox(height: 6),
                    
                    // Visual representation of impact
                    Row(
                      children: [
                        Icon(
                          Icons.schedule,
                          size: 14,
                          color: _warningColor,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "+${(_absenceDays * 1.5).round()} days added to timeline",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: _warningColor,
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 4),
                    
                    Row(
                      children: [
                        Icon(
                          Icons.trending_down,
                          size: 14,
                          color: _warningColor,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "-${((_originalProgress - _adjustedProgress) * 100).toInt()}% completion rate",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: _warningColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // Absence impact visualizer
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _warningColor.withOpacity(0.3)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Original Completion',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    Text(
                      _originalEndDateFullFormatted,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: _accentColor,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 8),
                
                Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    Container(
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    FractionallySizedBox(
                      widthFactor: _originalProgress,
                      child: Container(
                        height: 4,
                        decoration: BoxDecoration(
                          color: _accentColor,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 12),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Adjusted Completion',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          _adjustedEndDateFullFormatted,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: _warningColor,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: _warningColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'Delayed',
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                
                const SizedBox(height: 8),
                
                Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    Container(
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    FractionallySizedBox(
                      widthFactor: _adjustedProgress,
                      child: Container(
                        height: 4,
                        decoration: BoxDecoration(
                          color: _secondaryColor,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard() {
    final statusColor = _isOnTrack ? _successColor : Colors.orange;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _isOnTrack ? _successColor.withOpacity(0.1) : Colors.orange.withOpacity(0.1),
            _isOnTrack ? _successColor.withOpacity(0.05) : Colors.orange.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _isOnTrack ? _successColor.withOpacity(0.3) : Colors.orange.withOpacity(0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: statusColor.withOpacity(0.15),
            blurRadius: 10,
            spreadRadius: 0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Visual status indicator
              AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  final pulseEffect = 1.0 + 0.1 * math.sin(_animationController.value * math.pi);
                  return Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      border: Border.all(color: statusColor, width: 3),
                      boxShadow: [
                        BoxShadow(
                         color: statusColor.withOpacity(0.2 * pulseEffect),
                          blurRadius: 8,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Icon(
                        _isOnTrack ? Icons.check_circle : Icons.priority_high,
                        size: 24,
                        color: statusColor,
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(width: 16),

              // Status information
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _isOnTrack ? "On Track to Complete" : "Catching Up Needed",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: statusColor,
                      ),
                    ),
                    
                    const SizedBox(height: 6),
                    
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 14,
                          color: Colors.grey.shade600,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "$_daysRemaining days remaining",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Action recommendations
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Recommendations:',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: _primaryColor,
                  ),
                ),
                
                const SizedBox(height: 10),
                
                Row(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: _primaryColor.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Icon(
                          Icons.bolt,
                          size: 14,
                          color: _primaryColor,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Increase weekly study hours by 2-3 hours',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade800,
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 8),
                
                Row(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: _successColor.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Icon(
                          Icons.event_available,
                          size: 14,
                          color: _successColor,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Schedule make-up sessions for missed days',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade800,
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 8),
                
                Row(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: _secondaryColor.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Icon(
                          Icons.speed,
                          size: 14,
                          color: _secondaryColor,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Focus on high-impact skills to accelerate progress',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade800,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Call to action button
          ElevatedButton(
            onPressed: () {
              // Action when button is pressed
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _primaryColor,
              foregroundColor: Colors.white,
              elevation: 4,
              shadowColor: _primaryColor.withOpacity(0.4),
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              minimumSize: const Size(double.infinity, 0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.auto_graph,
                  size: 20,
                ),
                const SizedBox(width: 8),
                const Text(
                  'View Detailed Progress Report',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
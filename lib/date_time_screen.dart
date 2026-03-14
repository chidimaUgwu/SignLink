import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

// This screen allows users to select date, time, and duration
// Matches your second image design
class DateTimeScreen extends StatefulWidget {
  // Callbacks to notify parent of selections
  final Function(DateTime) onDateSelected;
  final Function(TimeOfDay) onTimeSelected;
  final Function(String) onDurationSelected;

  // Current values (if user goes back and forth)
  final DateTime? initialDate;
  final TimeOfDay? initialTime;
  final String? initialDuration;

  const DateTimeScreen({
    super.key,
    required this.onDateSelected,
    required this.onTimeSelected,
    required this.onDurationSelected,
    this.initialDate,
    this.initialTime,
    this.initialDuration,
  });

  @override
  State<DateTimeScreen> createState() => _DateTimeScreenState();
}

class _DateTimeScreenState extends State<DateTimeScreen> {
  // Calendar state
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDate;

  // Time selection
  TimeOfDay? _selectedTime;

  // Duration options (matching your design)
  final List<String> _durations = ['30 min', '1 hour', '2 hours'];
  String? _selectedDuration;

  // Available times (matching your design)
  final List<TimeOfDay> _availableTimes = [
    const TimeOfDay(hour: 14, minute: 0), // 2:00 PM
    const TimeOfDay(hour: 15, minute: 15), // 3:15 PM
    const TimeOfDay(hour: 16, minute: 30), // 4:30 PM
  ];

  @override
  void initState() {
    super.initState();
    // Initialize with any existing selections
    _selectedDate = widget.initialDate;
    _selectedTime = widget.initialTime;
    _selectedDuration = widget.initialDuration;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          const Text(
            'Select Date & Time',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Step 2 of 3', // Matching your design
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
          const SizedBox(height: 24),

          // Calendar Section
          _buildCalendar(),
          const SizedBox(height: 24),

          // Time Selection Section
          _buildTimeSelection(),
          const SizedBox(height: 24),

          // Duration Selection Section
          _buildDurationSelection(),
          const SizedBox(height: 24),

          // Summary Section (like in your design)
          if (_selectedDate != null &&
              _selectedTime != null &&
              _selectedDuration != null)
            _buildSummary(),
        ],
      ),
    );
  }

  // Calendar widget
  Widget _buildCalendar() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TableCalendar(
        firstDay: DateTime.now(),
        lastDay: DateTime.now().add(const Duration(days: 365)),
        focusedDay: _focusedDay,
        selectedDayPredicate: (day) {
          return isSameDay(_selectedDate, day);
        },
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _selectedDate = selectedDay;
            _focusedDay = focusedDay;
          });
          // Notify parent
          widget.onDateSelected(selectedDay);
        },
        calendarStyle: CalendarStyle(
          // Style for selected date
          selectedDecoration: const BoxDecoration(
            color: Colors.blue,
            shape: BoxShape.circle,
          ),
          // Style for today
          todayDecoration: BoxDecoration(
            color: Colors.blue.shade100,
            shape: BoxShape.circle,
          ),
        ),
        headerStyle: const HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
        ),
        // Show only October 2024 like in your design?
        // We'll keep it dynamic but you can set focusedDay to DateTime(2024, 10)
      ),
    );
  }

  // Time selection widget
  Widget _buildTimeSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Start Time',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text('PST Timezone', style: TextStyle(fontSize: 12)),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Time options grid
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: _availableTimes.length,
          itemBuilder: (context, index) {
            final time = _availableTimes[index];
            final timeString = _formatTimeOfDay(time);
            final isSelected = _selectedTime == time;

            return InkWell(
              onTap: () {
                setState(() {
                  _selectedTime = time;
                });
                widget.onTimeSelected(time);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: isSelected ? Colors.blue : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected ? Colors.blue : Colors.grey.shade300,
                  ),
                ),
                child: Center(
                  child: Text(
                    timeString,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  // Duration selection widget
  Widget _buildDurationSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Estimated Duration',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),

        Row(
          children: _durations.map((duration) {
            final isSelected = _selectedDuration == duration;

            return Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _selectedDuration = duration;
                    });
                    widget.onDurationSelected(duration);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.blue : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected ? Colors.blue : Colors.grey.shade300,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        duration,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // Summary widget (matches your design)
  Widget _buildSummary() {
    // Calculate end time based on duration
    String endTimeString = '';
    if (_selectedTime != null && _selectedDuration != null) {
      int minutesToAdd = 0;
      if (_selectedDuration == '30 min') minutesToAdd = 30;
      if (_selectedDuration == '1 hour') minutesToAdd = 60;
      if (_selectedDuration == '2 hours') minutesToAdd = 120;

      final startDateTime = DateTime(
        2000,
        1,
        1,
        _selectedTime!.hour,
        _selectedTime!.minute,
      );
      final endDateTime = startDateTime.add(Duration(minutes: minutesToAdd));
      endTimeString = _formatTime(TimeOfDay.fromDateTime(endDateTime));
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Interpreter requested for ${_formatDate(_selectedDate!)} at ${_formatTimeOfDay(_selectedTime!)}. '
            'Estimated finish: $endTimeString.',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  // Helper methods
  String _formatTimeOfDay(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  String _formatTime(TimeOfDay time) {
    return _formatTimeOfDay(time);
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}

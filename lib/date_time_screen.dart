import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

// This screen allows users to select date, start time, and end time
// Duration is automatically calculated
class DateTimeScreen extends StatefulWidget {
  // Callbacks to notify parent of selections
  final Function(DateTime) onDateSelected;
  final Function(TimeOfDay) onStartTimeSelected;
  final Function(TimeOfDay) onEndTimeSelected;
  final Function(String) onDurationCalculated; // New callback for duration

  // Current values (if user goes back and forth)
  final DateTime? initialDate;
  final TimeOfDay? initialStartTime;
  final TimeOfDay? initialEndTime;

  const DateTimeScreen({
    super.key,
    required this.onDateSelected,
    required this.onStartTimeSelected,
    required this.onEndTimeSelected,
    required this.onDurationCalculated,
    this.initialDate,
    this.initialStartTime,
    this.initialEndTime,
  });

  @override
  State<DateTimeScreen> createState() => _DateTimeScreenState();
}

class _DateTimeScreenState extends State<DateTimeScreen> {
  // Calendar state
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDate;

  // Time selections
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  // Calculated duration
  String _calculatedDuration = '';

  // Time picker state
  bool _isSelectingStartTime =
      true; // true = picking start, false = picking end

  @override
  void initState() {
    super.initState();
    // Initialize with any existing selections
    _selectedDate = widget.initialDate;
    _startTime = widget.initialStartTime;
    _endTime = widget.initialEndTime;

    // Calculate duration if both times exist
    if (_startTime != null && _endTime != null) {
      _calculateDuration();
    }
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
            'Step 2 of 3',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
          const SizedBox(height: 24),

          // Calendar Section
          _buildCalendar(),
          const SizedBox(height: 24),

          // Time Selection Section
          _buildTimeSelection(),
          const SizedBox(height: 24),

          // Duration Display (calculated automatically)
          if (_calculatedDuration.isNotEmpty) _buildDurationDisplay(),
          const SizedBox(height: 24),

          // Summary Section
          if (_selectedDate != null && _startTime != null && _endTime != null)
            _buildSummary(),
        ],
      ),
    );
  }

  // Calendar widget (same as before)
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
          widget.onDateSelected(selectedDay);
        },
        calendarStyle: CalendarStyle(
          selectedDecoration: const BoxDecoration(
            color: Colors.blue,
            shape: BoxShape.circle,
          ),
          todayDecoration: BoxDecoration(
            color: Colors.blue.shade100,
            shape: BoxShape.circle,
          ),
        ),
        headerStyle: const HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
        ),
      ),
    );
  }

  // Improved Time Selection with AM/PM pickers
  Widget _buildTimeSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Select Time',
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

        // Start Time and End Time pickers side by side
        Row(
          children: [
            // Start Time Picker
            Expanded(
              child: _buildTimePickerCard(
                label: 'START TIME',
                time: _startTime,
                isSelected: _isSelectingStartTime,
                onTap: () => _pickTime(isStartTime: true),
              ),
            ),
            const SizedBox(width: 16),
            // End Time Picker
            Expanded(
              child: _buildTimePickerCard(
                label: 'END TIME',
                time: _endTime,
                isSelected: !_isSelectingStartTime && _startTime != null,
                onTap: () => _pickTime(isStartTime: false),
              ),
            ),
          ],
        ),

        // Help text
        if (_startTime == null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              'Tap START TIME to begin',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
            ),
          )
        else if (_endTime == null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              'Now tap END TIME to complete',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
      ],
    );
  }

  // Individual time picker card
  Widget _buildTimePickerCard({
    required String label,
    required TimeOfDay? time,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.blue.withOpacity(0.1)
              : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: isSelected ? Colors.blue : Colors.grey[600],
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              time != null ? _formatTimeOfDay(time) : '--:-- --',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: time != null
                    ? (isSelected ? Colors.blue : Colors.black)
                    : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Time picker dialog
  Future<void> _pickTime({required bool isStartTime}) async {
    // Set which one we're selecting
    setState(() {
      _isSelectingStartTime = isStartTime;
    });

    // Show time picker dialog
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isStartTime
          ? (_startTime ?? TimeOfDay.now())
          : (_endTime ?? TimeOfDay.now()),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isStartTime) {
          _startTime = picked;
          widget.onStartTimeSelected(picked);
          // Clear end time if it's before start time
          if (_endTime != null && _isEndTimeBeforeStart()) {
            _endTime = null;
          }
        } else {
          // Validate end time is after start time
          if (_startTime != null && _isEndTimeValid(picked)) {
            _endTime = picked;
            widget.onEndTimeSelected(picked);
          } else {
            // Show error message
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('End time must be after start time'),
                backgroundColor: Colors.orange,
              ),
            );
            return;
          }
        }

        // Recalculate duration if both times are set
        if (_startTime != null && _endTime != null) {
          _calculateDuration();
        }
      });
    }
  }

  // Check if end time is before start time
  bool _isEndTimeBeforeStart() {
    if (_startTime == null || _endTime == null) return false;

    final startMinutes = _startTime!.hour * 60 + _startTime!.minute;
    final endMinutes = _endTime!.hour * 60 + _endTime!.minute;

    return endMinutes <= startMinutes;
  }

  // Check if end time is valid (after start time)
  bool _isEndTimeValid(TimeOfDay endTime) {
    if (_startTime == null) return true;

    final startMinutes = _startTime!.hour * 60 + _startTime!.minute;
    final endMinutes = endTime.hour * 60 + endTime.minute;

    return endMinutes > startMinutes;
  }

  // Calculate duration between start and end time
  void _calculateDuration() {
    if (_startTime == null || _endTime == null) return;

    // Convert both times to minutes since midnight
    final startMinutes = _startTime!.hour * 60 + _startTime!.minute;
    final endMinutes = _endTime!.hour * 60 + _endTime!.minute;

    // Calculate difference
    int diffMinutes = endMinutes - startMinutes;

    // Handle if end time is next day (shouldn't happen in our case, but just in case)
    if (diffMinutes < 0) {
      diffMinutes += 24 * 60;
    }

    // Format duration string
    String durationText;
    if (diffMinutes < 60) {
      durationText = '$diffMinutes min';
    } else {
      final hours = diffMinutes ~/ 60;
      final minutes = diffMinutes % 60;
      if (minutes == 0) {
        durationText = '$hours hour${hours > 1 ? 's' : ''}';
      } else {
        durationText = '$hours hour${hours > 1 ? 's' : ''} $minutes min';
      }
    }

    setState(() {
      _calculatedDuration = durationText;
    });

    // Notify parent
    widget.onDurationCalculated(durationText);
  }

  // Duration display
  Widget _buildDurationDisplay() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Estimated Duration',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 4),
          Text(
            _calculatedDuration,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.green.shade700,
            ),
          ),
        ],
      ),
    );
  }

  // Summary widget
  Widget _buildSummary() {
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
            'Interpreter requested for ${_formatDate(_selectedDate!)} from ${_formatTimeOfDay(_startTime!)} to ${_formatTimeOfDay(_endTime!)}. '
            'Total duration: $_calculatedDuration.',
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

import 'package:flutter/material.dart';

// This screen allows users to select the type of event they need an interpreter for
class EventTypeScreen extends StatefulWidget {
  // Callback function to notify parent when an option is selected
  final Function(String) onEventTypeSelected;

  const EventTypeScreen({super.key, required this.onEventTypeSelected});

  @override
  State<EventTypeScreen> createState() => _EventTypeScreenState();
}

class _EventTypeScreenState extends State<EventTypeScreen> {
  // Track which event type is currently selected
  String? _selectedEventType;

  // List of event types with their icons and descriptions
  // This matches your design: Regular Class, Campus Event, Meeting/Office Hours, Other
  final List<Map<String, dynamic>> _eventTypes = [
    {
      'title': 'Regular Class',
      'description': 'For your recurring academic schedule',
      'icon': Icons.class_,
      'value': 'class',
    },
    {
      'title': 'Campus Event',
      'description': 'Workshops, lectures, or social events',
      'icon': Icons.event,
      'value': 'campus_event',
    },
    {
      'title': 'Meeting/Office Hours',
      'description': 'One-on-one sessions with faculty or staff',
      'icon': Icons.people,
      'value': 'meeting',
    },
    {
      'title': 'Other',
      'description': 'Anything else not listed above',
      'icon': Icons.more_horiz,
      'value': 'other',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header section
        const Text(
          'What do you need an interpreter for?',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          'Select the event type that best matches your request.',
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
        ),
        const SizedBox(height: 24),

        // List of event type options
        // Using ListView.builder for efficient scrolling
        Expanded(
          child: ListView.builder(
            itemCount: _eventTypes.length,
            itemBuilder: (context, index) {
              final eventType = _eventTypes[index];
              final isSelected = _selectedEventType == eventType['value'];

              return Card(
                // Card widget gives us a nice elevation and rounded corners
                elevation: isSelected ? 4 : 1,
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  // Add a colored border if selected
                  side: isSelected
                      ? const BorderSide(color: Colors.blue, width: 2)
                      : BorderSide.none,
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.blue.withOpacity(0.1)
                          : Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      eventType['icon'],
                      color: isSelected ? Colors.blue : Colors.grey[700],
                      size: 28,
                    ),
                  ),
                  title: Text(
                    eventType['title'],
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: isSelected ? Colors.blue : Colors.black,
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      eventType['description'],
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ),
                  // Show check icon when selected
                  trailing: isSelected
                      ? const Icon(Icons.check_circle, color: Colors.blue)
                      : const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    // Update UI to show selection
                    setState(() {
                      _selectedEventType = eventType['value'];
                    });
                    // Notify parent screen about selection
                    widget.onEventTypeSelected(eventType['title']);
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

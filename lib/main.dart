import 'package:flutter/material.dart';
import 'event_type_screen.dart'; // Import our new screen

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Interpreter Request',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const RequestHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class RequestHomePage extends StatefulWidget {
  const RequestHomePage({super.key});

  @override
  State<RequestHomePage> createState() => _RequestHomePageState();
}

class _RequestHomePageState extends State<RequestHomePage> {
  int _currentStep = 1;

  // Track selected data from each step
  String? _selectedEventType;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String? _selectedDuration;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Interpreter Request'),
        centerTitle: true,
        elevation: 2,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Progress indicator
            LinearProgressIndicator(
              value: _currentStep / 4,
              backgroundColor: Colors.grey[300],
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
            const SizedBox(height: 8),
            Text(
              'Step $_currentStep of 4',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 24),

            // Show different screens based on current step
            Expanded(child: _buildCurrentStep()),

            // Navigation buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Back button
                if (_currentStep > 1)
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _currentStep--;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[300],
                      foregroundColor: Colors.black,
                    ),
                    child: const Text('Back'),
                  )
                else
                  const SizedBox(),

                // Next/Submit button
                ElevatedButton(
                  onPressed: _canProceed() ? _handleNext : null,
                  child: Text(_currentStep == 4 ? 'Submit' : 'Next Step'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Build the current step's screen
  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 1:
        return EventTypeScreen(
          onEventTypeSelected: (type) {
            setState(() {
              _selectedEventType = type;
            });
          },
        );
      case 2:
        // We'll build this next
        return const Center(child: Text('Step 2: Date & Time (Coming Soon)'));
      case 3:
        // We'll build this later
        return const Center(child: Text('Step 3: Review (Coming Soon)'));
      case 4:
        // We'll build this later
        return const Center(child: Text('Step 4: Confirmation (Coming Soon)'));
      default:
        return const SizedBox();
    }
  }

  // Check if we can proceed to next step
  bool _canProceed() {
    switch (_currentStep) {
      case 1:
        return _selectedEventType != null;
      case 2:
        return _selectedDate != null &&
            _selectedTime != null &&
            _selectedDuration != null;
      case 3:
        return true; // Review step always allows proceeding
      case 4:
        return true; // Final step
      default:
        return false;
    }
  }

  // Handle next button press
  void _handleNext() {
    if (_currentStep < 4) {
      setState(() {
        _currentStep++;
      });
    } else {
      // Submit the request
      _submitRequest();
    }
  }

  // Submit the final request
  void _submitRequest() {
    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Request submitted! Event: $_selectedEventType'),
        backgroundColor: Colors.green,
      ),
    );

    //Optional: Reset form after submission
    setState(() {
      _currentStep = 1;
      _selectedEventType = null;
      _selectedDate = null;
      _selectedTime = null;
      _selectedDuration = null;
    });
  }
}

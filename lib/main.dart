import 'package:flutter/material.dart';

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
      debugShowCheckedModeBanner: false, // Removes the debug banner
    );
  }
}

class RequestHomePage extends StatefulWidget {
  const RequestHomePage({super.key});

  @override
  State<RequestHomePage> createState() => _RequestHomePageState();
}

class _RequestHomePageState extends State<RequestHomePage> {
  // This will track which step of the form we're on
  int _currentStep = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Interpreter Request'),
        centerTitle: true,
        elevation: 2, // Adds a slight shadow
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Progress indicator
            LinearProgressIndicator(
              value: _currentStep / 4, // 4 total steps, so step 1 = 25%
              backgroundColor: Colors.grey[300],
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
            const SizedBox(height: 8),
            Text(
              'Step $_currentStep of 4',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 24),

            // Placeholder for different steps
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.calendar_month,
                      size: 80,
                      color: Colors.blue[200],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Welcome to Interpreter Request',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'We\'ll guide you through requesting an interpreter\n'
                      'for your class, event, or meeting.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),

            // Navigation buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Back button (disabled on step 1)
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
                  const SizedBox(), // Empty space when back is hidden
                // Next button
                ElevatedButton(
                  onPressed: () {
                    if (_currentStep < 4) {
                      setState(() {
                        _currentStep++;
                      });
                    } else {
                      // Submit form when on step 4
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Request submitted!')),
                      );
                    }
                  },
                  child: Text(_currentStep == 4 ? 'Submit' : 'Next Step'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

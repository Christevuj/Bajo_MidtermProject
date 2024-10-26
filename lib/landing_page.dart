import 'package:flutter/material.dart';
import 'dashboard.dart'; // Import your dashboard file

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 190, 117, 190), // Top gradient color (blue)
              Color.fromARGB(255, 210, 205, 210), // Bottom gradient color (light blue)
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Main illustration and text
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.task,
                    size: 120,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Welcome to Taskinator',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'A workspace to over 10 Million influencers\naround the global of the world.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            // "Let's Start" button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to the Dashboard page when clicked
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Dashboard()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 190, 117, 190), // Button color
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Center(
                  child: Text(
                    "Let's Start",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

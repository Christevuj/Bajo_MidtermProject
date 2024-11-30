import 'package:flutter/material.dart';
// Import the file where IntroSlides is defined
import 'allabout.dart';

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
              Color.fromARGB(255, 190, 117, 190),
              Color.fromARGB(255, 210, 205, 210),
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  // Updated TextStyle with Lobster font and regular font weight
                  const Text(
                    'Taskinator',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.normal,  // Regular text weight
                      color: Colors.white,
                      fontFamily: 'Lobster',  // Apply Lobster font here
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'where all people love to procrastinate',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to the IntroSlides page when clicked
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => IntroSlides()), // Use IntroSlides here
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 190, 117, 190),
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

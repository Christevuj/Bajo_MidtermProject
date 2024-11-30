import 'package:flutter/material.dart';
import 'package:bajo_flutterapp/dashboard.dart';  // Import the Dashboard screen

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: IntroSlides(), // Starts with the IntroSlides
    );
  }
}

class IntroSlides extends StatefulWidget {
  @override
  _IntroSlidesState createState() => _IntroSlidesState();
}

class _IntroSlidesState extends State<IntroSlides> {
  final PageController _pageController = PageController();
  int currentPage = 0;

  // Feature list for the intro slides with updated image paths
  final List<Map<String, String>> features = [
    {
      'title': 'Track your tasks with ease',
      'description':
          'Manage your tasks efficiently and stay organized effortlessly.',
      'icon': 'task',  // Icon for fallback (we will use images here)
      'image': 'assets/images/track.png',  // Image path for this slide
    },
    {
      'title': 'Create and customize tasks',
      'description': 'Personalize your tasks to suit your workflow and needs.',
      'icon': 'create',
      'image': 'assets/images/create.png',  // Path for the 'Create' image
    },
    {
      'title': 'Edit tasks instantly',
      'description': 'Quickly modify tasks to keep your progress updated.',
      'icon': 'edit',
      'image': 'assets/images/edit.png',  // Path for the 'Edit' image
    },
    {
      'title': 'History page',
      'description':
          'View completed tasks and track your achievements over time.',
      'icon': 'history',
      'image': 'assets/images/history.png',  // Path for the 'History' image
    },
  ];

  @override
  void dispose() {
    _pageController.dispose(); // Dispose the PageController to avoid memory leaks
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  currentPage = index; // Update the current page index
                });
              },
              itemCount: features.length,
              itemBuilder: (context, index) {
                return SlidePage(
                  title: features[index]['title']!,
                  description: features[index]['description']!,
                  image: features[index]['image']!, // Pass the image for each slide
                  icon: Icons.task, // Default icon (only used if no image)
                  isLast: index == features.length - 1, // Check if it's the last slide
                  onNext: () {
                    if (index < features.length - 1) {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    } else {
                      // Navigate to Dashboard on the last slide
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Dashboard(),
                        ),
                      );
                    }
                  },
                  currentPage: currentPage, // Pass the currentPage to SlidePage
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class SlidePage extends StatelessWidget {
  final String title;
  final String description;
  final bool isLast;
  final VoidCallback onNext;
  final int currentPage;
  final IconData icon;
  final String image;  // Required image path

  const SlidePage({
    required this.title,
    required this.description,
    required this.isLast,
    required this.onNext,
    required this.currentPage,
    required this.icon,
    required this.image, // Image passed as a required parameter
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center, // Center the content vertically
        children: [
          const SizedBox(height: 20), // Add 20px space above the icon/image
          // Display the image
          Image.asset(
            image,
            height: 280, // Set the height of the image to 280
            width: 280,  // Set the width of the image to 280
            fit: BoxFit.cover, // Ensure it fits within the box
          ),
          const SizedBox(height: 40),
          // Title with margin
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 24.0), // Add margin
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 24, // Adjusted font size to match LandingPage
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 20),
          // Description with margin
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 24.0), // Add margin
            child: Text(
              description,
              style: const TextStyle(
                fontSize: 16, // Adjusted font size to match LandingPage
                color: Color.fromARGB(255, 0, 0, 0),
                height: 1.5, // Add line height for better readability
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 80), // Adjust space to 80px below description
          ElevatedButton(
            onPressed: onNext, // Call the provided onNext function
            child: Text(
              isLast ? 'Get Started' : 'Next',
              style: const TextStyle(
                fontSize: 18,
                color: Colors.white, // Set the font color to white
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromARGB(255, 190, 117, 190),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
          const SizedBox(height: 40), // Add 40px space below the button
          // Dot indicators
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              4, // Number of dots
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                height: 12,
                width: 12,
                decoration: BoxDecoration(
                  color: index == currentPage
                      ? Color.fromARGB(255, 190, 117, 190) // Active dot color
                      : Color(0xFFD3CCE3), // Pastel violet for inactive dots
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

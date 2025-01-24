import 'package:flutter/material.dart';
import 'dashboard.dart';
import 'login.dart';  // Import the login
import 'signup.dart';  // Import the SignUpPage
import 'buslocation.dart';
import 'emergency_page.dart';
import 'additional_services.dart';
import 'parking.dart';
import 'parking_details_page.dart';

void main() {
  runApp(const SahayatriApp());
}

class SahayatriApp extends StatelessWidget {
  const SahayatriApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sahayatri',
      initialRoute: '/', // Define the initial route
      routes: {
        '/': (context) => const SahayatriHome(),
        '/login': (context) => const Login(),
        '/signup': (context) => const SignUpPage(),
        '/buslocation':(context)=> const BusLocationPage(),
        '/emergency': (context) => const EmergencyPage(),
        '/parking': (context) => const VehicleParkingPage(),
        '/additional': (context) => const AdditionalPage(),
      },
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,  // Change primary color to purple
        scaffoldBackgroundColor: Colors.white,  // Set background to white
        fontFamily: 'Preahvihear',
      ),
    );
  }
}

class SahayatriHome extends StatefulWidget {
  const SahayatriHome({super.key});

  @override
  _SahayatriHomeState createState() => _SahayatriHomeState();
}

class _SahayatriHomeState extends State<SahayatriHome> {
  int _tapCount = 0; // Counter for bus logo taps

  void _handleBusLogoTap() {
    setState(() {
      _tapCount++;
    });

    if (_tapCount >= 5) {
      Navigator.pushReplacementNamed(context, '/dashboard');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF6A0DAD), // Purple gradient start
              Color(0xFFF1E6FF), // Light purple gradient end
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
            const Text(
              'Sahayatri',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.white, // Text color changed to white
              ),
            ),
            const Text(
              'Your Travel Buddy',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.normal,
                color: Colors.white70, // Lighter text color
              ),
            ),
            const SizedBox(height: 30),
            GestureDetector(
              onTap: _handleBusLogoTap,
              child: Image.asset(
                'assets/bus.png',
                height: 200,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.directions_bus,
                    size: 200,
                    color: Colors.deepPurple.shade200, // Bus icon color changed to purple
                  );
                },
              ),
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple, // Button color changed to purple
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text(
                    'Log In',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  SizedBox(width: 10),
                  Icon(Icons.arrow_forward, color: Colors.white),
                ],
              ),
            ),
            const SizedBox(height: 20),
            OutlinedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/signup');
              },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.deepPurple),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text(
                    'Sign Up',
                    style: TextStyle(fontSize: 18, color: Colors.deepPurple),
                  ),
                  SizedBox(width: 10),
                  Icon(
                    Icons.arrow_forward,
                    color: Colors.deepPurple,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            OutlinedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/buslocation');
              },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.deepPurple),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text(
                    'Sign In as Driver',
                    style: TextStyle(fontSize: 18, color: Colors.deepPurple),
                  ),
                  SizedBox(width: 10),
                  Icon(
                    Icons.drive_eta,
                    color: Colors.deepPurple,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

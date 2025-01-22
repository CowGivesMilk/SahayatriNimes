import 'package:flutter/material.dart';
import 'signup.dart'; // Import the Sign-Up page
import 'bubble_generator.dart';
import 'dashboard.dart';
import 'api_service.dart';


class login extends StatefulWidget {
  const login({super.key});

  @override
  _loginState createState() => _loginState();
}

class _loginState extends State<login> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  // Function to handle sign-in
  void _LogIn() async {
    setState(() => _isLoading = true); // Show loading indicator
    try {
      // Call the login function from the API service
      final response = await ApiService.login(
        _emailController.text,
        _passwordController.text,
      );

      // Show a success message using a snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Welcome, ${response['username']}!')),
      );

      // Navigate to the Dashboard page on successful login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DashboardPage()),
      );
    } catch (error) {
      // Show an error message using a snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login Failed: $error')),
      );
    } finally {
      setState(() => _isLoading = false); // Hide loading indicator
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,  // Disable resizing of the layout when the keyboard appears
      backgroundColor: Colors.deepPurple[50], // Lighter purple background
      body: Stack(
        children: [
          ...generateRandomBubbles(),
          // Background decoration with a darker purple
          Positioned(
            top: -380,
            left: -231,
            child: Container(
              width: 700,
              height: 700,
              decoration: BoxDecoration(
                color: Colors.deepPurple, // Dark purple background
                borderRadius: BorderRadius.circular(350),
              ),
            ),
          ),
          Positioned(
            bottom: -125,
            right: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.purpleAccent[400],
                borderRadius: BorderRadius.circular(100),
              ),
            ),
          ),

          // Main content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Welcome\nOn Board',
                  style: TextStyle(
                    height: 1.2,
                    fontFamily: 'Preahvihear',
                    fontSize: 37,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 100),

                // Email input field
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    hintText: 'Your Email',
                    filled: true,
                    fillColor: Colors.deepPurple[100], // Light purple field color
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Password input field
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    filled: true,
                    fillColor: Colors.deepPurple[100], // Light purple field color
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                // Sign-In button with purple color
                ElevatedButton(
                  onPressed: _isLoading ? null : _LogIn,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple, // Purple button
                    padding: const EdgeInsets.all(15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
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
                const SizedBox(height: 100),

                // Navigate to Sign-Up
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                    MaterialPageRoute(builder: (context) => const SignUpPage()),
                    );
                  },
                  child: const Text(
                    "Don't have an account?",
                    style: TextStyle(fontSize: 16, color: Colors.deepPurple),
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

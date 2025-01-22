import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
//import 'api_service.dart';  // You'll connect this to your backend

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = false;

  // Placeholder data for categories and places
  final List<String> categories = ['Hospital', 'Tourist Destination', 'Government Office'];
  final List<String> places = ['Place 1', 'Place 2', 'Place 3'];

  // Function to search places
  void _searchPlaces() async {
    // Here you will connect to the backend to search from your database
    // For now, we'll just print the search term
    print('Searching for: ${_searchController.text}');
  }

  // Function to show the user profile
  Widget _userProfile() {
    // Replace with real user data from your database
    return Column(
      children: [
        CircleAvatar(radius: 30, backgroundImage: NetworkImage('https://www.example.com/user-profile.jpg')),
        const SizedBox(height: 10),
        Text('John Doe', style: TextStyle(color: Colors.white, fontSize: 18)),
        Text('Trips: 5 | Loyalty: 200', style: TextStyle(color: Colors.white, fontSize: 14)),
      ],
    );
  }

  // Function to show location categories as buttons
  Widget _categoryButtons() {
    return GridView.builder(
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        return ElevatedButton(
          onPressed: () {
            // Here, you'd filter the places based on the category
            // For now, just print the category selected
            print('Category: ${categories[index]}');
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
          child: Text(categories[index]),
        );
      },
    );
  }

  // Function to show a list of places
  Widget _placesList() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: places.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(places[index]),
          onTap: () {
            // Handle click (e.g., show details about the place)
            print('Selected Place: ${places[index]}');
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Platform'),
        actions: [
          IconButton(
            icon: Icon(Icons.location_on),
            onPressed: () {
              // Handle location icon click
              print('Location icon clicked');
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text('John Doe'),
              accountEmail: Text('john.doe@example.com'),
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage('https://www.example.com/user-profile.jpg'),
              ),
            ),
            ListTile(
              title: Text('History'),
              onTap: () => print('History tapped'),
            ),
            ListTile(
              title: Text('Safety'),
              onTap: () => print('Safety tapped'),
            ),
            ListTile(
              title: Text('Settings'),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsPage()),
              ),
            ),
            ListTile(
              title: Text('Help'),
              onTap: () => print('Help tapped'),
            ),
            ListTile(
              title: Text('Support'),
              onTap: () => print('Support tapped'),
            ),
            Divider(),
            ListTile(
              title: Text('Facebook'),
              onTap: () => print('Redirect to Facebook'),
            ),
            ListTile(
              title: Text('Instagram'),
              onTap: () => print('Redirect to Instagram'),
            ),
            ListTile(
              title: Text('Website'),
              onTap: () => print('Redirect to Website'),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search places...',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: _searchPlaces,
                ),
              ),
            ),
            _categoryButtons(),
            Expanded(child: _placesList()),
          ],
        ),
      ),
    );
  }
}

// Settings Page for the settings option in the burger menu
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Username: John Doe'),
            Text('Email: john.doe@example.com'),
            ElevatedButton(
              onPressed: () => print('Change Password clicked'),
              child: Text('Change Password'),
            ),
            Spacer(),
            ElevatedButton(
              onPressed: () => print('Logging out...'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text('Log Out'),
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'api_service.dart';
import 'main.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:permission_handler/permission_handler.dart';

class DashboardPage extends StatefulWidget {
  final String userId;
  final String name;
  final String email;
  String? picture;

  DashboardPage({
    super.key,
    required this.userId,
    required this.name,
    required this.email,
    this.picture,
  });

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> categories = [
    'Hospital',
    'Tourist Destination',
    'Government Office'
  ];
  final List<String> places = ['Place 1', 'Place 2', 'Place 3'];

  File? _mobileProfilePicture;
  Uint8List? _webProfilePicture;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      if (kIsWeb) {
        final webImage = await pickedFile.readAsBytes();
        setState(() {
          _webProfilePicture = webImage;
        });
        try {
          await ApiService.updateProfilePicture(widget.userId, _webProfilePicture);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile picture updated successfully!')),
          );
          setState(() {
            widget.picture = null;
          });
        } catch (error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to update profile picture: $error')),
          );
        }
      } else {
        final imageFile = File(pickedFile.path);
        setState(() {
          _mobileProfilePicture = imageFile;
        });
        try {
          await ApiService.updateProfilePicture(widget.userId, _mobileProfilePicture!);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile picture updated successfully!')),
          );
          setState(() {
            widget.picture = null;
          });
        } catch (error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to update profile picture: $error')),
          );
        }
      }
    }
  }

  void _searchPlaces() {
    print('Searching for: ${_searchController.text}');
  }

  Widget _categoryButtons() {
    return GridView.builder(
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 60,
        mainAxisSpacing: 10,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        return ElevatedButton(
          onPressed: () {
            print('Category: ${categories[index]}');
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
          child: Text(categories[index]),
        );
      },
    );
  }

  Widget _placesList() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: places.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(places[index]),
          onTap: () {
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
        title: const Text('Sahayatri'),
        actions: [
          IconButton(
            icon: const Icon(Icons.location_on),
            onPressed: () {
              print('Location icon clicked');
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(widget.name),
              accountEmail: Text(widget.email),
              currentAccountPicture: CircleAvatar(
                backgroundImage: widget.picture != null
                    ? NetworkImage(widget.picture!)
                    : null,
                child: widget.picture == null
                    ? IconButton(
                  icon: const Icon(Icons.add_a_photo),
                  onPressed: _pickImage,
                )
                    : null,
              ),
            ),
            ListTile(
              title: const Text('History'),
              onTap: () => print('History tapped'),
            ),
            ListTile(
              title: const Text('Safety'),
              onTap: () => print('Safety tapped'),
            ),
            ListTile(
              title: const Text('Additional Features'),
              onTap: () => print('Additional Features'),
            ),
            ListTile(
              title: const Text('Settings'),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsPage()),
              ),
            ),
            ListTile(
              title: const Text('Help'),
              onTap: () => print('Help tapped'),
            ),
            ListTile(
              title: const Text('Support'),
              onTap: () => print('Support tapped'),
            ),
            ListTile(
              title: const Text('Emergency Services'),
              onTap: () => Navigator.push(
                context,
                 MaterialPageRoute(builder: (context) => const EmergencyPage()),
              ),
            ),
            const Divider(),
            ListTile(
              title: const Text('Facebook'),
              onTap: () => print('Redirect to Facebook'),
            ),
            ListTile(
              title: const Text('Instagram'),
              onTap: () => print('Redirect to Instagram'),
            ),
            ListTile(
              title: const Text('Website'),
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
                  icon: const Icon(Icons.search),
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

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Change your settings here.'),
            ElevatedButton(
              onPressed: () => print('Change Password clicked'),
              child: const Text('Change Password'),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                // Navigate to main.dart
                Navigator.pushReplacementNamed(context, '/');
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Log Out'),
            ),
          ],
        ),
      ),
    );
  }
}


class EmergencyPage extends StatelessWidget {
  const EmergencyPage({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: const Text('Emergency Services')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton(
              onPressed: () async {
                Uri uri = Uri.parse('tel:102');
                if (!await launcher.launchUrl(uri)) {
                  debugPrint("Could not launch the uri"); // because the simulator doesn't have the phone app
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple, // Button color changed to purple
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.max, // Make the Row take all available width
                children: [
                  Expanded(
                    child: Text(
                      'Ambulance',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                  SizedBox(width: 8), // Space between the text and the icon
                  Icon(FontAwesomeIcons.ambulance, color: Colors.white),
                ],
              ),
            ),


            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                Uri uri = Uri.parse('tel:100');
                if (!await launcher.launchUrl(uri)) {
                  debugPrint("Could not launch the uri"); // because the simulator doesn't have the phone app
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple, // Button color changed to purple
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.max, // Make the Row take all available width
                children: [
                  Expanded(
                    child: Text(
                      'Police',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                  SizedBox(width: 8), // Space between the text and the icon
                  Icon(FontAwesomeIcons.userShield, color: Colors.white),
                ],
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                Uri uri = Uri.parse('tel:101');
                if (!await launcher.launchUrl(uri)) {
                  debugPrint("Could not launch the uri"); // because the simulator doesn't have the phone app
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple, // Button color changed to purple
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.max, // Make the Row take all available width
                children: [
                  Expanded(
                    child: Text(
                      'Fire Brigade',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                  SizedBox(width: 8), // Space between the text and the icon
                  Icon(FontAwesomeIcons.houseFire, color: Colors.white),
                ],
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                Uri uri = Uri.parse('tel:103');
                if (!await launcher.launchUrl(uri)) {
                  debugPrint("Could not launch the uri"); // because the simulator doesn't have the phone app
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple, // Button color changed to purple
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.max, // Make the Row take all available width
                children: [
                  Expanded(
                    child: Text(
                      'Traffic Police',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                  SizedBox(width: 8), // Space between the text and the icon
                  Icon(FontAwesomeIcons.trafficLight, color: Colors.white),
                ],
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                Uri uri = Uri.parse('tel:1149');
                if (!await launcher.launchUrl(uri)) {
                  debugPrint("Could not launch the uri"); // because the simulator doesn't have the phone app
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple, // Button color changed to purple
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.max, // Make the Row take all available width
                children: [
                  Expanded(
                    child: Text(
                      'Electricity Emergency',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                  SizedBox(width: 8), // Space between the text and the icon
                  Icon(FontAwesomeIcons.lightbulb, color: Colors.white),
                ],
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                Uri uri = Uri.parse('tel:9818201002');
                if (!await launcher.launchUrl(uri)) {
                  debugPrint("Could not launch the uri"); // because the simulator doesn't have the phone app
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple, // Button color changed to purple
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.max, // Make the Row take all available width
                children: [
                  Expanded(
                    child: Text(
                      'Gas Leakage',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                  SizedBox(width: 8), // Space between the text and the icon
                  Icon(FontAwesomeIcons.warning, color: Colors.white),
                ],
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                Uri uri = Uri.parse('tel:1145');
                if (!await launcher.launchUrl(uri)) {
                  debugPrint("Could not launch the uri"); // because the simulator doesn't have the phone app
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple, // Button color changed to purple
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.max, // Make the Row take all available width
                children: [
                  Expanded(
                    child: Text(
                      'Women And Child Protection',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                  SizedBox(width: 8), // Space between the text and the icon
                  Icon(FontAwesomeIcons.female, color: Colors.white),
                  Icon(FontAwesomeIcons.child, color: Colors.white),
                ],
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                Uri uri = Uri.parse('tel:1166');
                if (!await launcher.launchUrl(uri)) {
                  debugPrint("Could not launch the uri"); // because the simulator doesn't have the phone app
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple, // Button color changed to purple
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.max, // Make the Row take all available width
                children: [
                  Expanded(
                    child: Text(
                      'Suicidal Thoughts',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                  SizedBox(width: 8), // Space between the text and the icon
                  Icon(FontAwesomeIcons.sadCry, color: Colors.white),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
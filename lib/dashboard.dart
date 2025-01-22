import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io'; // For mobile file handling
import 'dart:typed_data'; // For web file handling
import 'package:flutter/foundation.dart' show kIsWeb;
import 'api_service.dart';

class DashboardPage extends StatefulWidget {
  final String userId;
  final String name;
  final String email;
  String? picture; // Keep it mutable for dynamic updates

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
  File? _mobileProfilePicture; // For mobile
  Uint8List? _webProfilePicture; // For web

  // Function to pick an image (handles web and mobile)
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      if (kIsWeb) {
        // For Web: Read as bytes
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
            widget.picture = null; // Forces reload of picture
          });
        } catch (error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to update profile picture: $error')),
          );
        }
      } else {
        // For Mobile: Use File
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
            widget.picture = null; // Forces reload of picture
          });
        } catch (error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to update profile picture: $error')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile picture display
            CircleAvatar(
              radius: 50,
              backgroundImage: widget.picture != null
                  ? NetworkImage(widget.picture!)
                  : null,
              child: widget.picture == null
                  ? IconButton(
                icon: const Icon(Icons.add_a_photo, size: 30),
                onPressed: _pickImage,
              )
                  : null,
            ),
            const SizedBox(height: 15),
            // Name and email display
            Text(
              widget.name,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(
              widget.email,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            // Action buttons or any other content
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Feature Coming Soon!')),
                );
              },
              child: const Text('View Saved Routes'),
            ),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Feature Coming Soon!')),
                );
              },
              child: const Text('Explore Nearby'),
            ),
            const SizedBox(height: 20),
            // Logout button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, // Updated button color property
                foregroundColor: Colors.white, // Text color property
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Log out and return to previous screen
              },
              child: const Text('Log Out'),
            ),
          ],
        ),
      ),
    );
  }
}

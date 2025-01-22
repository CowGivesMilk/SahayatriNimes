import 'dart:async'; // Import dart:async for Timer
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'bubble_generator.dart';

class BusLocationPage extends StatefulWidget {
  const BusLocationPage({super.key});

  @override
  _BusLocationPageState createState() => _BusLocationPageState();
}

class _BusLocationPageState extends State<BusLocationPage> {
  final _busNumberController = TextEditingController();
  final _driverNameController = TextEditingController();
  String? _selectedYatayat;

  // Placeholder list for Yatayat names (replace with DB data)
  final List<String> yatayatNames = ['Sajha Yatayat', 'Mayur Yatayat', 'Nepal Yatayat'];

  String? _locationMessage = "Location not yet shared.";
  Timer? _locationTimer; // To hold the Timer reference
  bool _isSharingLocation = false; // To check if location sharing is active

  // Request permission for location
  Future<bool> _requestPermission() async {
    var status = await Permission.location.request();
    return status.isGranted;
  }

  // Get the current location of the device
  Future<void> _getLocation() async {
    bool permissionGranted = await _requestPermission();

    if (permissionGranted) {
      try {
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );

        setState(() {
          _locationMessage = 'Latitude: ${position.latitude}, Longitude: ${position.longitude}';
        });
      } catch (e) {
        setState(() {
          _locationMessage = 'Failed to get location: $e';
        });
      }
    } else {
      setState(() {
        _locationMessage = 'Location permission denied.';
      });
    }
  }

  // Start location updates every 2 seconds
  void _startLocationUpdates() {
    _locationTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      _getLocation();
    });
  }

  // Stop location updates
  void _stopLocationUpdates() {
    if (_locationTimer != null) {
      _locationTimer!.cancel();
      setState(() {
        _locationMessage = 'Location updates stopped.';
        _isSharingLocation = false; // Stop sharing
      });
    }
  }

  @override
  void dispose() {
    _locationTimer?.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, // Disable resizing of the layout when the keyboard appears
      backgroundColor: Colors.deepPurple[50], // Light purple background
      body: Stack(
        children: [
          ...generateRandomBubbles(),
          // Background decoration with a darker purple (same as main page)
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Bus Location Sharing',
                  style: TextStyle(
                    fontFamily: 'Preahvihear',
                    fontSize: 37,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 100),

                // Yatayat Name Dropdown
                DropdownButtonFormField<String>(
                  value: _selectedYatayat,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedYatayat = newValue;
                    });
                  },
                  items: yatayatNames.map((String yatayat) {
                    return DropdownMenuItem<String>(value: yatayat, child: Text(yatayat));
                  }).toList(),
                  decoration: InputDecoration(
                    hintText: 'Select Yatayat Name',
                    filled: true,
                    fillColor: Colors.deepPurple[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Bus Number input field
                TextField(
                  controller: _busNumberController,
                  decoration: InputDecoration(
                    hintText: 'Bus Number',
                    filled: true,
                    fillColor: Colors.deepPurple[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Driver Name input field
                TextField(
                  controller: _driverNameController,
                  decoration: InputDecoration(
                    hintText: 'Driver Name',
                    filled: true,
                    fillColor: Colors.deepPurple[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                // Display the location message using RichText
                RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: _locationMessage?.contains('Latitude') ?? false
                            ? 'Latitude: ${_locationMessage?.split(',')[0].split(':')[1]?.trim()}'
                            : '',
                        style: TextStyle(color: Colors.black), // Black color for Latitude
                      ),
                      TextSpan(
                        text: ', ',
                        style: TextStyle(color: Colors.black), // Black color for separator
                      ),
                      TextSpan(
                        text: _locationMessage?.contains('Longitude') ?? false
                            ? 'Longitude: ${_locationMessage?.split(',')[1]?.split(':')[1]?.trim()}'
                            : '',
                        style: TextStyle(color: Colors.black), // Black color for Longitude
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                // Toggle button to start/stop location sharing
                ElevatedButton(
                  onPressed: () {
                    if (_isSharingLocation) {
                      _stopLocationUpdates(); // Stop sharing location
                    } else {
                      _startLocationUpdates(); // Start location updates
                      setState(() {
                        _isSharingLocation = true; // Location sharing started
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding: const EdgeInsets.all(15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _isSharingLocation ? 'Stop Sharing' : 'Share Location',
                        style: const TextStyle(fontSize: 18, color: Colors.white),
                      ),
                      const SizedBox(width: 10),
                      Icon(
                        _isSharingLocation ? Icons.warning : Icons.location_on,
                        color: Colors.white,
                      ),
                    ],
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

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'bubble_generator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BusLocationPage extends StatefulWidget {
  const BusLocationPage({super.key});

  @override
  _BusLocationPageState createState() => _BusLocationPageState();
}

class _BusLocationPageState extends State<BusLocationPage> {
  final _driverNameController = TextEditingController();
  String? _selectedYatayat;
  String? _selectedBusNumber;
  List<String> yatayatNames = [];
  List<String> busNumbers = [];
  String _locationMessage = "Location not yet shared.";
  Timer? _locationTimer;
  bool _isSharingLocation = false;
  bool _isLoadingYatayat = false; // For loading Yatayat names
  bool _isLoadingBuses = false;   // For loading buses for a selected Yatayat

  @override
  void initState() {
    super.initState();
    _fetchYatayatNames();
  }

  @override
  void dispose() {
    _locationTimer?.cancel();
    _driverNameController.dispose();
    super.dispose();
  }

  Future<bool> _requestPermission() async {
    var status = await Permission.location.request();
    return status.isGranted;
  }

  Future<void> _fetchYatayatNames() async {
    setState(() {
      _isLoadingYatayat = true; // Show loading for Yatayat names
    });

    const url = 'http://192.168.1.66:3000/get-yatayat-data';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          yatayatNames = List<String>.from(data.map((item) => item['yatayat_name']));
        });
      } else {
        throw Exception('Failed to fetch Yatayat data');
      }
    } catch (e) {
      print('Error fetching Yatayat names: $e');
      setState(() {
        yatayatNames = ['Error fetching data'];
      });
    } finally {
      setState(() {
        _isLoadingYatayat = false; // Hide loading indicator for Yatayat names
      });
    }
  }

  Future<void> _fetchBusNumbers(String yatayatName) async {
    setState(() {
      _isLoadingBuses = true; // Show loading for buses
    });

    // Find the ID of the selected Yatayat
    final yatayatId = yatayatNames.indexOf(yatayatName) + 1; // Assuming IDs start from 1

    final url = 'http://192.168.1.66:3000/get-buses-by-yatayat/$yatayatId';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('Bus numbers response: $data'); // Debug print
        if (data.isEmpty) {
          setState(() {
            busNumbers = ['No buses found'];
          });
        } else {
          setState(() {
            busNumbers = List<String>.from(data.map((item) => item['bus_number'].toString()));
          });
        }
      } else {
        throw Exception('Failed to fetch buses');
      }
    } catch (e) {
      print('Error fetching buses: $e');
      setState(() {
        busNumbers = ['No buses found'];
      });
    } finally {
      setState(() {
        _isLoadingBuses = false; // Hide loading indicator for buses
      });
    }
  }

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

  void _startLocationUpdates() {
    _locationTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      _getLocation();
    });
  }

  void _stopLocationUpdates() {
    if (_locationTimer != null) {
      _locationTimer!.cancel();
      setState(() {
        _locationMessage = 'Location updates stopped.';
        _isSharingLocation = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.deepPurple[50],
      body: Stack(
        children: [
          ...generateRandomBubbles(),
          Positioned(
            top: -380,
            left: -231,
            child: Container(
              width: 700,
              height: 700,
              decoration: BoxDecoration(
                color: Colors.deepPurple,
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
                _isLoadingYatayat
                    ? const CircularProgressIndicator() // Show loading indicator for Yatayat names
                    : DropdownButtonFormField<String>(
                  key: Key('yatayatDropdown'), // Unique Key
                  value: _selectedYatayat,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedYatayat = newValue;
                      _selectedBusNumber = null; // Reset the bus number when Yatayat changes
                      busNumbers = []; // Reset bus numbers
                    });
                    if (newValue != null) {
                      _fetchBusNumbers(newValue); // Fetch buses based on selected Yatayat
                    }
                  },
                  items: yatayatNames.map((String yatayat) {
                    return DropdownMenuItem<String>(
                      value: yatayat,
                      child: Text(yatayat),
                    );
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

                // Bus Number Dropdown
                _isLoadingBuses
                    ? const CircularProgressIndicator() // Show loading indicator for buses
                    : DropdownButtonFormField<String>(
                  key: Key('busNumberDropdown'), // Unique Key
                  value: _selectedBusNumber,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedBusNumber = newValue;
                    });
                  },
                  items: busNumbers.map((String bus) {
                    return DropdownMenuItem<String>(
                      value: bus,
                      child: Text(bus),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    hintText: 'Select Bus Number',
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

                // Location message
                Text(
                  _locationMessage,
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),

                // Share location button
                ElevatedButton(
                  onPressed: () {
                    if (_isSharingLocation) {
                      _stopLocationUpdates();
                    } else {
                      _startLocationUpdates();
                      setState(() {
                        _isSharingLocation = true;
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
                        _isSharingLocation ? Icons.location_off : Icons.location_on,
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

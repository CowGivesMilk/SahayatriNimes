import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'parking_details_page.dart'; // Import ParkingDetailsPage

class VehicleParkingPage extends StatefulWidget {
  const VehicleParkingPage({Key? key}) : super(key: key);

  @override
  _VehicleParkingPageState createState() => _VehicleParkingPageState();
}

class _VehicleParkingPageState extends State<VehicleParkingPage> {
  List<Map<String, dynamic>> parkingData = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchParkingData();
  }

  // Fetch parking data from the server
  Future<void> fetchParkingData() async {
    try {
      final response = await http.get(Uri.parse('http://192.168.1.66:3000/get-parking-data'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('Parking data: $data'); // Log the entire response to check data
        setState(() {
          parkingData = List<Map<String, dynamic>>.from(data);
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      // Handle error here
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Vehicle Parking')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator()) // Show loader while fetching data
          : Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView.builder(
          itemCount: parkingData.length,
          itemBuilder: (context, index) {
            final parking = parkingData[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to the ParkingDetailsPage with the complete parking data
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ParkingDetailsPage(parkingDetails: parking),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: Text(
                        'ID: ${parking['id']} - ${parking['parking_name']}',
                        style: const TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(FontAwesomeIcons.parking, color: Colors.white),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

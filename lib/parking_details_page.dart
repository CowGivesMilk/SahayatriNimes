import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ParkingDetailsPage extends StatelessWidget {
  final Map<String, dynamic> parkingDetails;

  ParkingDetailsPage({required this.parkingDetails});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text(parkingDetails['parking_name'] ?? 'Parking Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            // Parking name card
            _buildDetailCard(
              title: 'Parking Name',
              value: '${parkingDetails['parking_name'] ?? 'No Name Available'}',
              icon: Icons.local_parking,
            ),
            SizedBox(height: 15),

            // Parking ID card
            _buildDetailCard(
              title: 'Parking ID',
              value: '${parkingDetails['id'] ?? 'N/A'}',
              icon: Icons.confirmation_number,
            ),
            SizedBox(height: 15),

            // Location card with clickable feature for Google Maps using Plus Code
            _buildDetailCard(
              title: 'Location',
              value: '${parkingDetails['location'] ?? 'Location not available'}',
              icon: Icons.location_on,
              onTap: () {
                String plusCode = parkingDetails['location'] ?? '7V2VQR8H+5F'; // Default to Kathmandu Mall Plus Code if none exists
                _launchMapsWithPlusCode(plusCode);
              },
            ),
            SizedBox(height: 15),

            // Latitude card
            _buildDetailCard(
              title: 'Latitude',
              value: '${parkingDetails['latitude'] ?? 'N/A'}',
              icon: Icons.my_location,
            ),
            SizedBox(height: 15),

            // Longitude card
            _buildDetailCard(
              title: 'Longitude',
              value: '${parkingDetails['longitude'] ?? 'N/A'}',
              icon: Icons.my_location,
            ),
            SizedBox(height: 15),

            // Total Parking Spaces card
            _buildDetailCard(
              title: 'Total Parking Spaces',
              value: '${parkingDetails['parking_space'] ?? 'N/A'}',
              icon: Icons.local_parking,
            ),
            SizedBox(height: 15),

            // Used Parking Spaces card
            _buildDetailCard(
              title: 'Used Parking Spaces',
              value: '${parkingDetails['used_parking_space'] ?? 'N/A'}',
              icon: Icons.directions_car,
            ),
          ],
        ),
      ),
    );
  }

  // Custom widget to create a card for each detail
  Widget _buildDetailCard({
    required String title,
    required String value,
    required IconData icon,
    void Function()? onTap,
  }) {
    return Card(
      elevation: 4, // Shadow effect for card
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10), // Rounded corners
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            children: [
              Icon(icon, color: Colors.deepPurple, size: 30),
              SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      value,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Function to launch Google Maps with Plus Code
  void _launchMapsWithPlusCode(String plusCode) async {
    // Encode the Plus Code to ensure special characters like '+' are properly passed
    String encodedPlusCode = Uri.encodeComponent(plusCode);
    final url = 'https://www.google.com/maps/search/?api=1&query=$encodedPlusCode';
    print("Launching with Plus Code: $url");
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print("Could not launch URL with Plus Code.");
      throw 'Could not open the map.';
    }
  }
}

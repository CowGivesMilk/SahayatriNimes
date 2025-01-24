import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;

class EmergencyPage extends StatelessWidget {
  const EmergencyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Emergency Services')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            _buildEmergencyButton(
              context,
              label: 'Ambulance',
              phone: '102',
              icon: FontAwesomeIcons.ambulance,
            ),
            const SizedBox(height: 10),
            _buildEmergencyButton(
              context,
              label: 'Police',
              phone: '100',
              icon: FontAwesomeIcons.userShield,
            ),
            const SizedBox(height: 10),
            _buildEmergencyButton(
              context,
              label: 'Fire Brigade',
              phone: '101',
              icon: FontAwesomeIcons.houseFire,
            ),
            const SizedBox(height: 10),
            _buildEmergencyButton(
              context,
              label: 'Traffic Police',
              phone: '103',
              icon: FontAwesomeIcons.trafficLight,
            ),
            const SizedBox(height: 10),
            _buildEmergencyButton(
              context,
              label: 'Electricity Emergency',
              phone: '1149',
              icon: FontAwesomeIcons.lightbulb,
            ),
            const SizedBox(height: 10),
            _buildEmergencyButton(
              context,
              label: 'Gas Leakage',
              phone: '9818201002',
              icon: FontAwesomeIcons.warning,
            ),
            const SizedBox(height: 10),
            _buildEmergencyButton(
              context,
              label: 'Women And Child Protection',
              phone: '1145',
              icon: FontAwesomeIcons.female,
              secondaryIcon: FontAwesomeIcons.child,
            ),
            const SizedBox(height: 10),
            _buildEmergencyButton(
              context,
              label: 'Suicidal Thoughts',
              phone: '1166',
              icon: FontAwesomeIcons.phone,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmergencyButton(BuildContext context,
      {required String label,
        required String phone,
        required IconData icon,
        IconData? secondaryIcon}) {
    return ElevatedButton(
      onPressed: () async {
        Uri uri = Uri.parse('tel:$phone');
        if (!await launcher.launchUrl(uri)) {
          debugPrint("Could not launch the uri");
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.deepPurple,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
          const SizedBox(width: 8),
          Icon(icon, color: Colors.white),
          if (secondaryIcon != null)
            Icon(secondaryIcon, color: Colors.white),
        ],
      ),
    );
  }
}

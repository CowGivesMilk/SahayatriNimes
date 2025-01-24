import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'api_service.dart';
import 'main.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AdditionalPage extends StatelessWidget {
  const AdditionalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Additional features')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/parking');
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
                      'Vehicle Parking',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                  SizedBox(width: 8), // Space between the text and the icon
                  Icon(FontAwesomeIcons.parking, color: Colors.white),
                ],
              ),
            )



          ],
        ),
      ),
    );
  }
}


import 'dart:math';
import 'package:flutter/material.dart';

List<Widget> generateRandomBubbles() {
  final random = Random();
  final List<Widget> bubbles = [];
  for (int i = 0; i < 20; i++) { // Adjust the number of bubbles
    final size = random.nextDouble() * 50 + 20; // Random size between 20 and 70
    final topPosition = random.nextDouble() * 700; // Random top position
    final leftPosition = random.nextDouble() * 400; // Random left position
    bubbles.add(Positioned(
      top: topPosition,
      left: leftPosition,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.purple.withOpacity(0.6), // Purple color with slight transparency
          shape: BoxShape.circle,
        ),
      ),
    ));
  }
  return bubbles;
}
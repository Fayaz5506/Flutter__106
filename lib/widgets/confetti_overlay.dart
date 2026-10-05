import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';

class ConfettiOverlayWidget extends StatelessWidget {
  final ConfettiController controller;

  const ConfettiOverlayWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConfettiWidget(
        confettiController: controller,
        blastDirectionality: BlastDirectionality.explosive,
        shouldLoop: false,
        maxBlastForce: 25,
        minBlastForce: 10,
        emissionFrequency: 0.05,
        numberOfParticles: 20,
        gravity: 0.3,
        colors: const [
          Color(0xFFFF7A00),
          Color(0xFF00A68C),
          Color(0xFF3B82F6),
          Color(0xFFEC4899),
          Color(0xFFF59E0B),
        ],
      ),
    );
  }
}

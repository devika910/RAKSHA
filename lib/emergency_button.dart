import 'package:flutter/material.dart';

class EmergencyButton3D extends StatelessWidget {
  final VoidCallback onPressed;

  const EmergencyButton3D({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          width: 250,
          height: 250,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey, width: 15),
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [Colors.red.shade800, Colors.red.shade400],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              // Top highlight
              BoxShadow(
                color: Colors.white.withValues(alpha: 0.2),
                offset: const Offset(-4, -4),
                blurRadius: 8,
              ),
              // Bottom shadow
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.4),
                offset: const Offset(6, 6),
                blurRadius: 10,
              ),
              // Glow around
              BoxShadow(
                color: Colors.red.withValues(alpha: 0.5),
                blurRadius: 30,
                spreadRadius: 2,
              ),
            ],
          ),
          child: const Center(
            child: Icon(Icons.warning_rounded, color: Colors.white, size: 100),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ConnectionFlag extends StatelessWidget {
  const ConnectionFlag({super.key, required this.status});
  final bool status;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: status ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: status ? Colors.green : Colors.red,
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: status ? Colors.green : Colors.red,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: (status ? Colors.green : Colors.red).withOpacity(0.3),
                  blurRadius: 6,
                  spreadRadius: 2,
                ),
              ],
            ),
          ).animate(onPlay: (controller) => controller.repeat())
              .fadeOut(duration: 1000.ms)
              .fadeIn(duration: 1000.ms),
          const SizedBox(width: 8),
          Text(
            status ? 'CONNECTED' : 'DISCONNECTED',
            style: GoogleFonts.poppins(
              color: status ? Colors.green : Colors.red,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
          const SizedBox(width: 4),
          Icon(
            status ? Icons.cloud_done : Icons.cloud_off,
            size: 16,
            color: status ? Colors.green : Colors.red,
          ),
        ],
      ),
    ).animate()
        .fadeIn(duration: 400.ms)
        .slideX(begin: -0.2, end: 0);
  }
}
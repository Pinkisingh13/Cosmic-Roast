import 'dart:ui';
import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  final String roast;
  final String mulank;

  const ResultScreen({
    super.key,
    required this.roast,
    required this.mulank,
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset('assets/vertical_bg.png', fit: BoxFit.cover),
          ),
          
          // Blur Overlay
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(color: Colors.black.withOpacity(0.6)),
            ),
          ),

          // Content
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // App Branding
                  const Text(
                    'COSMIC ROAST',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.purpleAccent,
                      letterSpacing: 4,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Mulank Badge
                  _buildMulankBadge(),
                  const SizedBox(height: 16),

                  // Tagline
                  const Text(
                    "THE STARS HAVE SPOKEN",
                    style: TextStyle(
                      color: Colors.purpleAccent,
                      letterSpacing: 3,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Roast Text Card
                  _buildRoastCard(),
                  const SizedBox(height: 24),

                  // Year Badge
                  Text(
                    '✨ 2026 Predictions ✨',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.5),
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Try Again Button
                  _buildTryAgainButton(context),
                ],
              ),
            ),
          ),
        ],
      ),
      ),
    );
  }

  /// Builds the circular Mulank badge
  Widget _buildMulankBadge() {
    return Container(
      width: 100,
      height: 100,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.purpleAccent, width: 3),
        color: Colors.black.withOpacity(0.5),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withOpacity(0.3),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Text(
        mulank,
        style: const TextStyle(
          fontSize: 40,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  /// Builds the roast text card
  Widget _buildRoastCard() {
    return Container(
      constraints: const BoxConstraints(maxWidth: 500),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Text(
        roast,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 20,
          color: Colors.white,
          height: 1.6,
        ),
      ),
    );
  }

  /// Builds the try again button
  Widget _buildTryAgainButton(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () => Navigator.pop(context),
      icon: const Icon(Icons.refresh, size: 20),
      label: const Text("TRY ANOTHER DATE"),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(
          horizontal: 32,
          vertical: 16,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}

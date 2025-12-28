import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cosmic Roast',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        fontFamily: 'SF Pro Display',
      ),
      home: const CosmicRoastHome(),
    );
  }
}

class CosmicRoastHome extends StatefulWidget {
  const CosmicRoastHome({super.key});

  @override
  State<CosmicRoastHome> createState() => _CosmicRoastHomeState();
}

class _CosmicRoastHomeState extends State<CosmicRoastHome> {
  final TextEditingController dayController = TextEditingController();
  final TextEditingController monthController = TextEditingController();
  final TextEditingController yearController = TextEditingController();

  final FocusNode dayFocus = FocusNode();
  final FocusNode monthFocus = FocusNode();
  final FocusNode yearFocus = FocusNode();

  String? dayError;
  String? monthError;
  String? yearError;

  bool _isLoading = false;

  void _validateDay(String value) {
    setState(() {
      if (value.isEmpty) {
        dayError = null;
      } else {
        final day = int.tryParse(value);
        if (day == null || day < 1 || day > 31) {
          dayError = '1-31';
        } else {
          dayError = null;
        }
      }
    });
  }

  void _validateMonth(String value) {
    setState(() {
      if (value.isEmpty) {
        monthError = null;
      } else {
        final month = int.tryParse(value);
        if (month == null || month < 1 || month > 12) {
          monthError = '1-12';
        } else {
          monthError = null;
        }
      }
    });
  }

  void _validateYear(String value) {
    setState(() {
      if (value.isEmpty) {
        yearError = null;
      } else {
        final year = int.tryParse(value);
        final currentYear = DateTime.now().year;
        if (year == null || year < 1900 || year > currentYear) {
          yearError = '1900-$currentYear';
        } else {
          yearError = null;
        }
      }
    });
  }

  bool _validateAll() {
    final day = int.tryParse(dayController.text);
    final month = int.tryParse(monthController.text);
    final year = int.tryParse(yearController.text);
    final currentYear = DateTime.now().year;

    bool isValid = true;

    setState(() {
      if (day == null || day < 1 || day > 31) {
        dayError = '1-31';
        isValid = false;
      } else {
        dayError = null;
      }

      if (month == null || month < 1 || month > 12) {
        monthError = '1-12';
        isValid = false;
      } else {
        monthError = null;
      }

      if (year == null || year < 1900 || year > currentYear) {
        yearError = '1900-$currentYear';
        isValid = false;
      } else {
        yearError = null;
      }

      if (isValid && day != null && month != null && year != null) {
        final daysInMonth = DateTime(year, month + 1, 0).day;
        if (day > daysInMonth) {
          dayError = 'Max $daysInMonth';
          isValid = false;
        }
      }
    });

    return isValid;
  }

  Future<void> _onSubmit() async {
    FocusScope.of(context).unfocus();

    final day = dayController.text;
    final month = monthController.text;
    final year = yearController.text;

    if (day.isEmpty || month.isEmpty || year.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Please enter your complete birthdate',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red.shade700,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      _validateAll();
      return;
    }

    if (!_validateAll()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Please enter a valid birthdate',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red.shade700,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // REPLACE WITH YOUR RENDER URL
      final url = Uri.parse('https://YOUR-APP.onrender.com/roast-me');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'date': dayController.text,
          'month': monthController.text,
          'year': yearController.text,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final roast = data['roast'];
        final mulank = data['mulank'];

        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  ResultScreen(roast: roast, mulank: mulank.toString()),
            ),
          );
        }
      } else {
        throw Exception('Server Error');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    dayController.dispose();
    monthController.dispose();
    yearController.dispose();
    dayFocus.dispose();
    monthFocus.dispose();
    yearFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isWeb = size.width > 600;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              isWeb ? 'assets/web_bg.png' : 'assets/vertical_bg.png',
              fit: BoxFit.cover,
            ),
          ),

          // Overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(color: Colors.black.withOpacity(0.5)),
            ),
          ),

          // Main Content
          Scaffold(
            backgroundColor: Colors.transparent,
            body: SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo/Icon
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [
                              Colors.purple.shade300,
                              Colors.deepPurple.shade600,
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.purple.withOpacity(0.5),
                              blurRadius: 30,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.auto_awesome,
                          size: 50,
                          color: Colors.white,
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Title
                      ShaderMask(
                        shaderCallback: (bounds) => LinearGradient(
                          colors: [Colors.white, Colors.purple.shade200],
                        ).createShader(bounds),
                        child: const Text(
                          'COSMIC ROAST',
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 4,
                          ),
                        ),
                      ),

                      const SizedBox(height: 8),

                      // Subtitle
                      Text(
                        '✨ Savage Predictions 2026 ✨',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.purple.shade200,
                          letterSpacing: 2,
                        ),
                      ),

                      const SizedBox(height: 48),

                      // Glass Card
                      Container(
                        constraints: const BoxConstraints(maxWidth: 400),
                        padding: const EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          color: Colors.white.withOpacity(0.1),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            const Text(
                              'Enter Your Birthdate',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),

                            const SizedBox(height: 8),

                            Text(
                              'The stars have something to say...',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white.withOpacity(0.7),
                              ),
                            ),

                            const SizedBox(height: 32),

                            // Date Input Fields
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: _buildDateField(
                                    controller: dayController,
                                    focusNode: dayFocus,
                                    label: 'DD',
                                    maxLength: 2,
                                    errorText: dayError,
                                    onChanged: (value) {
                                      _validateDay(value);
                                      if (value.length == 2 &&
                                          dayError == null) {
                                        monthFocus.requestFocus();
                                      }
                                    },
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: _buildDateField(
                                    controller: monthController,
                                    focusNode: monthFocus,
                                    label: 'MM',
                                    maxLength: 2,
                                    errorText: monthError,
                                    onChanged: (value) {
                                      _validateMonth(value);
                                      if (value.length == 2 &&
                                          monthError == null) {
                                        yearFocus.requestFocus();
                                      }
                                    },
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  flex: 2,
                                  child: _buildDateField(
                                    controller: yearController,
                                    focusNode: yearFocus,
                                    label: 'YYYY',
                                    maxLength: 4,
                                    errorText: yearError,
                                    onChanged: (value) {
                                      _validateYear(value);
                                      if (value.length == 4 &&
                                          yearError == null) {
                                        FocusScope.of(context).unfocus();
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 32),

                            // Submit Button
                            SizedBox(
                              width: double.infinity,
                              height: 56,
                              child: ElevatedButton(
                                onPressed: _isLoading ? null : _onSubmit,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.deepPurple,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  elevation: 8,
                                  shadowColor:
                                      Colors.deepPurple.withOpacity(0.5),
                                ),
                                child: _isLoading
                                    ? const SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.rocket_launch, size: 20),
                                          SizedBox(width: 12),
                                          Text(
                                            'REVEAL MY FATE',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 2,
                                            ),
                                          ),
                                        ],
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String label,
    required int maxLength,
    required Function(String) onChanged,
    String? errorText,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white.withOpacity(0.1),
        border: Border.all(
          color: errorText != null ? Colors.red : Colors.white.withOpacity(0.3),
        ),
      ),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: maxLength,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
        decoration: InputDecoration(
          counterText: '',
          border: InputBorder.none,
          hintText: label,
          hintStyle: TextStyle(color: Colors.white.withOpacity(0.4)),
        ),
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        onChanged: onChanged,
      ),
    );
  }
}

// Simple Result Screen - No download/share functionality
class ResultScreen extends StatelessWidget {
  final String roast;
  final String mulank;

  const ResultScreen({super.key, required this.roast, required this.mulank});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          // Background
          Positioned.fill(
            child: Image.asset('assets/vertical_bg.png', fit: BoxFit.cover),
          ),
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
                  // App branding
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
                  Container(
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
                  ),
                  const SizedBox(height: 16),
                  
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

                  // The Roast Text
                  Container(
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
                  ),

                  const SizedBox(height: 24),
                  
                  Text(
                    '✨ 2026 Predictions ✨',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.5),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Try Again Button
                  ElevatedButton.icon(
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
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

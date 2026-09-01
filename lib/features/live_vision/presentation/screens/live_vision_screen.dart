// lib/features/live_vision/presentation/screens/live_vision_screen.dart

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

// Access global cameras initialized in main.dart
import '../../../../main.dart';

class LiveVisionScreen extends StatefulWidget {
  const LiveVisionScreen({Key? key}) : super(key: key);

  @override
  State<LiveVisionScreen> createState() => _LiveVisionScreenState();
}

class _LiveVisionScreenState extends State<LiveVisionScreen> {
  CameraController? _cameraController;
  bool _isCameraInitialized = false;
  bool _isNavigating = true;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    if (cameras.isNotEmpty) {
      _cameraController = CameraController(
        cameras.first, // Selects rear camera
        ResolutionPreset.medium,
        enableAudio: false,
      );

      try {
        await _cameraController!.initialize();
        if (mounted) {
          setState(() {
            _isCameraInitialized = true;
          });
        }
      } catch (e) {
        debugPrint('Error initializing camera feed: $e');
      }
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        children: [
          // Camera Detection Feed Box
          Container(
            height: 380,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFF07111A),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: const Color(0xFF132235),
                width: 1,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Stack(
                children: [
                  // Live Camera Viewfinder or Loading Indicator
                  Positioned.fill(
                    child: _isCameraInitialized && _cameraController != null
                        ? AspectRatio(
                            aspectRatio: _cameraController!.value.aspectRatio,
                            child: CameraPreview(_cameraController!),
                          )
                        : const Center(
                            child: CircularProgressIndicator(
                              color: Color(0xFF00E5FF),
                            ),
                          ),
                  ),

                  // Background Grid Overlay Effect
                  Positioned.fill(
                    child: CustomPaint(
                      painter: GridPainter(),
                    ),
                  ),

                  // Top Status Badges
                  Positioned(
                    top: 16,
                    left: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF221115),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color(0xFFFF4B4B).withOpacity(0.4),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          CircleAvatar(
                            radius: 4,
                            backgroundColor: Color(0xFFFF4B4B),
                          ),
                          SizedBox(width: 6),
                          Text(
                            "LIVE",
                            style: TextStyle(
                              color: Color(0xFFFF4B4B),
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 16,
                    right: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF092934),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color(0xFF00E5FF).withOpacity(0.4),
                        ),
                      ),
                      child: const Text(
                        "3 OBJECTS",
                        style: TextStyle(
                          color: Color(0xFF00E5FF),
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                  ),

                  // Bounding Boxes with Labels
                  // 1. Bench (Green Box)
                  Positioned(
                    left: 30,
                    bottom: 40,
                    child: _buildBoundingBox(
                      width: 75,
                      height: 70,
                      label: "BENCH",
                      color: const Color(0xFF00E676),
                    ),
                  ),

                  // 2. Person (Red Box)
                  Positioned(
                    left: 105,
                    top: 45,
                    child: _buildBoundingBox(
                      width: 105,
                      height: 120,
                      label: "PERSON 2m",
                      color: const Color(0xFFFF453A),
                    ),
                  ),

                  // 3. Stairs (Orange Box)
                  Positioned(
                    right: 40,
                    top: 90,
                    child: _buildBoundingBox(
                      width: 80,
                      height: 95,
                      label: "STAIRS 4m",
                      color: const Color(0xFFFF9F0A),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Audio Announcement Banner
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: const Color(0xFF0A1E29),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFF00E5FF).withOpacity(0.3),
              ),
            ),
            child: Row(
              children: const [
                Icon(Icons.volume_up_rounded, color: Color(0xFF00E5FF), size: 22),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    "Crosswalk ahead. Safe to cross.",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // 2x2 Detected Objects Grid
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 2.6,
            children: [
              _buildObjectTag("Person", "Ahead 2m", const Color(0xFFFF9F0A)),
              _buildObjectTag("Stairs", "Right 4m", const Color(0xFFFF453A)),
              _buildObjectTag("Bench", "Left 3m", const Color(0xFF00E676)),
              _buildObjectTag("Door", "Ahead 6m", const Color(0xFF00E676)),
            ],
          ),
          const SizedBox(height: 16),

          // Stop / Start Navigation Button
          GestureDetector(
            onTap: () {
              setState(() {
                _isNavigating = !_isNavigating;
                if (!_isNavigating) {
                  _cameraController?.pausePreview();
                } else {
                  _cameraController?.resumePreview();
                }
              });
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1418),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFFFF453A),
                  width: 1.5,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _isNavigating ? Icons.close : Icons.play_arrow_rounded,
                    color: const Color(0xFFFF453A),
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _isNavigating ? "Stop Navigation" : "Start Navigation",
                    style: const TextStyle(
                      color: Color(0xFFFF453A),
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  // Bounding Box Builder Widget
  Widget _buildBoundingBox({
    required double width,
    required double height,
    required String label,
    required Color color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
          decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(4),
              topRight: Radius.circular(4),
            ),
          ),
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 9,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            border: Border.all(color: color, width: 2),
          ),
        ),
      ],
    );
  }

  // Object Tag Pill Widget
  Widget _buildObjectTag(String title, String distance, Color indicatorColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF0D1622),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 4,
            backgroundColor: indicatorColor,
          ),
          const SizedBox(width: 10),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "$title ",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: distance,
                  style: const TextStyle(
                    color: Color(0xFF4A6B8D),
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Custom Painter for standard detection camera grid effect
class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF00E5FF).withOpacity(0.12)
      ..strokeWidth = 1;

    const double step = 30;

    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
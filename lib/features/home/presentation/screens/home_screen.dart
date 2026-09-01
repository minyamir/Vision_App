// lib/features/home/presentation/screens/home_screen.dart

import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../live_vision/presentation/screens/live_vision_screen.dart';
import '../../../settings/presentation/screens/settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF070B11),
      body: SafeArea(
        child: IndexedStack(
          index: _selectedIndex,
          children: const [
            HomeTabContent(),
            LiveVisionScreen(),
            FeaturesTabContent(),
            SettingsScreen(),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        color: const Color(0xFF070B11),
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 5, top: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
          decoration: BoxDecoration(
            color: const Color(0xFF0D1520),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(0, Icons.home_outlined, "HOME"),
              _buildNavItem(1, Icons.map_outlined, "NAVIGATE"),
              _buildNavItem(2, Icons.flash_on_outlined, "FEATURES"),
              _buildNavItem(3, Icons.settings_outlined, "SETTINGS"),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 68,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF0B2836) : Colors.transparent,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? const Color(0xFF00E5FF) : const Color(0xFF2C4A6F),
              size: 24,
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? const Color(0xFF00E5FF) : const Color(0xFF2C4A6F),
                fontSize: 9,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeTabContent extends StatefulWidget {
  const HomeTabContent({Key? key}) : super(key: key);

  @override
  State<HomeTabContent> createState() => _HomeTabContentState();
}

class _HomeTabContentState extends State<HomeTabContent> {
  bool _isListening = true;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "VisionVoice",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    "AI ASSISTANT",
                    style: TextStyle(
                      color: Color(0xFF00E5FF),
                      fontSize: 11,
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF0B1926),
                ),
                child: const Icon(
                  Icons.person_outline,
                  color: Color(0xFF00E5FF),
                  size: 20,
                ),
              )
            ],
          ),
          const SizedBox(height: 40),

          // Interactive Voice Microphone Button
          Center(
            child: Column(
              children: [
                GestureDetector(
                  onTap: () => setState(() => _isListening = !_isListening),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      if (_isListening) ...[
                        Container(
                          width: 260,
                          height: 260,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xFF00E5FF).withOpacity(0.08),
                              width: 1,
                            ),
                          ),
                        ),
                        Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xFF00E5FF).withOpacity(0.18),
                              width: 1,
                            ),
                          ),
                        ),
                      ],
                      if (!_isListening)
                        const SizedBox(width: 260, height: 260),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        width: _isListening ? 130 : 160,
                        height: _isListening ? 130 : 160,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _isListening ? null : const Color(0xFF111A29),
                          gradient: _isListening
                              ? const RadialGradient(
                                  colors: [
                                    Color(0xFF80F3FF),
                                    Color(0xFF00E5FF),
                                    Color(0xFF00A3FF),
                                  ],
                                )
                              : null,
                          border: _isListening
                              ? null
                              : Border.all(
                                  color: const Color(0xFF1E2D42),
                                  width: 1,
                                ),
                          boxShadow: _isListening
                              ? [
                                  BoxShadow(
                                    color: const Color(0xFF00E5FF).withOpacity(0.45),
                                    blurRadius: 40,
                                    spreadRadius: 10,
                                  ),
                                ]
                              : [],
                        ),
                        child: Icon(
                          _isListening ? Icons.mic_none_rounded : Icons.mic_off_rounded,
                          color: _isListening ? Colors.black : const Color(0xFF3B5270),
                          size: _isListening ? 48 : 52,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  _isListening ? "Vision" : "Tap to speak",
                  style: TextStyle(
                    color: _isListening ? Colors.white : const Color(0xFF3B5270),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),

          // Quick Actions Section Title
          const Text(
            "QUICK ACTIONS",
            style: TextStyle(
              color: Color(0xFF4A5A70),
              fontSize: 11,
              letterSpacing: 1.5,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          // 2x2 Dark Grid Cards
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.15,
            children: [
              _buildGridCard(
                title: "Navigate",
                subtitle: "Live guidance",
                icon: Icons.navigation_outlined,
                backgroundColor: const Color(0xFF08212A),
                iconContainerColor: const Color(0xFF0C3848),
                iconColor: const Color(0xFF00E5FF),
              ),
              _buildGridCard(
                title: "Read Text",
                subtitle: "OCR scanner",
                icon: Icons.crop_free,
                backgroundColor: const Color(0xFF0A1F1D),
                iconContainerColor: const Color(0xFF0E3833),
                iconColor: const Color(0xFF00FF9D),
              ),
              _buildGridCard(
                title: "Messages",
                subtitle: "Telegram / WA",
                icon: Icons.chat_bubble_outline,
                backgroundColor: const Color(0xFF15122B),
                iconContainerColor: const Color(0xFF261D4C),
                iconColor: const Color(0xFFA855F7),
              ),
              _buildGridCard(
                title: "Emergency",
                subtitle: "SOS alert",
                icon: Icons.shield_outlined,
                backgroundColor: const Color(0xFF221115),
                iconContainerColor: const Color(0xFF3B181E),
                iconColor: const Color(0xFFFF4B4B),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Recent Activity Section Title
          const Text(
            "RECENT ACTIVITY",
            style: TextStyle(
              color: Color(0xFF4A5A70),
              fontSize: 11,
              letterSpacing: 1.5,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          // Recent Activity Item List
          _buildActivityItem(
            title: "Sent message to Abel on Telegram",
            time: "2m ago",
            icon: Icons.chat_bubble_outline,
            iconContainerColor: const Color(0xFF1D1838),
            iconColor: const Color(0xFFA855F7),
          ),
          const SizedBox(height: 10),
          _buildActivityItem(
            title: "Read document — 3 pages scanned",
            time: "15m ago",
            icon: Icons.crop_free,
            iconContainerColor: const Color(0xFF0A2926),
            iconColor: const Color(0xFF00FF9D),
          ),
          const SizedBox(height: 10),
          _buildActivityItem(
            title: "Navigation session — 12 min walk",
            time: "1h ago",
            icon: Icons.navigation_outlined,
            iconContainerColor: const Color(0xFF0A2838),
            iconColor: const Color(0xFF00E5FF),
          ),
          const SizedBox(height: 10),
          _buildActivityItem(
            title: "Searched FastAPI tutorials",
            time: "3h ago",
            icon: Icons.language,
            iconContainerColor: const Color(0xFF2E2614),
            iconColor: const Color(0xFFFFB800),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildGridCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color backgroundColor,
    required Color iconContainerColor,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: iconContainerColor,
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(
                  color: Color(0xFF6B7A90),
                  fontSize: 12,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildActivityItem({
    required String title,
    required String time,
    required IconData icon,
    required Color iconContainerColor,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF0D1622),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFF162334),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: iconContainerColor,
            ),
            child: Icon(icon, color: iconColor, size: 18),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            time,
            style: const TextStyle(
              color: Color(0xFF2C4A6F),
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class FeaturesTabContent extends StatelessWidget {
  const FeaturesTabContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("Features Tab", style: TextStyle(color: Colors.white)),
    );
  }
}
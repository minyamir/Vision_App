import 'package:flutter/material.dart';
import 'route_names.dart'; // <--- ADD THIS
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/live_vision/presentation/screens/live_vision_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart'; // <--- ADD THIS

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case RouteNames.liveVision:
        return MaterialPageRoute(builder: (_) => const LiveVisionScreen());
      case RouteNames.settings:
        return MaterialPageRoute(builder: (_) => const SettingsScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
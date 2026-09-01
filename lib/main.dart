import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'app/app.dart';
import 'core/services/notification_service.dart';
import 'injection/dependency_injection.dart';

// Global variable to hold available device cameras
List<CameraDescription> cameras = [];

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize device cameras
  try {
    cameras = await availableCameras();
  } catch (e) {
    debugPrint('Failed to initialize cameras: $e');
  }

  // Initialize notifications service
  try {
    await NotificationService.init();
  } catch (e) {
    debugPrint('Failed to initialize notification service: $e');
  }

  // Initialize dependency injections
  await initDependencies();
  
  runApp(const App());
}
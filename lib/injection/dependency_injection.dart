import '../features/home/home_injection.dart';
import '../features/live_vision/live_vision_injection.dart';
import '../features/settings/settings_injection.dart';

Future<void> initDependencies() async {
  // Feature modules initialization
  initHomeInjection();
  initLiveVisionInjection();
  initSettingsInjection();
}
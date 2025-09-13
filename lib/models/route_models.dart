import 'advanced_models.dart';

enum AlertLevel { safe, medium, high }

// Route planning model
class RouteOption {
  final String id;
  final String name;
  final double distance;
  final Duration estimatedTime;
  final double safetyScore;
  final List<AdvancedBlackspot> blackspotsOnRoute;
  final List<LatLng> waypoints;
  final String description;

  RouteOption({
    required this.id,
    required this.name,
    required this.distance,
    required this.estimatedTime,
    required this.safetyScore,
    required this.blackspotsOnRoute,
    required this.waypoints,
    required this.description,
  });
}

class LatLng {
  final double latitude;
  final double longitude;

  LatLng(this.latitude, this.longitude);
}
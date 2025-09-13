import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import '../models/advanced_models.dart';
import '../models/blackspot.dart';
import '../models/route_models.dart' as route_models;
import '../models/user_profile.dart';

// Import specific types with prefix to avoid conflicts
typedef LatLng = route_models.LatLng;
typedef RouteOption = route_models.RouteOption;

class AIService {
  static final AIService _instance = AIService._internal();
  factory AIService() => _instance;
  AIService._internal();

  // Sensor data simulation
  Timer? _sensorTimer;
  final List<SensorData> _sensorHistory = [];
  final StreamController<SensorData> _sensorController = StreamController.broadcast();
  
  // Weather data
  WeatherData _currentWeather = WeatherData(
    condition: 'clear',
    temperature: 28.0,
    humidity: 60.0,
    windSpeed: 15.0,
    visibility: 2000.0,
    precipitationProbability: 0.1,
  );

  // Advanced blackspots for Maharashtra region
  final List<AdvancedBlackspot> _blackspots = [
    AdvancedBlackspot(
      id: '1',
      latitude: 17.0906743,
      longitude: 74.4666604,
      severity: BlackSpotSeverity.fatal,
      type: BlackSpotType.highway,
      title: 'Pune-Mumbai Highway Junction',
      description: 'High-speed collision zone with poor visibility',
      riskScore: 9.2,
      fatalAccidents: 5,
      seriousInjuries: 12,
      minorIncidents: 23,
      riskFactors: ['High speed traffic', 'Poor lighting', 'Sharp curves', 'Heavy vehicle zone'],
      lastUpdated: DateTime.now().subtract(const Duration(days: 2)),
    ),
    AdvancedBlackspot(
      id: '2',
      latitude: 17.097643,
      longitude: 74.449632,
      severity: BlackSpotSeverity.serious,
      type: BlackSpotType.junction,
      title: 'Market Road Intersection',
      description: 'Complex 5-way intersection with signal issues',
      riskScore: 6.8,
      fatalAccidents: 1,
      seriousInjuries: 8,
      minorIncidents: 19,
      riskFactors: ['Signal malfunction', 'Pedestrian crossing', 'Multiple lanes'],
      lastUpdated: DateTime.now().subtract(const Duration(days: 1)),
    ),
    AdvancedBlackspot(
      id: '3',
      latitude: 17.085,
      longitude: 74.455,
      severity: BlackSpotSeverity.minor,
      type: BlackSpotType.school,
      title: 'School Zone - Gandhi Road',
      description: 'Children crossing area during school hours',
      riskScore: 4.2,
      fatalAccidents: 0,
      seriousInjuries: 2,
      minorIncidents: 11,
      riskFactors: ['School hours', 'Children crossing', 'Speed bumps'],
      lastUpdated: DateTime.now().subtract(const Duration(hours: 6)),
    ),
    AdvancedBlackspot(
      id: '4',
      latitude: 17.095,
      longitude: 74.465,
      severity: BlackSpotSeverity.serious,
      type: BlackSpotType.construction,
      title: 'Highway Construction Zone',
      description: 'Active construction with lane changes',
      riskScore: 7.5,
      fatalAccidents: 2,
      seriousInjuries: 6,
      minorIncidents: 15,
      riskFactors: ['Lane merging', 'Construction vehicles', 'Reduced visibility'],
      lastUpdated: DateTime.now().subtract(const Duration(hours: 12)),
    ),
    AdvancedBlackspot(
      id: '5',
      latitude: 17.088,
      longitude: 74.472,
      severity: BlackSpotSeverity.fatal,
      type: BlackSpotType.urban,
      title: 'City Center Flyover',
      description: 'Steep gradient with frequent accidents',
      riskScore: 8.9,
      fatalAccidents: 4,
      seriousInjuries: 10,
      minorIncidents: 18,
      riskFactors: ['Steep gradient', 'Wet road issues', 'High traffic density'],
      lastUpdated: DateTime.now().subtract(const Duration(hours: 18)),
    ),
  ];

  // Current location simulation
  double _currentLat = 17.0906743;
  double _currentLng = 74.4666604;
  double _currentSpeed = 45.0;
  double _currentDirection = 90.0;

  Stream<SensorData> get sensorStream => _sensorController.stream;
  List<SensorData> get sensorHistory => List.unmodifiable(_sensorHistory);
  WeatherData get currentWeather => _currentWeather;
  List<AdvancedBlackspot> get blackspots => List.unmodifiable(_blackspots);

  void startSensorSimulation() {
    _sensorTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      _simulateSensorData();
    });
  }

  void stopSensorSimulation() {
    _sensorTimer?.cancel();
    _sensorTimer = null;
  }

  void _simulateSensorData() {
    final random = Random();
    
    // Simulate slight movement in Maharashtra area
    _currentLat += (random.nextDouble() - 0.5) * 0.001;
    _currentLng += (random.nextDouble() - 0.5) * 0.001;
    
    // Keep within Maharashtra bounds
    _currentLat = _currentLat.clamp(17.08, 17.11);
    _currentLng = _currentLng.clamp(74.44, 74.48);
    
    // Simulate speed variations
    _currentSpeed += (random.nextDouble() - 0.5) * 10;
    _currentSpeed = _currentSpeed.clamp(0.0, 120.0);
    
    // Simulate direction changes
    _currentDirection += (random.nextDouble() - 0.5) * 20;
    _currentDirection = _currentDirection % 360;

    final sensorData = SensorData(
      latitude: _currentLat,
      longitude: _currentLng,
      speed: _currentSpeed,
      direction: _currentDirection,
      acceleration: (random.nextDouble() - 0.5) * 4.0,
      gyroscopeX: (random.nextDouble() - 0.5) * 2.0,
      gyroscopeY: (random.nextDouble() - 0.5) * 2.0,
      gyroscopeZ: (random.nextDouble() - 0.5) * 2.0,
      timestamp: DateTime.now(),
    );

    // Keep only last 50 readings
    _sensorHistory.add(sensorData);
    if (_sensorHistory.length > 50) {
      _sensorHistory.removeAt(0);
    }

    _sensorController.add(sensorData);
  }

  // Advanced risk calculation
  double calculateAdvancedRiskScore(UserProfile? userProfile) {
    if (_sensorHistory.isEmpty) return 0.0;

    final currentData = _sensorHistory.last;
    
    return AIProcessingEngine.calculateDynamicRiskScore(
      currentData,
      _sensorHistory,
      _blackspots,
      _currentWeather,
      userProfile ?? _getDefaultProfile(),
      DateTime.now(),
    );
  }

  // Get alert level
  AlertLevel getAlertLevel(double riskScore) {
    return AIProcessingEngine.classifyAlertLevel(riskScore);
  }

  // Get safety recommendations
  List<String> getSafetyRecommendations(double riskScore) {
    if (_sensorHistory.isEmpty) return ['Initializing sensors...'];

    final currentData = _sensorHistory.last;
    final nearbyBlackspots = _getNearbyBlackspots(currentData.latitude, currentData.longitude);
    
    return AIProcessingEngine.generateSafetyRecommendations(
      riskScore,
      _currentWeather,
      currentData,
      nearbyBlackspots,
    );
  }

  // Get nearby blackspots
  List<AdvancedBlackspot> getNearbyBlackspots(double lat, double lng, {double radiusKm = 2.0}) {
    return _blackspots.where((blackspot) {
      final distance = _calculateDistance(lat, lng, blackspot.latitude, blackspot.longitude);
      return distance <= radiusKm * 1000; // Convert km to meters
    }).toList();
  }

  List<AdvancedBlackspot> _getNearbyBlackspots(double lat, double lng) {
    return getNearbyBlackspots(lat, lng, radiusKm: 1.0);
  }

  // Route planning
  List<RouteOption> calculateRouteOptions(double destLat, double destLng) {
    if (_sensorHistory.isEmpty) return [];

    final current = _sensorHistory.last;
    final routes = <RouteOption>[];

    // Main route (direct)
    routes.add(RouteOption(
      id: 'main',
      name: 'Main Route',
      distance: _calculateDistance(current.latitude, current.longitude, destLat, destLng) / 1000,
      estimatedTime: const Duration(minutes: 15),
      safetyScore: 6.5,
      blackspotsOnRoute: _getBlackspotsOnRoute(current.latitude, current.longitude, destLat, destLng),
      waypoints: [
        LatLng(current.latitude, current.longitude),
        LatLng(destLat, destLng),
      ],
      description: 'Fastest route via main roads',
    ));

    // Safe alternative route
    routes.add(RouteOption(
      id: 'safe',
      name: 'Safe Route',
      distance: _calculateDistance(current.latitude, current.longitude, destLat, destLng) / 1000 * 1.2,
      estimatedTime: const Duration(minutes: 20),
      safetyScore: 8.5,
      blackspotsOnRoute: [],
      waypoints: [
        LatLng(current.latitude, current.longitude),
        LatLng(current.latitude + 0.005, current.longitude + 0.005),
        LatLng(destLat, destLng),
      ],
      description: 'Safer route avoiding blackspots',
    ));

    return routes;
  }

  // Simulate weather changes
  void simulateWeatherChange() {
    final random = Random();
    final conditions = ['clear', 'rain', 'fog', 'storm'];
    
    _currentWeather = WeatherData(
      condition: conditions[random.nextInt(conditions.length)],
      temperature: 20.0 + random.nextDouble() * 15.0,
      humidity: 40.0 + random.nextDouble() * 40.0,
      windSpeed: random.nextDouble() * 30.0,
      visibility: 500.0 + random.nextDouble() * 1500.0,
      precipitationProbability: random.nextDouble(),
    );
  }

  // Get current location
  LatLng? getCurrentLocation() {
    if (_sensorHistory.isEmpty) return null;
    final current = _sensorHistory.last;
    return LatLng(current.latitude, current.longitude);
  }

  // Emergency alert
  void triggerEmergencyAlert() {
    // This would integrate with emergency services in a real app
    debugPrint('EMERGENCY ALERT TRIGGERED');
    debugPrint('Location: $_currentLat, $_currentLng');
    debugPrint('Time: ${DateTime.now()}');
  }

  // Cleanup
  void dispose() {
    _sensorTimer?.cancel();
    _sensorController.close();
  }

  // Helper methods
  double _calculateDistance(double lat1, double lng1, double lat2, double lng2) {
    const double earthRadius = 6371000; // meters
    double dLat = (lat2 - lat1) * pi / 180;
    double dLng = (lng2 - lng1) * pi / 180;
    
    double a = sin(dLat / 2) * sin(dLat / 2) +
               cos(lat1 * pi / 180) * cos(lat2 * pi / 180) *
               sin(dLng / 2) * sin(dLng / 2);
    
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadius * c;
  }

  List<AdvancedBlackspot> _getBlackspotsOnRoute(double startLat, double startLng, double endLat, double endLng) {
    // Simplified: return blackspots within 500m of the direct line
    return _blackspots.where((blackspot) {
      double distToStart = _calculateDistance(startLat, startLng, blackspot.latitude, blackspot.longitude);
      double distToEnd = _calculateDistance(endLat, endLng, blackspot.latitude, blackspot.longitude);
      double routeLength = _calculateDistance(startLat, startLng, endLat, endLng);
      
      return (distToStart + distToEnd) <= (routeLength + 500);
    }).toList();
  }

  UserProfile _getDefaultProfile() {
    return UserProfile(
      name: 'Guest User',
      email: '',
      phone: '',
      emergencyContact: '',
      emergencyContactName: '',
      driverExperience: 'intermediate',
      vehicleType: 'car',
    );
  }
}
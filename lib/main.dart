import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:async';

import 'screens/dashboard_screen.dart';
import 'screens/map_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/reporting_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/flow_diagram_screen.dart';
import 'models/user_profile.dart';
import 'models/advanced_models.dart' show AlertLevel, SensorData;
import 'services/ai_service.dart';

void main() {
  runApp(const SafeRouteApp());
}

class SafeRouteApp extends StatelessWidget {
  const SafeRouteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SafeRoute AI',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Inter',
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF030213),
          brightness: Brightness.light,
        ),
      ),
      home: const MainScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  UserProfile? _userProfile;
  double _currentRiskScore = 7.2;
  bool _isLocationTracking = false;
  AlertLevel _currentAlertLevel = AlertLevel.medium;
  List<String> _currentRecommendations = [];
  
  final AIService _aiService = AIService();
  StreamSubscription<SensorData>? _sensorSubscription;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
    _initializeAI();
  }

  @override
  void dispose() {
    _sensorSubscription?.cancel();
    _aiService.dispose();
    super.dispose();
  }

  void _initializeAI() {
    // Listen to sensor data updates
    _sensorSubscription = _aiService.sensorStream.listen((sensorData) {
      if (mounted) {
        setState(() {
          _currentRiskScore = _aiService.calculateAdvancedRiskScore(_userProfile);
          _currentAlertLevel = _aiService.getAlertLevel(_currentRiskScore);
          _currentRecommendations = _aiService.getSafetyRecommendations(_currentRiskScore);
        });
      }
    });
  }

  Future<void> _loadUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final profileJson = prefs.getString('userProfile');
    if (profileJson != null) {
      setState(() {
        _userProfile = UserProfile.fromJson(jsonDecode(profileJson));
      });
    }
  }

  Future<void> _saveUserProfile(UserProfile profile) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userProfile', jsonEncode(profile.toJson()));
    setState(() {
      _userProfile = profile;
    });
  }

  void _toggleLocationTracking() {
    setState(() {
      _isLocationTracking = !_isLocationTracking;
    });

    if (_isLocationTracking) {
      _aiService.startSensorSimulation();
    } else {
      _aiService.stopSensorSimulation();
    }
  }

  void _updateRiskScore(double newScore) {
    setState(() {
      _currentRiskScore = newScore;
    });
  }

  Color _getRiskColor() {
    if (_currentRiskScore >= 8) return const Color(0xFFEF4444); // red-500
    if (_currentRiskScore >= 5) return const Color(0xFFF59E0B); // yellow-500  
    return const Color(0xFF10B981); // green-500
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return DashboardScreen(
          riskScore: _currentRiskScore,
          userProfile: _userProfile,
          isTracking: _isLocationTracking,
          onToggleTracking: _toggleLocationTracking,
          alertLevel: _currentAlertLevel,
          recommendations: _currentRecommendations,
          aiService: _aiService,
        );
      case 1:
        return MapScreen(
          userProfile: _userProfile,
          onRiskScoreUpdate: _updateRiskScore,
          aiService: _aiService,
        );
      case 2:
        return ReportingScreen(aiService: _aiService);
      case 3:
        return ProfileScreen(
          userProfile: _userProfile,
          onProfileUpdate: _saveUserProfile,
        );
      case 4:
        return const SettingsScreen();
      case 5:
        return const FlowDiagramScreen();
      default:
        return DashboardScreen(
          riskScore: _currentRiskScore,
          userProfile: _userProfile,
          isTracking: _isLocationTracking,
          onToggleTracking: _toggleLocationTracking,
          alertLevel: _currentAlertLevel,
          recommendations: _currentRecommendations,
          aiService: _aiService,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Container(
            width: double.infinity,
            constraints: const BoxConstraints(maxWidth: 448), // max-w-md = 448px
            child: Column(
              children: [
                // Enhanced Header with AI status
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      bottom: BorderSide(
                        color: Color(0x1A000000),
                        width: 1,
                      ),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF030213),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.warning,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'SafeRoute AI',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    'AI-Powered Safety Assistant',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF717182),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          // Enhanced Risk Score Card
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: _getRiskColor().withOpacity(0.3),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: _getRiskColor().withOpacity(0.2),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    color: _getRiskColor(),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Container(
                                      width: 6,
                                      height: 6,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text(
                                      'AI Risk Score',
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Color(0xFF717182),
                                      ),
                                    ),
                                    Text(
                                      '${_currentRiskScore.toStringAsFixed(1)}/10',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: _getRiskColor(),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      // AI Status Indicator
                      if (_isLocationTracking) ...[
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                decoration: const BoxDecoration(
                                  color: Colors.green,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 6),
                              const Text(
                                'AI Processing Active',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.green,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                // Main Content
                Expanded(child: _buildBody()),
                // Enhanced Bottom Navigation
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      top: BorderSide(
                        color: Color(0x1A000000),
                        width: 1,
                      ),
                    ),
                  ),
                  child: SafeArea(
                    top: false,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: GridView.count(
                        shrinkWrap: true,
                        crossAxisCount: 6,
                        mainAxisSpacing: 4,
                        crossAxisSpacing: 4,
                        childAspectRatio: 1.2,
                        children: [
                          _buildNavButton(0, Icons.dashboard_outlined, 'Dashboard'),
                          _buildNavButton(1, Icons.map_outlined, 'AI Map'),
                          _buildNavButton(2, Icons.add, 'Report'),
                          _buildNavButton(3, Icons.person_outline, 'Profile'),
                          _buildNavButton(4, Icons.settings_outlined, 'Settings'),
                          _buildNavButton(5, Icons.description_outlined, 'Flow'),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavButton(int index, IconData icon, String label) {
    final isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF030213) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? Colors.white : const Color(0xFF717182),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: isSelected ? Colors.white : const Color(0xFF717182),
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
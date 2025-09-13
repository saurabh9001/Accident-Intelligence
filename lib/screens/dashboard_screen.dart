import 'package:flutter/material.dart';
import '../models/user_profile.dart';
import '../models/advanced_models.dart' show AlertLevel, AdvancedBlackspot;
import '../services/ai_service.dart';

class DashboardScreen extends StatelessWidget {
  final double riskScore;
  final UserProfile? userProfile;
  final bool isTracking;
  final VoidCallback onToggleTracking;
  final AlertLevel alertLevel;
  final List<String> recommendations;
  final AIService aiService;

  const DashboardScreen({
    super.key,
    required this.riskScore,
    required this.userProfile,
    required this.isTracking,
    required this.onToggleTracking,
    required this.alertLevel,
    required this.recommendations,
    required this.aiService,
  });

  Color _getRiskColor() {
    if (riskScore >= 8) return const Color(0xFFEF4444); // red-500
    if (riskScore >= 5) return const Color(0xFFF59E0B); // yellow-500
    return const Color(0xFF10B981); // green-500
  }

  String _getRiskLevel() {
    if (riskScore >= 8) return 'HIGH RISK';
    if (riskScore >= 5) return 'MEDIUM RISK';
    return 'SAFE';
  }

  String _getRiskMessage() {
    if (riskScore >= 8) {
      return 'Extreme caution advised. Consider alternative route.';
    } else if (riskScore >= 5) {
      return 'Moderate risk detected. Drive carefully.';
    } else {
      return 'Road conditions are favorable. Safe travels!';
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentLocation = aiService.getCurrentLocation();
    final weather = aiService.currentWeather;
    final nearbyBlackspots = currentLocation != null 
        ? aiService.getNearbyBlackspots(currentLocation.latitude, currentLocation.longitude)
        : <AdvancedBlackspot>[];
    
    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // AI Alert Banner
            if (alertLevel == AlertLevel.high) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.warning, color: Colors.red, size: 24),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '🚨 HIGH RISK ALERT',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Colors.red,
                            ),
                          ),
                          Text(
                            'Immediate attention required',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => aiService.triggerEmergencyAlert(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      child: const Text('Emergency', style: TextStyle(fontSize: 12)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Welcome Message
            if (userProfile != null) ...[
              Text(
                'Hello, ${userProfile!.name.split(' ').first}!',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'AI is keeping you safe on the roads',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF717182),
                ),
              ),
            ] else ...[
              const Text(
                'Welcome to SafeRoute AI',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Advanced AI-powered road safety system',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF717182),
                ),
              ),
            ],
            const SizedBox(height: 24),

            // Enhanced Risk Score Card with AI Analysis
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white,
                    _getRiskColor().withOpacity(0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: _getRiskColor().withOpacity(0.2)),
                boxShadow: [
                  BoxShadow(
                    color: _getRiskColor().withOpacity(0.1),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'AI Risk Analysis',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'LIVE',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  
                  // Risk Score Circle with Animation
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 140,
                        height: 140,
                        child: CircularProgressIndicator(
                          value: riskScore / 10.0,
                          strokeWidth: 8,
                          backgroundColor: Colors.grey.shade200,
                          valueColor: AlwaysStoppedAnimation<Color>(_getRiskColor()),
                        ),
                      ),
                      Column(
                        children: [
                          Text(
                            riskScore.toStringAsFixed(1),
                            style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: _getRiskColor(),
                            ),
                          ),
                          Text(
                            '/10',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: _getRiskColor().withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _getRiskLevel(),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: _getRiskColor(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _getRiskMessage(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF717182),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // AI Recommendations Card
            if (recommendations.isNotEmpty) ...[
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.psychology, color: Colors.blue, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'AI Safety Recommendations',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ...recommendations.take(3).map((rec) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              rec,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],

            // Real-time Sensor Data
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.sensors,
                        color: isTracking ? Colors.green : Colors.grey,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'AI Sensor Monitoring',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      Switch(
                        value: isTracking,
                        onChanged: (_) => onToggleTracking(),
                        activeColor: Colors.green,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    isTracking
                        ? 'AI analyzing GPS, accelerometer, gyroscope, and environmental data'
                        : 'Tap to start AI-powered monitoring',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF717182),
                    ),
                  ),
                  if (isTracking && aiService.sensorHistory.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    const Text(
                      'Live Data:',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildSensorDataRow('Location', '${currentLocation?.latitude.toStringAsFixed(6)}, ${currentLocation?.longitude.toStringAsFixed(6)}'),
                    _buildSensorDataRow('Speed', '${aiService.sensorHistory.last.speed.toStringAsFixed(1)} km/h'),
                    _buildSensorDataRow('Direction', '${aiService.sensorHistory.last.direction.toStringAsFixed(0)}°'),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Enhanced Stats with AI Data
            Row(
              children: [
                Expanded(
                  child: _buildAdvancedStatCard(
                    'Maharashtra\nLocation',
                    '${currentLocation?.latitude.toStringAsFixed(4) ?? "17.0906"}°N\n${currentLocation?.longitude.toStringAsFixed(4) ?? "74.4666"}°E',
                    Icons.my_location,
                    Colors.blue,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildAdvancedStatCard(
                    'Nearby\nBlackspots',
                    '${nearbyBlackspots.length}\nDetected',
                    Icons.warning,
                    nearbyBlackspots.isEmpty ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _buildAdvancedStatCard(
                    'Weather\nCondition',
                    '${weather.condition.toUpperCase()}\n${weather.temperature.toStringAsFixed(0)}°C',
                    Icons.wb_sunny,
                    _getWeatherColor(weather.condition),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildAdvancedStatCard(
                    'AI Processing\nStatus',
                    isTracking ? 'ACTIVE\nAnalyzing' : 'STANDBY\nReady',
                    Icons.psychology,
                    isTracking ? Colors.green : Colors.orange,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Enhanced Quick Actions
            const Text(
              'Emergency Actions',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: _buildAdvancedActionButton(
                    'Emergency\nCall',
                    Icons.emergency,
                    Colors.red,
                    () => aiService.triggerEmergencyAlert(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildAdvancedActionButton(
                    'Weather\nUpdate',
                    Icons.cloud_sync,
                    Colors.blue,
                    () => aiService.simulateWeatherChange(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildAdvancedActionButton(
                    'Route\nPlanning',
                    Icons.alt_route,
                    Colors.green,
                    () {
                      // Route planning functionality
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // AI Tips Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF030213),
                    Color(0xFF1a1a2e),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(
                        Icons.auto_awesome,
                        color: Colors.yellow,
                        size: 20,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'AI Safety Insight',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Advanced AI algorithms are continuously analyzing your driving patterns, environmental conditions, and road safety data to provide real-time risk assessment.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(
                        Icons.analytics,
                        color: Colors.blue,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Processing ${aiService.sensorHistory.length}/50 data points',
                        style: TextStyle(
                          fontSize: 12,
                          color: const Color.fromRGBO(255, 255, 255, 0.8),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSensorDataRow(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF717182),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdvancedStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color.fromRGBO(0, 0, 0, 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF717182),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdvancedActionButton(String title, IconData icon, Color color, VoidCallback onTap) {
    final red = (color.r * 255.0).round();
    final green = (color.g * 255.0).round();
    final blue = (color.b * 255.0).round();
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Color.fromRGBO(red, green, blue, 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Color.fromRGBO(red, green, blue, 0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getWeatherColor(String condition) {
    switch (condition.toLowerCase()) {
      case 'clear':
        return const Color(0xFF10B981);
      case 'cloudy':
        return const Color(0xFF3B82F6);
      case 'rain':
        return const Color(0xFF34D399);
      case 'snow':
        return const Color(0xFF60A5FA);
      case 'fog':
        return const Color(0xFF4F46E5);
      default:
        return const Color(0xFF10B981);
    }
  }
}
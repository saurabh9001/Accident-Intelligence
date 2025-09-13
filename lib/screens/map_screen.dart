import 'package:flutter/material.dart';
import '../models/user_profile.dart';
import '../models/blackspot.dart';
import '../services/ai_service.dart';

class MapScreen extends StatefulWidget {
  final UserProfile? userProfile;
  final Function(double) onRiskScoreUpdate;
  final AIService aiService;

  const MapScreen({
    super.key,
    required this.userProfile,
    required this.onRiskScoreUpdate,
    required this.aiService,
  });

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  bool _showTrafficLayer = false;
  bool _showWeatherLayer = false;
  String _selectedFilter = 'all';

  @override
  Widget build(BuildContext context) {
    final weather = widget.aiService.currentWeather;
    // Commented out unused variables to fix lint warnings
    // final blackspots = widget.aiService.blackspots;
    // final currentLocation = widget.aiService.getCurrentLocation();
    
    return Container(
      color: Colors.white, // Match React background
      child: Column(
        children: [
          // Enhanced Map Controls
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              children: [
                Row(
                  children: [
                    const Text(
                      'AI-Enhanced Map',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(76, 175, 80, 0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.location_on,
                            size: 16,
                            color: Colors.green,
                          ),
                          const SizedBox(width: 4),
                          const Text(
                            'Live AI',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.green,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Enhanced Filter Buttons
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterButton('all', 'All Spots'),
                      const SizedBox(width: 8),
                      _buildFilterButton('fatal', 'Fatal Risk', Colors.red),
                      const SizedBox(width: 8),
                      _buildFilterButton('serious', 'Serious Risk', Colors.orange),
                      const SizedBox(width: 8),
                      _buildFilterButton('minor', 'Minor Risk', Colors.green),
                    ],
                  ),
                ),
                
                const SizedBox(height: 12),
                
                // Enhanced Layer Toggles
                Row(
                  children: [
                    _buildLayerToggle(
                      'AI Analysis',
                      Icons.psychology,
                      _showTrafficLayer,
                      (value) => setState(() => _showTrafficLayer = value),
                    ),
                    const SizedBox(width: 16),
                    _buildLayerToggle(
                      'Weather Data',
                      Icons.cloud,
                      _showWeatherLayer,
                      (value) => setState(() => _showWeatherLayer = value),
                    ),
                  ],
                ),
                
                // Weather Info
                if (_showWeatherLayer) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.wb_sunny, color: _getWeatherColor(weather.condition)),
                        const SizedBox(width: 8),
                        Text(
                          '${weather.condition.toUpperCase()} • ${weather.temperature.toStringAsFixed(0)}°C',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          'Risk: ${(weather.riskFactor * 10).toStringAsFixed(1)}/10',
                          style: TextStyle(
                            fontSize: 12,
                            color: _getWeatherColor(weather.condition),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          
          // Map View (Mock)
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF0F8F0),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Stack(
                children: [
                  // Mock Map Background
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.green.shade50,
                          Colors.blue.shade50,
                        ],
                      ),
                    ),
                    child: CustomPaint(
                      painter: MapPainter(),
                    ),
                  ),
                  
                  // Blackspot Markers
                  ..._getFilteredBlackspots().map((spot) => _buildMarker(spot)),
                  
                  // Current Location Marker
                  Positioned(
                    left: 150,
                    top: 200,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3),
                        boxShadow: [
                          BoxShadow(
                            color: const Color.fromRGBO(0, 0, 0, 0.3),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.my_location,
                        size: 12,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  
                  // Map Legend
                  Positioned(
                    top: 16,
                    right: 16,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: const Color.fromRGBO(0, 0, 0, 0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildLegendItem('High Risk', Colors.red),
                          _buildLegendItem('Medium Risk', Colors.orange),
                          _buildLegendItem('Low Risk', Colors.green),
                          _buildLegendItem('Your Location', Colors.blue),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Route Information
          Container(
            margin: const EdgeInsets.all(16),
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
                const Text(
                  'Route Analysis',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildRouteInfo(
                        'Current Route',
                        '2.3 km • 8 min',
                        'Via Pune-Mumbai Highway',
                        Colors.blue,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildRouteInfo(
                        'Safe Alternative',
                        '3.1 km • 12 min',
                        'Via Inner Roads',
                        Colors.green,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton(String filter, String label, [Color? color]) {
    final isSelected = _selectedFilter == filter;
    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = filter),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? (color ?? const Color(0xFF030213))
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? (color ?? const Color(0xFF030213))
                : Colors.grey.shade300,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isSelected ? Colors.white : Colors.grey[700],
            fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildLayerToggle(String label, IconData icon, bool value, Function(bool) onChanged) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: value ? Colors.blue : Colors.grey),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: value ? Colors.blue : Colors.grey,
          ),
        ),
        const SizedBox(width: 4),
        Switch(
          value: value,
          onChanged: onChanged,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      ],
    );
  }

  List<BlackSpot> _getFilteredBlackspots() {
    if (_selectedFilter == 'all') return widget.aiService.blackspots;
    
    BlackSpotSeverity severity;
    switch (_selectedFilter) {
      case 'high':
        severity = BlackSpotSeverity.fatal;
        break;
      case 'medium':
        severity = BlackSpotSeverity.serious;
        break;
      case 'low':
        severity = BlackSpotSeverity.minor;
        break;
      default:
        return widget.aiService.blackspots;
    }
    
    return widget.aiService.blackspots.where((spot) => spot.severity == severity).toList();
  }

  Widget _buildMarker(BlackSpot spot) {
    Color color;
    switch (spot.severity) {
      case BlackSpotSeverity.fatal:
        color = Colors.red;
        break;
      case BlackSpotSeverity.serious:
        color = Colors.orange;
        break;
      case BlackSpotSeverity.minor:
        color = Colors.green;
        break;
    }

    // Mock positions based on coordinates (simplified)
    double left = (spot.longitude - 74.44) * 2000 + 100;
    double top = (17.1 - spot.latitude) * 2000 + 150;

    return Positioned(
      left: left.clamp(20, 300),
      top: top.clamp(50, 400),
      child: GestureDetector(
        onTap: () => _showSpotDetails(spot),
        child: Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
            boxShadow: [
              BoxShadow(
                color: const Color.fromRGBO(0, 0, 0, 0.3),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: const Icon(
            Icons.warning,
            size: 12,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 10),
          ),
        ],
      ),
    );
  }

  Widget _buildRouteInfo(String title, String distance, String via, Color color) {
    final red = (color.r * 255.0).round();
    final green = (color.g * 255.0).round();
    final blue = (color.b * 255.0).round();
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Color.fromRGBO(red, green, blue, 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Color.fromRGBO(red, green, blue, 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            distance,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            via,
            style: const TextStyle(
              fontSize: 10,
              color: Color(0xFF717182),
            ),
          ),
        ],
      ),
    );
  }

  void _showSpotDetails(BlackSpot spot) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: spot.severity == BlackSpotSeverity.fatal
                        ? Colors.red
                        : spot.severity == BlackSpotSeverity.serious
                            ? Colors.orange
                            : Colors.green,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.warning,
                    size: 12,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    spot.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Text(
                  '${spot.riskScore}/10',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              spot.description,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF717182),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.alt_route),
                    label: const Text('Avoid Route'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.info),
                    label: const Text('More Info'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF030213),
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getWeatherColor(String condition) {
    switch (condition) {
      case 'sunny':
        return Colors.yellow;
      case 'cloudy':
        return Colors.grey;
      case 'rainy':
        return Colors.blue;
      case 'snowy':
        return Colors.white;
      default:
        return Colors.grey;
    }
  }
}

class MapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color.fromRGBO(128, 128, 128, 0.3)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // Draw mock roads
    final path = Path();
    path.moveTo(0, size.height * 0.3);
    path.lineTo(size.width, size.height * 0.3);
    path.moveTo(size.width * 0.4, 0);
    path.lineTo(size.width * 0.4, size.height);
    path.moveTo(0, size.height * 0.7);
    path.lineTo(size.width * 0.8, size.height * 0.7);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Using BlackSpot model from blackspot.dart
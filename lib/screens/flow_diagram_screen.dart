import 'package:flutter/material.dart';

class FlowDiagramScreen extends StatelessWidget {
  const FlowDiagramScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white, // Match React background
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            const Center(
              child: Column(
                children: [
                  Text(
                    'AI-Enhanced Road Safety & Blackspot Alert System',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Complete System Architecture & Data Flow',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF717182),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 4),
                  Chip(
                    label: Text(
                      'Flutter Implementation Ready',
                      style: TextStyle(fontSize: 12),
                    ),
                    backgroundColor: Color(0xFFE3F2FD),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Data Sources Section
            _buildSectionHeader('Data Sources & External Systems'),
            const SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(
                  child: _buildDataSourceCard(
                    'Device Sensors',
                    Icons.sensors,
                    Colors.blue,
                    [
                      '• GPS Location',
                      '• Accelerometer',
                      '• Gyroscope',
                      '• Magnetometer',
                      '• Camera'
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildDataSourceCard(
                    'External APIs',
                    Icons.cloud,
                    Colors.green,
                    [
                      '• Weather API',
                      '• Traffic API',
                      '• Roads API',
                      '• Emergency Services',
                      '• Government Data'
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            Row(
              children: [
                Expanded(
                  child: _buildDataSourceCard(
                    'Local Storage',
                    Icons.storage,
                    Colors.purple,
                    [
                      '• User Profile',
                      '• Settings',
                      '• Cached Blackspots',
                      '• Trip History',
                      '• Offline Maps'
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildDataSourceCard(
                    'Real-time Data',
                    Icons.wifi,
                    Colors.orange,
                    [
                      '• Live Traffic',
                      '• Weather Updates',
                      '• Emergency Alerts',
                      '• User Reports',
                      '• Road Conditions'
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // AI Processing Section
            _buildSectionHeader('AI Processing & Analysis Engine'),
            const SizedBox(height: 16),
            
            _buildAIProcessingCard(),

            const SizedBox(height: 24),

            // Application Layer
            _buildSectionHeader('Flutter Mobile Application Layer'),
            const SizedBox(height: 16),
            
            _buildApplicationLayerGrid(),

            const SizedBox(height: 24),

            // Alert System
            _buildSectionHeader('Real-time Alert & Notification System'),
            const SizedBox(height: 16),
            
            Column(
              children: [
                _buildAlertCard(
                  'HIGH RISK ALERT (8-10)',
                  Colors.red,
                  [
                    'Triggers: Fatal blackspot proximity, extreme weather, emergency closures',
                    'Response: Loud audio warning, strong vibration, full-screen overlay, emergency route suggestion'
                  ],
                ),
                const SizedBox(height: 12),
                _buildAlertCard(
                  'MEDIUM RISK ALERT (5-7)',
                  Colors.orange,
                  [
                    'Triggers: Moderate accident areas, heavy traffic, poor visibility, construction zones',
                    'Response: Gentle audio tone, soft vibration, banner notification, speed reduction suggestion'
                  ],
                ),
                const SizedBox(height: 12),
                _buildAlertCard(
                  'SAFE ZONE (0-4)',
                  Colors.green,
                  [
                    'Indicators: Well-maintained roads, good weather, low traffic, no recent incidents',
                    'Feedback: Green status, encouraging messages, optimal route confirmation'
                  ],
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Data Flow Process
            _buildSectionHeader('Complete Data Flow Process'),
            const SizedBox(height: 16),
            
            _buildDataFlowCard(),

            const SizedBox(height: 24),

            // Flutter Implementation
            _buildSectionHeader('Flutter Implementation Guidelines'),
            const SizedBox(height: 16),
            
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _buildImplementationCard(
                    'Key Flutter Packages Required',
                    [
                      'Location Services: geolocator, location',
                      'Maps Integration: google_maps_flutter',
                      'Sensors: sensors_plus',
                      'Notifications: flutter_local_notifications',
                      'HTTP Requests: dio, http',
                      'State Management: provider, bloc',
                      'Local Storage: shared_preferences, hive',
                      'Camera/Media: image_picker, camera'
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildImplementationCard(
                    'Architecture Considerations',
                    [
                      'State Management: Use BLoC or Provider for complex state management',
                      'Background Processing: Implement background location tracking with battery optimization',
                      'Offline Capability: Cache critical safety data locally with smart sync',
                      'Performance: Optimize map rendering, implement lazy loading for blackspot data'
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Footer
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Colors.grey.shade300,
                  ),
                ),
              ),
              child: const Column(
                children: [
                  Text(
                    'Complete System Flow for AI-Enhanced Road Safety & Blackspot Alert System',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF717182),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Focus Area: Maharashtra, India (17.0906743,74.4666604 to 17.097643°N, 74.449632°E)',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF717182),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8),
                  Chip(
                    label: Text(
                      'Ready for Flutter Implementation',
                      style: TextStyle(fontSize: 12),
                    ),
                    backgroundColor: Color(0xFFE8F5E8),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildDataSourceCard(String title, IconData icon, Color color, List<String> items) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
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
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...items.map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(
              item,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF717182),
              ),
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildAIProcessingCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.psychology, color: Colors.red, size: 24),
              SizedBox(width: 12),
              Text(
                'Risk Assessment AI',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          Row(
            children: [
              Expanded(
                child: _buildProcessingStep(
                  'Input Processing',
                  [
                    '→ Current Location (17.0906743,74.4666604)',
                    '→ Speed & Direction',
                    '→ Weather Conditions',
                    '→ Time of Day',
                    '→ Driver Profile'
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildProcessingStep(
                  'AI Analysis',
                  [
                    '→ Blackspot Proximity',
                    '→ Weather Risk Factor',
                    '→ Traffic Density',
                    '→ Driver Behavior Pattern',
                    '→ Historical Accident Data'
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildProcessingStep(
                  'Output Generation',
                  [
                    '→ Dynamic Risk Score (0-10)',
                    '→ Alert Level (Green/Yellow/Red)',
                    '→ Safety Recommendations',
                    '→ Route Suggestions'
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProcessingStep(String title, List<String> items) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          ...items.map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 2),
            child: Text(
              item,
              style: const TextStyle(
                fontSize: 10,
                color: Color(0xFF717182),
              ),
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildApplicationLayerGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.2,
      children: [
        _buildAppLayerCard('Dashboard', Icons.dashboard, Colors.blue, [
          '• Live Risk Score',
          '• Current Location',
          '• Speed & Direction',
          '• Weather Conditions',
          '• Quick Actions'
        ]),
        _buildAppLayerCard('Interactive Map', Icons.map, Colors.green, [
          '• Color-coded Blackspots',
          '• Real-time Location',
          '• Route Planning',
          '• Traffic Overlay',
          '• Tap for Details'
        ]),
        _buildAppLayerCard('Profile Setup', Icons.person, Colors.purple, [
          '• Driver Experience',
          '• Vehicle Type',
          '• Risk Preferences',
          '• Emergency Contacts',
          '• Alert Sensitivity'
        ]),
        _buildAppLayerCard('User Reporting', Icons.add_circle, Colors.orange, [
          '• Incident Types',
          '• Photo/Video Capture',
          '• GPS Auto-capture',
          '• Severity Assessment',
          '• Real-time Submission'
        ]),
      ],
    );
  }

  Widget _buildAppLayerCard(String title, IconData icon, Color color, List<String> features) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
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
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: features.map((feature) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  feature,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Color(0xFF717182),
                  ),
                ),
              )).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlertCard(String title, Color color, List<String> details) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
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
              Icon(Icons.warning, color: color, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...details.map((detail) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              detail,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF717182),
              ),
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildDataFlowCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          colors: [Colors.blue.shade50, Colors.purple.shade50],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildFlowStep('Data\nCollection', Icons.storage, Colors.blue),
              const Icon(Icons.arrow_forward, color: Colors.grey),
              _buildFlowStep('AI\nProcessing', Icons.psychology, Colors.purple),
              const Icon(Icons.arrow_forward, color: Colors.grey),
              _buildFlowStep('Risk\nCalculation', Icons.calculate, Colors.orange),
              const Icon(Icons.arrow_forward, color: Colors.grey),
              _buildFlowStep('Alert\nGeneration', Icons.notifications, Colors.red),
              const Icon(Icons.arrow_forward, color: Colors.grey),
              _buildFlowStep('User\nAction', Icons.shield, Colors.green),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            '→ Real-time Continuous Loop → Adaptive Learning → Improved Accuracy',
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF717182),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFlowStep(String label, IconData icon, Color color) {
    return Column(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
            border: Border.all(color: color),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildImplementationCard(String title, List<String> items) {
    return Container(
      padding: const EdgeInsets.all(16),
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
              const Icon(Icons.code, color: Color(0xFF030213), size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...items.map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              '• $item',
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF717182),
              ),
            ),
          )),
        ],
      ),
    );
  }
}
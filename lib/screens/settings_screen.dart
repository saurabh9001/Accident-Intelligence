import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;
  bool _locationServices = true;
  bool _backgroundLocation = true;
  bool _dataCollection = true;
  bool _shareUsageData = false;
  double _alertFrequency = 5.0;
  String _language = 'English';
  String _units = 'Metric';
  String _theme = 'Light';

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _notificationsEnabled = prefs.getBool('notifications_enabled') ?? true;
      _soundEnabled = prefs.getBool('sound_enabled') ?? true;
      _vibrationEnabled = prefs.getBool('vibration_enabled') ?? true;
      _locationServices = prefs.getBool('location_services') ?? true;
      _backgroundLocation = prefs.getBool('background_location') ?? true;
      _dataCollection = prefs.getBool('data_collection') ?? true;
      _shareUsageData = prefs.getBool('share_usage_data') ?? false;
      _alertFrequency = prefs.getDouble('alert_frequency') ?? 5.0;
      _language = prefs.getString('language') ?? 'English';
      _units = prefs.getString('units') ?? 'Metric';
      _theme = prefs.getString('theme') ?? 'Light';
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications_enabled', _notificationsEnabled);
    await prefs.setBool('sound_enabled', _soundEnabled);
    await prefs.setBool('vibration_enabled', _vibrationEnabled);
    await prefs.setBool('location_services', _locationServices);
    await prefs.setBool('background_location', _backgroundLocation);
    await prefs.setBool('data_collection', _dataCollection);
    await prefs.setBool('share_usage_data', _shareUsageData);
    await prefs.setDouble('alert_frequency', _alertFrequency);
    await prefs.setString('language', _language);
    await prefs.setString('units', _units);
    await prefs.setString('theme', _theme);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Settings saved successfully!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showResetDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Settings'),
        content: const Text(
          'Are you sure you want to reset all settings to their default values? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _resetSettings();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }

  Future<void> _resetSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    
    setState(() {
      _notificationsEnabled = true;
      _soundEnabled = true;
      _vibrationEnabled = true;
      _locationServices = true;
      _backgroundLocation = true;
      _dataCollection = true;
      _shareUsageData = false;
      _alertFrequency = 5.0;
      _language = 'English';
      _units = 'Metric';
      _theme = 'Light';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Settings reset to defaults'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white, // Match React background
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Settings',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Customize your SafeRoute AI experience',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF717182),
              ),
            ),
            const SizedBox(height: 24),

            // Notification Settings
            _buildSectionHeader('Notifications'),
            const SizedBox(height: 16),
            _buildCard([
              _buildSwitchTile(
                title: 'Enable Notifications',
                subtitle: 'Receive safety alerts and updates',
                value: _notificationsEnabled,
                onChanged: (value) {
                  setState(() => _notificationsEnabled = value);
                  _saveSettings();
                },
              ),
              const Divider(),
              _buildSwitchTile(
                title: 'Sound Alerts',
                subtitle: 'Play audio for high-priority alerts',
                value: _soundEnabled,
                onChanged: _notificationsEnabled
                    ? (value) {
                        setState(() => _soundEnabled = value);
                        _saveSettings();
                      }
                    : null,
              ),
              const Divider(),
              _buildSwitchTile(
                title: 'Vibration Alerts',
                subtitle: 'Vibrate device for important notifications',
                value: _vibrationEnabled,
                onChanged: _notificationsEnabled
                    ? (value) {
                        setState(() => _vibrationEnabled = value);
                        _saveSettings();
                      }
                    : null,
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Alert Frequency: ${_alertFrequency.toStringAsFixed(1)}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'How often to show safety alerts (1=Less, 10=More)',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF717182),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Slider(
                      value: _alertFrequency,
                      min: 1.0,
                      max: 10.0,
                      divisions: 9,
                      label: _alertFrequency.toStringAsFixed(1),
                      onChanged: _notificationsEnabled
                          ? (value) => setState(() => _alertFrequency = value)
                          : null,
                      onChangeEnd: (value) => _saveSettings(),
                      activeColor: const Color(0xFF030213),
                    ),
                  ],
                ),
              ),
            ]),

            const SizedBox(height: 24),

            // Location Settings
            _buildSectionHeader('Location & Privacy'),
            const SizedBox(height: 16),
            _buildCard([
              _buildSwitchTile(
                title: 'Location Services',
                subtitle: 'Allow app to access your location',
                value: _locationServices,
                onChanged: (value) {
                  setState(() => _locationServices = value);
                  if (!value) {
                    setState(() => _backgroundLocation = false);
                  }
                  _saveSettings();
                },
              ),
              const Divider(),
              _buildSwitchTile(
                title: 'Background Location',
                subtitle: 'Continue tracking when app is closed',
                value: _backgroundLocation,
                onChanged: _locationServices
                    ? (value) {
                        setState(() => _backgroundLocation = value);
                        _saveSettings();
                      }
                    : null,
              ),
              const Divider(),
              _buildSwitchTile(
                title: 'Anonymized Data Collection',
                subtitle: 'Help improve safety algorithms',
                value: _dataCollection,
                onChanged: (value) {
                  setState(() => _dataCollection = value);
                  _saveSettings();
                },
              ),
              const Divider(),
              _buildSwitchTile(
                title: 'Share Usage Analytics',
                subtitle: 'Share anonymous usage statistics',
                value: _shareUsageData,
                onChanged: (value) {
                  setState(() => _shareUsageData = value);
                  _saveSettings();
                },
              ),
            ]),

            const SizedBox(height: 24),

            // App Preferences
            _buildSectionHeader('App Preferences'),
            const SizedBox(height: 16),
            _buildCard([
              _buildDropdownTile(
                title: 'Language',
                subtitle: 'Choose your preferred language',
                value: _language,
                items: ['English', 'Hindi', 'Marathi', 'Spanish', 'French'],
                onChanged: (value) {
                  setState(() => _language = value!);
                  _saveSettings();
                },
              ),
              const Divider(),
              _buildDropdownTile(
                title: 'Units',
                subtitle: 'Distance and speed units',
                value: _units,
                items: ['Metric', 'Imperial'],
                onChanged: (value) {
                  setState(() => _units = value!);
                  _saveSettings();
                },
              ),
              const Divider(),
              _buildDropdownTile(
                title: 'Theme',
                subtitle: 'App appearance',
                value: _theme,
                items: ['Light', 'Dark', 'Auto'],
                onChanged: (value) {
                  setState(() => _theme = value!);
                  _saveSettings();
                },
              ),
            ]),

            const SizedBox(height: 24),

            // Data Management
            _buildSectionHeader('Data Management'),
            const SizedBox(height: 16),
            _buildCard([
              _buildActionTile(
                title: 'Clear Cache',
                subtitle: 'Free up storage space',
                icon: Icons.clear_all,
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Cache cleared successfully'),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
              ),
              const Divider(),
              _buildActionTile(
                title: 'Export Data',
                subtitle: 'Download your safety reports',
                icon: Icons.download,
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Data export started'),
                      backgroundColor: Colors.blue,
                    ),
                  );
                },
              ),
              const Divider(),
              _buildActionTile(
                title: 'Reset Settings',
                subtitle: 'Restore default settings',
                icon: Icons.restore,
                color: Colors.orange,
                onTap: _showResetDialog,
              ),
            ]),

            const SizedBox(height: 24),

            // About Section
            _buildSectionHeader('About'),
            const SizedBox(height: 16),
            _buildCard([
              _buildInfoTile(
                title: 'App Version',
                subtitle: '1.0.0 (Build 100)',
                icon: Icons.info,
              ),
              const Divider(),
              _buildActionTile(
                title: 'Privacy Policy',
                subtitle: 'Read our privacy policy',
                icon: Icons.privacy_tip,
                onTap: () {
                  // Open privacy policy
                },
              ),
              const Divider(),
              _buildActionTile(
                title: 'Terms of Service',
                subtitle: 'View terms and conditions',
                icon: Icons.description,
                onTap: () {
                  // Open terms of service
                },
              ),
              const Divider(),
              _buildActionTile(
                title: 'Contact Support',
                subtitle: 'Get help with the app',
                icon: Icons.support,
                onTap: () {
                  // Open support contact
                },
              ),
            ]),

            const SizedBox(height: 24),

            // Emergency Section
            _buildCard([
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.emergency,
                      color: Colors.red.shade600,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Emergency Services',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            'Quick access to emergency contacts',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF717182),
                            ),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Show emergency contacts
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Emergency Contacts'),
                            content: const Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ListTile(
                                  leading: Icon(Icons.local_police),
                                  title: Text('Police: 100'),
                                ),
                                ListTile(
                                  leading: Icon(Icons.local_hospital),
                                  title: Text('Ambulance: 108'),
                                ),
                                ListTile(
                                  leading: Icon(Icons.fire_truck),
                                  title: Text('Fire: 101'),
                                ),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text('Close'),
                              ),
                            ],
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Emergency'),
                    ),
                  ],
                ),
              ),
            ]),
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

  Widget _buildCard(List<Widget> children) {
    return Container(
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
      child: Column(children: children),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool)? onChanged,
  }) {
    return SwitchListTile(
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: onChanged == null ? Colors.grey : null,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 14,
          color: onChanged == null ? Colors.grey : const Color(0xFF717182),
        ),
      ),
      value: value,
      onChanged: onChanged,
      activeColor: const Color(0xFF030213),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
    );
  }

  Widget _buildDropdownTile({
    required String title,
    required String subtitle,
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          fontSize: 14,
          color: Color(0xFF717182),
        ),
      ),
      trailing: DropdownButton<String>(
        value: value,
        items: items.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item),
          );
        }).toList(),
        onChanged: onChanged,
        underline: Container(),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
    );
  }

  Widget _buildActionTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
    Color? color,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: color ?? const Color(0xFF030213),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: color,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          fontSize: 14,
          color: Color(0xFF717182),
        ),
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
    );
  }

  Widget _buildInfoTile({
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: const Color(0xFF030213),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          fontSize: 14,
          color: Color(0xFF717182),
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
    );
  }
}
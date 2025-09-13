import 'package:flutter/material.dart';
import '../models/user_profile.dart';

class ProfileScreen extends StatefulWidget {
  final UserProfile? userProfile;
  final Function(UserProfile) onProfileUpdate;

  const ProfileScreen({
    super.key,
    required this.userProfile,
    required this.onProfileUpdate,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emergencyContactController = TextEditingController();
  final _emergencyContactNameController = TextEditingController();

  String _selectedExperience = 'intermediate';
  String _selectedVehicleType = 'car';
  String _selectedRoutePreference = 'balanced';
  bool _enableSoundAlerts = true;
  bool _enableVibrationAlerts = true;
  double _alertSensitivity = 7.0;

  final List<String> _experienceOptions = [
    'beginner',
    'intermediate',
    'experienced',
    'professional'
  ];

  final List<String> _vehicleOptions = [
    'two_wheeler',
    'car',
    'suv',
    'truck',
    'bus'
  ];

  final List<String> _routePreferences = [
    'fastest',
    'safest',
    'balanced',
    'scenic'
  ];

  @override
  void initState() {
    super.initState();
    if (widget.userProfile != null) {
      _loadExistingProfile();
    }
  }

  void _loadExistingProfile() {
    final profile = widget.userProfile!;
    _nameController.text = profile.name;
    _emailController.text = profile.email;
    _phoneController.text = profile.phone;
    _emergencyContactController.text = profile.emergencyContact;
    _emergencyContactNameController.text = profile.emergencyContactName;
    _selectedExperience = profile.driverExperience;
    _selectedVehicleType = profile.vehicleType;
    _selectedRoutePreference = profile.routePreference;
    _enableSoundAlerts = profile.enableSoundAlerts;
    _enableVibrationAlerts = profile.enableVibrationAlerts;
    _alertSensitivity = profile.alertSensitivity;
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      final profile = UserProfile(
        name: _nameController.text,
        email: _emailController.text,
        phone: _phoneController.text,
        emergencyContact: _emergencyContactController.text,
        emergencyContactName: _emergencyContactNameController.text,
        driverExperience: _selectedExperience,
        vehicleType: _selectedVehicleType,
        routePreference: _selectedRoutePreference,
        enableSoundAlerts: _enableSoundAlerts,
        enableVibrationAlerts: _enableVibrationAlerts,
        alertSensitivity: _alertSensitivity,
      );

      widget.onProfileUpdate(profile);
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile saved successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Profile Setup',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Personalize your safety experience',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF717182),
                ),
              ),
              const SizedBox(height: 24),

              // Personal Information Section
              _buildSectionHeader('Personal Information'),
              const SizedBox(height: 16),
              
              _buildCard([
                _buildTextField(
                  controller: _nameController,
                  label: 'Full Name',
                  icon: Icons.person,
                  validator: (value) =>
                      value?.isEmpty == true ? 'Name is required' : null,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _emailController,
                  label: 'Email Address',
                  icon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value?.isEmpty == true) return 'Email is required';
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                        .hasMatch(value!)) {
                      return 'Enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _phoneController,
                  label: 'Phone Number',
                  icon: Icons.phone,
                  keyboardType: TextInputType.phone,
                  validator: (value) =>
                      value?.isEmpty == true ? 'Phone number is required' : null,
                ),
              ]),

              const SizedBox(height: 24),

              // Emergency Contact Section
              _buildSectionHeader('Emergency Contact'),
              const SizedBox(height: 16),
              
              _buildCard([
                _buildTextField(
                  controller: _emergencyContactNameController,
                  label: 'Emergency Contact Name',
                  icon: Icons.contact_emergency,
                  validator: (value) =>
                      value?.isEmpty == true ? 'Contact name is required' : null,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _emergencyContactController,
                  label: 'Emergency Contact Number',
                  icon: Icons.phone_callback,
                  keyboardType: TextInputType.phone,
                  validator: (value) =>
                      value?.isEmpty == true ? 'Contact number is required' : null,
                ),
              ]),

              const SizedBox(height: 24),

              // Driver Profile Section
              _buildSectionHeader('Driver Profile'),
              const SizedBox(height: 16),
              
              _buildCard([
                _buildDropdown(
                  label: 'Driving Experience',
                  value: _selectedExperience,
                  items: _experienceOptions,
                  onChanged: (value) => setState(() => _selectedExperience = value!),
                  getDisplayText: (value) => value.replaceAll('_', ' ').toUpperCase(),
                ),
                const SizedBox(height: 16),
                _buildDropdown(
                  label: 'Vehicle Type',
                  value: _selectedVehicleType,
                  items: _vehicleOptions,
                  onChanged: (value) => setState(() => _selectedVehicleType = value!),
                  getDisplayText: (value) => value.replaceAll('_', ' ').toUpperCase(),
                ),
                const SizedBox(height: 16),
                _buildDropdown(
                  label: 'Route Preference',
                  value: _selectedRoutePreference,
                  items: _routePreferences,
                  onChanged: (value) => setState(() => _selectedRoutePreference = value!),
                  getDisplayText: (value) => value.toUpperCase(),
                ),
              ]),

              const SizedBox(height: 24),

              // Alert Preferences Section
              _buildSectionHeader('Alert Preferences'),
              const SizedBox(height: 16),
              
              _buildCard([
                _buildSwitchTile(
                  title: 'Sound Alerts',
                  subtitle: 'Enable audio notifications for safety alerts',
                  value: _enableSoundAlerts,
                  onChanged: (value) => setState(() => _enableSoundAlerts = value),
                ),
                const Divider(),
                _buildSwitchTile(
                  title: 'Vibration Alerts',
                  subtitle: 'Enable vibration for safety notifications',
                  value: _enableVibrationAlerts,
                  onChanged: (value) => setState(() => _enableVibrationAlerts = value),
                ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Alert Sensitivity: ${_alertSensitivity.toStringAsFixed(1)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Higher values trigger alerts more frequently',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF717182),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Slider(
                        value: _alertSensitivity,
                        min: 1.0,
                        max: 10.0,
                        divisions: 9,
                        label: _alertSensitivity.toStringAsFixed(1),
                        onChanged: (value) => setState(() => _alertSensitivity = value),
                        activeColor: const Color(0xFF030213),
                      ),
                    ],
                  ),
                ),
              ]),

              const SizedBox(height: 32),

              // Save Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF030213),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Save Profile',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Profile Completion Status
              _buildCard([
                Row(
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Profile Completion',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            'Complete your profile for better safety recommendations',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF717182),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '${_getProfileCompletionPercentage()}%',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ]),
            ],
          ),
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
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: children),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0x1A000000)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0x1A000000)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF030213)),
        ),
        filled: true,
        fillColor: const Color(0xFFF3F3F5),
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
    required String Function(String) getDisplayText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(getDisplayText(item)),
            );
          }).toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0x1A000000)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0x1A000000)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF030213)),
            ),
            filled: true,
            fillColor: const Color(0xFFF3F3F5),
          ),
        ),
      ],
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return SwitchListTile(
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
      value: value,
      onChanged: onChanged,
      activeColor: const Color(0xFF030213),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
    );
  }

  int _getProfileCompletionPercentage() {
    int completedFields = 0;
    const int totalFields = 8;

    if (_nameController.text.isNotEmpty) completedFields++;
    if (_emailController.text.isNotEmpty) completedFields++;
    if (_phoneController.text.isNotEmpty) completedFields++;
    if (_emergencyContactController.text.isNotEmpty) completedFields++;
    if (_emergencyContactNameController.text.isNotEmpty) completedFields++;
    if (_selectedExperience.isNotEmpty) completedFields++;
    if (_selectedVehicleType.isNotEmpty) completedFields++;
    if (_selectedRoutePreference.isNotEmpty) completedFields++;

    return ((completedFields / totalFields) * 100).round();
  }
}
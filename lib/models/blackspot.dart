// Base blackspot models
enum BlackSpotSeverity { 
  // High risk levels
  fatal,    // maps to high
  serious,  // maps to medium
  minor     // maps to low
}

enum BlackSpotType { junction, highway, urban, construction, school }

class BlackSpot {
  final String id;
  final double latitude;
  final double longitude;
  final BlackSpotSeverity severity;
  final String title;
  final String description;
  final double riskScore;

  BlackSpot({
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.severity,
    required this.title,
    required this.description,
    required this.riskScore,
  });
}
class PositionData {
  final double latitude;
  final double longitude;
  final int time;
  final double distance;
  final double accuracy;
  final double speedAccuracy;
  final double currentSpeed;

  PositionData({
    required this.latitude,
    required this.longitude,
    required this.time,
    required this.distance,
    required this.accuracy,
    required this.speedAccuracy,
    required this.currentSpeed,
  });


  Map<String, dynamic> toJson() => {
    'latitude': latitude,
    'longitude': longitude,
    'timestamp': time,
    'accuracy': accuracy,
    'speedAccuracy': speedAccuracy,
    'currentSpeed': currentSpeed,
  };
}
// running_interval.dart
class RunningIntervalData {
  final int? id; // null for new intervals before insertion
  //final String planName;
  final String name;
  final int duration;
  final bool isDurationInSeconds;
  final int pace;

  RunningIntervalData({
    this.id,
    //required this.planName,
    required this.name,
    required this.duration,
    required this.isDurationInSeconds,
    required this.pace,
  });

  factory RunningIntervalData.fromJson(Map<String, dynamic> json) => RunningIntervalData(
    id: json['id'],
    //planName: json['planName'],
    name: json['name'],
    duration: json['duration'],
    isDurationInSeconds: json['isDurationInSeconds'],
    pace: json['pace'],
  );

  Map<String, dynamic> toJson() => {
    if (id != null) 'id': id,
    //'planName': planName,
    'name': name,
    'duration': duration,
    'isDurationInSeconds': isDurationInSeconds,
    'pace': pace,
  };
}

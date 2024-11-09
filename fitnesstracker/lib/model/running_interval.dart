class RunningInterval {
  String name;
  int duration; // Either in seconds or meters
  bool isDurationInSeconds;
  int pace; // in seconds

  RunningInterval({
    required this.name,
    required this.duration,
    required this.isDurationInSeconds,
    required this.pace,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'duration': duration,
    'isDurationInSeconds': isDurationInSeconds,
    'pace': pace,
  };
}


class StringFormatter {
  static String NONE_PACE = "--:--";
  static String NONE_DURATION = "--:--:--";
  static String NONE_DISTANCE = "--";
  static String distanceUnit = "km";
  static String speedUnit = "km/h";
  static String paceUnit = "min/km";
  static String durationUnit = "hh:mm:ss";

  static String formatDuration(int totalSeconds) {
    /**
     * Format duration in hh:mm:ss from duration in seconds.
     */
    int hours = totalSeconds ~/ 3600;
    int minutes = (totalSeconds % 3600) ~/ 60;
    int seconds = totalSeconds % 60;
    return [if (hours > 0) hours, minutes, seconds]
        .map((e) => e.toString().padLeft(2, '0'))
        .join(':');
  }

  static String formatPaceFromSpeed(double speed) {
    if (speed != 0) {
      return formatDuration((1000 / speed).floor());
    } else {
      return NONE_PACE;
    }
  }

  static String formatPace(double distance, int time) {
    if (distance > 0 && time > 0) {
      return "${formatDuration((time / distance * 1000).floor())} $paceUnit";
    } else {
      return NONE_PACE;
    }
  }

  static String getNonePace() {
    return NONE_PACE;
  }
}

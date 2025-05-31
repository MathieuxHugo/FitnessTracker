class StringFormatter {
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

  static String formatPace(double speed) {
    /**
     * Format speed to mm:ss from speed in m/s
     */
    if (speed != 0) {
      return formatDuration((1000 / speed).floor());
    } else {
      return "--:--";
    }
  }

  static String getNonePace() {
    return "--:--";
  }
}

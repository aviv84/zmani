import 'dart:math';

class PrayerTimesUtils {
  // Jerusalem coordinates (default)
  static double latitude = 31.7683;
  static double longitude = 35.2137;
  
  static Map<String, String> calculatePrayerTimes([DateTime? date]) {
    date ??= DateTime.now();
    
    final sunrise = _calculateSunrise(date);
    final sunset = _calculateSunset(date);
    
    // Calculate prayer times based on sunrise/sunset
    final sunriseTime = _formatTime(sunrise);
    final sunsetTime = _formatTime(sunset);
    
    // Approximate times (in a real app, use proper calculation)
    final shachrit = _addMinutes(sunrise, 30);
    final mincha = _subtractMinutes(sunset, 30);
    final minchaGedola = _addMinutes(_noon(date), 30);
    final maariv = _addMinutes(sunset, 25);
    
    return {
      'sunrise': sunriseTime,
      'sunset': sunsetTime,
      'shachrit': _formatTime(shachrit),
      'mincha': _formatTime(mincha),
      'mincha2': _formatTime(minchaGedola),
      'maariv': _formatTime(maariv),
    };
  }
  
  static DateTime _calculateSunrise(DateTime date) {
    // Simplified sunrise calculation (approximate)
    final dayOfYear = date.difference(DateTime(date.year, 1, 1)).inDays + 1;
    final solarNoon = 12.0;
    final declination = 23.45 * sin((2 * pi * (284 + dayOfYear)) / 365);
    final hourAngle = acos(-tan(latitude * pi / 180) * tan(declination * pi / 180));
    final sunrise = solarNoon - (hourAngle * 12 / pi);
    
    final hour = sunrise.floor();
    final minute = ((sunrise - hour) * 60).floor();
    
    return DateTime(date.year, date.month, date.day, hour, minute);
  }
  
  static DateTime _calculateSunset(DateTime date) {
    // Simplified sunset calculation (approximate)
    final dayOfYear = date.difference(DateTime(date.year, 1, 1)).inDays + 1;
    final solarNoon = 12.0;
    final declination = 23.45 * sin((2 * pi * (284 + dayOfYear)) / 365);
    final hourAngle = acos(-tan(latitude * pi / 180) * tan(declination * pi / 180));
    final sunset = solarNoon + (hourAngle * 12 / pi);
    
    final hour = sunset.floor();
    final minute = ((sunset - hour) * 60).floor();
    
    return DateTime(date.year, date.month, date.day, hour, minute);
  }
  
  static DateTime _noon(DateTime date) {
    return DateTime(date.year, date.month, date.day, 12, 0);
  }
  
  static DateTime _addMinutes(DateTime time, int minutes) {
    return time.add(Duration(minutes: minutes));
  }
  
  static DateTime _subtractMinutes(DateTime time, int minutes) {
    return time.subtract(Duration(minutes: minutes));
  }
  
  static String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
  
  static void setLocation(double lat, double lng) {
    latitude = lat;
    longitude = lng;
  }
}
import 'dart:convert';
import 'package:http/http.dart' as http;

class PrayerTimesService {
  static const String _baseUrl = 'https://www.hebcal.com/zmanim';
  
  // Default to Jerusalem coordinates
  static double latitude = 31.7683;
  static double longitude = 35.2137;
  static String cityName = 'Jerusalem';
  
  static Future<Map<String, String>> getCurrentPrayerTimes() async {
    try {
      final now = DateTime.now();
      final url = Uri.parse(
        '$_baseUrl?cfg=json&geonameid=281184&date=${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}'
      );
      
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final times = data['times'] as Map<String, dynamic>? ?? {};
        
        return {
          'sunrise': _formatTime(times['sunrise']) ?? '06:00',
          'sunset': _formatTime(times['sunset']) ?? '18:00',
          'shachrit': _formatTime(times['sunrise']) ?? '06:30',
          'mincha': _formatTime(times['mincha']) ?? '17:30',
          'mincha2': _formatTime(times['minchaGedola']) ?? '13:00',
          'maariv': _formatTime(times['tzeit']) ?? '19:30',
        };
      }
    } catch (e) {
      print('Error fetching prayer times: $e');
    }
    
    // Fallback to approximate times
    return _getApproximateTimes();
  }
  
  static String? _formatTime(dynamic timeString) {
    if (timeString == null) return null;
    
    try {
      final time = DateTime.parse(timeString.toString());
      return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return null;
    }
  }
  
  static Map<String, String> _getApproximateTimes() {
    final now = DateTime.now();
    
    // Very basic approximation based on season
    final month = now.month;
    String sunrise, sunset;
    
    if (month >= 4 && month <= 9) {
      // Summer months
      sunrise = '05:30';
      sunset = '19:30';
    } else {
      // Winter months  
      sunrise = '06:30';
      sunset = '17:00';
    }
    
    return {
      'sunrise': sunrise,
      'sunset': sunset,
      'shachrit': _addMinutesToTime(sunrise, 15),
      'mincha': _subtractMinutesFromTime(sunset, 30),
      'mincha2': '13:00',
      'maariv': _addMinutesToTime(sunset, 25),
    };
  }
  
  static String _addMinutesToTime(String time, int minutes) {
    final parts = time.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    
    final newMinute = minute + minutes;
    final newHour = hour + (newMinute ~/ 60);
    
    return '${(newHour % 24).toString().padLeft(2, '0')}:${(newMinute % 60).toString().padLeft(2, '0')}';
  }
  
  static String _subtractMinutesFromTime(String time, int minutes) {
    final parts = time.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    
    var newMinute = minute - minutes;
    var newHour = hour;
    
    if (newMinute < 0) {
      newMinute += 60;
      newHour -= 1;
    }
    
    if (newHour < 0) newHour += 24;
    
    return '${newHour.toString().padLeft(2, '0')}:${newMinute.toString().padLeft(2, '0')}';
  }
  
  static void setLocation(double lat, double lng, String city) {
    latitude = lat;
    longitude = lng;
    cityName = city;
  }
}
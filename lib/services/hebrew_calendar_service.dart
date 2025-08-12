import 'dart:convert';
import 'package:http/http.dart' as http;

class HebrewCalendarService {
  static const String _baseUrl = 'https://www.hebcal.com/converter';
  static const String _hebrewDateUrl = 'https://www.hebcal.com/hebcal';
  
  static Future<Map<String, dynamic>?> getCurrentHebrewDate() async {
    try {
      final now = DateTime.now();
      print('Current date for Hebrew conversion: ${now.year}-${now.month}-${now.day}');
      final url = Uri.parse('$_baseUrl?cfg=json&gy=${now.year}&gm=${now.month}&gd=${now.day}&g2h=1');
      
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'day': data['hd'].toString(),
          'month': data['hm'],
          'year': data['hy'].toString(),
          'fullDate': '${data['hd']} ${data['hm']} ${data['hy']}',
          'hebrew': data['hebrew'] ?? '',
        };
      }
    } catch (e) {
      print('Error fetching Hebrew date: $e');
    }
    
    // Fallback to current Gregorian date display
    final now = DateTime.now();
    return {
      'day': now.day.toString(),
      'month': _getHebrewMonthName(now.month),
      'year': now.year.toString(),
      'fullDate': '${now.day} ${_getHebrewMonthName(now.month)} ${now.year}',
      'hebrew': '',
    };
  }
  
  static Future<String> getCurrentParasha() async {
    try {
      final now = DateTime.now();
      final url = Uri.parse('$_hebrewDateUrl?cfg=json&year=${now.year}&month=${now.month}&ss=on');
      
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final items = data['items'] as List?;
        
        if (items != null) {
          for (final item in items) {
            if (item['category'] == 'parashat') {
              return 'פרשת ${item['hebrew'] ?? item['title']}';
            }
          }
        }
      }
    } catch (e) {
      print('Error fetching parasha: $e');
    }
    
    return 'פרשת השבוע'; // Fallback
  }
  
  static String _getHebrewMonthName(int month) {
    const months = {
      1: 'ינואר', 2: 'פברואר', 3: 'מרץ', 4: 'אפריל',
      5: 'מאי', 6: 'יוני', 7: 'יולי', 8: 'אוגוסט',
      9: 'ספטמבר', 10: 'אוקטובר', 11: 'נובמבר', 12: 'דצמבר'
    };
    return months[month] ?? '';
  }
}
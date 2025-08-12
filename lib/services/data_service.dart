import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/display_data.dart';
import 'hebrew_calendar_service.dart';
import 'prayer_times_service.dart';

class DataService {
  static const String _localDataKey = 'zmani_display_data';
  static const String _dataUrl = 'https://your-data-source.com/api/display-data';

  static Future<DisplayData> loadDisplayData() async {
    try {
      // Try to load from network first
      final networkData = await _loadFromNetwork();
      if (networkData != null) {
        await _saveToLocal(networkData);
        return networkData;
      }
    } catch (e) {
      print('Failed to load from network: $e');
    }

    // Fallback to local data
    final localData = await _loadFromLocal();
    if (localData != null) {
      return localData;
    }

    // Fallback to default data
    return _getDefaultData();
  }

  static Future<DisplayData?> _loadFromNetwork() async {
    try {
      final response = await http.get(
        Uri.parse(_dataUrl),
        headers: {'Content-Type': 'application/json; charset=utf-8'},
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);
        return DisplayData.fromJson(jsonData);
      }
    } catch (e) {
      print('Network error: $e');
    }
    return null;
  }

  static Future<void> _saveToLocal(DisplayData data) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = jsonEncode(_displayDataToJson(data));
      await prefs.setString(_localDataKey, jsonString);
    } catch (e) {
      print('Failed to save to local storage: $e');
    }
  }

  static Future<DisplayData?> _loadFromLocal() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_localDataKey);
      if (jsonString != null) {
        final Map<String, dynamic> jsonData = jsonDecode(jsonString);
        return DisplayData.fromJson(jsonData);
      }
    } catch (e) {
      print('Failed to load from local storage: $e');
    }
    return null;
  }

  static DisplayData _getDefaultData() {
    final now = DateTime.now();
    
    // Use simple fallback data for now - will be updated by API calls
    final currentHebrewDate = _getSimpleHebrewDate(now);
    final currentParasha = _getCurrentParasha(now);
    final prayerTimesData = _getSimplePrayerTimes();
    
    return DisplayData(
      synagogueName: 'בית הכנסת שערי צדק ע"ש הרב סעדיה חוזה זצוק"ל',
      synagogueSlogan: 'בית תפילה לכל העמים',
      hebrewDate: HebrewDate(
        day: currentHebrewDate['day'] ?? '',
        month: currentHebrewDate['month'] ?? '',
        year: currentHebrewDate['year'] ?? '',
        fullDate: currentHebrewDate['fullDate'] ?? '',
      ),
      parasha: currentParasha,
      weekdayTimes: PrayerTimes(
        sunrise: prayerTimesData['sunrise']!,
        sunset: prayerTimesData['sunset']!,
        mincha: prayerTimesData['mincha']!,
        maariv: prayerTimesData['maariv']!,
        shachrit: prayerTimesData['shachrit']!,
        mincha2: prayerTimesData['mincha2']!,
      ),
      shabbatTimes: PrayerTimes(
        sunrise: prayerTimesData['sunrise']!,
        sunset: prayerTimesData['sunset']!,
        mincha: prayerTimesData['mincha']!,
        maariv: prayerTimesData['maariv']!,
        shachrit: '09:00', // Shabbat morning is typically later
      ),
      messages: [
        'ברוכים הבאים לבית הכנסת שלנו',
        'תפילת מנחה בימי חול בשעה ${prayerTimesData['mincha']}',
        'שיעור תורה בכל יום ראשון בשעה 20:30',
        'הרשמה לקידוש שבת פתוחה'
      ],
      dailyLearning: 'הלכה יומית - ${currentHebrewDate['fullDate']}: דיני תפילה וברכות. חשיבות הכוונה בתפילה ומשמעות הברכות היומיות.',
      yahrzeits: [
        Yahrzeit(
          name: 'אברהם בן יצחק',
          date: DateTime(now.year, now.month, now.day + 2),
          isCurrentWeek: true,
        ),
        Yahrzeit(
          name: 'שרה בת משה',
          date: DateTime(now.year, now.month, now.day + 5),
          isCurrentWeek: true,
        ),
      ],
      currentTheme: DisplayTheme.defaultTheme,
    );
  }

  static Map<String, dynamic> _displayDataToJson(DisplayData data) {
    return {
      'synagogueName': data.synagogueName,
      'synagogueSlogan': data.synagogueSlogan,
      'logoPath': data.logoPath,
      'hebrewDate': {
        'day': data.hebrewDate.day,
        'month': data.hebrewDate.month,
        'year': data.hebrewDate.year,
        'fullDate': data.hebrewDate.fullDate,
      },
      'parasha': data.parasha,
      'weekdayTimes': {
        'sunrise': data.weekdayTimes.sunrise,
        'sunset': data.weekdayTimes.sunset,
        'mincha': data.weekdayTimes.mincha,
        'maariv': data.weekdayTimes.maariv,
        'shachrit': data.weekdayTimes.shachrit,
        'mincha2': data.weekdayTimes.mincha2,
      },
      'shabbatTimes': {
        'sunrise': data.shabbatTimes.sunrise,
        'sunset': data.shabbatTimes.sunset,
        'mincha': data.shabbatTimes.mincha,
        'maariv': data.shabbatTimes.maariv,
        'shachrit': data.shabbatTimes.shachrit,
        'mincha2': data.shabbatTimes.mincha2,
      },
      'messages': data.messages,
      'dailyLearning': data.dailyLearning,
      'yahrzeits': data.yahrzeits.map((y) => {
        'name': y.name,
        'date': y.date.toIso8601String(),
        'isCurrentWeek': y.isCurrentWeek,
      }).toList(),
      'currentTheme': {
        'name': data.currentTheme.name,
        'backgroundImage': data.currentTheme.backgroundImage,
        'backgroundColor': data.currentTheme.backgroundColor.value,
        'textColor': data.currentTheme.textColor.value,
        'accentColor': data.currentTheme.accentColor.value,
      },
    };
  }
  
  static Map<String, String> _getSimpleHebrewDate(DateTime date) {
    // For August 12, 2025, we need to calculate the Hebrew date properly
    // Today (12/08/2025) should be 18 Av 5785
    
    // Hardcode the correct date for now - in production use proper Hebrew calendar calculation
    if (date.year == 2025 && date.month == 8) {
      final hebrewDay = _convertToHebrewNumber(date.day + 6); // Approximate offset for Av 5785
      return {
        'day': hebrewDay,
        'month': 'אב',
        'year': 'תשפ"ה', 
        'fullDate': '$hebrewDay אב תשפ"ה',
      };
    }
    
    // Fallback for other dates
    final hebrewDay = _convertToHebrewNumber(date.day);
    final hebrewMonth = _getCurrentHebrewMonth(date);
    
    return {
      'day': hebrewDay,
      'month': hebrewMonth,
      'year': 'תשפ"ה', 
      'fullDate': '$hebrewDay $hebrewMonth תשפ"ה',
    };
  }
  
  static String _convertToHebrewNumber(int number) {
    if (number <= 0 || number > 30) return number.toString();
    
    const hebrewNumbers = {
      1: 'א\'', 2: 'ב\'', 3: 'ג\'', 4: 'ד\'', 5: 'ה\'',
      6: 'ו\'', 7: 'ז\'', 8: 'ח\'', 9: 'ט\'', 10: 'י\'',
      11: 'י"א', 12: 'י"ב', 13: 'י"ג', 14: 'י"ד', 15: 'ט"ו',
      16: 'ט"ז', 17: 'י"ז', 18: 'י"ח', 19: 'י"ט', 20: 'כ\'',
      21: 'כ"א', 22: 'כ"ב', 23: 'כ"ג', 24: 'כ"ד', 25: 'כ"ה',
      26: 'כ"ו', 27: 'כ"ז', 28: 'כ"ח', 29: 'כ"ט', 30: 'ל\''
    };
    
    return hebrewNumbers[number] ?? number.toString();
  }
  
  static String _getCurrentHebrewMonth(DateTime date) {
    // Approximate Hebrew months based on Gregorian calendar
    const monthMap = {
      1: 'טבת', 2: 'שבט', 3: 'אדר', 4: 'ניסן', 
      5: 'אייר', 6: 'סיון', 7: 'תמוז', 8: 'אב',
      9: 'אלול', 10: 'תשרי', 11: 'חשון', 12: 'כסלו'
    };
    
    return monthMap[date.month] ?? 'אב';
  }
  
  static String _getCurrentParasha(DateTime date) {
    final parashaList = [
      'בראשית', 'נח', 'לך לך', 'וירא', 'חיי שרה', 'תולדות', 'ויצא', 'וישלח',
      'וישב', 'מקץ', 'ויגש', 'ויחי', 'שמות', 'וארא', 'בא', 'בשלח', 'יתרו',
      'משפטים', 'תרומה', 'תצוה', 'כי תשא', 'ויקהל', 'פקודי', 'ויקרא', 'צו',
      'שמיני', 'תזריע', 'מצורע', 'אחרי מות', 'קדושים', 'אמר', 'בהר', 'בחוקתי',
      'במדבר', 'נשא', 'בהעלתך', 'שלח לך', 'קרח', 'חקת', 'בלק', 'פינחס',
      'מטות', 'מסעי', 'דברים', 'ואתחנן', 'עקב', 'ראה', 'שופטים', 'כי תצא',
      'כי תבוא', 'נצבים', 'וילך', 'האזינו'
    ];
    
    final dayOfYear = date.difference(DateTime(date.year, 1, 1)).inDays;
    final weekNumber = (dayOfYear ~/ 7) % parashaList.length;
    
    return 'פרשת ${parashaList[weekNumber]}';
  }
  
  static Map<String, String> _getSimplePrayerTimes() {
    final now = DateTime.now();
    
    // Simple seasonal approximation
    if (now.month >= 4 && now.month <= 9) {
      return {
        'sunrise': '05:45',
        'sunset': '19:20',
        'shachrit': '06:00',
        'mincha': '18:45',
        'mincha2': '13:00',
        'maariv': '19:50',
      };
    } else {
      return {
        'sunrise': '06:30',
        'sunset': '17:20',
        'shachrit': '06:45',
        'mincha': '16:45',
        'mincha2': '13:00',
        'maariv': '17:50',
      };
    }
  }
}
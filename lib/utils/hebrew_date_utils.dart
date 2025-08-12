import 'dart:math';

class HebrewDateUtils {
  static const List<String> hebrewMonths = [
    'תשרי', 'חשון', 'כסלו', 'טבת', 'שבט', 'אדר',
    'ניסן', 'אייר', 'סיון', 'תמוז', 'אב', 'אלול'
  ];

  static const List<String> hebrewDays = [
    'א\'', 'ב\'', 'ג\'', 'ד\'', 'ה\'', 'ו\'', 'ז\'', 'ח\'', 'ט\'', 'י\'',
    'י\"א', 'י\"ב', 'י\"ג', 'י\"ד', 'ט\"ו', 'ט\"ז', 'י\"ז', 'י\"ח', 'י\"ט', 'כ\'',
    'כ\"א', 'כ\"ב', 'כ\"ג', 'כ\"ד', 'כ\"ה', 'כ\"ו', 'כ\"ז', 'כ\"ח', 'כ\"ט', 'ל\''
  ];

  static String getHebrewYear(int year) {
    final thousands = (year ~/ 1000);
    final remainder = year % 1000;
    final hundreds = remainder ~/ 100;
    final tens = (remainder % 100) ~/ 10;
    final ones = remainder % 10;

    String result = '';
    
    if (thousands > 0) {
      result += _getHebrewLetter(thousands);
    }
    if (hundreds > 0) {
      result += _getHebrewLetter(hundreds);
    }
    if (tens > 0) {
      result += _getHebrewLetter(tens);
    }
    if (ones > 0) {
      result += _getHebrewLetter(ones);
    }

    return result.isNotEmpty ? result : 'תש\"פ';
  }

  static String _getHebrewLetter(int num) {
    const letters = {
      1: 'א', 2: 'ב', 3: 'ג', 4: 'ד', 5: 'ה',
      6: 'ו', 7: 'ז', 8: 'ח', 9: 'ט', 10: 'י'
    };
    return letters[num] ?? '';
  }

  static Map<String, dynamic> getCurrentHebrewDate() {
    final now = DateTime.now();
    final hebrewYear = 5784 + (now.year - 2023); // Approximate calculation
    final dayOfYear = now.difference(DateTime(now.year, 1, 1)).inDays;
    
    // Simple approximation for Hebrew month (this would need a proper Hebrew calendar library for accuracy)
    final monthIndex = ((dayOfYear / 30).floor() + 6) % 12; // Starting from Tishrei
    final dayInMonth = ((dayOfYear % 30) + 1).clamp(1, 29);
    
    final hebrewMonth = hebrewMonths[monthIndex];
    final hebrewDay = hebrewDays[dayInMonth - 1];
    final hebrewYearStr = getHebrewYear(hebrewYear);
    
    return {
      'day': hebrewDay,
      'month': hebrewMonth,
      'year': hebrewYearStr,
      'fullDate': '$hebrewDay $hebrewMonth $hebrewYearStr',
    };
  }

  static String getCurrentParasha() {
    final parashaList = [
      'בראשית', 'נח', 'לך לך', 'וירא', 'חיי שרה', 'תולדות', 'ויצא', 'וישלח',
      'וישב', 'מקץ', 'ויגש', 'ויחי', 'שמות', 'וארא', 'בא', 'בשלח', 'יתרו',
      'משפטים', 'תרומה', 'תצוה', 'כי תשא', 'ויקהל', 'פקודי', 'ויקרא', 'צו',
      'שמיני', 'תזריע', 'מצורע', 'אחרי מות', 'קדושים', 'אמר', 'בהר', 'בחוקתי',
      'במדבר', 'נשא', 'בהעלתך', 'שלח לך', 'קרח', 'חקת', 'בלק', 'פינחס',
      'מטות', 'מסעי', 'דברים', 'ואתחנן', 'עקב', 'ראה', 'שופטים', 'כי תצא',
      'כי תבוא', 'נצבים', 'וילך', 'האזינו'
    ];
    
    final now = DateTime.now();
    final startOfYear = DateTime(now.year, 1, 1);
    final weeksSinceStart = now.difference(startOfYear).inDays ~/ 7;
    
    return 'פרשת ${parashaList[weeksSinceStart % parashaList.length]}';
  }
}
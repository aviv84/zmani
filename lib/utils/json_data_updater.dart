import 'dart:convert';
import 'dart:io';
import 'hebrew_date_utils.dart';
import 'prayer_times_utils.dart';

class JsonDataUpdater {
  static Future<void> updateSampleDataFile() async {
    final now = DateTime.now();
    
    // Get real-time data
    final hebrewDateData = HebrewDateUtils.getCurrentHebrewDate();
    final parasha = HebrewDateUtils.getCurrentParasha();
    final prayerTimesData = PrayerTimesUtils.calculatePrayerTimes();
    
    final updatedData = {
      "synagogueName": "בית הכנסת שערי צדק ע\"ש הרב סעדיה חוזה זצוק\"ל",
      "synagogueSlogan": "בית תפילה לכל העמים",
      "logoPath": null,
      "hebrewDate": {
        "day": hebrewDateData['day'],
        "month": hebrewDateData['month'], 
        "year": hebrewDateData['year'],
        "fullDate": hebrewDateData['fullDate']
      },
      "parasha": parasha,
      "weekdayTimes": {
        "sunrise": prayerTimesData['sunrise'],
        "sunset": prayerTimesData['sunset'],
        "mincha": prayerTimesData['mincha'],
        "maariv": prayerTimesData['maariv'],
        "shachrit": prayerTimesData['shachrit'],
        "mincha2": prayerTimesData['mincha2']
      },
      "shabbatTimes": {
        "sunrise": prayerTimesData['sunrise'],
        "sunset": prayerTimesData['sunset'],
        "mincha": prayerTimesData['mincha'],
        "maariv": prayerTimesData['maariv'],
        "shachrit": "09:00"
      },
      "messages": [
        "ברוכים הבאים לבית הכנסת שלנו",
        "תפילת מנחה בימי חול בשעה ${prayerTimesData['mincha']}",
        "שיעור תורה בכל יום ראשון בשעה 20:30",
        "הרשמה לקידוש שבת פתוחה"
      ],
      "dailyLearning": "הלכה יומית - ${hebrewDateData['fullDate']}: דיני תפילה וברכות. חשיבות הכוונה בתפילה ומשמעות הברכות היומיות.",
      "yahrzeits": [
        {
          "name": "אברהם בן יצחק",
          "date": DateTime(now.year, now.month, now.day + 2).toIso8601String(),
          "isCurrentWeek": true
        },
        {
          "name": "שרה בת משה", 
          "date": DateTime(now.year, now.month, now.day + 5).toIso8601String(),
          "isCurrentWeek": true
        }
      ],
      "currentTheme": {
        "name": "default",
        "backgroundImage": null,
        "backgroundColor": 4294967295,
        "textColor": 4278190080,
        "accentColor": 4280391411
      }
    };
    
    // In a real Flutter app, you wouldn't write to assets but this shows the structure
    print('Updated JSON data: ${jsonEncode(updatedData)}');
  }
}
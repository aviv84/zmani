import 'package:flutter/material.dart';

class DisplayData {
  final String synagogueName;
  final String? synagogueSlogan;
  final String? logoPath;
  final HebrewDate hebrewDate;
  final String parasha;
  final PrayerTimes weekdayTimes;
  final PrayerTimes shabbatTimes;
  final List<String> messages;
  final String dailyLearning;
  final List<Yahrzeit> yahrzeits;
  final DisplayTheme currentTheme;

  DisplayData({
    required this.synagogueName,
    this.synagogueSlogan,
    this.logoPath,
    required this.hebrewDate,
    required this.parasha,
    required this.weekdayTimes,
    required this.shabbatTimes,
    required this.messages,
    required this.dailyLearning,
    required this.yahrzeits,
    required this.currentTheme,
  });

  factory DisplayData.fromJson(Map<String, dynamic> json) {
    return DisplayData(
      synagogueName: json['synagogueName'] ?? 'בית כנסת',
      synagogueSlogan: json['synagogueSlogan'],
      logoPath: json['logoPath'],
      hebrewDate: HebrewDate.fromJson(json['hebrewDate']),
      parasha: json['parasha'] ?? 'פרשת השבוע',
      weekdayTimes: PrayerTimes.fromJson(json['weekdayTimes']),
      shabbatTimes: PrayerTimes.fromJson(json['shabbatTimes']),
      messages: List<String>.from(json['messages'] ?? []),
      dailyLearning: json['dailyLearning'] ?? 'הלכה יומית',
      yahrzeits: (json['yahrzeits'] as List?)
          ?.map((y) => Yahrzeit.fromJson(y))
          .toList() ?? [],
      currentTheme: DisplayTheme.fromJson(json['currentTheme']),
    );
  }
}

class HebrewDate {
  final String day;
  final String month;
  final String year;
  final String fullDate;

  HebrewDate({
    required this.day,
    required this.month,
    required this.year,
    required this.fullDate,
  });

  factory HebrewDate.fromJson(Map<String, dynamic> json) {
    return HebrewDate(
      day: json['day'] ?? '',
      month: json['month'] ?? '',
      year: json['year'] ?? '',
      fullDate: json['fullDate'] ?? '',
    );
  }
}

class PrayerTimes {
  final String sunrise;
  final String sunset;
  final String mincha;
  final String maariv;
  final String? shachrit;
  final String? mincha2;

  PrayerTimes({
    required this.sunrise,
    required this.sunset,
    required this.mincha,
    required this.maariv,
    this.shachrit,
    this.mincha2,
  });

  factory PrayerTimes.fromJson(Map<String, dynamic> json) {
    return PrayerTimes(
      sunrise: json['sunrise'] ?? '06:00',
      sunset: json['sunset'] ?? '18:00',
      mincha: json['mincha'] ?? '17:30',
      maariv: json['maariv'] ?? '19:00',
      shachrit: json['shachrit'],
      mincha2: json['mincha2'],
    );
  }
}

class Yahrzeit {
  final String name;
  final DateTime date;
  final bool isCurrentWeek;

  Yahrzeit({
    required this.name,
    required this.date,
    required this.isCurrentWeek,
  });

  factory Yahrzeit.fromJson(Map<String, dynamic> json) {
    return Yahrzeit(
      name: json['name'] ?? '',
      date: DateTime.parse(json['date']),
      isCurrentWeek: json['isCurrentWeek'] ?? false,
    );
  }
}

class DisplayTheme {
  final String name;
  final String? backgroundImage;
  final Color backgroundColor;
  final Color textColor;
  final Color accentColor;

  DisplayTheme({
    required this.name,
    this.backgroundImage,
    required this.backgroundColor,
    required this.textColor,
    required this.accentColor,
  });

  factory DisplayTheme.fromJson(Map<String, dynamic> json) {
    return DisplayTheme(
      name: json['name'] ?? 'default',
      backgroundImage: json['backgroundImage'],
      backgroundColor: Color(json['backgroundColor'] ?? 0xFFFFFFFF),
      textColor: Color(json['textColor'] ?? 0xFF000000),
      accentColor: Color(json['accentColor'] ?? 0xFF2196F3),
    );
  }

  static DisplayTheme get defaultTheme => DisplayTheme(
    name: 'default',
    backgroundColor: const Color(0xFFFFFFFF),
    textColor: const Color(0xFF000000),
    accentColor: const Color(0xFF2196F3),
  );
}
# Zmani - זמני

Digital display app for synagogue showing prayer times, Hebrew calendar, and messages.

## Features

- **Real-time Hebrew Date**: Shows current Hebrew date (י"ח אב תשפ"ה) using HebCal API
- **Current Parasha**: Displays weekly Torah portion (פרשת עקב) from API
- **Prayer Times**: Dynamic prayer times based on location and season
- **Dual Slides**: Automatic rotation between weekday and Shabbat/Holiday content
- **Hebrew & RTL Support**: Full Hebrew interface with right-to-left layout
- **Live Clock**: Real-time clock and date display
- **Management Messages**: Dynamic messages for synagogue announcements
- **Daily Learning**: Hebrew daily learning content (הלכה יומית)
- **Yahrzeit Reminders**: Weekly yahrzeit notifications
- **Responsive Design**: Supports both portrait and landscape orientations
- **Android TV Compatible**: Optimized for TV displays and tablets

## Architecture

**Frontend**: Flutter (Dart)
**APIs**: HebCal.com for Hebrew calendar and parasha data
**Platform**: Android TV and tablets
**Language**: Hebrew with RTL layout

## Project Structure

```
lib/
├── main.dart                    # App entry point
├── screens/
│   └── display_screen.dart      # Main display screen
├── widgets/
│   ├── header_widget.dart       # Header (logo, time, date, parasha)
│   ├── footer_widget.dart       # Footer (synagogue name, slogan)
│   └── slide_content.dart       # Main content slides
├── models/
│   └── display_data.dart        # Data models
├── services/
│   ├── data_service.dart        # Main data service
│   ├── hebrew_calendar_service.dart
│   └── prayer_times_service.dart
└── utils/
    ├── hebrew_date_utils.dart
    └── prayer_times_utils.dart
```

## Setup

1. Install Flutter SDK
2. Run `flutter pub get`
3. Connect Android device or start emulator
4. Run `flutter run`

## Configuration

The app displays:
- Synagogue name: בית הכנסת שערי צדק ע"ש הרב סעדיה חוזה זצוק"ל
- Slogan: בית תפילה לכל העמים

## API Integration

- **HebCal API**: Real Hebrew dates and parasha information
- **Prayer Times**: Calculated for Jerusalem coordinates
- **Offline Fallback**: Local data when network unavailable

## Contributing

This project was built following the PRD requirements for a synagogue digital display system.

---

🤖 Generated with [Claude Code](https://claude.ai/code)
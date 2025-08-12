import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'screens/display_screen.dart';

void main() {
  runApp(const ZmaniApp());
}

class ZmaniApp extends StatelessWidget {
  const ZmaniApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'זמני - תצוגה דיגיטלית לבית כנסת',
      debugShowCheckedModeBanner: false,
      locale: const Locale('he', 'IL'),
      supportedLocales: const [
        Locale('he', 'IL'),
        Locale('en', 'US'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          displayMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
          displaySmall: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
          headlineLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          headlineMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          headlineSmall: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          titleLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          titleMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          bodyLarge: TextStyle(fontSize: 16),
          bodyMedium: TextStyle(fontSize: 14),
        ),
      ),
      home: const DisplayScreen(),
    );
  }
}
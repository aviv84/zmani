import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../widgets/header_widget.dart';
import '../widgets/footer_widget.dart';
import '../widgets/slide_content.dart';
import '../models/display_data.dart';
import '../services/data_service.dart';
import 'dart:async';

class DisplayScreen extends StatefulWidget {
  const DisplayScreen({super.key});

  @override
  State<DisplayScreen> createState() => _DisplayScreenState();
}

class _DisplayScreenState extends State<DisplayScreen> {
  final PageController _pageController = PageController();
  Timer? _slideTimer;
  Timer? _clockTimer;
  DisplayData? _displayData;
  DateTime _currentTime = DateTime.now();
  int _currentSlideIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
    _startClockTimer();
    _startSlideTimer();
  }

  @override
  void dispose() {
    _slideTimer?.cancel();
    _clockTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _loadData() async {
    final data = await DataService.loadDisplayData();
    setState(() {
      _displayData = data;
    });
    
    // Load real Hebrew date separately to update UI
    _loadHebrewDate();
  }
  
  void _loadHebrewDate() async {
    try {
      final now = DateTime.now();
      final url = Uri.parse(
        'https://www.hebcal.com/converter?cfg=json&gy=${now.year}&gm=${now.month}&gd=${now.day}&g2h=1'
      );
      
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final apiData = jsonDecode(response.body);
        print('Hebrew date API response: $apiData');
        
        if (_displayData != null) {
          final hebrewDay = _convertToHebrewNumber(apiData['hd']);
          final hebrewMonth = _convertMonthToHebrew(apiData['hm']); // Convert to Hebrew
          final hebrewYear = _convertYearToHebrew(apiData['hy']);
          
          // Extract parasha from API events
          String parasha = _displayData!.parasha; // fallback
          final events = apiData['events'] as List?;
          if (events != null && events.isNotEmpty) {
            for (final event in events) {
              final eventStr = event.toString();
              if (eventStr.startsWith('Parashat ')) {
                final parashaName = eventStr.replaceFirst('Parashat ', '');
                parasha = 'פרשת ${_convertParashaToHebrew(parashaName)}';
                break;
              }
            }
          }
          
          final updatedHebrewDate = HebrewDate(
            day: hebrewDay,
            month: hebrewMonth,
            year: hebrewYear,
            fullDate: '$hebrewDay $hebrewMonth $hebrewYear',
          );
          
          setState(() {
            _displayData = DisplayData(
              synagogueName: _displayData!.synagogueName,
              synagogueSlogan: _displayData!.synagogueSlogan,
              logoPath: _displayData!.logoPath,
              hebrewDate: updatedHebrewDate,
              parasha: parasha,
              weekdayTimes: _displayData!.weekdayTimes,
              shabbatTimes: _displayData!.shabbatTimes,
              messages: _displayData!.messages,
              dailyLearning: _displayData!.dailyLearning,
              yahrzeits: _displayData!.yahrzeits,
              currentTheme: _displayData!.currentTheme,
            );
          });
        }
      }
    } catch (e) {
      print('Error loading Hebrew date: $e');
    }
  }
  
  String _convertToHebrewNumber(int number) {
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
  
  String _convertYearToHebrew(int year) {
    // Convert Hebrew year to proper Hebrew letters format
    // For 5785 -> תשפ"ה
    String yearStr = year.toString();
    if (yearStr.length == 4) {
      final thousands = int.parse(yearStr.substring(0, 1)); // 5
      final hundreds = int.parse(yearStr.substring(1, 2));  // 7
      final tens = int.parse(yearStr.substring(2, 3));      // 8
      final ones = int.parse(yearStr.substring(3, 4));      // 5
      
      String result = '';
      
      // Hebrew letters for thousands (5000s)
      if (thousands == 5) result += 'ה';
      
      // Hebrew letters for hundreds
      const hundredsMap = {7: 'ת', 6: 'ת', 8: 'ת'};
      if (hundredsMap.containsKey(hundreds)) result += hundredsMap[hundreds]!;
      
      // Hebrew letters for tens and ones - for 85 = פ"ה
      if (tens == 8 && ones == 5) {
        result += 'שפ"ה';
      } else {
        // General mapping for other years
        const tensMap = {8: 'פ', 9: 'צ', 7: 'ע'};
        const onesMap = {5: 'ה', 4: 'ד', 6: 'ו', 3: 'ג', 2: 'ב', 1: 'א'};
        
        if (tensMap.containsKey(tens)) result += tensMap[tens]!;
        if (onesMap.containsKey(ones)) result += '"${onesMap[ones]!}';
      }
      
      return result.isNotEmpty ? result : year.toString();
    }
    
    return year.toString();
  }
  
  String _convertMonthToHebrew(String monthName) {
    // Convert English Hebrew month names to Hebrew
    const monthMap = {
      'Tishrei': 'תשרי', 'Cheshvan': 'חשון', 'Kislev': 'כסלו', 'Tevet': 'טבת',
      'Shvat': 'שבט', 'Adar': 'אדר', 'Nisan': 'ניסן', 'Iyyar': 'אייר',
      'Sivan': 'סיון', 'Tamuz': 'תמוז', 'Av': 'אב', 'Elul': 'אלול',
      'Adar I': 'אדר א\'', 'Adar II': 'אדר ב\''
    };
    
    return monthMap[monthName] ?? monthName;
  }
  
  String _convertParashaToHebrew(String englishName) {
    // Convert English parasha names to Hebrew
    const parashaMap = {
      'Bereshit': 'בראשית', 'Noach': 'נח', 'Lech-Lecha': 'לך לך', 'Vayera': 'וירא',
      'Chayei Sara': 'חיי שרה', 'Toldot': 'תולדות', 'Vayetzei': 'ויצא', 'Vayishlach': 'וישלח',
      'Vayeshev': 'וישב', 'Miketz': 'מקץ', 'Vayigash': 'ויגש', 'Vayechi': 'ויחי',
      'Shemot': 'שמות', 'Vaera': 'וארא', 'Bo': 'בא', 'Beshalach': 'בשלח',
      'Yitro': 'יתרו', 'Mishpatim': 'משפטים', 'Terumah': 'תרומה', 'Tetzaveh': 'תצוה',
      'Ki Tisa': 'כי תשא', 'Vayakhel': 'ויקהל', 'Pekudei': 'פקודי', 'Vayikra': 'ויקרא',
      'Tzav': 'צו', 'Shmini': 'שמיני', 'Tazria': 'תזריע', 'Metzora': 'מצורע',
      'Achrei Mot': 'אחרי מות', 'Kedoshim': 'קדושים', 'Emor': 'אמר', 'Behar': 'בהר',
      'Bechukotai': 'בחוקתי', 'Bamidbar': 'במדבר', 'Nasso': 'נשא', 'Beha\'alotcha': 'בהעלתך',
      'Sh\'lach': 'שלח לך', 'Korach': 'קרח', 'Chukat': 'חקת', 'Balak': 'בלק',
      'Pinchas': 'פינחס', 'Matot': 'מטות', 'Masei': 'מסעי', 'Devarim': 'דברים',
      'Vaetchanan': 'ואתחנן', 'Eikev': 'עקב', 'Re\'eh': 'ראה', 'Shoftim': 'שופטים',
      'Ki Teitzei': 'כי תצא', 'Ki Tavo': 'כי תבוא', 'Nitzavim': 'נצבים', 'Vayeilech': 'וילך',
      'Ha\'Azinu': 'האזינו'
    };
    
    return parashaMap[englishName] ?? englishName;
  }

  void _startClockTimer() {
    _clockTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _currentTime = DateTime.now();
      });
    });
  }

  void _startSlideTimer() {
    _slideTimer = Timer.periodic(const Duration(seconds: 15), (timer) {
      if (_displayData != null) {
        final isShabbatOrHoliday = _isShabbatOrHoliday();
        final maxSlides = isShabbatOrHoliday ? 2 : 1;
        
        setState(() {
          _currentSlideIndex = (_currentSlideIndex + 1) % maxSlides;
        });
        
        _pageController.animateToPage(
          _currentSlideIndex,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  bool _isShabbatOrHoliday() {
    final now = DateTime.now();
    final weekday = now.weekday;
    return weekday == DateTime.friday && now.hour >= 18 || 
           weekday == DateTime.saturday;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Column(
            children: [
              HeaderWidget(
                currentTime: _currentTime,
                displayData: _displayData,
              ),
              Expanded(
                child: _displayData != null
                    ? PageView(
                        controller: _pageController,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          SlideContent(
                            slideType: SlideType.weekday,
                            displayData: _displayData!,
                          ),
                          if (_isShabbatOrHoliday())
                            SlideContent(
                              slideType: SlideType.shabbat,
                              displayData: _displayData!,
                            ),
                        ],
                      )
                    : const Center(
                        child: CircularProgressIndicator(),
                      ),
              ),
              FooterWidget(displayData: _displayData),
            ],
          ),
        ),
      ),
    );
  }
}
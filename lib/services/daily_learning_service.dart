import 'dart:convert';
import 'package:http/http.dart' as http;

class DailyLearningService {
  static Future<String> getDailyLearning() async {
    try {
      // Try to get Daf Yomi, fallback to simple daily content
      final dafYomi = await _getDafYomi();
      if (dafYomi != null) {
        return dafYomi;
      }
      
      return _getSingleHalachaContent();
      
    } catch (e) {
      return _getSingleHalachaContent();
    }
  }
  
  static Future<String?> _getDafYomi() async {
    try {
      final now = DateTime.now();
      final dateStr = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
      
      final response = await http.get(
        Uri.parse('https://www.sefaria.org/api/calendars/daf-yomi/$dateStr')
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final daf = data['daf'];
        if (daf != null) {
          return 'דף היומי: $daf';
        }
      }
    } catch (e) {
      // Silently fail and use fallback
    }
    return null;
  }
  
  static String _getSingleHalachaContent() {
    final now = DateTime.now();
    final dayOfYear = now.difference(DateTime(now.year, 1, 1)).inDays;
    
    final halachaContent = [
      '''הלכות תפילה - חשיבות הכוונה
על פי השולחן ערוך (אורח חיים סימן צ"ח): "המתפלל צריך לכוין לבו בכל התפילה כולה, ואם אי אפשר לו לכוין בכולה, יכוין במה שיוכל". חכמים קבעו שהכוונה העיקרית נדרשת בפסוק ראשון של קריאת שמע ובברכת אבות בתפילה.''',
      
      '''הלכות שבת - דיני הבדלה
הבדלה על הכוס מצוה מן התורה (פסחים קג ע"ב). מברכים ברכות הבדלה על כוס יין המכיל לפחות רביעית. סדר הברכות: יין, בשמים, נר, הבדלה. יש לעמוד בכבוד ויראה בשעת ההבדלה.''',
      
      '''הלכות כשרות - עיקרי דיני בישול
אסור לבשל בשר עם חלב (שמות כג, יט). החכמים הרחיבו את האיסור וקבעו הפרדה בין מזון בשרי לחלבי. יש להמתין בין אכילת בשר לחלב לפי המנהגים - מ-3 שעות עד 6 שעות.''',
      
      '''הלכות חגים - הכנות לראש השנה
ראש השנה - יום הדין, נוהגים באכילת סימנים (תפוח בדבש לשנה טובה ומתוקה, רימון למרבות זכויות). מצוה להרבות בתפילות ובקשות לשנה טובה.''',
      
      '''הלכות בית הכנסת - כבוד המקום
בית הכנסת קדוש הוא (מגילה כח ע"א). אסור להיכנס בלא צורך, לאכול ולשתות ולישון בו. מצוה לנהוג בו כבוד - לא לרוץ, לשוחח בעניני חול.''',
      
      '''הלכות צדקה - מצות מתן חסד
צדקה מצוה גדולה היא, ומצילה מיתה (משלי י, ב). חייב אדם לתת מעשירו לעניים - עד חומש מהכנסתו. הצדקה הגדולה ביותר - להחזיק ביד אדם שמסכן עד שלא יצטרך לבריות.''',
      
      '''הלכות ברכות - ברכת המזון
חובה לברך ברכת המזון אחר אכילת כזית פת מחמשת מיני דגן. יש לברך במקום האכילה ובמצב ישיבה. מצוה מן המובחר לברך על כוס יין בציבור של שלושה ומעלה.'''
    ];
    
    return halachaContent[dayOfYear % halachaContent.length];
  }
}
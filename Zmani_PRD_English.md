# PRD - "Zmani" Digital Display for Synagogue

## 1. Project Overview  
Create an Android-based digital display app for synagogue use that shows daily prayer times, Hebrew calendar events, management messages, Yahrzeit reminders, and daily learning content. The app will run on Android TV or tablets, support Hebrew and RTL, and allow easy content updates by multiple managers.

## 2. Functional Requirements

### 2.1 Display Content  
- Show synagogue logo on all screens  
- Show current time (24-hour format), updated live  
- Show both Hebrew and Gregorian dates, including Hebrew date details (e.g., day, month, year)  
- Show weekly Torah portion (Parashat HaShavua)  
- Display daily prayer times relevant to the day (sunrise, sunset, mincha, maariv, etc.)  
- Display management messages updated dynamically  
- Display Yahrzeit reminders one week before including Shabbat  
- Display daily learning content (Halacha Yomit or Daf Yomi), adaptable by date and occasion  
- Display holiday and special day themes dynamically with matching backgrounds and fonts  
- Support both portrait (vertical) and landscape (horizontal) screen orientations  

### 2.2 Content Updates & Management  
- Allow 3 authorized managers to update messages and content  
- Content update via simple Web interface or Google Sheets integration  
- Ability to import Yahrzeit lists (CSV or similar) with names and dates, auto-notify on relevant week  
- Sync content periodically over the internet, with offline mode fallback using local files  

### 2.3 Themes & Calendar Support  
- Support automatic theme switching based on Hebrew calendar dates and holidays (e.g., Shavuot, Hanukkah, Rosh Hashanah, Yom Kippur)  
- Each theme includes background image/color, font style, and color scheme  
- Show full Hebrew calendar details including Omer counting and holiday names  

## 3. Technical & Hardware Requirements

### 3.1 Platform & Language  
- Platform: Android TV and Android tablets  
- Development language & framework: Flutter (Dart)  
- IDE: Android Studio  

### 3.2 Device Requirements  
- Android device with minimum 2GB RAM (preferably 3GB+)  
- Screen: Full HD (1080×1920 in portrait or 1920×1080 in landscape)  
- Stable internet connection (Wi-Fi or Ethernet) preferred, with offline content fallback  
- Power supply and HDMI connection as needed  

## 4. Content Display & Slide Structure

### Slide 1 (Weekdays)  
- Daily prayer times (weekday schedule)  
- Management messages  
- Daily learning content (Halacha Yomit or similar)  

### Slide 2 (Shabbat & Holidays)  
- Shabbat/holiday-specific prayer times  
- Holiday-relevant messages  
- Daily learning content adapted for Shabbat/holidays  

*Slides will rotate automatically in a loop.*

## 5. Sprint Plan

### Sprint 1 – Core UI and Basic Content Display (2 weeks)

**Goals:**  
- Set up Flutter project with RTL and Hebrew support  
- Implement fixed Header and Footer displaying:  
  - Synagogue logo  
  - Current time  
  - Hebrew and Gregorian dates  
  - Weekly Torah portion  
  - Footer with synagogue name and optional slogan  
- Develop Slide 1 content display with placeholder data:  
  - Prayer times, management messages, daily learning text  
- Support automatic slide rotation  
- Support both portrait and landscape screen orientations  
- Basic testing and documentation  

**Acceptance Criteria:**  
- App runs on Android TV/tablet without crashes  
- Header and Footer show required data correctly  
- Slide 1 displays prayer times, messages, and learning content in Hebrew with RTL layout  
- Slides rotate automatically  
- Works correctly in both screen orientations  

### Sprint 2 – Shabbat/Holiday Slide, Message Management & Themes (2 weeks)

**Goals:**  
- Implement Slide 2 for Shabbat and holidays with appropriate content placeholders  
- Develop basic message management interface (Web or simple app) for adding/editing/removing messages  
- Integrate dynamic data source (Google Sheets/JSON) for messages and learning content  
- Improve slide rotation logic to switch between Slide 1 and Slide 2 based on day (weekday vs Shabbat/holiday)  
- Implement basic theme support with different backgrounds and color schemes for holidays  
- Testing and collecting feedback from managers  

**Acceptance Criteria:**  
- Slide 2 displays correct Shabbat/holiday content  
- Managers can add and edit messages dynamically via the management interface  
- App switches slides automatically according to the calendar  
- Basic theme switching works and displays correct backgrounds/colors  
- Content updates reflect properly in the app  

## 6. Additional Notes  
- Future sprints will cover full Yahrzeit integration, advanced theme management, offline content support, and UI/UX polish.  
- Further requirements can be added as the project evolves.  

## 7. Project Language and Localization  
The entire project, user interface, and all textual content will be implemented in Hebrew, using right-to-left (RTL) layout and conventions. Special attention will be given to font choices, text alignment, and UI components to ensure a natural and intuitive Hebrew user experience.

## Appendix A: Basic Screen Layout Diagram  
| Logo | Time | Date | Parasha |
| |
| Slide Content |
| (Prayer Times, Messages, Learning) |
| |
| Synagogue Name | Slogan | Links |

## Appendix B: Slide Rotation Flow  
If day is Shabbat or Holiday --> Show Slide 2 (Shabbat/Holiday content)  
Else --> Show Slide 1 (Weekday content)  
Slides rotate automatically every set interval.

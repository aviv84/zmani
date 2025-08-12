import 'package:flutter/material.dart';
import '../models/display_data.dart';

enum SlideType { weekday, shabbat }

class SlideContent extends StatelessWidget {
  final SlideType slideType;
  final DisplayData displayData;

  const SlideContent({
    super.key,
    required this.slideType,
    required this.displayData,
  });

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    final isPortrait = orientation == Orientation.portrait;
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: displayData.currentTheme.backgroundColor,
        image: displayData.currentTheme.backgroundImage != null
            ? DecorationImage(
                image: AssetImage(displayData.currentTheme.backgroundImage!),
                fit: BoxFit.cover,
                opacity: 0.1,
              )
            : null,
      ),
      child: isPortrait ? _buildPortraitLayout() : _buildLandscapeLayout(),
    );
  }

  Widget _buildPortraitLayout() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildPrayerTimes(),
          const SizedBox(height: 15),
          _buildMessages(),
          const SizedBox(height: 15),
          _buildDailyLearning(),
          const SizedBox(height: 15),
          _buildYahrzeits(), // Always show
          const SizedBox(height: 15), // Bottom padding
        ],
      ),
    );
  }

  Widget _buildLandscapeLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Left column - Prayer Times (25% width)
        Expanded(
          flex: 1,
          child: _buildPrayerTimes(),
        ),
        const SizedBox(width: 10),
        
        // Middle column - Messages (35% width)
        Expanded(
          flex: 1,
          child: _buildMessages(),
        ),
        const SizedBox(width: 10),
        
        // Right column - Learning and Yahrzeits (40% width)
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 3,
                child: _buildDailyLearning(),
              ),
              const SizedBox(height: 10),
              Expanded(
                flex: 2,
                child: _buildYahrzeits(), // Always show
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPrayerTimes() {
    final prayerTimes = slideType == SlideType.shabbat 
        ? displayData.shabbatTimes 
        : displayData.weekdayTimes;
    
    final title = slideType == SlideType.shabbat 
        ? 'זמני שבת וחג'
        : 'זמני תפילה';

    return Card(
      elevation: 4,
      color: displayData.currentTheme.backgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: displayData.currentTheme.textColor,
              ),
            ),
            const SizedBox(height: 12),
            _buildPrayerTimeRow('זריחה', prayerTimes.sunrise),
            if (prayerTimes.shachrit != null)
              _buildPrayerTimeRow('שחרית', prayerTimes.shachrit!),
            _buildPrayerTimeRow('מנחה', prayerTimes.mincha),
            if (prayerTimes.mincha2 != null)
              _buildPrayerTimeRow('מנחה גדולה', prayerTimes.mincha2!),
            _buildPrayerTimeRow('שקיעה', prayerTimes.sunset),
            _buildPrayerTimeRow('מעריב', prayerTimes.maariv),
          ],
        ),
      ),
    );
  }

  Widget _buildPrayerTimeRow(String prayer, String time) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            prayer,
            style: TextStyle(
              fontSize: 18,
              color: displayData.currentTheme.textColor,
            ),
          ),
          Text(
            time,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: displayData.currentTheme.accentColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessages() {
    return Card(
      elevation: 4,
      color: displayData.currentTheme.backgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'הודעות הנהלה',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: displayData.currentTheme.textColor,
              ),
            ),
            const SizedBox(height: 12),
            if (displayData.messages.isEmpty)
              Text(
                'אין הודעות חדשות',
                style: TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  color: displayData.currentTheme.textColor.withOpacity(0.7),
                ),
              )
            else
              ...displayData.messages.map((message) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '• ',
                      style: TextStyle(
                        fontSize: 16,
                        color: displayData.currentTheme.accentColor,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        message,
                        style: TextStyle(
                          fontSize: 16,
                          color: displayData.currentTheme.textColor,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
          ],
        ),
      ),
    );
  }

  Widget _buildDailyLearning() {
    return Card(
      elevation: 4,
      color: displayData.currentTheme.backgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              slideType == SlideType.shabbat ? 'לימוד שבת' : 'הלכה יומית',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: displayData.currentTheme.textColor,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              displayData.dailyLearning,
              style: TextStyle(
                fontSize: 16,
                color: displayData.currentTheme.textColor,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildYahrzeits() {
    final currentWeekYahrzeits = displayData.yahrzeits
        .where((y) => y.isCurrentWeek)
        .toList();

    return Card(
      elevation: 4,
      color: displayData.currentTheme.backgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'יארצייט השבוע',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: displayData.currentTheme.textColor,
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: currentWeekYahrzeits.isEmpty
                  ? Center(
                      child: Text(
                        'אין יארצייט השבוע',
                        style: TextStyle(
                          fontSize: 14,
                          fontStyle: FontStyle.italic,
                          color: displayData.currentTheme.textColor.withOpacity(0.7),
                        ),
                      ),
                    )
                  : ListView.separated(
                      itemCount: currentWeekYahrzeits.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final yahrzeit = currentWeekYahrzeits[index];
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                yahrzeit.name,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: displayData.currentTheme.textColor,
                                ),
                              ),
                            ),
                            Text(
                              '${yahrzeit.date.day}/${yahrzeit.date.month}',
                              style: TextStyle(
                                fontSize: 14,
                                color: displayData.currentTheme.accentColor,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  bool _shouldShowYahrzeits() {
    return displayData.yahrzeits.any((y) => y.isCurrentWeek);
  }
}

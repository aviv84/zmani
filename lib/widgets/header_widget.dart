import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/display_data.dart';

class HeaderWidget extends StatelessWidget {
  final DateTime currentTime;
  final DisplayData? displayData;

  const HeaderWidget({
    super.key,
    required this.currentTime,
    this.displayData,
  });

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    final isPortrait = orientation == Orientation.portrait;
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: displayData?.currentTheme.backgroundColor ?? Colors.white,
        border: Border(
          bottom: BorderSide(
            color: displayData?.currentTheme.accentColor ?? Colors.blue,
            width: 2,
          ),
        ),
      ),
      child: isPortrait ? _buildPortraitHeader() : _buildLandscapeHeader(),
    );
  }

  Widget _buildPortraitHeader() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildLogo(),
            _buildTimeAndDate(),
          ],
        ),
        const SizedBox(height: 12),
        _buildParasha(),
      ],
    );
  }

  Widget _buildLandscapeHeader() {
    return Row(
      children: [
        _buildLogo(),
        const SizedBox(width: 20),
        Expanded(child: _buildTimeAndDate()),
        const SizedBox(width: 20),
        _buildParasha(),
      ],
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: displayData?.currentTheme.accentColor ?? Colors.blue,
        shape: BoxShape.circle,
      ),
      child: displayData?.logoPath != null
          ? ClipOval(
              child: Image.asset(
                displayData!.logoPath!,
                fit: BoxFit.cover,
              ),
            )
          : Icon(
              Icons.synagogue,
              color: Colors.white,
              size: 30,
            ),
    );
  }

  Widget _buildTimeAndDate() {
    final timeFormat = DateFormat('HH:mm');
    final dateFormat = DateFormat('dd/MM/yyyy'); // Day/Month/Year format
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          timeFormat.format(currentTime),
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: displayData?.currentTheme.textColor ?? Colors.black,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              dateFormat.format(currentTime),
              style: TextStyle(
                fontSize: 16,
                color: displayData?.currentTheme.textColor ?? Colors.black,
              ),
            ),
            const SizedBox(width: 20),
            if (displayData?.hebrewDate != null)
              Text(
                displayData!.hebrewDate.fullDate,
                style: TextStyle(
                  fontSize: 16,
                  color: displayData?.currentTheme.textColor ?? Colors.black,
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildParasha() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: displayData?.currentTheme.accentColor.withOpacity(0.1) ?? 
               Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        displayData?.parasha ?? 'פרשת השבוע',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: displayData?.currentTheme.textColor ?? Colors.black,
        ),
      ),
    );
  }
}
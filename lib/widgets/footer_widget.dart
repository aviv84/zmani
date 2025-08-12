import 'package:flutter/material.dart';
import '../models/display_data.dart';

class FooterWidget extends StatelessWidget {
  final DisplayData? displayData;

  const FooterWidget({
    super.key,
    this.displayData,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: displayData?.currentTheme.accentColor ?? Colors.blue,
        border: Border(
          top: BorderSide(
            color: displayData?.currentTheme.accentColor.withOpacity(0.3) ?? 
                   Colors.blue.withOpacity(0.3),
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            displayData?.synagogueName ?? 'בית כנסת',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          if (displayData?.synagogueSlogan != null)
            Text(
              displayData!.synagogueSlogan!,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white,
              ),
            ),
        ],
      ),
    );
  }
}
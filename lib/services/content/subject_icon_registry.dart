import 'package:flutter/material.dart';

class SubjectIconRegistry {
  static const Map<String, IconData> icons = {
    'math': Icons.calculate,
    'reading': Icons.menu_book,
    'writing': Icons.edit,
    'science': Icons.science,
    'history': Icons.history_edu,
    'art': Icons.palette,
    'music': Icons.music_note,
  };

  static const Map<String, Color> colors = {
    'math': Color(0xFF4A90D9),
    'reading': Color(0xFF50C878),
    'writing': Color(0xFFE8833A),
    'science': Color(0xFF9B59B6),
    'history': Color(0xFFE74C3C),
    'art': Color(0xFFF39C12),
    'music': Color(0xFF1ABC9C),
  };

  static IconData getIcon(String key) => icons[key] ?? Icons.school;
  static Color getColor(String key) => colors[key] ?? Colors.grey;
}

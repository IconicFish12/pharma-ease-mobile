import 'package:flutter/material.dart';
import 'package:mobile_course_fp/data/model/user_model.dart';

extension DatumExt on Datum {
  Color get roleColor {
    final r = role?.toLowerCase() ?? '';
    if (r == 'admin') return Colors.blue;
    if (r == 'pharmacist') return Colors.green;
    if (r == 'cashier') return Colors.orange;
    if (r == 'owner') return Colors.purple;
    return Colors.grey;
  }

  String get initials {
    if (name == null || name!.isEmpty) return '?';
    List<String> parts = name!.split(' ');
    if (parts.length > 1 && parts[1].isNotEmpty) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return parts[0][0].toUpperCase();
  }
}

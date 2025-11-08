import 'package:flutter/material.dart';
import 'package:mobile_course_fp/config/config.dart';

class User {
  final String id;
  String fullName;
  String email;
  String? password;
  UserRole role;
  DateTime lastLogin;
  UserStatus status;

  User({
    required this.id,
    required this.fullName,
    required this.email,
    required this.role,
    required this.lastLogin,
    this.password,
    this.status = UserStatus.active,
  });

  Color get statusColor {
    switch (status) {
      case UserStatus.active:
        return Colors.green;
      case UserStatus.inactive:
        return Colors.red;
    }
  }

  String get statusText {
    switch (status) {
      case UserStatus.active:
        return 'Active';
      case UserStatus.inactive:
        return 'Non-Active';
    }
  }

  String get initials {
    if (fullName.isEmpty) return '?';
    List<String> parts = fullName.split(' ');
    if (parts.length > 1 && parts[1].isNotEmpty) {
      return parts[0][0].toUpperCase() + parts[1][0].toUpperCase();
    } else {
      return parts[0][0].toUpperCase();
    }
  }

  // Helper untuk teks role
  String get roleText {
    switch (role) {
      case UserRole.admin:
        return 'Admin';
      case UserRole.pharmacist:
        return 'Pharmacist';
      case UserRole.cashier:
        return 'Cashier';
      default:
        return 'Unknown';
    }
  }

  // Helper untuk warna role (KEUNIKAN)
  Color get roleColor {
    switch (role) {
      case UserRole.admin:
        return Config.accentBlue; // Biru
      case UserRole.pharmacist:
        return Config.primaryGreen; // Hijau
      case UserRole.cashier:
        return Colors.orange.shade700; // Oranye
      default:
        return Colors.grey;
    }
  }
}

enum UserRole { owner, pharmacist, cashier, storageOfficer, admin }

enum UserStatus { active, inactive }

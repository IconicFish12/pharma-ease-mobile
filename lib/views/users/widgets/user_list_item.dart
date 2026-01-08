import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_course_fp/data/model/user_model.dart';
import '../utils/user_extensions.dart';

class UserListItem extends StatelessWidget {
  final Datum user;
  final VoidCallback onTap;

  const UserListItem({super.key, required this.user, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    String lastLoginText =
        '-'; 
    if (user.createdAt != null) {
      try {
        final DateTime date = DateTime.parse(user.createdAt!);
        lastLoginText = DateFormat('dd MMM yyyy').format(date);
      } catch (e) {
        lastLoginText = '-';
      }
    }

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          radius: 24,
          backgroundColor: user.roleColor.withOpacity(0.15),
          child: Text(
            user.initials,
            style: textTheme.titleLarge?.copyWith(
              color: user.roleColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(user.name ?? 'No Name', style: textTheme.titleLarge),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(user.email ?? '-', style: textTheme.bodyMedium),
            const SizedBox(height: 4),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: user.roleColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    user.role?.toUpperCase() ?? '-',
                    style: textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: user.roleColor,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '• ${user.shift?.toUpperCase() ?? '-'}',
                  style: textTheme.bodySmall,
                ),
              ],
            ),
          ],
        ),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}

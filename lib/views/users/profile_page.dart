import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_course_fp/config/config.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    // Data dummy (bisa Anda ganti dengan data user yang login)
    const String userName = "Rarara Ra";
    const String userRole = "Admin";
    const String userEmail = "rararara@pharmaease.com";
    const String userPhone = "0213102301203102";
    const String userLocation = "Jawa Barat, Indonesia";
    const String userJoined = "January 15, 2024";
    const String userId = "PE-2024-001";
    const String userInitials = "RR"; 

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Config.textPrimary),
          onPressed: () {
            // Menggunakan GoRouter untuk kembali
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/home'); // Fallback jika tidak bisa pop
            }
          },
        ),
        title: Text("My Profile", style: textTheme.titleLarge,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.edit_outlined, color: Config.primaryGreen),
            onPressed: () {
              // TODO: Tampilkan modal untuk edit profil
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Edit profile modal coming soon!'),
                ),
              );
            },
            tooltip: 'Edit Profile',
          ),
          const SizedBox(width: 8),
        ],
      ),
      // Background color juga dari config
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0), // Padding standar
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Kartu Header Profil
              Card(
                // Menggunakan Card agar style (elevation, shape) sesuai config
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Center(
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Config.primaryGreen.withOpacity(0.1),
                          child: Text(
                            userInitials,
                            style: textTheme.headlineLarge?.copyWith(
                              color: Config.primaryGreen,
                              fontSize: 36,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(userName, style: textTheme.headlineMedium),
                        const SizedBox(height: 4),
                        Text(
                          userRole,
                          style: textTheme.bodyLarge?.copyWith(
                            color: Config.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // 2. Kartu Info Kontak
              Text(
                "Contact Information",
                style: textTheme.titleLarge?.copyWith(fontSize: 16),
              ),
              const SizedBox(height: 12),
              Card(
                child: Column(
                  children: [
                    _buildProfileInfoTile(
                      context,
                      icon: Icons.email_outlined,
                      title: userEmail,
                      subtitle: "Email Address",
                    ),
                    const Divider(height: 1, indent: 16, endIndent: 16),
                    _buildProfileInfoTile(
                      context,
                      icon: Icons.phone_outlined,
                      title: userPhone,
                      subtitle: "Phone Number",
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // 3. Kartu Info Akun
              Text(
                "Account Details",
                style: textTheme.titleLarge?.copyWith(fontSize: 16),
              ),
              const SizedBox(height: 12),
              Card(
                child: Column(
                  children: [
                    _buildProfileInfoTile(
                      context,
                      icon: Icons.location_on_outlined,
                      title: userLocation,
                      subtitle: "Location",
                    ),
                    const Divider(height: 1, indent: 16, endIndent: 16),
                    _buildProfileInfoTile(
                      context,
                      icon: Icons.calendar_today_outlined,
                      title: userJoined,
                      subtitle: "Joined Date",
                    ),
                    const Divider(height: 1, indent: 16, endIndent: 16),
                    _buildProfileInfoTile(
                      context,
                      icon: Icons.badge_outlined,
                      title: userId,
                      subtitle: "Employee ID",
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // 4. Kartu Aksi
              Text(
                "Actions",
                style: textTheme.titleLarge?.copyWith(fontSize: 16),
              ),
              const SizedBox(height: 12),
              Card(
                child: Column(
                  children: [
                    _buildProfileInfoTile(
                      context,
                      icon: Icons.lock_outline,
                      title: "Change Password",
                      subtitle: "Update your account security",
                      onTap: () {
                        // TODO: Navigasi ke halaman ganti password
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Change password coming soon!'),
                          ),
                        );
                      },
                    ),
                    const Divider(height: 1, indent: 16, endIndent: 16),
                    // Tombol Logout
                    ListTile(
                      leading: const Icon(Icons.logout, color: Config.errorRed),
                      title: Text(
                        "Logout",
                        style: textTheme.bodyLarge?.copyWith(
                          color: Config.errorRed,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      onTap: () {
                        // Kembali ke Splash Screen (rute '/')
                        context.go('/');
                      },
                      dense: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Helper widget baru untuk item info, menggunakan ListTile
  Widget _buildProfileInfoTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    final textTheme = Theme.of(context).textTheme;
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: Config.primaryGreen),
      title: Text(title, style: textTheme.bodyLarge),
      subtitle: Text(
        subtitle,
        style: textTheme.bodyMedium?.copyWith(color: Config.textSecondary),
      ),
      dense: true,
    );
  }
}

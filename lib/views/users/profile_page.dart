import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mobile_course_fp/config/config.dart';
import 'package:mobile_course_fp/data/provider/auth_provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? _pickedImage;
  final ImagePicker _picker = ImagePicker();

  // Fungsi untuk menangani pengambilan gambar
  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 80, // Kompresi sedikit agar tidak terlalu besar
      );

      if (pickedFile != null) {
        setState(() {
          _pickedImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      debugPrint("Error picking image: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to pick image: $e')),
        );
      }
    }
  }

  // Menampilkan pilihan Camera atau Gallery
  void _showImageSourceOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Photo Library'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.currentUser;

    final String userName = user?.name ?? "Guest";
    final String userRole = user?.role ?? "-";
    final String userEmail = user?.email ?? "-";
    final String userAddress = user?.alamat ?? "-";
    final String userId = user?.empId ?? "-";
    
    final String userJoined = user?.startDate != null 
        ? DateFormat('MMMM dd, yyyy').format(user!.startDate) 
        : "-";

    String userInitials = "";
    if (userName.isNotEmpty) {
      List<String> names = userName.split(" ");
      if (names.length >= 2) {
        userInitials = "${names[0][0]}${names[1][0]}".toUpperCase();
      } else {
        userInitials = names[0][0].toUpperCase();
      }
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Config.textPrimary),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/home');
            }
          },
        ),
        title: Text(
          "My Profile",
          style: textTheme.titleLarge,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.edit_outlined, color: Config.primaryGreen),
            onPressed: () {
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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: user == null 
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // KARTU HEADER PROFIL
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Center(
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            CircleAvatar(
                              radius: 50,
                              backgroundColor: Config.primaryGreen.withOpacity(0.1),
                              // Prioritas Tampilan:
                              // 1. Gambar yang baru dipilih (_pickedImage)
                              // 2. Gambar dari server (user.profileAvatar)
                              // 3. Null (menampilkan inisial)
                              backgroundImage: _pickedImage != null
                                  ? FileImage(_pickedImage!)
                                  : (user.profileAvatar != null && user.profileAvatar!.isNotEmpty
                                      ? NetworkImage(user.profileAvatar!)
                                      : null) as ImageProvider?,
                              child: (_pickedImage == null && (user.profileAvatar == null || user.profileAvatar!.isEmpty))
                                  ? Text(
                                      userInitials,
                                      style: textTheme.headlineLarge?.copyWith(
                                        color: Config.primaryGreen,
                                        fontSize: 36,
                                      ),
                                    )
                                  : null,
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: InkWell(
                                // Memanggil fungsi pilihan Kamera/Galeri
                                onTap: () => _showImageSourceOptions(context),
                                borderRadius: BorderRadius.circular(50),
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Config.primaryGreen,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.white, width: 2),
                                  ),
                                  child: const Icon(
                                    Icons.camera_alt,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                ),
                              ),
                            ),
                          ],
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

              // KARTU KONTAK
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
                      icon: Icons.location_on_outlined,
                      title: userAddress,
                      subtitle: "Address",
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // KARTU DETAIL AKUN
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

              // KARTU AKSI
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
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Change password coming soon!'),
                          ),
                        );
                      },
                    ),
                    const Divider(height: 1, indent: 16, endIndent: 16),
                    ListTile(
                      leading: const Icon(Icons.logout, color: Config.errorRed),
                      title: Text(
                        "Logout",
                        style: textTheme.bodyLarge?.copyWith(
                          color: Config.errorRed,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      onTap: () async {
                        final success = await context.read<AuthProvider>().logout();
                        if (success && context.mounted) {
                          context.go('/'); 
                        }
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

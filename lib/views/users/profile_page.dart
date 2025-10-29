import 'package:flutter/material.dart';
import 'package:mobile_course_fp/components/sidebar.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    const Color mainGreen = Color(0xFF356B52);

    return Scaffold(
      drawer: Sidebar(currentRoute: '/profile'),
      appBar: AppBar(
        backgroundColor: mainGreen,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        title: const Padding(
          padding: EdgeInsets.only(left: 12),
          child: Text(
            "Pharma Ease",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.white,
              fontSize: 18,
            ),
          ),
        ),
        actions: [
          const Padding(
            padding: EdgeInsets.only(right: 8),
            child: CircleAvatar(
              backgroundColor: Colors.lightBlue,
              child: Text("RA", style: TextStyle(color: Colors.white)),
            ),
          ),
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      backgroundColor: const Color(0xFFF5F6F8),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "My Profile",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                "View and manage your account information",
                style: TextStyle(color: Colors.grey[700], fontSize: 14),
              ),
              const SizedBox(height: 24),

              // Card Profil
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Profile Information",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        OutlinedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.edit_outlined,
                              size: 18, color: Colors.black87),
                          label: const Text(
                            "Edit Profile",
                            style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            side:
                                const BorderSide(color: Colors.black87, width: 1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                            backgroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const CircleAvatar(
                      radius: 45,
                      backgroundColor: Color(0xFF356B52),
                      child: Text(
                        "JD",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "Rarara Ra",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                    const Text(
                      "Admin",
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                    const SizedBox(height: 20),

                    // Info Items
                    _infoItem(Icons.email_outlined, "Email Address",
                        "rararara@pharmaease.com"),
                    _infoItem(Icons.phone_outlined, "Phone Number",
                        "0213102301203102"),
                    _infoItem(Icons.location_on_outlined, "Location",
                        "Jawa Barat, Indonesia"),
                    _infoItem(Icons.calendar_today_outlined, "Joined Date",
                        "January 15, 2024"),
                    _infoItem(Icons.badge_outlined, "Employee ID", "PE-2024-001"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoItem(IconData icon, String title, String value) {
    const Color green = Color(0xFF356B52);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: green),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(fontSize: 13, color: Colors.grey)),
              Text(value,
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w500)),
            ],
          ),
        ],
      ),
    );
  }
}

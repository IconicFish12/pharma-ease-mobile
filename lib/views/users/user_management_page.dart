import 'package:flutter/material.dart';
import 'package:mobile_course_fp/components/sidebar.dart';

class UserManagementPage extends StatefulWidget {
  const UserManagementPage({super.key});

  @override
  State<UserManagementPage> createState() => _UserManagementPageState();
}

class _UserManagementPageState extends State<UserManagementPage> {
  final List<Map<String, String>> users = [
    {
      "name": "John Smith",
      "email": "john@pharmaease.com",
      "role": "Admin",
      "status": "Active",
      "lastLogin": "2025-10-20 09:30",
    },
    {
      "name": "Sarah Johnson",
      "email": "sarah@pharmaease.com",
      "role": "Staff",
      "status": "Active",
      "lastLogin": "2025-10-19 14:15",
    },
    {
      "name": "Michael Brown",
      "email": "michael@pharmaease.com",
      "role": "Manager",
      "status": "Inactive",
      "lastLogin": "2025-09-28 16:45",
    },
    {
      "name": "Emily Davis",
      "email": "emily@pharmaease.com",
      "role": "Staff",
      "status": "Active",
      "lastLogin": "2025-10-18 10:20",
    },
    {
      "name": "Daniel Wilson",
      "email": "daniel@pharmaease.com",
      "role": "Admin",
      "status": "Active",
      "lastLogin": "2025-10-21 08:55",
    },
  ];

  @override
  Widget build(BuildContext context) {
    const Color mainGreen = Color(0xFF356B52);

    return Scaffold(
      drawer: const Sidebar(currentRoute: '/users'),
      appBar: AppBar(
        backgroundColor: mainGreen,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        title: const Padding(
          padding: EdgeInsets.only(left: 16),
          child: Text(
            "Pharma Ease",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/profile');
              },
              child: const CircleAvatar(
                backgroundColor: Colors.lightBlue,
                child: Text("RA", style: TextStyle(color: Colors.white)),
              ),
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

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "User Management",
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 27),
              ),
              const Text(
                "Manage your pharmacy operations efficiently",
                style: TextStyle(color: Color.fromARGB(255, 129, 129, 129)),
              ),
              const SizedBox(height: 25),

              Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 1,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "User Management",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Column(
                        spacing: 10,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextField(
                            decoration: InputDecoration(
                              hintText: "Search users...",
                              prefixIcon: const Icon(Icons.search),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: Colors.grey,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 0,
                                horizontal: 12,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton.icon(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 18,
                            ),
                            label: const Text(
                              "Add New User",
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // table
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columns: const [
                            DataColumn(label: Text("Name")),
                            DataColumn(label: Text("Email")),
                            DataColumn(label: Text("Role")),
                            DataColumn(label: Text("Status")),
                            DataColumn(label: Text("Last Login")),
                            DataColumn(label: Text("Actions")),
                          ],
                          rows: users.map((u) {
                            return DataRow(
                              cells: [
                                DataCell(Text(u["name"]!)),
                                DataCell(Text(u["email"]!)),
                                DataCell(Text(u["role"]!)),
                                DataCell(Text(u["status"]!)),
                                DataCell(Text(u["lastLogin"]!)),
                                DataCell(
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit, size: 18),
                                        onPressed: () {},
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.delete,
                                          size: 18,
                                        ),
                                        onPressed: () {},
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: const Color(0xFFF5F6F8),
    );
  }
}

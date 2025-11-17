import 'package:flutter/material.dart';
import '../config/config.dart';
import 'activityHelper.dart';

class ActivityLog extends StatefulWidget {
  const ActivityLog({super.key});

  @override
  State<ActivityLog> createState() => _ActivityLogState();
}

class _ActivityLogState extends State<ActivityLog> {
  // dummy data (nanti sambungkan API)
  List<Map<String, String>> logs = [
    {
      'timestamp': '2025-10-20 09:45:23',
      'user': 'John Smith',
      'role': 'Admin',
      'action': 'Login',
      'module': 'Authentication',
      'details': 'Successful login',
      'ip': '192.168.1.100',
    },
    {
      'timestamp': '2025-10-20 09:46:15',
      'user': 'John Smith',
      'role': 'Admin',
      'action': 'Create',
      'module': 'User Management',
      'details': 'Added new user: Emily Brown',
      'ip': '192.168.1.100',
    },
    {
      'timestamp': '2025-10-20 10:15:30',
      'user': 'Sarah Johnson',
      'role': 'Pharmacist',
      'action': 'Update',
      'module': 'Inventory',
      'details': 'Updated stock for Paracetamol 500mg',
      'ip': '192.168.1.105',
    },
    {
      'timestamp': '2025-10-20 10:30:45',
      'user': 'Mike Davis',
      'role': 'Cashier',
      'action': 'Create',
      'module': 'Transactions',
      'details': 'Processed transaction TXN-20251020-001',
      'ip': '192.168.1.110',
    },
    {
      'timestamp': '2025-10-20 11:00:12',
      'user': 'John Smith',
      'role': 'Admin',
      'action': 'Update',
      'module': 'Supplier Management',
      'details': 'Modified supplier: MediSupply Co.',
      'ip': '192.168.1.100',
    },
    {
      'timestamp': '2025-10-19 16:20:33',
      'user': 'Sarah Johnson',
      'role': 'Pharmacist',
      'action': 'Create',
      'module': 'Purchase Orders',
      'details': 'Created PO-2025-005',
      'ip': '192.168.1.105',
    },
    {
      'timestamp': '2025-10-19 14:30:55',
      'user': 'Robert Wilson',
      'role': 'Cashier',
      'action': 'Failed Login',
      'module': 'Authentication',
      'details': 'Failed login attempt',
      'ip': '192.168.1.115',
    },
    {
      'timestamp': '2025-10-19 13:15:42',
      'user': 'John Smith',
      'role': 'Admin',
      'action': 'Delete',
      'module': 'User Management',
      'details': 'Deactivated user: Test User',
      'ip': '192.168.1.100',
    },
  ];

  String searchText = "";
  String selectedAction = "All Actions";
  String selectedModule = "All Modules";

  final List<String> actions = [
    "All Actions",
    "Login",
    "Create",
    "Update",
    "Failed Login",
    "Delete",
  ];

  final List<String> modules = [
    "All Modules",
    "Authentication",
    "User Management",
    "Inventory",
    "Transactions",
    "Supplier Management",
    "Purchase Orders",
  ];

  // warna untuk badge action
  final Map<String, Color> actionColors = {
    'Login': Colors.green,
    'Create': Colors.blue,
    'Update': Colors.orange,
    'Failed Login': Colors.red,
    'Delete': Colors.redAccent,
  };

  @override
  Widget build(BuildContext context) {
    // filter logic (search + action + module)
    final filteredLogs = logs.where((log) {
      final q = searchText.toLowerCase();
      final matchesSearch =
          log['user']!.toLowerCase().contains(q) ||
          log['action']!.toLowerCase().contains(q) ||
          log['module']!.toLowerCase().contains(q) ||
          log['details']!.toLowerCase().contains(q) ||
          log['ip']!.toLowerCase().contains(q) ||
          log['timestamp']!.toLowerCase().contains(q);

      final matchesAction =
          selectedAction == "All Actions" || log['action'] == selectedAction;
      final matchesModule =
          selectedModule == "All Modules" || log['module'] == selectedModule;

      return matchesSearch && matchesAction && matchesModule;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back),
            ),
            Icon(Icons.bar_chart_rounded, color: Config.primaryGreen),
            SizedBox(width: 8),
            Text('Pharma Ease'),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              backgroundColor: Config.accentBlue,
              child: Text(
                'H',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Activity Log",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              const Text(
                "Manage your pharmacy operations efficiently",
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 20),

              // info box
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFE9F6EE),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.shield_outlined, color: Color(0xFF356B52)),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "System Activity Log",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF356B52),
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "Secure tracking of all employee activities and system changes",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // activity container
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // header + export
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Activity Log",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Column(
                          children: [
                            ElevatedButton.icon(
                              onPressed: () async {
                                try {
                                  await exportCSVwithSAF(logs, "activity_log");
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("CSV berhasil disimpan"),
                                    ),
                                  );
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text("Gagal export: $e")),
                                  );
                                }
                              },
                              icon: const Icon(Icons.download),
                              label: const Text("Export Activity Log"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF356B52),
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // search
                    TextField(
                      onChanged: (v) => setState(() => searchText = v),
                      decoration: InputDecoration(
                        hintText: "Search activities...",
                        prefixIcon: const Icon(Icons.search),
                        filled: true,
                        fillColor: const Color(0xFFF4F4F4),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // filters
                    const Text(
                      "Filter by Action",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 6),
                    DropdownButtonFormField<String>(
                      initialValue: selectedAction,
                      items: actions
                          .map(
                            (a) => DropdownMenuItem(value: a, child: Text(a)),
                          )
                          .toList(),
                      onChanged: (v) => setState(() => selectedAction = v!),
                      decoration: _dropdownDecoration(),
                    ),
                    const SizedBox(height: 16),

                    const Text(
                      "Filter by Module",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 6),
                    DropdownButtonFormField<String>(
                      initialValue: selectedModule,
                      items: modules
                          .map(
                            (m) => DropdownMenuItem(value: m, child: Text(m)),
                          )
                          .toList(),
                      onChanged: (v) => setState(() => selectedModule = v!),
                      decoration: _dropdownDecoration(),
                    ),

                    const SizedBox(height: 20),

                    // table (horizontal scroll)
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        // minimal styling
                        headingRowColor: WidgetStateProperty.resolveWith(
                          (states) => const Color(0xFFF4F4F4),
                        ),
                        columns: const [
                          DataColumn(label: Text("Timestamp")),
                          DataColumn(label: Text("User")),
                          DataColumn(label: Text("Role")),
                          DataColumn(label: Text("Action")),
                          DataColumn(label: Text("Module")),
                          DataColumn(label: Text("Details")),
                          DataColumn(label: Text("IP Address")),
                        ],
                        rows: filteredLogs.map((r) {
                          final action = r['action']!;
                          final color = actionColors[action] ?? Colors.grey;
                          return DataRow(
                            cells: [
                              DataCell(Text(r['timestamp']!)),
                              DataCell(Text(r['user']!)),
                              DataCell(Text(r['role']!)),
                              DataCell(
                                Chip(
                                  label: Text(
                                    action,
                                    style: TextStyle(color: color),
                                  ),
                                  backgroundColor: color.withOpacity(0.12),
                                ),
                              ),
                              DataCell(Text(r['module']!)),
                              DataCell(
                                SizedBox(
                                  width: 300,
                                  child: Text(
                                    r['details']!,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              DataCell(Text(r['ip']!)),
                            ],
                          );
                        }).toList(),
                      ),
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

  InputDecoration _dropdownDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: const Color(0xFFF4F4F4),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }
}

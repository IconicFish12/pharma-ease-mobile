import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../config/config.dart';
import 'activityHelper.dart';
import 'package:intl/intl.dart';

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

  // (PERBAIKAN) warna dan ikon untuk badge action
  // Menggunakan warna dari Config
  final Map<String, Color> actionColors = {
    'Login': Config.successGreen,
    'Create': Config.accentBlue,
    'Update': Colors.orange,
    'Failed Login': Config.errorRed,
    'Delete': Config.errorRed,
  };

  // (BARU) Ikon untuk setiap aksi
  final Map<String, IconData> actionIcons = {
    'Login': Icons.login_outlined,
    'Create': Icons.add_circle_outline,
    'Update': Icons.edit_outlined,
    'Failed Login': Icons.warning_amber_rounded,
    'Delete': Icons.delete_outline,
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
                // (PERBAIKAN) Menggunakan context.pop() dari go_router
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.go('/home'); // Fallback ke home
                }
              },
              icon: Icon(Icons.arrow_back),
            ),
            Image.asset('assets/images/app_logo.png', width: 40),
            SizedBox(width: 8),
            Text('Pharma Ease'),
          ],
        ),
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
                              label: const Text("Export"),
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

                    // --- (PERUBAHAN TOTAL DI SINI) ---
                    // Mengganti DataTable dengan ListView.builder
                    ListView.builder(
                      itemCount: filteredLogs.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final log = filteredLogs[index];
                        final action = log['action']!;
                        final color = actionColors[action] ?? Colors.grey;
                        final icon = actionIcons[action] ?? Icons.info_outline;

                        return _ActivityLogItem(
                          log: log,
                          actionColor: color,
                          actionIcon: icon,
                          onTap: () {
                            _showLogDetailsDialog(context, log, color, icon);
                          },
                        );
                      },
                    ),
                    // --- (AKHIR DARI PERUBAHAN) ---
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // (BARU) Dialog untuk menampilkan detail log
  void _showLogDetailsDialog(
    BuildContext context,
    Map<String, String> log,
    Color actionColor,
    IconData actionIcon,
  ) {
    final textTheme = Theme.of(context).textTheme;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(actionIcon, color: actionColor),
              SizedBox(width: 8),
              Text(
                'Log Details: ${log['action']}',
                style: textTheme.titleLarge?.copyWith(color: actionColor),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailRow(context, 'Timestamp:', log['timestamp']!),
                _buildDetailRow(context, 'User:', log['user']!),
                _buildDetailRow(context, 'Role:', log['role']!),
                _buildDetailRow(context, 'Module:', log['module']!),
                _buildDetailRow(context, 'Details:', log['details']!),
                _buildDetailRow(context, 'IP Address:', log['ip']!),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Close',
                style: TextStyle(color: Config.primaryGreen),
              ),
            ),
          ],
        );
      },
    );
  }

  // (BARU) Helper widget untuk baris detail di dialog
  Widget _buildDetailRow(BuildContext context, String label, String value) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: textTheme.bodyMedium?.copyWith(color: Config.textSecondary),
          ),
          SizedBox(height: 2),
          Text(value, style: textTheme.bodyLarge,
          ),
        ],
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

class _ActivityLogItem extends StatelessWidget {
  final Map<String, String> log;
  final Color actionColor;
  final IconData actionIcon;
  final VoidCallback onTap;

  const _ActivityLogItem({
    required this.log,
    required this.actionColor,
    required this.actionIcon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      elevation: 1, // Elevasi halus
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        onTap: onTap, // Aksi interaktif
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: actionColor.withOpacity(0.1),
          child: Icon(actionIcon, color: actionColor, size: 20),
        ),
        title: Text.rich(
          TextSpan(
            style: textTheme.bodyLarge,
            children: [
              TextSpan(
                text: log['user'],
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text: ' (${log['role']})',
                style: textTheme.bodyMedium?.copyWith(
                  color: Config.textSecondary,
                ),
              ),
            ],
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4),
            Text(
              log['details']!,
              style: textTheme.bodyMedium,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 4),
            Text(
              // Format tanggal agar lebih mudah dibaca
              _formatTimestamp(log['timestamp']!),
              style: textTheme.bodySmall?.copyWith(color: Config.textSecondary),
            ),
          ],
        ),
        trailing: Chip(
          label: Text(
            log['action']!,
            style: textTheme.labelSmall?.copyWith(
              color: actionColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: actionColor.withOpacity(0.1),
          padding: EdgeInsets.zero,
        ),
        isThreeLine: true,
      ),
    );
  }

  // (BARU) Helper untuk memformat tanggal
  String _formatTimestamp(String timestamp) {
    try {
      final dateTime = DateTime.parse(timestamp);
      // Format: 20 Okt 2025, 09:45
      return DateFormat('dd MMM yyyy, HH:mm').format(dateTime);
    } catch (e) {
      return timestamp; // Kembalikan teks asli jika format gagal
    }
  }
}

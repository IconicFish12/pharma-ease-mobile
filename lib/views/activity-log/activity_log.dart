import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../config/config.dart';
import '../../data/model/activity_log_model.dart';
import '../../data/provider/activity_log_provider.dart';
import 'activityHelper.dart'; // Pastikan file export helper kamu ada/disesuaikan

class ActivityLog extends StatefulWidget {
  const ActivityLog({super.key});

  @override
  State<ActivityLog> createState() => _ActivityLogState();
}

class _ActivityLogState extends State<ActivityLog> {
  String searchText = "";
  String selectedAction = "All Actions";
  String selectedModule = "All Modules";

  final List<String> actions = [
    "All Actions",
    "Login",
    "Created", // Sesuaikan dengan Enum Description
    "Updated",
    "Deleted",
  ];

  final List<String> modules = [
    "All Modules",
    "Authentication",
    "User Management",
    "Inventory",
    "Transactions",
    "Supplier Management",
  ];

  // Helper untuk warna berdasarkan string Action
  Color _getActionColor(String action) {
    switch (action.toLowerCase()) {
      case 'login':
        return Config.successGreen;
      case 'created':
        return Config.accentBlue;
      case 'updated':
        return Colors.orange;
      case 'deleted':
        return Config.errorRed;
      default:
        return Colors.grey;
    }
  }

  // Helper untuk icon berdasarkan string Action
  IconData _getActionIcon(String action) {
    switch (action.toLowerCase()) {
      case 'login':
        return Icons.login_outlined;
      case 'created':
        return Icons.add_circle_outline;
      case 'updated':
        return Icons.edit_outlined;
      case 'deleted':
        return Icons.delete_outline;
      default:
        return Icons.info_outline;
    }
  }

  @override
  void initState() {
    super.initState();
    // Panggil API saat halaman dibuka
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ActivityLogProvider>().fetchLogs();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            IconButton(
              onPressed: () {
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.go('/home');
                }
              },
              icon: const Icon(Icons.arrow_back),
            ),
            Image.asset('assets/images/app_logo.png', width: 40),
            const SizedBox(width: 8),
            const Text('Pharma Ease'),
          ],
        ),
      ),
      body: SafeArea(
        child: Consumer<ActivityLogProvider>(
          builder: (context, provider, child) {
            // === 1. HANDLING STATE ===
            if (provider.state == ViewState.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (provider.state == ViewState.error) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, color: Colors.red, size: 48),
                    const SizedBox(height: 16),
                    Text("Error: ${provider.errorMessage}"),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => provider.fetchLogs(),
                      child: const Text("Retry"),
                    )
                  ],
                ),
              );
            }

            // === 2. FILTERING LOGIC (Client Side) ===
            // Kita filter data list yang sudah ada di Provider
            final filteredLogs = provider.logs.where((log) {
              // Extract data dari Model Datum ke String sederhana
              final actionStr = _parseEnum(log.description.toString());
              final moduleStr = log.logName ?? '-';
              final userStr = _getUserName(log);
              final detailsStr = provider.getChangeSummary(log);
              
              final q = searchText.toLowerCase();
              
              // Cek Search Text
              final matchesSearch =
                  userStr.toLowerCase().contains(q) ||
                  actionStr.toLowerCase().contains(q) ||
                  moduleStr.toLowerCase().contains(q) ||
                  detailsStr.toLowerCase().contains(q);

              // Cek Dropdown Action
              final matchesAction =
                  selectedAction == "All Actions" || 
                  actionStr.toLowerCase() == selectedAction.toLowerCase();

              // Cek Dropdown Module
              // Note: Karena module dari API dinamis, logic contains lebih aman
              final matchesModule =
                  selectedModule == "All Modules" || 
                  moduleStr.toLowerCase().contains(selectedModule.toLowerCase()) || 
                  (selectedModule == "Inventory" && moduleStr == "Medicine Management"); // Contoh mapping

              return matchesSearch && matchesAction && matchesModule;
            }).toList();

            return SingleChildScrollView(
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

                  // Info Box
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

                  // Activity Container
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
                        // Header + Export
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "History",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            ElevatedButton.icon(
                              onPressed: () async {
                                // Konversi List<Datum> ke List<Map> agar fungsi export lama tetap jalan
                                final exportData = filteredLogs.map((log) => {
                                  'timestamp': log.createdAt.toString(),
                                  'user': _getUserName(log),
                                  'action': _parseEnum(log.description.toString()),
                                  'details': provider.getChangeSummary(log),
                                }).toList();

                                try {
                                  await exportCSVwithSAF(exportData, "activity_log");
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("CSV berhasil disimpan")),
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
                        const SizedBox(height: 16),

                        // Search Field
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

                        // Filters
                        const Text("Filter by Action", style: TextStyle(fontWeight: FontWeight.w600)),
                        const SizedBox(height: 6),
                        DropdownButtonFormField<String>(
                          initialValue: selectedAction,
                          items: actions.map((a) => DropdownMenuItem(value: a, child: Text(a))).toList(),
                          onChanged: (v) => setState(() => selectedAction = v!),
                          decoration: _dropdownDecoration(),
                        ),
                        const SizedBox(height: 16),

                        const Text("Filter by Module", style: TextStyle(fontWeight: FontWeight.w600)),
                        const SizedBox(height: 6),
                        DropdownButtonFormField<String>(
                          initialValue: selectedModule,
                          items: modules.map((m) => DropdownMenuItem(value: m, child: Text(m))).toList(),
                          onChanged: (v) => setState(() => selectedModule = v!),
                          decoration: _dropdownDecoration(),
                        ),
                        const SizedBox(height: 20),

                        // === 3. LIST VIEW (Real Data) ===
                        if (filteredLogs.isEmpty)
                           const Padding(
                             padding: EdgeInsets.all(20),
                             child: Center(child: Text("No logs found.")),
                           )
                        else
                          ListView.builder(
                            itemCount: filteredLogs.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              final log = filteredLogs[index];
                              
                              // Extract properties for display
                              final actionStr = _parseEnum(log.description.toString());
                              final userStr = _getUserName(log);
                              final detailsStr = provider.getChangeSummary(log);
                              final timestampStr = log.createdAt.toString();
                              
                              final color = _getActionColor(actionStr);
                              final icon = _getActionIcon(actionStr);

                              return _ActivityLogItem(
                                userName: userStr,
                                role: log.properties?.role?.toString().split('.').last ?? '-',
                                action: actionStr,
                                details: detailsStr,
                                timestamp: timestampStr,
                                actionColor: color,
                                actionIcon: icon,
                                onTap: () {
                                  _showLogDetailsDialog(context, log, actionStr, color, icon);
                                },
                              );
                            },
                          ),
                          
                          // Tombol Load More (Optional, jika API support pagination)
                          if (provider.logs.isNotEmpty && provider.state != ViewState.loadingMore)
                             Padding(
                               padding: const EdgeInsets.only(top: 10),
                               child: Center(
                                 child: TextButton(
                                   onPressed: () => provider.loadMore(), 
                                   child: const Text("Load More"),
                                 ),
                               ),
                             ),
                           if (provider.state == ViewState.loadingMore)
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Center(child: CircularProgressIndicator()),
                              ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // --- Helper Methods ---

  // Karena Model menggunakan Enum (Description.CREATED), kita perlu parse stringnya
  String _parseEnum(String enumString) {
    // Input: "Description.CREATED" -> Output: "Created"
    if (enumString.contains('.')) {
      return toBeginningOfSentenceCase(enumString.split('.').last.toLowerCase()) ?? enumString;
    }
    return enumString;
  }

  // Helper untuk ambil nama user dengan aman
  String _getUserName(Datum log) {
    // Coba ambil dari Causer -> Name (Enum)
    if (log.causer?.name != null) {
      return _parseEnum(log.causer!.name.toString());
    }
    // Backup ambil dari Properties -> UserName (Enum)
    if (log.properties?.userName != null) {
       return _parseEnum(log.properties!.userName.toString());
    }
    return "Unknown User";
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

  // Dialog Detail
  void _showLogDetailsDialog(
    BuildContext context,
    Datum log,
    String actionStr,
    Color actionColor,
    IconData actionIcon,
  ) {
    final textTheme = Theme.of(context).textTheme;
    final provider = context.read<ActivityLogProvider>();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              Icon(actionIcon, color: actionColor),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Log Details: $actionStr',
                  style: textTheme.titleLarge?.copyWith(color: actionColor, fontSize: 18),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailRow(context, 'Timestamp:', _formatTimestamp(log.createdAt.toString())),
                _buildDetailRow(context, 'User:', _getUserName(log)),
                _buildDetailRow(context, 'Module:', log.logName ?? '-'),
                const Divider(),
                _buildDetailRow(context, 'Details:', provider.getChangeSummary(log)),
                _buildDetailRow(context, 'IP Address:', log.properties?.ip?.toString().split('.').last ?? '-'),
                if (log.subjectId != null)
                   _buildDetailRow(context, 'Subject ID:', log.subjectId!),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close', style: TextStyle(color: Color(0xFF356B52))),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          const SizedBox(height: 2),
          Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
  
  String _formatTimestamp(String timestamp) {
    try {
      final dateTime = DateTime.parse(timestamp);
      return DateFormat('dd MMM yyyy, HH:mm').format(dateTime);
    } catch (e) {
      return timestamp;
    }
  }
}

// Widget Item List Terpisah (Agar lebih bersih)
class _ActivityLogItem extends StatelessWidget {
  final String userName;
  final String role;
  final String action;
  final String details;
  final String timestamp;
  final Color actionColor;
  final IconData actionIcon;
  final VoidCallback onTap;

  const _ActivityLogItem({
    required this.userName,
    required this.role,
    required this.action,
    required this.details,
    required this.timestamp,
    required this.actionColor,
    required this.actionIcon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: actionColor.withOpacity(0.1),
          child: Icon(actionIcon, color: actionColor, size: 20),
        ),
        title: Text.rich(
          TextSpan(
            style: const TextStyle(fontSize: 16, color: Colors.black),
            children: [
              TextSpan(text: userName, style: const TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(text: ' ($role)', style: const TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(details, maxLines: 2, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 4),
            Text(
              _formatDate(timestamp),
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
        trailing: Chip(
          label: Text(
            action,
            style: TextStyle(color: actionColor, fontWeight: FontWeight.bold, fontSize: 10),
          ),
          backgroundColor: actionColor.withOpacity(0.1),
          padding: EdgeInsets.zero,
          visualDensity: VisualDensity.compact,
        ),
      ),
    );
  }

  String _formatDate(String timestamp) {
    try {
      final dt = DateTime.parse(timestamp);
      return DateFormat('dd MMM yyyy, HH:mm').format(dt);
    } catch (e) {
      return timestamp;
    }
  }
}
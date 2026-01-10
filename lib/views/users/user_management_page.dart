import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:mobile_course_fp/data/model/user_model.dart';
import 'package:mobile_course_fp/data/provider/user_provider.dart';
import 'package:mobile_course_fp/data/provider/provider.dart';

class UserManagementPage extends StatefulWidget {
  const UserManagementPage({super.key});

  @override
  State<UserManagementPage> createState() => _UserManagementPageState();
}

class _UserManagementPageState extends State<UserManagementPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<UserProvider>().fetchList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _addUser(Datum newUser) async {
    final provider = context.read<UserProvider>();
    final bool success = await provider.addData(data: newUser);

    if (mounted) {
      if (success) {
        Navigator.pop(context);
        context.read<UserProvider>().fetchList();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('User added successfully'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed: ${provider.errorMessage}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _updateUser(Datum updatedUser) async {
    final provider = context.read<UserProvider>();
    final bool success = await provider.updateData(
      updatedUser.id,
      data: updatedUser,
    );

    if (mounted) {
      if (success) {
        Navigator.pop(context);
        context.read<UserProvider>().fetchList();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('User updated successfully'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed: ${provider.errorMessage}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _deleteUser(dynamic userId) async {
    final provider = context.read<UserProvider>();
    final bool success = await provider.deleteData(userId);

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User deleted successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete: ${provider.errorMessage}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _onSearch(String query) {
    context.read<UserProvider>().fetchList(params: {'search': query});
  }

  void _showAddEditUserModal({bool isEditMode = false, Datum? user}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: _AddEditUserModal(
          isEditMode: isEditMode,
          userToEdit: user,
          onSave: isEditMode ? _updateUser : _addUser,
          onDelete: _deleteUser,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('User Management', style: textTheme.titleLarge),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await context.read<UserProvider>().fetchList();
        },
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'User & Employee Management',
                    style: textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 16),
                  _buildSearchBar(context),
                ],
              ),
            ),
            Expanded(
              child: Consumer<UserProvider>(
                builder: (context, provider, child) {
                  if (provider.state == ViewState.loading &&
                      provider.listData.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (provider.state == ViewState.error) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            color: Colors.red,
                            size: 48,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "Terjadi Kesalahan:",
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              provider.errorMessage ?? "Unknown Error",
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              context.read<UserProvider>().fetchList();
                            },
                            child: const Text("Coba Lagi"),
                          ),
                        ],
                      ),
                    );
                  }

                  if (provider.listData.isEmpty) {
                    return const Center(child: Text("Belum ada data user."));
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    itemCount: provider.listData.length,
                    itemBuilder: (context, index) {
                      final user = provider.listData[index];
                      return UserListItem(
                        user: user,
                        onTap: () =>
                            _showAddEditUserModal(isEditMode: true, user: user),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddEditUserModal(isEditMode: false),
        backgroundColor: Colors.green,
        label: const Text('Add New User'),
        icon: const Icon(Icons.person_add_alt_1_outlined),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return TextField(
      controller: _searchController,
      onSubmitted: _onSearch,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: 'Search users...',
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.grey[100],
        contentPadding: const EdgeInsets.symmetric(vertical: 0),
      ),
    );
  }
}

class UserListItem extends StatelessWidget {
  final Datum user;
  final VoidCallback onTap;

  const UserListItem({super.key, required this.user, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

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

class _AddEditUserModal extends StatefulWidget {
  final bool isEditMode;
  final Datum? userToEdit;
  final Function(Datum) onSave;
  final Function(dynamic) onDelete;

  const _AddEditUserModal({
    required this.isEditMode,
    this.userToEdit,
    required this.onSave,
    required this.onDelete,
  });

  @override
  State<_AddEditUserModal> createState() => _AddEditUserModalState();
}

class _AddEditUserModalState extends State<_AddEditUserModal> {
  final _formKey = GlobalKey<FormState>();

  late String _userId;
  late String _fullName;
  late String _email;
  late String _empId;
  late String _role;
  late String _shift;
  late String _salary;
  late String _address;
  late String _password;

  String? _dateOfBirth;
  String? _startDate;

  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  bool _obscurePassword = true;

  final List<String> _roles = ['admin', 'pharmacist', 'cashier', 'owner'];
  final List<String> _shifts = ['pagi', 'siang', 'sore'];

  @override
  void initState() {
    super.initState();
    if (widget.isEditMode && widget.userToEdit != null) {
      final u = widget.userToEdit!;
      _userId = u.id ?? '';
      _fullName = u.name ?? '';
      _email = u.email ?? '';
      _empId = u.empId ?? '';
      _role = _roles.contains(u.role) ? u.role! : 'cashier';
      _shift = _shifts.contains(u.shift) ? u.shift! : 'pagi';

      if (u.salary != null) {
        _salary = u.salary.toString().replaceAll(RegExp(r'[^0-9]'), '');
      } else {
        _salary = '';
      }

      _address = u.address ?? '';
      _dateOfBirth = u.dateOfBirth;
      _startDate = u.startDate;
      _password = '';
    } else {
      _userId = '';
      _fullName = '';
      _email = '';
      _empId = '';
      _role = 'cashier';
      _shift = 'pagi';
      _salary = '';
      _address = '';
      _password = '';
      _startDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    }

    if (_dateOfBirth != null) {
      _dobController.text = _formatDateDisplay(_dateOfBirth!);
    }
    if (_startDate != null) {
      _startDateController.text = _formatDateDisplay(_startDate!);
    }
  }

  String _formatDateDisplay(String yyyyMMdd) {
    try {
      DateTime dt = DateFormat('yyyy-MM-dd').parse(yyyyMMdd);
      return DateFormat('dd MMM yyyy').format(dt);
    } catch (e) {
      return yyyyMMdd;
    }
  }

  Future<void> _selectDate(BuildContext context, bool isDob) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.green,
              onPrimary: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      String formattedForApi = DateFormat('yyyy-MM-dd').format(picked);
      String formattedForDisplay = DateFormat('dd MMM yyyy').format(picked);

      setState(() {
        if (isDob) {
          _dateOfBirth = formattedForApi;
          _dobController.text = formattedForDisplay;
        } else {
          _startDate = formattedForApi;
          _startDateController.text = formattedForDisplay;
        }
      });
    }
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final user = Datum(
        id: widget.isEditMode ? widget.userToEdit!.id : null,
        name: _fullName,
        email: _email,
        empId: _empId,
        role: _role,
        shift: _shift,
        salary: int.tryParse(_salary.replaceAll(RegExp(r'[^0-9]'), '')),
        address: _address,
        dateOfBirth: _dateOfBirth,
        startDate: _startDate,
        password: (widget.isEditMode && _password.isEmpty) ? null : _password,
      );

      widget.onSave(user);
    }
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete User'),
        content: Text(
          'Are you sure you want to delete ${widget.userToEdit?.name}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              Navigator.pop(dialogContext);

              final success = await context.read<UserProvider>().deleteData(
                widget.userToEdit?.id,
              );

              if (success && context.mounted) {
                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('User deleted successfully'),
                    backgroundColor: Colors.green,
                  ),
                );
              } else if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Failed to delete user'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.all(24.0),
      child: SingleChildScrollView(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.isEditMode ? 'Edit User' : 'Add New User',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    initialValue: _fullName,
                    decoration: const InputDecoration(
                      labelText: 'Full Name',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                    validator: (v) => v!.isEmpty ? 'Required' : null,
                    onSaved: (v) => _fullName = v!,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    initialValue: _empId,
                    decoration: const InputDecoration(
                      labelText: 'Employee ID',
                      prefixIcon: Icon(Icons.badge_outlined),
                    ),
                    validator: (v) => v!.isEmpty ? 'Required' : null,
                    onSaved: (v) => _empId = v!,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _roles.contains(_role) ? _role : _roles.first,
                          decoration: const InputDecoration(
                            labelText: 'Role',
                            prefixIcon: Icon(
                              Icons.admin_panel_settings_outlined,
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 15,
                            ),
                          ),
                          items: _roles
                              .map(
                                (r) => DropdownMenuItem(
                                  value: r,
                                  child: Text(
                                    r.toUpperCase(),
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (v) => setState(() => _role = v!),
                          onSaved: (v) => _role = v!,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _shifts.contains(_shift)
                              ? _shift
                              : _shifts.first,
                          decoration: const InputDecoration(
                            labelText: 'Shift',
                            prefixIcon: Icon(Icons.schedule),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 15,
                            ),
                          ),
                          items: _shifts
                              .map(
                                (s) => DropdownMenuItem(
                                  value: s,
                                  child: Text(
                                    s.toUpperCase(),
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (v) => setState(() => _shift = v!),
                          onSaved: (v) => _shift = v!,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    initialValue: _salary,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: const InputDecoration(
                      labelText: 'Salary',
                      prefixIcon: Icon(Icons.monetization_on_outlined),
                      prefixText: 'Rp ',
                    ),
                    validator: (v) => v!.isEmpty ? 'Required' : null,
                    onSaved: (v) => _salary = v!,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _dobController,
                          readOnly: true,
                          onTap: () => _selectDate(context, true),
                          decoration: const InputDecoration(
                            labelText: 'Birth Date',
                            suffixIcon: Icon(Icons.calendar_today),
                          ),
                          validator: (v) =>
                              _dateOfBirth == null ? 'Required' : null,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: _startDateController,
                          readOnly: true,
                          onTap: () => _selectDate(context, false),
                          decoration: const InputDecoration(
                            labelText: 'Joined Date',
                            suffixIcon: Icon(Icons.work_history_outlined),
                          ),
                          validator: (v) =>
                              _startDate == null ? 'Required' : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    initialValue: _address,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      labelText: 'Address',
                      prefixIcon: Icon(Icons.home_outlined),
                    ),
                    validator: (v) => v!.isEmpty ? 'Required' : null,
                    onSaved: (v) => _address = v!,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    initialValue: _email,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                    validator: (v) =>
                        !v!.contains('@') ? 'Invalid email' : null,
                    onSaved: (v) => _email = v!,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      labelText: widget.isEditMode
                          ? 'Password (Leave empty to keep)'
                          : 'Password',
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () => setState(
                          () => _obscurePassword = !_obscurePassword,
                        ),
                      ),
                    ),
                    validator: (v) {
                      if (!widget.isEditMode) {
                        if (v == null || v.isEmpty) return 'Required';
                        if (v.length < 6) return 'Min 6 chars';
                      } else {
                        if (v != null && v.isNotEmpty && v.length < 6)
                          return 'Min 6 chars';
                      }
                      return null;
                    },
                    onSaved: (v) => _password = v ?? '',
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: _saveForm,
                      child: Text(
                        widget.isEditMode ? 'Update Data' : 'Save User',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  if (widget.isEditMode)
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: TextButton.icon(
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.red,
                        ),
                        onPressed: _confirmDelete,
                        icon: const Icon(Icons.delete_outline),
                        label: const Text('Delete This User'),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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

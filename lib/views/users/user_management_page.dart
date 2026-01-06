import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:mobile_course_fp/data/model/user_model.dart';
import 'package:mobile_course_fp/data/provider/user_provider.dart';

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserProvider>().getMany();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _addUser(Datum newUser) async {
    final provider = context.read<UserProvider>();
    final bool success = await provider.create(newUser);

    if (mounted) {
      if (success) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User added successfully')),
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
    final bool success = await provider.update(updatedUser.id, updatedUser);

    if (mounted) {
      if (success) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User updated successfully')),
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
    final bool success = await provider.delete(userId);

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
    context.read<UserProvider>().getMany(search: query);
  }

  void _loadMore() {
    context.read<UserProvider>().getMany(isLoadMore: true);
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
    final provider = context.watch<UserProvider>();
    final List<Datum> userList = provider.listData;
    final bool isLoading = provider.isLoading;

    return Scaffold(
      appBar: AppBar(
        title: Text('User Management', style: textTheme.titleLarge),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await context.read<UserProvider>().getMany();
        },
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.all(16.0),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  Text(
                    'User & Employee Management',
                    style: textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 16),
                  _buildSearchBar(context),
                  const SizedBox(height: 16),
                ]),
              ),
            ),
            if (userList.isEmpty && isLoading)
              const SliverToBoxAdapter(
                child: Center(child: CircularProgressIndicator()),
              )
            else if (userList.isEmpty)
              const SliverToBoxAdapter(
                child: Center(child: Text("No users found")),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    if (index == userList.length) {
                      if (provider.hasMoreData) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: isLoading
                              ? const Center(child: CircularProgressIndicator())
                              : ElevatedButton.icon(
                                  onPressed: _loadMore,
                                  icon: const Icon(Icons.arrow_downward),
                                  label: const Text("Load More Users"),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.grey[200],
                                    foregroundColor: Colors.black,
                                  ),
                                ),
                        );
                      } else {
                        return const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Center(child: Text("All users loaded")),
                        );
                      }
                    }

                    final user = userList[index];
                    return UserListItem(
                      user: user,
                      onTap: () =>
                          _showAddEditUserModal(isEditMode: true, user: user),
                    );
                  }, childCount: userList.length + 1),
                ),
              ),
            const SliverToBoxAdapter(child: SizedBox(height: 80)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddEditUserModal(isEditMode: false),
        backgroundColor: Colors.green,
        label: const Text('Add New User'),
        icon: const Icon(Icons.person_add_alt_1_outlined),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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

    String lastLoginText = '-';
    if (user.createdAt != null && user.createdAt!.isNotEmpty) {
      try {
        final DateTime date = DateTime.parse(user.createdAt!);
        lastLoginText = DateFormat('dd MMM yyyy').format(date);
      } catch (e) {
        lastLoginText = user.createdAt!;
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
            Text(
              '${user.role?.toUpperCase()} • ${user.shift?.toUpperCase() ?? '-'}',
              style: textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            Text(
              'Joined: $lastLoginText',
              style: textTheme.bodySmall?.copyWith(color: Colors.grey),
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
  final List<String> _shifts = ['pagi', 'siang', 'malam'];

  @override
  void initState() {
    super.initState();
    if (widget.isEditMode && widget.userToEdit != null) {
      final u = widget.userToEdit!;
      _fullName = u.name ?? '';
      _email = u.email ?? '';
      _empId = u.empId ?? '';
      _role = u.role ?? 'cashier';
      _shift = u.shift ?? 'pagi';
      _salary = u.salary?.toString() ?? '';
      _dateOfBirth = u.dateOfBirth;
      _startDate = u.startDate;
      _address = u.address ?? '';
      _password = '';
    } else {
      _fullName = '';
      _email = '';
      _empId = '';
      _role = 'cashier';
      _shift = 'pagi';
      _salary = '';
      _dateOfBirth = null;
      _startDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
      _address = '';
      _password = '';
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
      if (RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(yyyyMMdd)) {
        DateTime dt = DateFormat('yyyy-MM-dd').parse(yyyyMMdd);
        return DateFormat('dd MMM yyyy').format(dt);
      }
      return yyyyMMdd;
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
        salary: _salary, 
        address: _address,
        dateOfBirth: _dateOfBirth,
        startDate: _startDate,
        password: _password.isEmpty ? null : _password,
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
            onPressed: () {
              widget.onDelete(widget.userToEdit!.id);
              Navigator.pop(dialogContext);
              Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
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
                  style: textTheme.headlineMedium,
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
                      hintText: 'John Smith',
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
                      hintText: 'EMP-001',
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
                          ),
                          items: _roles
                              .map(
                                (r) => DropdownMenuItem(
                                  value: r,
                                  child: Text(r.toUpperCase()),
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
                          ),
                          items: _shifts
                              .map(
                                (s) => DropdownMenuItem(
                                  value: s,
                                  child: Text(s.toUpperCase()),
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
                      labelText: 'Salary (Rp)',
                      hintText: 'e.g 5000000',
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
                      hintText: 'Complete home address',
                      prefixIcon: Icon(Icons.home_outlined),
                      alignLabelWithHint: true,
                    ),
                    validator: (v) => v!.isEmpty ? 'Required' : null,
                    onSaved: (v) => _address = v!,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    initialValue: _email,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      hintText: 'mail@example.com',
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                    validator: (v) =>
                        !v!.contains('@') ? 'Invalid email' : null,
                    onSaved: (v) => _email = v!,
                  ),
                  const SizedBox(height: 16),
                  if (!widget.isEditMode)
                    TextFormField(
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        labelText: 'Password',
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
                        }
                        return null;
                      },
                      onSaved: (v) => _password = v!,
                    ),
                  const SizedBox(height: 32),
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
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
                      ),
                    ],
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
      return parts[0][0].toUpperCase() + parts[1][0].toUpperCase();
    }
    return parts[0][0].toUpperCase();
  }
}

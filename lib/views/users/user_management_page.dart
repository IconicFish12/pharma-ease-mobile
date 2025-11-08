import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_course_fp/views/users/user_model.dart';
import '../../config/config.dart';

class UserManagementPage extends StatefulWidget {
  const UserManagementPage({super.key});

  @override
  State<UserManagementPage> createState() => _UserManagementPageState();
}

class _UserManagementPageState extends State<UserManagementPage> {
  final List<User> _users = [
    User(
      id: 'USR001',
      fullName: 'John Smith',
      email: 'john@pharmaease.com',
      role: UserRole.admin,
      lastLogin: DateTime(2025, 10, 20, 9, 30),
      status: UserStatus.active,
    ),
    User(
      id: 'USR002',
      fullName: 'Sarah Johnson',
      email: 'sarah@pharmaease.com',
      role: UserRole.pharmacist,
      lastLogin: DateTime(2025, 10, 20, 8, 15),
      status: UserStatus.active,
    ),
    User(
      id: 'USR003',
      fullName: 'Mike Davis',
      email: 'mike@pharmaease.com',
      role: UserRole.cashier,
      lastLogin: DateTime(2025, 10, 19, 17, 45),
      status: UserStatus.active,
    ),
    User(
      id: 'USR004',
      fullName: 'Emily Brown',
      email: 'emily@pharmaease.com',
      role: UserRole.pharmacist,
      lastLogin: DateTime(2025, 10, 19, 16, 20),
      status: UserStatus.active,
    ),
    User(
      id: 'USR005',
      fullName: 'Robert Wilson',
      email: 'robert@pharmaease.com',
      role: UserRole.cashier,
      lastLogin: DateTime(2025, 10, 15, 14, 10),
      status: UserStatus.inactive,
    ),
  ];

  void _addUser(User newUser) {
    setState(() {
      _users.add(newUser);
    });
    Navigator.pop(context);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('User added successfully!')));
  }

  void _updateUser(User updatedUser) {
    setState(() {
      final index = _users.indexWhere((user) => user.id == updatedUser.id);
      if (index != -1) {
        _users[index] = updatedUser;
      }
    });
    Navigator.pop(context);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('User updated successfully!')));
  }

  void _deleteUser(String userId) {
    setState(() {
      _users.removeWhere((user) => user.id == userId);
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('User deleted successfully!')));
  }

  void _showAddEditUserModal({bool isEditMode = false, User? user}) {
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
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Config.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              backgroundColor: Config.accentBlue,
              child: Text(
                'A',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(16.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Text(
                  'User & Employee Management',
                  style: textTheme.headlineMedium,
                ),
                SizedBox(height: 16),
                _buildSearchBar(context),
                SizedBox(height: 16),
              ]),
            ),
          ),
          // Daftar Pengguna
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final user = _users[index];
                return UserListItem(
                  user: user,
                  onTap: () {
                    _showAddEditUserModal(isEditMode: true, user: user);
                  },
                );
              }, childCount: _users.length),
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 80)),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddEditUserModal(isEditMode: false),
        backgroundColor: Config.primaryGreen,
        label: const Text('Add New User'),
        icon: const Icon(Icons.person_add_alt_1_outlined),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Search users...',
        prefixIcon: Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.grey[100],
        contentPadding: EdgeInsets.symmetric(vertical: 0),
      ),
    );
  }
}

class UserListItem extends StatelessWidget {
  final User user;
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
        title: Text(user.fullName, style: textTheme.titleLarge),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4),
            Text(user.email, style: textTheme.bodyMedium),
            SizedBox(height: 4),
            Text(
              'Last Login: ${DateFormat('dd MMM yyyy, HH:mm').format(user.lastLogin)}',
              style: textTheme.bodyMedium?.copyWith(
                color: Config.textSecondary,
              ),
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: user.roleColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                user.roleText,
                style: textTheme.labelSmall?.copyWith(
                  color: user.roleColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: user.statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                user.statusText,
                style: textTheme.labelSmall?.copyWith(
                  color: user.statusColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        isThreeLine: true,
      ),
    );
  }
}

class _AddEditUserModal extends StatefulWidget {
  final bool isEditMode;
  final User? userToEdit;
  final Function(User) onSave;
  final Function(String) onDelete;

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

  // Form fields controllers
  late String _fullName;
  late String _email;
  late UserRole _role;
  late UserStatus _status;
  late String _password;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    if (widget.isEditMode && widget.userToEdit != null) {
      _fullName = widget.userToEdit!.fullName;
      _email = widget.userToEdit!.email;
      _role = widget.userToEdit!.role;
      _status = widget.userToEdit!.status;
      _password = ''; // Password tidak diambil untuk diedit
    } else {
      _fullName = '';
      _email = '';
      _role = UserRole.cashier; // Default
      _status = UserStatus.active; // Default
      _password = '';
    }
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final user = User(
        id: widget.isEditMode
            ? widget.userToEdit!.id
            : 'USR${DateTime.now().millisecondsSinceEpoch}',
        fullName: _fullName,
        email: _email,
        role: _role,
        status: _status,
        lastLogin: widget.isEditMode
            ? widget.userToEdit!.lastLogin
            : DateTime.now(),
        password: _password.isEmpty ? null : _password,
      );
      widget.onSave(user);
    }
  }

  // Dialog konfirmasi hapus
  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete User'),
        content: Text(
          'Are you sure you want to delete ${widget.userToEdit!.fullName}? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              'Cancel',
              style: TextStyle(color: Config.textSecondary),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Config.errorRed,
            ),
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
            SizedBox(height: 8),
            Text(
              widget.isEditMode
                  ? 'Update the user details below.'
                  : 'Enter user details to add to the system.',
              style: textTheme.bodyMedium,
            ),
            SizedBox(height: 24),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    initialValue: _fullName,
                    decoration: const InputDecoration(
                      labelText: 'Full Name',
                      hintText: 'e.g., John Smith',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter full name';
                      }
                      return null;
                    },
                    onSaved: (value) => _fullName = value!,
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    initialValue: _email,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email Address',
                      hintText: 'e.g., user@pharmaease.com',
                    ),
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          !value.contains('@')) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                    onSaved: (value) => _email = value!,
                  ),
                  SizedBox(height: 16),
                  DropdownButtonFormField<UserRole>(
                    value: _role,
                    decoration: const InputDecoration(labelText: 'Role'),
                    items: UserRole.values
                        .map(
                          (role) => DropdownMenuItem(
                            value: role,
                            child: Text(
                              role
                                  .toString()
                                  .split('.')
                                  .last
                                  .replaceFirstMapped(
                                    RegExp(
                                      r'.',
                                    ), 
                                    (match) => match
                                        .group(0)!
                                        .toUpperCase(),
                                  ),
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _role = value!;
                      });
                    },
                    onSaved: (value) => _role = value!,
                  ),
                  SizedBox(height: 16),
                  if (!widget.isEditMode)
                    TextFormField(
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        hintText: 'Enter a secure password',
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (!widget.isEditMode &&
                            (value == null || value.isEmpty)) {
                          return 'Please enter a password';
                        }
                        return null;
                      },
                      onSaved: (value) => _password = value!,
                    ),
                  if (widget.isEditMode)
                    DropdownButtonFormField<UserStatus>(
                      value: _status,
                      decoration: const InputDecoration(labelText: 'Status'),
                      items: UserStatus.values
                          .map(
                            (status) => DropdownMenuItem(
                              value: status,
                              child: Text(
                                status
                                    .toString()
                                    .split('.')
                                    .last
                                    .replaceFirstMapped(
                                      RegExp(
                                        r'.',
                                      ), 
                                      (match) => match
                                          .group(0)!
                                          .toUpperCase(), 
                                    ),
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _status = value!;
                        });
                      },
                      onSaved: (value) => _status = value!,
                    ),
                  SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _saveForm,
                          child: Text(
                            widget.isEditMode ? 'Update User' : 'Add User',
                            style: textTheme.labelLarge,
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Config.textSecondary,
                            side: BorderSide(
                              color: Config.textSecondary.withOpacity(0.5),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 16,
                            ),
                          ),
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            'Cancel',
                            style: textTheme.labelLarge?.copyWith(
                              color: Config.textSecondary,
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
                          foregroundColor: Config.errorRed,
                        ),
                        onPressed: _confirmDelete,
                        icon: Icon(Icons.delete_outline),
                        label: Text('Delete User'),
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

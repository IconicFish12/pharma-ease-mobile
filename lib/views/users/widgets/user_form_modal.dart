import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:mobile_course_fp/data/model/user_model.dart';

class UserFormModal extends StatefulWidget {
  final bool isEditMode;
  final Datum? userToEdit;
  final Function(Datum) onSave;
  final Function(dynamic) onDelete;

  const UserFormModal({
    super.key,
    required this.isEditMode,
    this.userToEdit,
    required this.onSave,
    required this.onDelete,
  });

  @override
  State<UserFormModal> createState() => _UserFormModalState();
}

class _UserFormModalState extends State<UserFormModal> {
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

    debugPrint("ID : $_userId");

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
              await widget.onDelete(widget.userToEdit?.id);

              if (context.mounted) {
                Navigator.pop(context); // Tutup BottomSheet
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
                        if (v != null && v.isNotEmpty && v.length < 6) {
                          return 'Min 6 chars';
                        }
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

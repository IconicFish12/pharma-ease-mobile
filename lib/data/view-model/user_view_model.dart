enum UserRole { admin, owner, pharmacist, cashier }
enum UserShift{ pagi, siang, sore }
class UserViewModel {
  String? userId;
  String name;
  String empId;
  String email;
  String password;
  UserRole role;
  UserShift shift;
  DateTime dateOfBirth;
  String alamat;
  String? profilePicture;
  int? salary;
  DateTime dateStart;

  UserViewModel({
    this.userId,
    required this.name,
    required this.empId,
    required this.email,
    required this.password,
    required this.role,
    required this.shift,
    required this.dateOfBirth,
    required this.alamat,
    this.profilePicture,
    this.salary,
    required this.dateStart,
  });
}
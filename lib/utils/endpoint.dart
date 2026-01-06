
const String baseUrlRakha = "https://jamari-transuranic-uncentrally.ngrok-free.dev/api/admin"; 

enum Endpoints {

  medicineList('/medicine'),     
  medicineCategory('/medicine-category'),
  supplierList('/suppliers'),
  login('/login'),
  users('users');

  final String path;
  const Endpoints(this.path);


  String get url {
    print("$baseUrlRakha$path");
    return "$baseUrlRakha$path"; 
  }
  // delete, edit
  String urlWithId(String id) {
    return "$baseUrlRakha$path/$id";
  }
}
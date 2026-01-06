
const String baseUrl = "https://jamari-transuranic-uncentrally.ngrok-free.dev/api/admin"; 

enum Endpoints {

  medicineList('/medicine'),     
  medicineCategory('/medicine-category'),
  supplierList('/suppliers'),
  login('/login'),
  medicineOrder('/medicine-order'),
  users('users');

  final String path;
  const Endpoints(this.path);


  String get url {
    print("$baseUrl$path");
    return "$baseUrl$path"; 
  }
  // delete, edit
  String urlWithId(String id) {
    return "$baseUrl$path/$id";
  }
}
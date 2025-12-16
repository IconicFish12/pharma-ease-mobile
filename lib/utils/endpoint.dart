
const String baseUrl = "http://10.0.2.2:8000/api/admin"; 

enum Endpoints {

  medicineList('/medicine'),     
  supplierList('/suppliers'),
  login('/login');      


  final String path;
  const Endpoints(this.path);


  String get url {
    print("$baseUrl$path");
    return "$baseUrl$path"; 
  }
  // delete, edit
  String urlWithId(int id) {
    
    return "$baseUrl$path$id";
  }
}
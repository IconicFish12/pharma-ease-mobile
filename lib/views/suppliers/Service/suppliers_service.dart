import 'package:http/http.dart' as http;
import '../../../utils/endpoint.dart'; 
import '../../../data/model/supplier_model.dart'; 
import '../Model/suppliers_model.dart'; 
import '../Mapper/suppliers_mapper.dart'; 


class SupplierService {
  
  Future<List<Supplier>> getSuppliers() async {
    try {
      final response = await http.get(
        Uri.parse(Endpoints.supplierList.url),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json", 
        },
      );

      print("URL: ${Endpoints.supplierList.url}"); 
      print("Status: ${response.statusCode}"); 

      if (response.statusCode == 200) {
        final SupplierModel apiResponse = supplierModelFromMap(response.body);
        final List<Datum>? rawData = apiResponse.data;
        if (rawData == null) return [];
        return rawData.map((datum) => datum.datumToSupplier()).toList();
      } else {
        print("Error Body: ${response.body}"); 
        throw Exception('Gagal: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
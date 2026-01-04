import '../../../data/model/supplier_model.dart'; 
import '../Model/suppliers_model.dart'; 

extension DatumToDomain on Datum {
  
  Supplier datumToSupplier() {
    return Supplier(
      // Mapping dari Datum (API) ke Supplier (UI)
      id: id ?? "0", 
      suppliersName: supplierName ?? "Unknown", 
      contactPerson: contactPerson ?? "-",      
      phoneNumber: phone?.toString() ?? "-",
      address: address ?? "-",
      medicineQuantity: 0, 
      email: "-", 
      whatsappNumber: phone?.toString() ?? "-", 
      status: SupplierStatus.active, 
    );
  }
}
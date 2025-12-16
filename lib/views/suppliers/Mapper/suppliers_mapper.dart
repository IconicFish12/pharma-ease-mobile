import '../../../data/model/supplier_model.dart'; 
import '../Model/suppliers_model.dart'; 

extension DatumToDomain on Datum {
  
  Supplier toDomain() {
    return Supplier(
      // Mapping dari Datum (API) ke Supplier (UI)
      id: this.id ?? "0", 
      suppliersName: this.supplierName ?? "Unknown", 
      contactPerson: this.contactPerson ?? "-",      
      phoneNumber: this.phone?.toString() ?? "-",
      address: this.address ?? "-",
      medicineQuantity: 0, 
      email: "-", 
      whatsappNumber: this.phone?.toString() ?? "-", 
      status: SupplierStatus.active, 
    );
  }
}
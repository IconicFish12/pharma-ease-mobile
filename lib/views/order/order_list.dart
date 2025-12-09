import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_course_fp/config/config.dart';
import 'package:mobile_course_fp/views/order/order_detail.dart';
import 'package:mobile_course_fp/views/order/order_model.dart';
import 'package:mobile_course_fp/views/suppliers/supplier_list.dart';
import 'dart:math';

class MedicineTemporary {
  final String name;
  final double price;

  MedicineTemporary({required this.name, required this.price});

  static List<MedicineTemporary> list = [
    MedicineTemporary(name: "Paracetamol 500mg", price: 5000),
    MedicineTemporary(name: "Amoxicillin 500mg", price: 12000),
    MedicineTemporary(name: "Ibuprofen 400mg", price: 8500),
    MedicineTemporary(name: "Vitamin C 1000mg", price: 15000),
    MedicineTemporary(name: "Omeprazole 20mg", price: 25000),
    MedicineTemporary(name: "Cetirizine 10mg", price: 3000),
  ];
}
class OrderList extends StatefulWidget {
  const OrderList({super.key});

  @override
  State<OrderList> createState() => _OrderListState();
}

class _OrderListState extends State<OrderList> {
  final List<Order> _orders = [
    Order(
      id: "ORD-JNSJ2",
      suppliersName: "MediSupply Co.",
      contactPerson: "David Lee",
      email: "david@medisupply.com",
      phoneNumber: "+1-555-0101",
      whatsappNumber: "+15550101",
      address: "123 Medical Ave, NY",
      orderDate: "2025-02-01",
      expectedDeliveryDate: "2025-02-10",
      items: [
        OrderItem(name: "Paracetamol", price: 100000, amount: 3),
        OrderItem(name: "Amoxicillin", price: 150000, amount: 2),
      ],
    ),
    Order(
      id: "ORD-ASDV1",
      suppliersName: "PharmaCorp Ltd.",
      contactPerson: "Lisa Chen",
      email: "lisa@pharmacorp.com",
      phoneNumber: "+1-555-0102",
      whatsappNumber: "+15550102",
      address: "456 Health St, CA",
      orderDate: "2025-01-28",
      status: OrderStatus.failed,
      expectedDeliveryDate: "2025-02-05",
      items: [
        OrderItem(name: "Ibuprofen", price: 200000, amount: 2),
        OrderItem(name: "Paracetamol", price: 150000, amount: 1),
      ],
    ),
  ];


void showAddNewOrderBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: AddOrderModal(
          onSave: (Order newOrder) {
            setState(() {
              _orders.add(newOrder); 
            });
            Navigator.pop(context); 
            
            ScaffoldMessenger.of(context).showSnackBar(
               SnackBar(content: Text('Order berhasil dibuat untuk ${newOrder.suppliersName}')),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text("Orders", style: textTheme.titleLarge),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Config.textPrimary),
          onPressed: () => context.pop(),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Order Management", style: textTheme.headlineMedium),
            const SizedBox(height: 16),

            _buildSearchBar(),
            const SizedBox(height: 24),

            Text("Order List", style: textTheme.headlineMedium),
            const SizedBox(height: 16),

            ..._orders.map((order) {
              return OrderListItem(
                order: order,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => OrderDetailPage(order: order),
                    ),
                  );
                },
              );
            }),

            const SizedBox(height: 80),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showAddNewOrderBottomSheet(context);
        },
        backgroundColor: Config.primaryGreen,
        label: Text("Add New Order", style: TextStyle(color: Colors.white),),
        icon: Icon(Icons.trolley, color: Colors.white,),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      decoration: InputDecoration(
        hintText: "Search orders...",
        prefixIcon: Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.grey[100],
      ),
    );
  }
}

class OrderListItem extends StatelessWidget {
  final Order order;
  final VoidCallback onTap;

  const OrderListItem({super.key, required this.order, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(order.id, style: textTheme.titleLarge),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: order.statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      order.statusText,
                      style: textTheme.labelSmall?.copyWith(
                        color: order.statusColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 12),
              _infoRow(Icons.store_mall_directory, order.suppliersName),
              SizedBox(height: 8),
              _infoRow(Icons.calendar_month, "Order: ${order.orderDate}"),
              SizedBox(height: 8),
              _infoRow(
                Icons.inventory_2,
                "${order.totalItemsOrdered} items",
              ),
              SizedBox(height: 8),
              _infoRow(Icons.monetization_on_sharp, "Rp.${order.totalAmount}")
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Config.textSecondary),
        SizedBox(width: 8),
        Text(text),
      ],
    );
  }
}

class AddOrderModal extends StatefulWidget {
  final Function(Order) onSave;

  const AddOrderModal({super.key, required this.onSave});

  @override
  State<AddOrderModal> createState() => _AddOrderModalState();
}

class _AddOrderModalState extends State<AddOrderModal> {
  final _formKey = GlobalKey<FormState>();

  String? _selectedSupplierId;
  DateTime _selectedDate = DateTime.now();
  final TextEditingController _dateController = TextEditingController();

  // list sementara sebelum data ditambahin ke model OrderItem
  List<OrderItem> _tempItems = [];

  MedicineTemporary? _selectedMedicine; 
  final _amountController = TextEditingController(); 

  @override
  void initState() {
    super.initState();
    _dateController.text = DateFormat('yyyy-MM-dd').format(_selectedDate);
  }

  @override
  void dispose() {
    _dateController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  String _generateOrderId() {
  const length = 5; 
  const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'; 
  final random = Random();

  final String randomString = List.generate(length, 
    (index) => chars[random.nextInt(chars.length)]
  ).join();

  return 'ORD-$randomString'; 
}

  void _addItemToTempList() {
    if (_selectedMedicine != null && _amountController.text.isNotEmpty) {
      setState(() {
        _tempItems.add(OrderItem(
          name: _selectedMedicine!.name, 
          price: _selectedMedicine!.price, 
          amount: int.parse(_amountController.text),
        ));
        _selectedMedicine = null;
        _amountController.clear(); 
      });
    }
  }

  void _removeItemFromTempList(int index) {
    setState(() {
      _tempItems.removeAt(index);
    });
  }

  void _submitOrder() {
    if (_formKey.currentState!.validate()) {
      if (_tempItems.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please add at least one item!')),
        );
        return;
      }
      _formKey.currentState!.save();

      final selectedSupplier = SupplierData.suppliers.firstWhere(
        (element) => element.id == _selectedSupplierId
      );

      final newOrderId = _generateOrderId();

      final newOrder = Order(
        id: newOrderId,
        suppliersName: selectedSupplier.suppliersName,
        contactPerson: selectedSupplier.contactPerson,
        email: selectedSupplier.email,
        phoneNumber: selectedSupplier.phoneNumber,
        whatsappNumber: selectedSupplier.whatsappNumber,
        address: selectedSupplier.address,
        orderDate: _dateController.text,
        expectedDeliveryDate: "", 
        status: OrderStatus.pending,
        items: _tempItems, 
      );

      widget.onSave(newOrder);
    }
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('New Order', style: Theme.of(context).textTheme.headlineSmall),
                IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
              ],
            ),
            const SizedBox(height: 20),
        
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Select Supplier',
                      prefixIcon: Icon(Icons.store),
                      border: OutlineInputBorder(),
                    ),
                    value: _selectedSupplierId,
                    items: SupplierData.suppliers.map((supplier) {
                      return DropdownMenuItem(
                        value: supplier.id,
                        child: Text(supplier.suppliersName),
                      );
                    }).toList(),
                    onChanged: (val) => setState(() => _selectedSupplierId = val),
                    validator: (val) => val == null ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _dateController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: 'Order Date',
                      prefixIcon: Icon(Icons.calendar_today),
                      border: OutlineInputBorder(),
                    ),
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _selectedDate,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2030),
                      );
                      if (picked != null) {
                        setState(() {
                          _selectedDate = picked;
                          _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 24),
                  
                  const Divider(),
                  Text("Add Medicine Items", style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 10),
                  
                  DropdownButtonFormField<MedicineTemporary>(
                    decoration: const InputDecoration(
                      labelText: 'Select Medicine',
                      prefixIcon: Icon(Icons.medication),
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0)
                    ),
                    value: _selectedMedicine,
                    items: MedicineTemporary.list.map((med) {
                      return DropdownMenuItem(
                        value: med,
                        child: Text(
                          "${med.name} (Rp ${med.price.toStringAsFixed(0)})", 
                          overflow: TextOverflow.ellipsis
                        ),
                      );
                    }).toList(),
                    onChanged: (val) {
                      setState(() {
                        _selectedMedicine = val;
                      });
                    },
                  ),
                  
                  const SizedBox(height: 10),
        
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Input Quantity
                      Expanded(
                        flex: 2,
                        child: TextField(
                          controller: _amountController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Qty', 
                            isDense: true, 
                            border: OutlineInputBorder()
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        flex: 2,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: Colors.grey.shade400)
                          ),
                          child: Text(
                            _selectedMedicine != null 
                              ? "Rp ${_selectedMedicine!.price.toStringAsFixed(0)}" 
                              : "Rp 0",
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                        ),
                      ),
                      
                      const SizedBox(width: 8),
                      
                      ElevatedButton(
                        onPressed: _addItemToTempList,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12)
                        ),
                        child: const Icon(Icons.add, color: Colors.white),
                      ),
                    ],
                  ),
        
                  const SizedBox(height: 16),
                  if (_tempItems.isNotEmpty) ...[
                    Text("Items in cart:", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[700])),
                    const SizedBox(height: 8),
                    Container(
                      height: 150,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemCount: _tempItems.length,
                        separatorBuilder: (ctx, i) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final item = _tempItems[index];
                          // Hitung subtotal
                          final subtotal = item.price * item.amount;
                          
                          return ListTile(
                            dense: true,
                            title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                            // detail harga
                            subtitle: Text("${item.amount} x Rp ${item.price.toStringAsFixed(0)} = Rp ${subtotal.toStringAsFixed(0)}"),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                              onPressed: () => _removeItemFromTempList(index),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
        
                  const SizedBox(height: 24),
        
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _submitOrder,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Config.primaryGreen, 
                      ),
                      child: const Text('Confirm & Create Order', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
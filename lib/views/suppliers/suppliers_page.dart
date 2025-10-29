import 'package:flutter/material.dart';
import 'package:mobile_course_fp/components/sidebar.dart';

class SuppliersPage extends StatefulWidget {
  const SuppliersPage({super.key});

  @override
  State<SuppliersPage> createState() => _SuppliersPageState();
}

class _SuppliersPageState extends State<SuppliersPage> {
  final List<Map<String, String>> suppliers = [
    {
      "name": "MediSupply Co.",
      "contact": "David Lee",
      "email": "david@medisupply.com",
    },
    {
      "name": "PharmaCorp Ltd.",
      "contact": "Lisa Chen",
      "email": "lisa@pharmacorp.com",
    },
    {
      "name": "HealthDist Inc.",
      "contact": "James Wilson",
      "email": "james@healthdist.com",
    },
    {
      "name": "Global Pharma",
      "contact": "Anna Martinez",
      "email": "anna@globalpharma.com",
    },
    {
      "name": "MedSource Direct",
      "contact": "Tom Harris",
      "email": "tom@medsource.com",
    },
  ];

  @override
  Widget build(BuildContext context) {
    const Color mainGreen = Color(0xFF356B52);

    return Scaffold(
      drawer: const Sidebar(currentRoute: '/supplier'),
      appBar: AppBar(
        backgroundColor: mainGreen,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        title: const Padding(
          padding: EdgeInsets.only(left: 16),
          child: Text(
            "Pharma Ease",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/profile');
              },
              child: const CircleAvatar(
                backgroundColor: Colors.lightBlue,
                child: Text("RA", style: TextStyle(color: Colors.white)),
              ),
            ),
          ),
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Suppliers",
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 27),
              ),
              Text(
                "Manage your pharmacy operations efficiently",
                style: TextStyle(color: Color.fromARGB(255, 129, 129, 129)),
              ),
              SizedBox(height: 25),

              Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 1,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    Text(
                        "Supplier Management",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 15),
                      Column(
                        spacing: 10,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextField(
                            decoration: InputDecoration(
                              hintText: "Search suppliers...",
                              prefixIcon: Icon(Icons.search),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Colors.grey,
                                ),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 0,
                                horizontal: 12,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton.icon(
                            onPressed: () {},
                            icon: Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 18,
                            ),
                            label: Text(
                              "Add New Supplier",
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ],
                      ),

                     SizedBox(height: 20),

                     // table
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columns: const [
                            DataColumn(label: Text("Supplier Name")),
                            DataColumn(label: Text("Contact Person")),
                            DataColumn(label: Text("Email")),
                          ],
                          rows: suppliers.map((s) {
                            return DataRow(
                              cells: [
                                DataCell(Text(s["name"]!)),
                                DataCell(Text(s["contact"]!)),
                                DataCell(Text(s["email"]!)),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: const Color(0xFFF5F6F8),
    );
  }
}


// Search bar
// Container(
//             width: 200,
//             padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
//             decoration: BoxDecoration(
//               color: const Color.fromARGB(255, 247, 247, 247),
//               borderRadius: BorderRadius.circular(8),
//               border: Border.all(color: Colors.grey[400]!),
//             ),
//             child: Row(
//               children: const [
//                 Icon(Icons.search, color: Colors.grey),
//                 SizedBox(width: 8),
//                 Text(
//                   "Search...",
//                   style: TextStyle(color: Colors.grey, fontSize: 16),
//                 ),
//               ],
//             ),
//           ),
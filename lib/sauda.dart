import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'footer.dart';

// --- Data Models ---
class SaudaModel {
  final String id;
  final String companyName;
  final String spNo;
  final String item;
  final String seller;
  final String buyer;
  final String qty;
  final String status;

  SaudaModel({
    required this.id,
    required this.companyName,
    required this.spNo,
    required this.item,
    required this.seller,
    required this.buyer,
    required this.qty,
    required this.status,
  });
}

class SaudaPage extends StatefulWidget {
  const SaudaPage({super.key});

  @override
  State<SaudaPage> createState() => _SaudaPageState();
}

class _SaudaPageState extends State<SaudaPage> {
  final Color navyBlue = const Color(0xFF003366);
  final Color royalBlue = const Color(0xFF007BFF);
  final Color cottonGold = const Color(0xFFC5A059);

  List<SaudaModel> _allSaudas = [
    SaudaModel(id: "1", companyName: "ISHWAR GLOBAL", spNo: "IG-25-26-001", item: "S-6 Cotton", seller: "Ruchitra", buyer: "Sharma Agro", qty: "31.000", status: "PARTIALLY DISPATCHED"),
    SaudaModel(id: "2", companyName: "SHRI ISHWAR TRADING", spNo: "IS-25-26-001", item: "Cotton Waste", seller: "Goyal Petrochem", buyer: "Khandelwal Exp", qty: "100.000", status: "BOOKED"),
  ];

  List<SaudaModel> _filteredSaudas = [];
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    _filteredSaudas = _allSaudas;
  }

  void _searchSauda(String query) {
    setState(() {
      _searchQuery = query;
      _filteredSaudas = _allSaudas.where((s) {
        return s.companyName.toLowerCase().contains(query.toLowerCase()) ||
               s.seller.toLowerCase().contains(query.toLowerCase()) ||
               s.buyer.toLowerCase().contains(query.toLowerCase()) ||
               s.item.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      bottomNavigationBar: const CustomFooter(currentIndex: -1),
      appBar: AppBar(
        backgroundColor: navyBlue,
        title: Text("Sauda Patrak Management", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // SEARCH SECTION
          Container(
            padding: const EdgeInsets.all(15),
            color: navyBlue,
            child: TextField(
              onChanged: _searchSauda,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Search by Company, Seller, Buyer or Item...",
                hintStyle: const TextStyle(color: Colors.white70),
                prefixIcon: const Icon(Icons.search, color: Colors.white),
                filled: true,
                fillColor: Colors.white.withOpacity(0.1),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
          ),

          // LIST HEADER
          Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("LIST OF SAUDA PATRAKS", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: navyBlue)),
                ElevatedButton.icon(
                  onPressed: () => _showCompanySelection(context),
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text("CREATE SAUDA"),
                  style: ElevatedButton.styleFrom(backgroundColor: royalBlue, foregroundColor: Colors.white),
                ),
              ],
            ),
          ),

          // DATA TABLE/LIST
          Expanded(
            child: ListView.builder(
              itemCount: _filteredSaudas.length,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              itemBuilder: (context, index) {
                final sauda = _filteredSaudas[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ExpansionTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: navyBlue.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                      child: Text(sauda.id, style: TextStyle(color: navyBlue, fontWeight: FontWeight.bold)),
                    ),
                    title: Text(sauda.companyName, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 13)),
                    subtitle: Text("${sauda.spNo} | ${sauda.item}", style: const TextStyle(fontSize: 11)),
                    trailing: _buildStatusBadge(sauda.status),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          children: [
                            _infoRow("Seller", sauda.seller),
                            _infoRow("Buyer", sauda.buyer),
                            _infoRow("Qty (MT)", sauda.qty),
                            const Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _miniBtn(Icons.visibility, "View", Colors.blue),
                                _miniBtn(Icons.edit, "Edit", Colors.orange),
                                _miniBtn(Icons.picture_as_pdf, "PDF", Colors.red),
                                _miniBtn(Icons.local_shipping, "Dispatch", Colors.green),
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ).animate().slideX(begin: 0.1, end: 0, delay: (index * 50).ms);
              },
            ),
          ),
        ],
      ),
    );
  }

  // --- Step 1: Company Selection ---
  void _showCompanySelection(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Select Company", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
            const Text("You can only select one at a time", style: TextStyle(color: Colors.red, fontSize: 12)),
            const SizedBox(height: 20),
            _companyTile(
              "ISHWAR GLOBAL", 
              "IG-25-26-001", 
              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS2fMeeY6od5EVDriZUNz_WRpXX0yqXvRbwVp2Xen8DHg&s",
            ),
            const SizedBox(height: 10),
            _companyTile(
              "SHRI ISHWAR TRADING", 
              "IS-25-26-001", 
              "https://thumbs.dreamstime.com/z/cotton-logo-template-vector-design-symbol-nature-335208618.jpg",
            ),
          ],
        ),
      ),
    );
  }

  Widget _companyTile(String name, String id, String logo) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (context) => SaudaFormPage(companyName: name, spId: id, logo: logo)));
      },
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(12)),
        child: Row(
          children: [
            Image.network(logo, width: 40, height: 40),
            const SizedBox(width: 15),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(id, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
            ])),
            const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
    );
  }

  // --- Helper Widgets ---
  Widget _buildStatusBadge(String status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: Colors.cyan.shade100, borderRadius: BorderRadius.circular(6)),
      child: Text(status, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.cyan)),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(label, style: const TextStyle(color: Colors.grey)), Text(value, style: const TextStyle(fontWeight: FontWeight.bold))],
      ),
    );
  }

  Widget _miniBtn(IconData icon, String label, Color color) {
    return Column(
      children: [
        IconButton(onPressed: () {}, icon: Icon(icon, color: color)),
        Text(label, style: const TextStyle(fontSize: 10)),
      ],
    );
  }
}

// --- Step 2: Complex Form Page ---
class SaudaFormPage extends StatefulWidget {
  final String companyName;
  final String spId;
  final String logo;

  const SaudaFormPage({super.key, required this.companyName, required this.spId, required this.logo});

  @override
  State<SaudaFormPage> createState() => _SaudaFormPageState();
}

class _SaudaFormPageState extends State<SaudaFormPage> {
  final Color navyBlue = const Color(0xFF003366);
  
  // Dummy Lists for Dropdowns
  final List<String> _sellers = ["Ruchitra", "Goyal Petrochem", "Vardhaman"];
  final List<String> _buyers = ["Sharma Agro", "Khandelwal Exp", "Reliance"];
  final List<String> _items = ["S-6 Cotton", "MCU-5", "Organic Cotton"];

  String? selectedSeller;
  String? selectedBuyer;
  String? selectedItem;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: navyBlue, title: const Text("Create New Sauda")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Selected Company Display
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(color: navyBlue.withOpacity(0.05), borderRadius: BorderRadius.circular(12)),
              child: Row(
                children: [
                  Image.network(widget.logo, width: 50),
                  const SizedBox(width: 15),
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(widget.companyName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Text("Sauda Patrak ID: ${widget.spId}"),
                  ])
                ],
              ),
            ),
            const SizedBox(height: 25),

            _formLabel("SELECT SELLER"),
            _buildSearchableDropdown(_sellers, selectedSeller, (val) => setState(() => selectedSeller = val)),

            _formLabel("SELECT BUYER"),
            _buildSearchableDropdown(_buyers, selectedBuyer, (val) => setState(() => selectedBuyer = val)),

            _formLabel("ITEM SPECIFICATION"),
            _buildSearchableDropdown(_items, selectedItem, (val) => setState(() => selectedItem = val)),

            const SizedBox(height: 20),
            _buildTextField("QUANTITY (MT)"),
            _buildTextField("RATE (₹/MT)"),

            const Divider(height: 40),
            _formLabel("TERMS & CONDITIONS"),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(8)),
              child: const Text(
                "1. Material quality grade is as per Code of Conduct.\n"
                "2. Quality/Weight/Payment disputes settled as per Vidharbh Cotton Association, Akola.\n"
                "3. Broker is not liable for mutual consent deals.\n"
                "4. Insure vehicle before dispatch.",
                style: TextStyle(fontSize: 12, color: Colors.black87),
              ),
            ),

            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                // Logic to save and go back
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Sauda Patrak Saved Successfully!")));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: navyBlue,
                minimumSize: const Size(double.infinity, 55),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text("SAVE SAUDA PATRAK", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _formLabel(String label) => Padding(
    padding: const EdgeInsets.only(bottom: 8, top: 15),
    child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.blueGrey)),
  );

  Widget _buildSearchableDropdown(List<String> list, String? selected, Function(String?) onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(8)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          hint: const Text("Search or Select..."),
          value: selected,
          items: list.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildTextField(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
      ),
    );
  }
}
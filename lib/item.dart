import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'footer.dart';

class ItemPage extends StatefulWidget {
  const ItemPage({super.key});

  @override
  State<ItemPage> createState() => _ItemPageState();
}

class _ItemPageState extends State<ItemPage> {
  final Color navyBlue = const Color(0xFF003366);
  final Color cottonGold = const Color(0xFFC5A059);

  // Data Mapping for Sub-categories
  final Map<String, List<String>> _subCategories = {
    "Cotton": [],
    "Cotton-Waste": ["Cotton Flat Waste", "Comber Noil", "Flat Strips", "BRD", "ID (Lickring & Drapping)"],
    "Organic": ["NPOP", "NOP", "TC2"],
    "Region-Agri": [], 
    "BCI": ["BCI Traceability", "CNA", "NPOP", "Inditex", "NOP"],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FA),
      bottomNavigationBar: const CustomFooter(currentIndex: 1),
      appBar: AppBar(
        backgroundColor: navyBlue,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Item Categories",
          style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            color: navyBlue,
            child: Text(
              "Select Item Category",
              style: GoogleFonts.poppins(color: Colors.white70, fontSize: 16),
            ).animate().fadeIn(duration: 500.ms).slideX(),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: GridView.count(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              crossAxisCount: 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              children: [
                // FIXED: Using standard Material Icons
                _buildCategoryCard("1. Cotton", Icons.cloud_queue, Colors.blueGrey),
                _buildCategoryCard("2. Cotton-Waste", Icons.recycling, cottonGold),
                _buildCategoryCard("3. Organic", Icons.eco, Colors.green),
                _buildCategoryCard("4. Region-Agri", Icons.agriculture, Colors.orange),
                _buildCategoryCard("5. BCI", Icons.verified_user_outlined, Colors.blue),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(String title, IconData icon, Color iconColor) {
    String cleanTitle = title.contains('. ') ? title.split('. ')[1] : title;

    return InkWell(
      onTap: () => _openSubCategoryPage(cleanTitle),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: navyBlue.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, 8)),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: iconColor),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: navyBlue,
              ),
            ),
          ],
        ),
      ),
    ).animate().scale(duration: 400.ms, curve: Curves.easeOutBack);
  }

  void _openSubCategoryPage(String categoryName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SubCategoryScreen(
          categoryName: categoryName,
          items: _subCategories[categoryName] ?? [],
          navyBlue: navyBlue,
        ),
      ),
    );
  }
}

class SubCategoryScreen extends StatelessWidget {
  final String categoryName;
  final List<String> items;
  final Color navyBlue;

  const SubCategoryScreen({
    super.key,
    required this.categoryName,
    required this.items,
    required this.navyBlue,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: navyBlue,
        title: Text(categoryName, style: GoogleFonts.poppins(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline, color: Colors.white, size: 28),
            onPressed: () => _showAddItemForm(context),
          ),
        ],
      ),
      body: items.isEmpty
          ? Center(child: Text("No items found. Tap + to add.", style: GoogleFonts.poppins()))
          : ListView.builder(
              padding: const EdgeInsets.all(15),
              itemCount: items.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: navyBlue.withOpacity(0.1),
                      child: Text("${index + 1}", style: TextStyle(color: navyBlue, fontWeight: FontWeight.bold)),
                    ),
                    title: Text(items[index], style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
                    trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                  ),
                ).animate().slideX(begin: 1, end: 0, delay: (index * 100).ms);
              },
            ),
    );
  }

  void _showAddItemForm(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              decoration: const BoxDecoration(
                color: Color(0xFF007BFF),
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("ADD NEW ITEM", style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold)),
                  IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close, color: Colors.white)),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel("ITEM NAME *"),
                    _buildTextField("Enter item name"),
                    const SizedBox(height: 20),
                    _buildLabel("STATUS"),
                    _buildDropdown(["ACTIVE", "INACTIVE"]),
                    const SizedBox(height: 20),
                    _buildLabel("DESCRIPTION"),
                    _buildTextField("Enter description", maxLines: 3),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("ITEM ATTRIBUTES", style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                        const Icon(Icons.add_circle, color: Color(0xFF007BFF)),
                      ],
                    ),
                    const Divider(),
                    Row(
                      children: [
                        Expanded(child: _buildTextField("Attribute Name")),
                        const SizedBox(width: 10),
                        Expanded(child: _buildTextField("Unit")),
                        const SizedBox(width: 10),
                        const Icon(Icons.delete, color: Colors.red),
                      ],
                    ),
                    const SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF007BFF),
                        minimumSize: const Size(double.infinity, 55),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text("SAVE ITEM", style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text, style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey[600])),
    );
  }

  Widget _buildTextField(String hint, {int maxLines = 1}) {
    return TextField(
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Widget _buildDropdown(List<String> items) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(8)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: items[0],
          isExpanded: true,
          items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: (val) {},
        ),
      ),
    );
  }
}
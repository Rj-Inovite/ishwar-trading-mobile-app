import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'footer.dart';

class SellerPage extends StatefulWidget {
  const SellerPage({super.key});

  @override
  State<SellerPage> createState() => _SellerPageState();
}

class _SellerPageState extends State<SellerPage> {
  final Color navyBlue = const Color(0xFF003366);
  final Color royalBlue = const Color(0xFF007BFF);

  // Initial dummy data for the list
  final List<String> _sellers = ["Vardhaman Textiles", "Shree Krishna Traders", "Global Cotton Corp"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FA),
      bottomNavigationBar: const CustomFooter(currentIndex: -1), // Neutral footer
      appBar: AppBar(
        backgroundColor: navyBlue,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Seller Master Details",
          style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // TOTAL COUNT HEADER
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: navyBlue,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Registered Sellers",
                  style: GoogleFonts.poppins(color: Colors.white70, fontSize: 14),
                ),
                Text(
                  "${_sellers.length} Total Partners",
                  style: GoogleFonts.poppins(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ],
            ).animate().fadeIn(duration: 600.ms).slideX(),
          ),

          const SizedBox(height: 10),

          // SELLER LIST
          Expanded(
            child: _sellers.isEmpty
                ? Center(child: Text("No sellers added yet.", style: GoogleFonts.poppins()))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    itemCount: _sellers.length,
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 3,
                        shadowColor: Colors.black12,
                        margin: const EdgeInsets.only(bottom: 15),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(15),
                          leading: CircleAvatar(
                            backgroundColor: royalBlue.withOpacity(0.1),
                            child: Icon(Icons.business, color: royalBlue),
                          ),
                          title: Text(
                            _sellers[index],
                            style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: navyBlue),
                          ),
                          subtitle: const Text("Verified Seller"),
                          trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                        ),
                      ).animate(delay: (100 * index).ms).fadeIn().slideY(begin: 0.2, end: 0);
                    },
                  ),
          ),
        ],
      ),
      
      // PLUS OPTION TO ADD NEW SELLER
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddSellerForm(context),
        backgroundColor: royalBlue,
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text("ADD NEW SELLER", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white)),
      ).animate().scale(delay: 500.ms),
    );
  }

  // THE COMPREHENSIVE FORM MODAL [Based on image_576102]
  void _showAddSellerForm(BuildContext context) {
    String newSellerName = "";

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.9,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Column(
          children: [
            // Top Royal Blue Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              decoration: BoxDecoration(
                color: royalBlue,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "CREATE NEW SELLER",
                    style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, color: Colors.white),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sectionTitle("PARTY DETAILS"),
                    _buildFormRow([
                      _buildField("PARTY NAME *", (val) => newSellerName = val),
                      _buildField("EMAIL *", (val) {}),
                    ]),
                    _buildField("MOBILE NUMBER", (val) {}),
                    _buildField("ADDRESS", (val) {}, maxLines: 2),
                    _buildFormRow([
                      _buildField("GSTIN NO *", (val) {}),
                      _buildField("PAN *", (val) {}),
                    ]),
                    
                    const Divider(height: 40),
                    _sectionTitle("CONTACT PERSON"),
                    _buildFormRow([
                      _buildField("CONTACT NAME", (val) {}),
                      _buildField("DESIGNATION", (val) {}),
                    ]),
                    _buildFormRow([
                      _buildField("PHONE NUMBER", (val) {}),
                      _buildField("DISPATCH NO", (val) {}),
                    ]),

                    const Divider(height: 40),
                    _sectionTitle("BANK DETAILS"),
                    _buildField("BANK NAME", (val) {}),
                    _buildFormRow([
                      _buildField("ACCOUNT NUMBER", (val) {}),
                      _buildField("IFSC CODE", (val) {}),
                    ]),

                    const SizedBox(height: 30),
                    
                    // SUBMIT BUTTON
                    ElevatedButton(
                      onPressed: () {
                        if (newSellerName.isNotEmpty) {
                          setState(() {
                            _sellers.add(newSellerName);
                          });
                          Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: royalBlue,
                        minimumSize: const Size(double.infinity, 60),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      ),
                      child: Text(
                        "SUBMIT SELLER",
                        style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- HELPER UI WIDGETS ---

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Text(
        title,
        style: GoogleFonts.poppins(fontWeight: FontWeight.w900, color: navyBlue, letterSpacing: 1.2, fontSize: 13),
      ),
    );
  }

  Widget _buildFormRow(List<Widget> children) {
    return Row(
      children: children.map((w) => Expanded(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 4), child: w))).toList(),
    );
  }

  Widget _buildField(String label, Function(String) onChanged, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey[600])),
          const SizedBox(height: 5),
          TextField(
            onChanged: onChanged,
            maxLines: maxLines,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[100],
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
              contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
}
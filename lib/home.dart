import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'footer.dart'; // Ensure this file exists
import 'item.dart';
import 'sauda.dart';
import 'seller.dart';
import 'buyer.dart';

class HomeScreen extends StatefulWidget {
  final String userEmail; // Pass the email from login.dart

  const HomeScreen({super.key, this.userEmail = "ruchi@gmail.com"});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Timer _refreshTimer;
  DateTime now = DateTime.now();

  @override
  void initState() {
    super.initState();
    // 10-Second Auto Refresh Logic
    _refreshTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      setState(() {
        now = DateTime.now();
      });
      debugPrint("Dashboard Refreshed");
    });
  }

  @override
  void dispose() {
    _refreshTimer.cancel();
    super.dispose();
  }

  // Logic to get name from Email prefix
  String _getUserName() {
    return widget.userEmail.split('@')[0].toUpperCase();
  }

  // Logic for Dynamic Greeting
  String _getGreeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  @override
  Widget build(BuildContext context) {
    const Color navyBlue = Color(0xFF003366);
    const Color cottonGold = Color(0xFFC5A059);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      bottomNavigationBar: const CustomFooter(), // Linked to footer.dart
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. CUSTOM TOP HEADER DASHBOARD
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 60, left: 25, right: 25, bottom: 30),
              decoration: const BoxDecoration(
                color: navyBlue,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _getGreeting(),
                            style: GoogleFonts.poppins(color: Colors.white70, fontSize: 16),
                          ),
                          Text(
                            _getUserName(),
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const CircleAvatar(
                        radius: 25,
                        backgroundColor: cottonGold,
                        child: Icon(Icons.person, color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 600.ms).slideY(begin: -0.2, end: 0),

            const SizedBox(height: 25),

            // 2. QUICK ACTIONS GRID
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 4,
                mainAxisSpacing: 15,
                crossAxisSpacing: 15,
                children: [
                  _buildMenuIcon(context, "Items", Icons.inventory_2_outlined, const ItemPage()),
                  _buildMenuIcon(context, "Sauda", Icons.description_outlined, const SaudaPage()),
                  _buildMenuIcon(context, "Seller", Icons.storefront_outlined, const SellerPage()),
                  _buildMenuIcon(context, "Buyer", Icons.shopping_bag_outlined, const BuyerPage()),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // 3. VIEW BUYER/SELLER QUICK LINKS
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(child: _buildQuickLink(context, "View Buyers", Icons.group, const BuyerPage())),
                  const SizedBox(width: 15),
                  Expanded(child: _buildQuickLink(context, "View Sellers", Icons.support_agent, const SellerPage())),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // 4. RECENT TRANSACTIONS LIST
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Recent Transactions",
                    style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: navyBlue),
                  ),
                  const Icon(Icons.history, color: cottonGold, size: 20),
                ],
              ),
            ),

            const SizedBox(height: 15),

            // DUMMY TRANSACTIONS DATA
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 4,
              itemBuilder: (context, index) {
                return _buildTransactionItem(
                  index == 0 ? "Premium Cotton" : "Linter Batch #$index",
                  "Inv-00${index + 124}",
                  index % 2 == 0 ? "+ ₹45,000" : "- ₹12,000",
                  index % 2 == 0 ? Colors.green : Colors.red,
                ).animate(delay: (200 * index).ms).fadeIn().slideX();
              },
            ),

            const SizedBox(height: 20),
            
            // PREVIOUS PAGE OPTION
            TextButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back, color: Colors.grey),
              label: Text("Back to Welcome", style: GoogleFonts.poppins(color: Colors.grey)),
            ),
            const SizedBox(height: 100), // Space for footer
          ],
        ),
      ),
    );
  }

  // REUSABLE CIRCLE MENU ITEM
  Widget _buildMenuIcon(BuildContext context, String label, IconData icon, Widget target) {
    return Column(
      children: [
        InkWell(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => target)),
          child: Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
            ),
            child: Icon(icon, color: const Color(0xFF003366), size: 28),
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w500)),
      ],
    );
  }

  // REUSABLE QUICK LINK CARD
  Widget _buildQuickLink(BuildContext context, String title, IconData icon, Widget target) {
    return InkWell(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => target)),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: const Color(0xFFC5A059).withOpacity(0.1),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: const Color(0xFFC5A059).withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFFC5A059), size: 20),
            const SizedBox(width: 10),
            Text(title, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.bold, color: const Color(0xFF003366))),
          ],
        ),
      ),
    );
  }

  // REUSABLE TRANSACTION ITEM
  Widget _buildTransactionItem(String title, String sub, String amount, Color amtColor) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)],
      ),
      child: Row(
        children: [
          CircleAvatar(backgroundColor: Colors.blueGrey.shade50, child: const Icon(Icons.receipt_long, color: Color(0xFF003366))),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                Text(sub, style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
          Text(amount, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: amtColor)),
        ],
      ),
    );
  }
}
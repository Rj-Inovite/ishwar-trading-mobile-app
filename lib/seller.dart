import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'footer.dart';

// ---------------------------------------------------------------------------
// 1. DATA MODEL: SELLER
// ---------------------------------------------------------------------------
class SellerModel {
  final String id;
  String businessName;
  String email;
  String mobile;
  String address;
  String gstin;
  String pan;
  // Contact Person
  String contactPerson;
  String designation;
  String alternatePhone;
  // Banking
  String bankName;
  String accountNo;
  String ifscCode;
  String branch;
  
  bool isActive;
  DateTime registrationDate;

  SellerModel({
    required this.id,
    required this.businessName,
    this.email = "",
    this.mobile = "",
    this.address = "",
    this.gstin = "",
    this.pan = "",
    this.contactPerson = "",
    this.designation = "",
    this.alternatePhone = "",
    this.bankName = "",
    this.accountNo = "",
    this.ifscCode = "",
    this.branch = "",
    this.isActive = true,
    required this.registrationDate,
  });
}

// ---------------------------------------------------------------------------
// 2. MAIN PAGE STATE
// ---------------------------------------------------------------------------
class SellerPage extends StatefulWidget {
  const SellerPage({super.key});

  @override
  State<SellerPage> createState() => _SellerPageState();
}

class _SellerPageState extends State<SellerPage> {
  // --- UI Palette ---
  final Color navyBlue = const Color(0xFF001A33);
  final Color forestGreen = const Color(0xFF2E7D32); // Unique for Sellers
  final Color accentGold = const Color(0xFFC5A059);
  final Color softWhite = const Color(0xFFFFFFFF);
  final Color scaffoldBg = const Color(0xFFF1F4F9);

  // --- State Variables ---
  final List<SellerModel> _masterSellers = [];
  List<SellerModel> _filteredSellers = [];
  final TextEditingController _searchController = TextEditingController();
  String _currentQuery = "";

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() {
    // Demo data for layout testing
    final demoData = [
      SellerModel(
        id: "S1",
        businessName: "Mahalaxmi Cotton Corp",
        gstin: "27GKLM9988H1Z1",
        address: "APMC Market, Akola, MH",
        mobile: "9988776655",
        contactPerson: "Rajesh Deshmukh",
        registrationDate: DateTime.now(),
      ),
      SellerModel(
        id: "S2",
        businessName: "Om Shanti Ginning Pressing",
        gstin: "27PPPQ1234A1Z9",
        address: "Midc Area, Yavatmal",
        isActive: false,
        registrationDate: DateTime.now(),
      ),
    ];
    setState(() {
      _masterSellers.addAll(demoData);
      _filteredSellers = List.from(_masterSellers);
    });
  }

  // ---------------------------------------------------------------------------
  // 3. LOGIC & FILTERS
  // ---------------------------------------------------------------------------

  void _onSearchChanged(String value) {
    setState(() {
      _currentQuery = value;
      _filteredSellers = _masterSellers
          .where((s) => s.businessName.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  void _toggleStatus(SellerModel seller) {
    setState(() {
      seller.isActive = !seller.isActive;
    });
  }

  // ---------------------------------------------------------------------------
  // 4. SCAFFOLD BUILD
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldBg,
      bottomNavigationBar: const CustomFooter(currentIndex: -1),
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildSummaryHeader(),
          _buildSearchContainer(),
          Expanded(
            child: _filteredSellers.isEmpty 
              ? _buildEmptyView() 
              : _buildSellerList(),
          ),
        ],
      ),
      floatingActionButton: _buildAddButton(),
    );
  }

  // ---------------------------------------------------------------------------
  // 5. MODULAR UI COMPONENTS
  // ---------------------------------------------------------------------------

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: navyBlue,
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text("Seller Master", 
        style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white)),
      actions: [
        IconButton(icon: const Icon(Icons.cloud_download_outlined, color: Colors.white70), onPressed: () {}),
      ],
    );
  }

  Widget _buildSummaryHeader() {
    int active = _masterSellers.where((s) => s.isActive).length;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(25, 20, 25, 35),
      decoration: BoxDecoration(
        color: navyBlue,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _statBox("TOTAL", "${_masterSellers.length}", Colors.white),
          _statBox("ACTIVE", "$active", Colors.greenAccent),
          _statBox("INACTIVE", "${_masterSellers.length - active}", Colors.orangeAccent),
        ],
      ).animate().slideY(begin: -0.5, end: 0, curve: Curves.easeOut),
    );
  }

  Widget _statBox(String label, String value, Color color) {
    return Column(
      children: [
        Text(value, style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold, color: color)),
        Text(label, style: GoogleFonts.poppins(fontSize: 10, color: Colors.white54, letterSpacing: 1.5)),
      ],
    );
  }

  Widget _buildSearchContainer() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
      child: Container(
        decoration: BoxDecoration(
          color: softWhite,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 20, offset: const Offset(0, 10))],
        ),
        child: TextField(
          controller: _searchController,
          onChanged: _onSearchChanged,
          decoration: InputDecoration(
            hintText: "Search by business name...",
            prefixIcon: Icon(Icons.search, color: forestGreen),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 15),
          ),
        ),
      ),
    ).animate().fadeIn(delay: 200.ms);
  }

  // ---------------------------------------------------------------------------
  // 6. LIST & CARD LOGIC
  // ---------------------------------------------------------------------------

  Widget _buildSellerList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      itemCount: _filteredSellers.length,
      itemBuilder: (context, index) {
        final seller = _filteredSellers[index];
        return _sellerCard(seller, index);
      },
    );
  }

  Widget _sellerCard(SellerModel seller, int index) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: seller.isActive ? Colors.transparent : Colors.grey.withOpacity(0.3)),
      ),
      color: seller.isActive ? softWhite : Colors.grey[100],
      child: InkWell(
        onTap: () => _showDetailsModal(seller),
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            children: [
              Container(
                height: 55, width: 55,
                decoration: BoxDecoration(
                  color: seller.isActive ? forestGreen.withOpacity(0.1) : Colors.grey[300],
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(Icons.inventory_2_outlined, color: seller.isActive ? forestGreen : Colors.grey),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(seller.businessName, 
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold, 
                        color: seller.isActive ? navyBlue : Colors.grey[500],
                        decoration: seller.isActive ? null : TextDecoration.lineThrough,
                      )),
                    Text("GST: ${seller.gstin}", style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey)),
                  ],
                ),
              ),
              Column(
                children: [
                  PopupMenuButton<String>(
                    onSelected: (val) {
                      if (val == 'status') _toggleStatus(seller);
                      if (val == 'view') _showDetailsModal(seller);
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(value: 'view', child: Text("Full Profile")),
                      PopupMenuItem(value: 'status', child: Text(seller.isActive ? "Inactivate" : "Activate")),
                    ],
                  ),
                  _statusBadge(seller.isActive),
                ],
              ),
            ],
          ),
        ),
      ),
    ).animate(delay: (80 * index).ms).slideX(begin: 0.1, end: 0).fadeIn();
  }

  Widget _statusBadge(bool active) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: active ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(active ? "ACTIVE" : "INACTIVE", 
        style: TextStyle(color: active ? Colors.green : Colors.red, fontSize: 8, fontWeight: FontWeight.bold)),
    );
  }

  // ---------------------------------------------------------------------------
  // 7. COMPREHENSIVE VIEW PROFILE
  // ---------------------------------------------------------------------------

  void _showDetailsModal(SellerModel seller) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
        child: Column(
          children: [
            _modalTop(seller.businessName, forestGreen),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(25),
                child: Column(
                  children: [
                    _detailGroup("Basic Business Info", [
                      _infoRow("Company", seller.businessName, Icons.business),
                      _infoRow("GSTIN", seller.gstin, Icons.verified_user),
                      _infoRow("PAN", seller.pan, Icons.credit_card),
                    ]),
                    const Divider(height: 40),
                    _detailGroup("Contact Details", [
                      _infoRow("Address", seller.address, Icons.map),
                      _infoRow("Mobile", seller.mobile, Icons.phone_android),
                      _infoRow("Email", seller.email, Icons.email),
                    ]),
                    const Divider(height: 40),
                    _detailGroup("Management", [
                      _infoRow("Contact Person", seller.contactPerson, Icons.person),
                      _infoRow("Designation", seller.designation, Icons.badge),
                    ]),
                    const Divider(height: 40),
                    _detailGroup("Bank Information", [
                      _infoRow("Bank Name", seller.bankName, Icons.account_balance),
                      _infoRow("A/C Number", seller.accountNo, Icons.numbers),
                      _infoRow("IFSC", seller.ifscCode, Icons.code),
                    ]),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 8. DATA ENTRY FORM (ADD SELLER)
  // ---------------------------------------------------------------------------

  void _showAddSellerForm() {
    final bizNameC = TextEditingController();
    final gstC = TextEditingController();
    final phoneC = TextEditingController();
    final addrC = TextEditingController();
    final bankC = TextEditingController();
    final accC = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.9,
        decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
        child: Column(
          children: [
            _modalTop("Register New Seller", accentGold),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _formSectionLabel("BUSINESS IDENTITY"),
                    _gridRow([_input(bizNameC, "Business Name *"), _input(gstC, "GSTIN *")]),
                    _input(addrC, "Full Address", lines: 2),
                    
                    _formSectionLabel("COMMUNICATION"),
                    _input(phoneC, "Mobile Number"),
                    
                    _formSectionLabel("FINANCIALS"),
                    _input(bankC, "Bank Name"),
                    _gridRow([_input(accC, "Account No"), _input(TextEditingController(), "IFSC Code")]),

                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () {
                        if (bizNameC.text.isNotEmpty) {
                          setState(() {
                            _masterSellers.insert(0, SellerModel(
                              id: "S${_masterSellers.length + 1}",
                              businessName: bizNameC.text,
                              gstin: gstC.text,
                              address: addrC.text,
                              mobile: phoneC.text,
                              bankName: bankC.text,
                              accountNo: accC.text,
                              registrationDate: DateTime.now(),
                            ));
                            _filteredSellers = List.from(_masterSellers);
                          });
                          Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: forestGreen,
                        minimumSize: const Size(double.infinity, 60),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      ),
                      child: Text("Register Seller", style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(height: 50),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 9. HELPER UI WIDGETS
  // ---------------------------------------------------------------------------

  Widget _modalTop(String title, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(color: color, borderRadius: const BorderRadius.vertical(top: Radius.circular(30))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title.toUpperCase(), style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
          IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close, color: Colors.white)),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String val, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        children: [
          Icon(icon, color: forestGreen, size: 20),
          const SizedBox(width: 15),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(label, style: GoogleFonts.poppins(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
            Text(val.isEmpty ? "N/A" : val, style: GoogleFonts.poppins(fontSize: 14, color: navyBlue, fontWeight: FontWeight.w600)),
          ]),
        ],
      ),
    );
  }

  Widget _input(TextEditingController c, String label, {int lines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey)),
        const SizedBox(height: 5),
        TextField(
          controller: c, maxLines: lines,
          decoration: InputDecoration(
            filled: true, fillColor: scaffoldBg,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          ),
        ),
      ]),
    );
  }

  Widget _gridRow(List<Widget> items) {
    return Row(children: items.map((i) => Expanded(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 4), child: i))).toList());
  }

  Widget _detailGroup(String title, List<Widget> items) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [_formSectionLabel(title), ...items]);
  }

  Widget _formSectionLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 10),
      child: Text(text, style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w900, color: navyBlue, letterSpacing: 1)),
    );
  }

  Widget _buildEmptyView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.person_add_disabled_outlined, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 15),
          Text("No Sellers Registered", style: GoogleFonts.poppins(color: Colors.grey, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildAddButton() {
    return FloatingActionButton.extended(
      onPressed: _showAddSellerForm,
      backgroundColor: forestGreen,
      icon: const Icon(Icons.add, color: Colors.white),
      label: const Text("ADD SELLER", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
    );
  }
}
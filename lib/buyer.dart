import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'footer.dart';

// ---------------------------------------------------------------------------
// 1. ADVANCED DATA MODEL
// ---------------------------------------------------------------------------
class BuyerModel {
  final String id;
  String name;
  String email;
  String mobile;
  String address;
  String gstin;
  String pan;
  // Contact Person
  String repName;
  String designation;
  String directPhone;
  String alternateNo;
  // Banking
  String bankName;
  String accountNo;
  String ifscCode;
  
  bool isActive;
  DateTime createdAt;

  BuyerModel({
    required this.id,
    required this.name,
    this.email = "",
    this.mobile = "",
    this.address = "",
    this.gstin = "",
    this.pan = "",
    this.repName = "",
    this.designation = "",
    this.directPhone = "",
    this.alternateNo = "",
    this.bankName = "",
    this.accountNo = "",
    this.ifscCode = "",
    this.isActive = true,
    required this.createdAt,
  });
}

// ---------------------------------------------------------------------------
// 2. MAIN PAGE STATEFUL WIDGET
// ---------------------------------------------------------------------------
class BuyerPage extends StatefulWidget {
  const BuyerPage({super.key});

  @override
  State<BuyerPage> createState() => _BuyerPageState();
}

class _BuyerPageState extends State<BuyerPage> {
  // --- Branding Colors ---
  final Color navyBlue = const Color(0xFF001A33);
  final Color royalBlue = const Color(0xFF0056b3);
  final Color accentGold = const Color(0xFFC5A059);
  final Color surfaceWhite = const Color(0xFFFFFFFF);
  final Color backgroundGrey = const Color(0xFFF8FAFC);

  // --- Logic & Controllers ---
  final List<BuyerModel> _masterList = [];
  List<BuyerModel> _displayList = [];
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  void _loadInitialData() {
    // Adding dummy data for immediate "Wow" factor
    final initialBuyers = [
      BuyerModel(
        id: "1",
        name: "Reliance Industries Ltd",
        gstin: "27AAACR1234F1Z5",
        address: "RCP, Navi Mumbai, Maharashtra",
        email: "corp@reliance.com",
        mobile: "022-44770000",
        bankName: "HDFC Bank",
        accountNo: "50200088991122",
        ifscCode: "HDFC0000123",
        createdAt: DateTime.now(),
      ),
      BuyerModel(
        id: "2",
        name: "Raymond Group",
        gstin: "27BKRP1002G1Z2",
        address: "Raymond Estate, Thane West",
        repName: "Gautam Singhania",
        createdAt: DateTime.now(),
      ),
      BuyerModel(
        id: "3",
        name: "Arvind Textiles",
        gstin: "24AAACA0101A1Z0",
        address: "Naroda Road, Ahmedabad",
        isActive: false,
        createdAt: DateTime.now(),
      ),
    ];
    setState(() {
      _masterList.addAll(initialBuyers);
      _displayList = List.from(_masterList);
    });
  }

  // ---------------------------------------------------------------------------
  // 3. CORE LOGIC METHODS
  // ---------------------------------------------------------------------------

  void _runFilter(String enteredKeyword) {
    List<BuyerModel> results = [];
    if (enteredKeyword.isEmpty) {
      results = _masterList;
    } else {
      results = _masterList
          .where((user) => user.name.toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
    }
    setState(() {
      _displayList = results;
    });
  }

  void _toggleBuyerStatus(BuyerModel buyer) {
    setState(() {
      buyer.isActive = !buyer.isActive;
    });
  }

  // ---------------------------------------------------------------------------
  // 4. UI BUILDING - SCAFFOLD
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundGrey,
      bottomNavigationBar: const CustomFooter(currentIndex: -1),
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildStatsHeader(),
          _buildSearchBar(),
          Expanded(
            child: _displayList.isEmpty ? _buildNoDataFound() : _buildBuyerListView(),
          ),
        ],
      ),
      floatingActionButton: _buildFab(),
    );
  }

  // ---------------------------------------------------------------------------
  // 5. MODULAR UI COMPONENTS (AppBar, Header, Search)
  // ---------------------------------------------------------------------------

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: navyBlue,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text("Buyer Master", 
        style: GoogleFonts.poppins(fontWeight: FontWeight.w700, color: Colors.white, letterSpacing: 1)),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.tune_rounded, color: Colors.white70),
          onPressed: () {}, // Filter logic
        )
      ],
    );
  }

  Widget _buildStatsHeader() {
    int activeCount = _masterList.where((b) => b.isActive).length;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
      decoration: BoxDecoration(
        color: navyBlue,
        borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(40), bottomRight: Radius.circular(40)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _headerStatItem("Total", "${_masterList.length}"),
              _headerStatItem("Active", "$activeCount", color: Colors.greenAccent),
              _headerStatItem("Inactive", "${_masterList.length - activeCount}", color: Colors.redAccent),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    ).animate().slideY(begin: -1, end: 0, duration: 500.ms, curve: Curves.easeOutCubic);
  }

  Widget _headerStatItem(String label, String value, {Color color = Colors.white}) {
    return Column(
      children: [
        Text(value, style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
        Text(label, style: GoogleFonts.poppins(fontSize: 12, color: Colors.white54, fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(25, 20, 25, 10),
      child: Container(
        decoration: BoxDecoration(
          color: surfaceWhite,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, 5))],
        ),
        child: TextField(
          controller: _searchController,
          onChanged: (value) => _runFilter(value),
          decoration: InputDecoration(
            hintText: "Search company or GST...",
            hintStyle: GoogleFonts.poppins(color: Colors.grey[400], fontSize: 14),
            prefixIcon: Icon(Icons.search_rounded, color: royalBlue),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 15),
          ),
        ),
      ),
    ).animate().fadeIn(delay: 300.ms);
  }

  // ---------------------------------------------------------------------------
  // 6. BUYER LIST VIEW & CARD DESIGN
  // ---------------------------------------------------------------------------

  Widget _buildBuyerListView() {
    return ListView.builder(
      padding: const EdgeInsets.all(25),
      itemCount: _displayList.length,
      itemBuilder: (context, index) {
        final buyer = _displayList[index];
        return _buildBuyerCard(buyer, index);
      },
    );
  }

  Widget _buildBuyerCard(BuyerModel buyer, int index) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 18),
      color: buyer.isActive ? surfaceWhite : Colors.grey[100],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: buyer.isActive ? Colors.transparent : Colors.grey[300]!),
      ),
      child: InkWell(
        onTap: () => _viewBuyerDetails(buyer),
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            children: [
              // Circular Indicator
              Container(
                width: 55, height: 55,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: buyer.isActive ? [royalBlue, navyBlue] : [Colors.grey, Colors.blueGrey],
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Icon(Icons.business_center_rounded, color: Colors.white),
              ),
              const SizedBox(width: 15),
              // Text Data
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(buyer.name, 
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold, fontSize: 16, 
                        color: buyer.isActive ? navyBlue : Colors.grey[500],
                        decoration: buyer.isActive ? null : TextDecoration.lineThrough,
                      )),
                    const SizedBox(height: 4),
                    Text(buyer.gstin.isEmpty ? "No GST Number" : "GST: ${buyer.gstin}", 
                      style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600])),
                  ],
                ),
              ),
              // Action Menu
              PopupMenuButton<String>(
                onSelected: (val) {
                  if (val == 'status') _toggleBuyerStatus(buyer);
                  if (val == 'view') _viewBuyerDetails(buyer);
                },
                itemBuilder: (context) => [
                  PopupMenuItem(value: 'view', child: _popItem(Icons.visibility, "View Info")),
                  PopupMenuItem(value: 'status', child: _popItem(
                    buyer.isActive ? Icons.block : Icons.check_circle, 
                    buyer.isActive ? "Inactivate" : "Activate",
                    color: buyer.isActive ? Colors.red : Colors.green
                  )),
                ],
                icon: const Icon(Icons.more_vert_rounded, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    ).animate(delay: (100 * index).ms).slideX(begin: 0.1, end: 0).fadeIn();
  }

  Widget _popItem(IconData icon, String label, {Color color = Colors.black87}) {
    return Row(children: [Icon(icon, size: 18, color: color), const SizedBox(width: 10), Text(label)]);
  }

  // ---------------------------------------------------------------------------
  // 7. COMPREHENSIVE VIEW DETAILS MODAL
  // ---------------------------------------------------------------------------

  void _viewBuyerDetails(BuyerModel buyer) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
        child: Column(
          children: [
            _modalHeader(buyer.name, isEdit: false),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(25),
                child: Column(
                  children: [
                    _infoSection("Party Identity", [
                      _infoTile("Company Name", buyer.name, Icons.corporate_fare),
                      _infoTile("GSTIN", buyer.gstin, Icons.assignment_turned_in),
                      _infoTile("PAN Number", buyer.pan, Icons.badge),
                    ]),
                    const Divider(height: 40),
                    _infoSection("Communication", [
                      _infoTile("Address", buyer.address, Icons.location_on),
                      _infoTile("Official Email", buyer.email, Icons.alternate_email),
                      _infoTile("Mobile", buyer.mobile, Icons.phone_iphone),
                    ]),
                    const Divider(height: 40),
                    _infoSection("Contact Person", [
                      _infoTile("Representative", buyer.repName, Icons.person),
                      _infoTile("Designation", buyer.designation, Icons.work),
                    ]),
                    const Divider(height: 40),
                    _infoSection("Bank Account", [
                      _infoTile("Bank Name", buyer.bankName, Icons.account_balance),
                      _infoTile("Account No", buyer.accountNo, Icons.numbers),
                      _infoTile("IFSC", buyer.ifscCode, Icons.code),
                    ]),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoTile(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: backgroundGrey, borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: royalBlue, size: 20),
          ),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.bold)),
              Text(value.isEmpty ? "Not Specified" : value, style: GoogleFonts.poppins(fontSize: 14, color: navyBlue, fontWeight: FontWeight.w600)),
            ],
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 8. MULTI-SECTION DATA ENTRY FORM
  // ---------------------------------------------------------------------------

  void _showAddBuyerForm(BuildContext context) {
    final nameC = TextEditingController();
    final gstinC = TextEditingController();
    final emailC = TextEditingController();
    final phoneC = TextEditingController();
    final addrC = TextEditingController();
    final bankC = TextEditingController();
    final accC = TextEditingController();
    final ifscC = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.9,
        decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
        child: Column(
          children: [
            _modalHeader("New Buyer Registration"),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _formHeader("Primary Information"),
                    _inputRow([_formField("Company Name *", nameC), _formField("GSTIN *", gstinC)]),
                    _formField("Office Address", addrC, maxLines: 2),
                    _formHeader("Contact Details"),
                    _inputRow([_formField("Official Email", emailC), _formField("Phone", phoneC)]),
                    _formHeader("Bank Details"),
                    _formField("Bank Name", bankC),
                    _inputRow([_formField("Account Number", accC), _formField("IFSC Code", ifscC)]),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () {
                        if (nameC.text.isNotEmpty) {
                          setState(() {
                            _masterList.insert(0, BuyerModel(
                              id: DateTime.now().toString(),
                              name: nameC.text,
                              gstin: gstinC.text,
                              address: addrC.text,
                              email: emailC.text,
                              mobile: phoneC.text,
                              bankName: bankC.text,
                              accountNo: accC.text,
                              ifscCode: ifscC.text,
                              createdAt: DateTime.now(),
                            ));
                            _displayList = List.from(_masterList);
                          });
                          Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: royalBlue,
                        minimumSize: const Size(double.infinity, 60),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      ),
                      child: Text("Create Buyer Record", style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold)),
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
  // 9. HELPER WIDGETS
  // ---------------------------------------------------------------------------

  Widget _modalHeader(String title, {bool isEdit = true}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(color: isEdit ? royalBlue : navyBlue, borderRadius: const BorderRadius.vertical(top: Radius.circular(30))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title.toUpperCase(), style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
          IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close, color: Colors.white)),
        ],
      ),
    );
  }

  Widget _formHeader(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Text(text.toUpperCase(), style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w900, color: navyBlue, letterSpacing: 1.2)),
    );
  }

  Widget _formField(String label, TextEditingController ctrl, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey)),
          const SizedBox(height: 5),
          TextField(
            controller: ctrl,
            maxLines: maxLines,
            decoration: InputDecoration(
              filled: true,
              fillColor: backgroundGrey,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _inputRow(List<Widget> children) {
    return Row(children: children.map((w) => Expanded(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 4), child: w))).toList());
  }

  Widget _infoSection(String title, List<Widget> children) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [_formHeader(title), ...children]);
  }

  Widget _buildNoDataFound() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off_rounded, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 10),
          Text("No Buyer Matches Found", style: GoogleFonts.poppins(color: Colors.grey, fontWeight: FontWeight.bold)),
          TextButton(onPressed: () => _showAddBuyerForm(context), child: const Text("Add New Buyer Instead")),
        ],
      ),
    );
  }

  Widget _buildFab() {
    return FloatingActionButton.extended(
      onPressed: () => _showAddBuyerForm(context),
      backgroundColor: royalBlue,
      icon: const Icon(Icons.add, color: Colors.white),
      label: Text("ADD BUYER", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white)),
    );
  }
}
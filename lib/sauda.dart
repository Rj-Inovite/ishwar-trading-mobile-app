import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

// ---------------------------------------------------------------------------
// 1. GLOBAL SYNC REGISTRY
// ---------------------------------------------------------------------------
class GlobalItemRegistry {
  static List<String> categories = ["Cotton", "Cotton-Waste", "Organic", "BCI", "Yarn"];
  static Map<String, List<String>> subCategories = {
    "Cotton": ["Shankar-6", "MCU-5", "Bunny", "RD-71", "J-34"],
    "Cotton-Waste": ["Comber Noil", "Yellow Cotton", "Flat Card", "Droppings"],
    "Organic": ["NPOP Certified", "BCI-Organic Mix", "GOTS Certified"],
  };
  
  static List<String> sellers = ["M/s. SHRI RASBEHARI COTTON", "Ruchitra Enterprises", "Goyal Petro", "Aryan Textile"];
  static List<String> buyers = ["NITIN TRADERS", "Sharma Agro", "Reliance Ind.", "Khandelwal Exp"];
}

// ---------------------------------------------------------------------------
// 2. ENTERPRISE DATA MODELS (ENHANCED)
// ---------------------------------------------------------------------------
class SaudaModel {
  final String id;
  final String companyName;
  final DateTime saudaDate;
  final String spNo;
  final String seller;
  final String buyer;
  final String? consignee;
  final String item;
  final String? subItem;
  final double rate;
  final double qty; // MT
  final int bales;  // Specific for Cotton
  final double tolerance;
  final double commSeller;
  final double commBuyer;
  final String remarks;
  final String transport;
  final String loading;
  final String insurance;
  final String paymentTerm;
  final String transportBy;
  final String inspection;
  final bool tcRequired;
  final double tds;
  final String gstType;
  final double gstRate;
  final String status;
  final DateTime createdAt;
  
  // Bank Details
  final String bankName;
  final String accountNo;
  final String ifscCode;

  SaudaModel({
    required this.id, required this.companyName, required this.saudaDate,
    required this.spNo, required this.seller, required this.buyer,
    this.consignee, required this.item, this.subItem, required this.rate,
    required this.qty, required this.bales, required this.tolerance, 
    required this.commSeller, required this.commBuyer, required this.remarks,
    required this.transport, required this.loading, required this.insurance,
    required this.paymentTerm, required this.transportBy, required this.inspection,
    required this.tcRequired, required this.tds, 
    required this.gstType, required this.gstRate, required this.status,
    required this.createdAt, required this.bankName, required this.accountNo, 
    required this.ifscCode,
  });

  double get baseAmount => qty * rate;
  double get gstAmount => baseAmount * (gstRate / 100);
  double get netTotal => baseAmount + gstAmount;
  double get roundedTotal => netTotal.roundToDouble();
}

// ---------------------------------------------------------------------------
// 3. MAIN DASHBOARD PAGE
// ---------------------------------------------------------------------------
class SaudaPage extends StatefulWidget {
  const SaudaPage({super.key});

  @override
  State<SaudaPage> createState() => _SaudaPageState();
}

class _SaudaPageState extends State<SaudaPage> {
  final Color navyBlue = const Color(0xFF001A33);
  final Color royalBlue = const Color(0xFF007BFF);
  final Color cottonGold = const Color(0xFFC5A059);

  List<SaudaModel> _saudaList = [];
  bool _isOverlayOpen = false;
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    _saudaList.add(SaudaModel(
      id: "337", companyName: "SHRI ISHWAR TRADING COMPANY", saudaDate: DateTime.now(),
      spNo: "IS-2025-26-337", seller: "M/s. SHRI RASBEHARI COTTON", buyer: "NITIN TRADERS",
      item: "Cotton", subItem: "SUPER GRADE", rate: 48000.0, qty: 150.0, bales: 750,
      tolerance: 2.0, commSeller: 75.0, commBuyer: 0.0,
      remarks: "UNLOADING 2ND DAY PAYMENT", transport: "Inclusive",
      loading: "Exclusive", insurance: "Seller Account", paymentTerm: "NET CASH",
      transportBy: "Seller", inspection: "Buyer Place", tcRequired: true,
      tds: 0.1, gstType: "IGST", gstRate: 5.0,
      status: "BOOKED", createdAt: DateTime.now(),
      bankName: "HDFC BANK", accountNo: "50200012345678", ifscCode: "HDFC0001234",
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          _buildBodyContent(),
          if (_isOverlayOpen) _buildCompanyPickerOverlay(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => setState(() => _isOverlayOpen = true),
        backgroundColor: royalBlue,
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text("NEW SAUDA", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white)),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: navyBlue,
      elevation: 0,
      title: Text("SAUDA PATRAK", style: GoogleFonts.poppins(fontWeight: FontWeight.w800, letterSpacing: 1.2, color: Colors.white)),
      centerTitle: true,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
          child: _buildSearchBar(),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      onChanged: (v) => setState(() => _searchQuery = v),
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: "Search Company, Seller or ID...",
        hintStyle: const TextStyle(color: Colors.white54, fontSize: 13),
        prefixIcon: const Icon(Icons.search, color: Colors.white70),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
      ),
    );
  }

  Widget _buildBodyContent() {
    final filtered = _saudaList.where((s) => 
      s.companyName.toLowerCase().contains(_searchQuery.toLowerCase()) || 
      s.seller.toLowerCase().contains(_searchQuery.toLowerCase()) ||
      s.spNo.contains(_searchQuery)
    ).toList();
    
    return Column(
      children: [
        _buildStatBanner(),
        Expanded(
          child: filtered.isEmpty ? _buildEmptyPlaceholder() : ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            itemCount: filtered.length,
            itemBuilder: (context, index) => _buildSaudaCard(filtered[index], index),
          ),
        ),
      ],
    );
  }

  Widget _buildStatBanner() {
    double totalVolume = _saudaList.fold(0, (sum, item) => sum + item.qty);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
      decoration: BoxDecoration(color: navyBlue, borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _statBox("TOTAL DEALS", _saudaList.length.toString(), Colors.white),
          _statBox("MT VOLUME", totalVolume.toStringAsFixed(2), cottonGold),
          _statBox("SYSTEM", "STABLE", Colors.greenAccent),
        ],
      ),
    );
  }

  Widget _statBox(String l, String v, Color c) => Column(
    children: [
      Text(v, style: GoogleFonts.poppins(color: c, fontWeight: FontWeight.bold, fontSize: 20)),
      Text(l, style: const TextStyle(color: Colors.white38, fontSize: 9, letterSpacing: 1)),
    ],
  );

  Widget _buildSaudaCard(SaudaModel sauda, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))]),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: navyBlue.withOpacity(0.05), borderRadius: BorderRadius.circular(12)),
          child: Icon(Icons.receipt_long_rounded, color: navyBlue),
        ),
        title: Text(sauda.buyer, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 14)),
        subtitle: Text("${sauda.spNo} • ${sauda.item}", style: const TextStyle(fontSize: 11)),
        trailing: _buildStatusBadge(sauda.status),
        children: [
          _buildCardDetails(sauda),
        ],
      ),
    ).animate().fadeIn(delay: (index * 80).ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildCardDetails(SaudaModel sauda) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Column(
        children: [
          const Divider(),
          _infoLine("Seller", sauda.seller),
          _infoLine("Bales", "${sauda.bales} Units"),
          _infoLine("Net Amount", "₹${NumberFormat('#,###.00').format(sauda.roundedTotal)}", isBold: true),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _actionIconButton(Icons.visibility_rounded, "VIEW", Colors.blue, () => _handlePreview(sauda, isPdf: false)),
              _actionIconButton(Icons.picture_as_pdf_rounded, "PDF", Colors.redAccent, () => _handlePreview(sauda, isPdf: true)),
              _actionIconButton(Icons.edit_document, "EDIT", Colors.orange, () {}),
              _actionIconButton(Icons.share_rounded, "SHARE", Colors.green, () {}),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildCompanyPickerOverlay() {
    return Container(
      color: Colors.black.withOpacity(0.8),
      child: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.85,
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(35), boxShadow: [BoxShadow(color: Colors.white.withOpacity(0.1), blurRadius: 40)]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("SELECT FIRM", style: GoogleFonts.poppins(fontWeight: FontWeight.w900, color: navyBlue, fontSize: 18)),
              const SizedBox(height: 8),
              const Text("Select entity to create Sauda Patrak", style: TextStyle(color: Colors.grey, fontSize: 12)),
              const SizedBox(height: 30),
              _companyCard("ISHWAR GLOBAL", "IG-25-26-", "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS2fMeeY6od5EVDriZUNz_WRpXX0yqXvRbwVp2Xen8DHg&s"),
              const SizedBox(height: 15),
              _companyCard("SHRI ISHWAR TRADING", "IS-25-26-", "https://thumbs.dreamstime.com/z/cotton-logo-template-vector-design-symbol-nature-335208618.jpg"),
              const SizedBox(height: 30),
              TextButton(onPressed: () => setState(() => _isOverlayOpen = false), child: const Text("CLOSE", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold))),
            ],
          ),
        ).animate().scale(curve: Curves.elasticOut, duration: 700.ms),
      ),
    );
  }

  Widget _companyCard(String name, String prefix, String imgUrl) {
    return InkWell(
      onTap: () {
        setState(() => _isOverlayOpen = false);
        Navigator.push(context, MaterialPageRoute(builder: (context) => SaudaFormPage(
          companyName: name, 
          spPrefix: prefix,
          onSave: (model) => setState(() => _saudaList.insert(0, model)),
        )));
      },
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade200), borderRadius: BorderRadius.circular(20), color: Colors.grey.shade50),
        child: Row(
          children: [
            ClipRRect(borderRadius: BorderRadius.circular(10), child: Image.network(imgUrl, width: 45, height: 45, fit: BoxFit.cover)),
            const SizedBox(width: 15),
            Expanded(child: Text(name, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 14, color: navyBlue))),
            const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 4. THE ELABORATED VIEW & PDF LOGIC
  // ---------------------------------------------------------------------------
  void _handlePreview(SaudaModel sauda, {required bool isPdf}) {
    if (isPdf) {
      _generateAndDisplayPdf(sauda);
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.92,
        decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(40))),
        child: Column(
          children: [
            _modalHeader("DETAILED SAUDA REPORT", false),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _reportBrandHeader(sauda),
                    const Divider(height: 40),
                    
                    Text("1. BASIC INFORMATION", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: royalBlue)),
                    const SizedBox(height: 10),
                    _detailGrid([
                      _dataPoint("Conf No", sauda.id),
                      _dataPoint("Date", DateFormat('dd/MM/yyyy').format(sauda.saudaDate)),
                      _dataPoint("Day", DateFormat('EEEE').format(sauda.saudaDate)),
                      _dataPoint("SP No", sauda.spNo),
                    ]),

                    const SizedBox(height: 25),
                    Text("2. PARTY DETAILS", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: royalBlue)),
                    const SizedBox(height: 10),
                    _detailBox([
                      _infoLine("Seller Name", sauda.seller),
                      _infoLine("Buyer Name", sauda.buyer),
                      if(sauda.consignee != null) _infoLine("Consignee", sauda.consignee!),
                    ]),

                    const SizedBox(height: 25),
                    Text("3. PRODUCT & QUANTITY", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: royalBlue)),
                    const SizedBox(height: 10),
                    _detailGrid([
                      _dataPoint("Item", sauda.item),
                      _dataPoint("Variety", sauda.subItem ?? "Standard"),
                      _dataPoint("Bales", "${sauda.bales} Bales"),
                      _dataPoint("Weight", "${sauda.qty} MT"),
                      _dataPoint("Rate", "₹${sauda.rate}/MT"),
                      _dataPoint("Tolerance", "±${sauda.tolerance}%"),
                    ]),

                    const SizedBox(height: 25),
                    Text("4. LOGISTICS & TERMS", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: royalBlue)),
                    const SizedBox(height: 10),
                    _detailBox([
                      _infoLine("Transport", sauda.transport),
                      _infoLine("Loading", sauda.loading),
                      _infoLine("Insurance", sauda.insurance),
                      _infoLine("Payment", sauda.paymentTerm),
                      _infoLine("TC Required", sauda.tcRequired ? "YES" : "NO"),
                    ]),

                    const SizedBox(height: 25),
                    Text("5. FINANCIALS", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: royalBlue)),
                    const SizedBox(height: 10),
                    _detailBox([
                      _infoLine("Taxable Amount", "₹${NumberFormat('#,###.00').format(sauda.baseAmount)}"),
                      _infoLine("GST (${sauda.gstRate}%)", "₹${NumberFormat('#,###.00').format(sauda.gstAmount)}"),
                      _infoLine("NET TOTAL", "₹${NumberFormat('#,###.00').format(sauda.roundedTotal)}", isBold: true),
                      _infoLine("Seller Comm.", "₹${sauda.commSeller} Per Bale"),
                    ]),

                    const SizedBox(height: 25),
                    Text("6. BANK DETAILS", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: royalBlue)),
                    const SizedBox(height: 10),
                    _detailBox([
                      _infoLine("Bank", sauda.bankName),
                      _infoLine("A/C No", sauda.accountNo),
                      _infoLine("IFSC", sauda.ifscCode),
                    ]),

                    const SizedBox(height: 25),
                    Text("7. REMARKS", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: royalBlue)),
                    const SizedBox(height: 10),
                    Text(sauda.remarks, style: const TextStyle(fontSize: 13, color: Colors.black87)),

                    const SizedBox(height: 60),
                    _signatureBlock(sauda.companyName),
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

  // --- PDF GENERATOR (MATCHING IMAGE) ---
  Future<void> _generateAndDisplayPdf(SaudaModel sauda) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header
              pw.Center(
                child: pw.Column(children: [
                  pw.Text(sauda.companyName, style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold)),
                  pw.Text("'M-SQUARE TUTORIALS' Near Deshonnati Press Gaorakshan Road Akola 444001", style: const pw.TextStyle(fontSize: 10)),
                  pw.Text("Ph: 0724 2401455 Mobile: +91 8286522808 Email: ishwar.trade@gmail.com", style: const pw.TextStyle(fontSize: 10)),
                  pw.SizedBox(height: 10),
                  pw.Divider(),
                ]),
              ),

              // Title Row
              pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
                pw.Text("Conf No. : ${sauda.id}", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                pw.Text("SALE CONFIRMATION", style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold, decoration: pw.TextDecoration.underline)),
                pw.Text("Dt: ${DateFormat('dd/MM/yyyy').format(sauda.saudaDate)}"),
              ]),
              pw.SizedBox(height: 20),

             // Buyer Table
pw.Row(
  children: [
    pw.Expanded(
      child: pw.Container(
        padding: const pw.EdgeInsets.all(10),
        decoration: pw.BoxDecoration(
          border: pw.Border.all(),
        ),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              "Buyer:",
              style: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.Text(sauda.buyer),
            pw.Text("GSTIN: 27AJKR2194N1ZB"),
          ],
        ),
      ),
    ),

    pw.SizedBox(width: 10),

    pw.Expanded(
      child: pw.Container(
        padding: const pw.EdgeInsets.all(10),
        decoration: pw.BoxDecoration(
          border: pw.Border.all(),
        ),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              "Delivery At:",
              style: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.Text("Factory/Warehouse as per instruction"),
            pw.Text("PAN No: XXXXXX000X"),
          ],
        ),
      ),
    ),
  ],
),

pw.SizedBox(height: 20),

pw.Text(
  "As per the Telephonic conversation, we are confirming the sale with below specifications:",
),

pw.SizedBox(height: 15),
              // Detailed Rows
              _pdfRow("Name of Seller", sauda.seller),
              _pdfRow("Variety", sauda.subItem ?? "Standard"),
              _pdfRow("Station", "AS PER DISPATCH"),
              _pdfRow("Spec.", "MM, MIC, Trash, Moisture as per testing"),
              _pdfRow("Bales", "${sauda.bales} Bales Only"),
              _pdfRow("Price", "Rs. ${sauda.rate}/- SPOT Per Candy Passing"),
              _pdfRow("Payment", sauda.paymentTerm),
              _pdfRow("Insurance", sauda.insurance),
              _pdfRow("Remarks", sauda.remarks),
              _pdfRow("Seller Comm.", "Rs. ${sauda.commSeller} PER BALE AS PER INVOICE"),

              pw.Spacer(),
              pw.Divider(),
              pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
                pw.Text("Thanking You"),
                pw.Column(children: [
                  pw.Text("For ${sauda.companyName}", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.SizedBox(height: 40),
                  pw.Text("Authorized Signatory"),
                ])
              ])
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
  }

  pw.Widget _pdfRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 4),
      child: pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
        pw.SizedBox(width: 120, child: pw.Text(label, style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
        pw.Text(": "),
        pw.Expanded(child: pw.Text(value)),
      ]),
    );
  }

  // --- SUB-WIDGETS ---
  Widget _modalHeader(String t, bool red) => Container(
    padding: const EdgeInsets.all(25),
    decoration: BoxDecoration(color: red ? Colors.red.shade900 : navyBlue, borderRadius: const BorderRadius.vertical(top: Radius.circular(40))),
    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(t, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1)),
      IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close, color: Colors.white)),
    ]),
  );

  Widget _reportBrandHeader(SaudaModel s) => Row(
    children: [
      const Icon(Icons.business_center, size: 50, color: Color(0xFFC5A059)),
      const SizedBox(width: 15),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(s.companyName, style: GoogleFonts.poppins(fontWeight: FontWeight.w900, fontSize: 18)),
        Text("TRANSACTION ID: #SAUDA-${s.id}", style: const TextStyle(color: Colors.grey, fontSize: 11)),
      ]),
    ],
  );

  Widget _detailGrid(List<Widget> children) => GridView.count(
    crossAxisCount: 2, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
    childAspectRatio: 3, children: children,
  );

  Widget _dataPoint(String l, String v) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(l, style: const TextStyle(color: Colors.grey, fontSize: 10)),
      Text(v, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
    ],
  );

  Widget _detailBox(List<Widget> children) => Container(
    padding: const EdgeInsets.all(15),
    decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.grey.shade200)),
    child: Column(children: children),
  );

  Widget _signatureBlock(String co) => Column(
    crossAxisAlignment: CrossAxisAlignment.end,
    children: [
      const Divider(),
      const SizedBox(height: 10),
      Text("E-Signed Verification", style: TextStyle(color: Colors.grey.shade400, fontSize: 10)),
      Text(co, style: GoogleFonts.dancingScript(fontSize: 22, fontWeight: FontWeight.bold, color: navyBlue)),
      const Text("Digital Authorized Signatory", style: TextStyle(fontSize: 10, letterSpacing: 1)),
    ],
  );

  Widget _infoLine(String l, String v, {bool isBold = false}) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(l, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      Text(v, style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.w500, fontSize: 13, color: isBold ? navyBlue : Colors.black87)),
    ]),
  );

  Widget _buildStatusBadge(String s) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    decoration: BoxDecoration(color: Colors.green.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
    child: Text(s, style: const TextStyle(color: Colors.green, fontSize: 9, fontWeight: FontWeight.bold)),
  );

  Widget _actionIconButton(IconData i, String l, Color c, VoidCallback t) => InkWell(
    onTap: t,
    child: Column(children: [Icon(i, color: c, size: 22), const SizedBox(height: 4), Text(l, style: TextStyle(fontSize: 9, color: c, fontWeight: FontWeight.bold))]),
  );

  Widget _buildEmptyPlaceholder() => Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.layers_clear_outlined, size: 80, color: Colors.grey.shade300), const Text("No matching sauda found.", style: TextStyle(color: Colors.grey))]));
}

// ---------------------------------------------------------------------------
// 5. ENHANCED FORM PAGE
// ---------------------------------------------------------------------------
class SaudaFormPage extends StatefulWidget {
  final String companyName;
  final String spPrefix;
  final Function(SaudaModel) onSave;

  const SaudaFormPage({super.key, required this.companyName, required this.spPrefix, required this.onSave});

  @override
  State<SaudaFormPage> createState() => _SaudaFormPageState();
}

class _SaudaFormPageState extends State<SaudaFormPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _rateC = TextEditingController();
  final TextEditingController _qtyC = TextEditingController();
  final TextEditingController _balesC = TextEditingController();
  final TextEditingController _toleranceC = TextEditingController(text: "2.0");
  final TextEditingController _commSellerC = TextEditingController();
  final TextEditingController _commBuyerC = TextEditingController();
  final TextEditingController _remarksC = TextEditingController();
  final TextEditingController _paymentTermC = TextEditingController();
  final TextEditingController _gstRateC = TextEditingController(text: "5.0");
  final TextEditingController _bankNameC = TextEditingController();
  final TextEditingController _accountNoC = TextEditingController();
  final TextEditingController _ifscCodeC = TextEditingController();

  String? _selectedSeller;
  String? _selectedBuyer;
  String? _selectedItem;
  String? _selectedSubItem;
  String _transport = "Inclusive";
  String _loading = "Exclusive";
  String _insurance = "Seller Account";
  String _gstType = "IGST (Inter-State)";
  bool _tcReq = true;

  double _totalCalculated = 0.0;

  void _calculateTotals() {
    double r = double.tryParse(_rateC.text) ?? 0.0;
    double q = double.tryParse(_qtyC.text) ?? 0.0;
    double g = double.tryParse(_gstRateC.text) ?? 0.0;
    setState(() {
      _totalCalculated = (r * q) + ((r * q) * (g / 100));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: const Color(0xFF001A33), title: Text("CREATE SAUDA: ${widget.companyName}", style: const TextStyle(fontSize: 12))),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _formSection(Icons.info_outline, "1. HEADER & IDENTITY"),
              _displayCard([
                _labeledData("Date", DateFormat('dd-MM-yyyy').format(DateTime.now())),
                _labeledData("Day", DateFormat('EEEE').format(DateTime.now())),
                _labeledData("New ID", "${widget.spPrefix}${DateTime.now().millisecond}"),
              ]),

              const SizedBox(height: 30),
              _formSection(Icons.groups_outlined, "2. PARTY DETAILS"),
              _buildModernDropdown("Select Seller", GlobalItemRegistry.sellers, _selectedSeller, (v) => setState(() => _selectedSeller = v)),
              _buildModernDropdown("Select Buyer", GlobalItemRegistry.buyers, _selectedBuyer, (v) => setState(() => _selectedBuyer = v)),

              const SizedBox(height: 30),
              _formSection(Icons.inventory_2_outlined, "3. ITEM & QUANTITY"),
              _buildModernDropdown("Commodity", GlobalItemRegistry.categories, _selectedItem, (v) {
                setState(() { _selectedItem = v; _selectedSubItem = null; });
              }),
              if (_selectedItem != null)
                _buildModernDropdown("Variety / Grade", GlobalItemRegistry.subCategories[_selectedItem!] ?? ["Standard"], _selectedSubItem, (v) => setState(() => _selectedSubItem = v)),
              
              Row(children: [
                Expanded(child: _buildTextField("Rate (₹/MT)", _rateC, isNum: true, onCh: (v) => _calculateTotals())),
                const SizedBox(width: 15),
                Expanded(child: _buildTextField("Qty (MT)", _qtyC, isNum: true, onCh: (v) => _calculateTotals())),
              ]),
              Row(children: [
                Expanded(child: _buildTextField("Bales (Units)", _balesC, isNum: true)),
                const SizedBox(width: 15),
                Expanded(child: _buildTextField("Tolerance %", _toleranceC, isNum: true)),
              ]),

              const SizedBox(height: 30),
              _formSection(Icons.account_balance_outlined, "4. BANK DETAILS"),
              _buildTextField("Bank Name", _bankNameC),
              Row(children: [
                Expanded(child: _buildTextField("Account No", _accountNoC)),
                const SizedBox(width: 15),
                Expanded(child: _buildTextField("IFSC Code", _ifscCodeC)),
              ]),

              const SizedBox(height: 30),
              _formSection(Icons.local_shipping_outlined, "5. LOGISTICS & TERMS"),
              _buildModernDropdown("Transport", ["Inclusive", "Exclusive"], _transport, (v) => setState(() => _transport = v!)),
              _buildModernDropdown("Insurance", ["Seller Account", "Buyer Account"], _insurance, (v) => setState(() => _insurance = v!)),
              _buildTextField("Payment Term (e.g. NET CASH)", _paymentTermC),
              _buildTextField("Remarks", _remarksC, lines: 2),

              const SizedBox(height: 30),
              _formSection(Icons.calculate_outlined, "6. FINANCIAL SUMMARY"),
              _buildModernDropdown("GST Type", ["IGST (Inter-State)", "CGST+SGST"], _gstType, (v) => setState(() => _gstType = v!)),
              _buildTextField("GST Rate %", _gstRateC, isNum: true, onCh: (v) => _calculateTotals()),
              
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(15)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("ESTIMATED TOTAL:", style: TextStyle(fontWeight: FontWeight.bold)),
                    Text("₹ ${NumberFormat('#,###.00').format(_totalCalculated)}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF001A33))),
                  ],
                ),
              ),

              const SizedBox(height: 50),
              _submitButton(),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  // --- HELPERS ---
  Widget _formSection(IconData i, String t) => Padding(
    padding: const EdgeInsets.only(bottom: 15),
    child: Row(children: [Icon(i, color: const Color(0xFFC5A059), size: 20), const SizedBox(width: 10), Text(t, style: GoogleFonts.poppins(fontWeight: FontWeight.w800, fontSize: 13, color: const Color(0xFF001A33)))]),
  );

  Widget _buildModernDropdown(String label, List<String> items, String? val, Function(String?) onCh) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: DropdownButtonFormField<String>(
        value: val,
        decoration: InputDecoration(labelText: label, border: OutlineInputBorder(borderRadius: BorderRadius.circular(15))),
        items: items.map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontSize: 13)))).toList(),
        onChanged: onCh,
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController c, {bool isNum = false, int lines = 1, Function(String)? onCh}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: TextFormField(
        controller: c, maxLines: lines, onChanged: onCh,
        keyboardType: isNum ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(labelText: label, border: OutlineInputBorder(borderRadius: BorderRadius.circular(15))),
      ),
    );
  }

  Widget _displayCard(List<Widget> children) => Container(
    padding: const EdgeInsets.all(15),
    decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.grey.shade200)),
    child: Column(children: children),
  );

  Widget _labeledData(String l, String v) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [Text(l, style: const TextStyle(color: Colors.grey, fontSize: 12)), Text(v, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13))],
  );

  Widget _submitButton() => ElevatedButton(
    onPressed: () {
      if (_formKey.currentState!.validate()) {
        widget.onSave(SaudaModel(
          id: DateTime.now().millisecond.toString(),
          companyName: widget.companyName,
          saudaDate: DateTime.now(),
          spNo: "${widget.spPrefix}${DateTime.now().second}",
          seller: _selectedSeller ?? "Unknown",
          buyer: _selectedBuyer ?? "Unknown",
          item: _selectedItem ?? "Cotton",
          subItem: _selectedSubItem,
          rate: double.tryParse(_rateC.text) ?? 0.0,
          qty: double.tryParse(_qtyC.text) ?? 0.0,
          bales: int.tryParse(_balesC.text) ?? 0,
          tolerance: double.tryParse(_toleranceC.text) ?? 0.0,
          commSeller: double.tryParse(_commSellerC.text) ?? 0.0,
          commBuyer: 0.0,
          remarks: _remarksC.text,
          transport: _transport,
          loading: _loading,
          insurance: _insurance,
          paymentTerm: _paymentTermC.text,
          transportBy: "Seller",
          inspection: "Buyer Place",
          tcRequired: _tcReq,
          tds: 0.1,
          gstType: _gstType,
          gstRate: double.tryParse(_gstRateC.text) ?? 5.0,
          status: "BOOKED",
          createdAt: DateTime.now(),
          bankName: _bankNameC.text,
          accountNo: _accountNoC.text,
          ifscCode: _ifscCodeC.text,
        ));
        Navigator.pop(context);
      }
    },
    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF001A33), minimumSize: const Size(double.infinity, 60), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
    child: const Text("FINALIZE & SAVE SAUDA", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
  );
}
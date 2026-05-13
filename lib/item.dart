import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'footer.dart'; // Ensure this file exists in your project

// ---------------------------------------------------------------------------
// 1. ROBUST DATA MODELS
// ---------------------------------------------------------------------------

class ItemAttribute {
  String name;
  String unit;
  ItemAttribute({required this.name, required this.unit});
}

class ItemModel {
  final String id;
  final String name;
  final String category;
  final String status;
  final String description;
  final List<ItemAttribute> attributes;
  final DateTime createdAt;
  final IconData icon;

  ItemModel({
    required this.id,
    required this.name,
    required this.category,
    required this.status,
    required this.description,
    required this.attributes,
    required this.createdAt,
    this.icon = Icons.inventory_2_outlined,
  });
}

// ---------------------------------------------------------------------------
// 2. MAIN CATEGORY PAGE
// ---------------------------------------------------------------------------

class ItemPage extends StatefulWidget {
  const ItemPage({super.key});

  @override
  State<ItemPage> createState() => _ItemPageState();
  
  static IconData _getAutoIcon(String text) {
  text = text.toLowerCase();

  if (text.contains('cotton')) {
    return Icons.blur_on_rounded;
  } else if (text.contains('organic')) {
    return Icons.eco_rounded;
  } else if (text.contains('waste')) {
    return Icons.autorenew_rounded;
  } else if (text.contains('agri')) {
    return Icons.landscape_rounded;
  } else if (text.contains('bci')) {
    return Icons.verified_user_rounded;
  } else if (text.contains('fabric')) {
    return Icons.checkroom_rounded;
  } else if (text.contains('yarn')) {
    return Icons.scatter_plot_rounded;
  } else {
    return Icons.inventory_2_outlined;
  }
}
}

class _ItemPageState extends State<ItemPage> {
  final Color navyBlue = const Color(0xFF001A33);
  final Color cottonGold = const Color(0xFFC5A059);
  
  // Centralized Data Store with your specific Sub-Category requirements
  late Map<String, List<ItemModel>> _categoryData;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() {
    _categoryData = {
      "Cotton": [],
      "Cotton-Waste": [
        _quickCreate("Cotton Flat Waste", "Cotton-Waste"),
        _quickCreate("Cotton Sweeping Waste", "Cotton-Waste"),
        _quickCreate("Comber Noil", "Cotton-Waste"),
        _quickCreate("Flat Strips", "Cotton-Waste"),
        _quickCreate("BRD", "Cotton-Waste"),
        _quickCreate("LD (Lickring & Dropping)", "Cotton-Waste"),
      ],
      "Organic": [
        _quickCreate("NPOP", "Organic"),
        _quickCreate("NOP", "Organic"),
        _quickCreate("IC2 (GOTS/OCS)", "Organic"),
      ],
      "Region-Agri": [],
      "BCI": [
        _quickCreate("BCI Traceability", "BCI"),
        _quickCreate("CNA", "BCI"),
        _quickCreate("NPOP", "BCI"),
        _quickCreate("Inditex - NPOP", "BCI"),
      ],
    };
  }

  ItemModel _quickCreate(String name, String cat) {
    return ItemModel(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      name: name,
      category: cat,
      status: "ACTIVE",
      description: "Default industrial sub-category",
      attributes: [ItemAttribute(name: "Standard", unit: "Metric")],
      createdAt: DateTime.now(),
      icon: _getAutoIcon(name),
    );
  }

  static IconData _getAutoIcon(String name) {
    String n = name.toLowerCase();
    if (n.contains("waste")) return Icons.recycling_rounded;
    if (n.contains("organic")) return Icons.eco_rounded;
    if (n.contains("cotton")) return Icons.cloud_queue_rounded;
    if (n.contains("bci")) return Icons.verified_user_rounded;
    if (n.contains("agri")) return Icons.agriculture_rounded;
    if (n.contains("npop")) return Icons.assignment_turned_in_rounded;
    return Icons.precision_manufacturing_rounded;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFD),
      bottomNavigationBar: const CustomFooter(currentIndex: 1),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddMainCategoryForm,
        backgroundColor: navyBlue,
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text("NEW SECTOR", style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      appBar: _buildAppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeroHeader(),
          const SizedBox(height: 20),
          _buildSectionTitle("Industrial Categories"),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: 1,
              ),
              itemCount: _categoryData.keys.length,
              itemBuilder: (context, index) {
                String key = _categoryData.keys.elementAt(index);
                return _buildCategoryCard(key, _getAutoIcon(key), index);
              },
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: navyBlue,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.apps_rounded, color: Colors.white),
        onPressed: () {},
      ),
      title: Text("ITEM MASTER v2.0", 
        style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w800, letterSpacing: 1.5)),
      centerTitle: true,
    );
  }

  Widget _buildHeroHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
      decoration: BoxDecoration(
        color: navyBlue,
        borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(50), bottomRight: Radius.circular(50)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("System Administrator", style: GoogleFonts.poppins(color: Colors.white60, fontSize: 14)),
          Text("Inventory Master Control", 
            style: GoogleFonts.poppins(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: GoogleFonts.poppins(fontWeight: FontWeight.w800, fontSize: 18, color: navyBlue)),
          Text("${_categoryData.length} Sectors", style: const TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(String title, IconData icon, int index) {
    int count = _categoryData[title]?.length ?? 0;
    return InkWell(
      onTap: () => _openSubCategoryPage(title),
      borderRadius: BorderRadius.circular(30),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [BoxShadow(color: navyBlue.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, 8))],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(color: navyBlue.withOpacity(0.05), shape: BoxShape.circle),
              child: Icon(icon, size: 35, color: navyBlue),
            ),
            const SizedBox(height: 12),
            Text(title, 
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 14, color: navyBlue)),
            Text("$count Sub-items", 
              style: GoogleFonts.poppins(fontSize: 10, color: Colors.blueGrey, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    ).animate().scale(delay: (index * 50).ms, curve: Curves.easeOutBack);
  }

  void _showAddMainCategoryForm() {
    final nameC = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        title: Text("Add Main Category", style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        content: TextField(
          controller: nameC,
          decoration: const InputDecoration(hintText: "Category Name (e.g. Logistics)"),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: navyBlue),
            onPressed: () {
              if (nameC.text.isNotEmpty) {
                setState(() {
                  // NEW MAIN CATEGORY INSERTED AT TOP OF MAP
                  var newData = {nameC.text: <ItemModel>[]};
                  newData.addAll(_categoryData);
                  _categoryData = newData;
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Sector '${nameC.text}' added to Master Registry!")),
                );
              }
            }, 
            child: const Text("CREATE", style: TextStyle(color: Colors.white)),
          )
        ],
      ),
    );
  }

  void _openSubCategoryPage(String categoryName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SubCategoryScreen(
          categoryName: categoryName,
          initialItems: _categoryData[categoryName] ?? [],
          navyBlue: navyBlue,
          onUpdate: (newList) {
            setState(() {
              _categoryData[categoryName] = newList;
            });
          },
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 3. SUB-CATEGORY LISTING SCREEN (ENHANCED UI)
// ---------------------------------------------------------------------------

class SubCategoryScreen extends StatefulWidget {
  final String categoryName;
  final List<ItemModel> initialItems;
  final Color navyBlue;
  final Function(List<ItemModel>) onUpdate;

  const SubCategoryScreen({
    super.key,
    required this.categoryName,
    required this.initialItems,
    required this.navyBlue,
    required this.onUpdate,
  });

  @override
  State<SubCategoryScreen> createState() => _SubCategoryScreenState();
}

class _SubCategoryScreenState extends State<SubCategoryScreen> {
  late List<ItemModel> items;
  late List<ItemModel> filteredItems;
  Timer? _refreshTimer;
  int _secondsRemaining = 10;
  final TextEditingController _searchC = TextEditingController();

  @override
  void initState() {
    super.initState();
    items = List.from(widget.initialItems);
    filteredItems = items;
    _startRefreshTimer();
  }

  void _filterItems(String query) {
    setState(() {
      filteredItems = items
          .where((item) => item.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _startRefreshTimer() {
    _refreshTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (_secondsRemaining > 0) {
            _secondsRemaining--;
          } else {
            _secondsRemaining = 10;
            debugPrint("Data Sync Complete");
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F4F8),
      appBar: AppBar(
        backgroundColor: widget.navyBlue,
        elevation: 0,
        title: Column(
          children: [
            Text(widget.categoryName, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16)),
            Text("Auto-Sync in $_secondsRemaining s", style: const TextStyle(fontSize: 9, color: Colors.white54)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline, size: 28),
            onPressed: () => _showAddItemForm(context),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: Column(
        children: [
          _buildSearchBox(),
          _buildCountHeader(),
          Expanded(
            child: filteredItems.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: filteredItems.length,
                    itemBuilder: (context, index) => _buildItemCard(filteredItems[index], index),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBox() {
    return Container(
      padding: const EdgeInsets.all(20),
      color: widget.navyBlue,
      child: TextField(
        controller: _searchC,
        onChanged: _filterItems,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: "Search sub-categories...",
          hintStyle: const TextStyle(color: Colors.white38),
          prefixIcon: const Icon(Icons.search, color: Colors.white70),
          filled: true,
          fillColor: Colors.white.withOpacity(0.1),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
        ),
      ),
    );
  }

  Widget _buildCountHeader() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          const Icon(Icons.sort_rounded, color: Colors.blueGrey, size: 20),
          const SizedBox(width: 10),
          Text("${filteredItems.length} Sub-categories found", 
            style: GoogleFonts.poppins(color: Colors.blueGrey, fontWeight: FontWeight.w600, fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildItemCard(ItemModel item, int index) {
    return Dismissible(
      key: Key(item.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(color: Colors.redAccent, borderRadius: BorderRadius.circular(20)),
        child: const Icon(Icons.delete_sweep, color: Colors.white, size: 30),
      ),
      onDismissed: (direction) {
        setState(() {
          items.removeWhere((element) => element.id == item.id);
          _filterItems(_searchC.text);
          widget.onUpdate(items);
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Removed ${item.name}")));
      },
      child: Card(
        elevation: 0,
        margin: const EdgeInsets.only(bottom: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: ListTile(
          contentPadding: const EdgeInsets.all(15),
          leading: Container(
            height: 55, width: 55,
            decoration: BoxDecoration(color: widget.navyBlue.withOpacity(0.05), borderRadius: BorderRadius.circular(18)),
            child: Icon(item.icon, color: widget.navyBlue),
          ),
          title: Text(item.name, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: widget.navyBlue)),
          subtitle: Row(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 5),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: item.status == "ACTIVE" ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(item.status, style: TextStyle(color: item.status == "ACTIVE" ? Colors.green : Colors.red, fontSize: 10, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          trailing: const Icon(Icons.chevron_right_rounded, color: Colors.grey),
          onTap: () => _viewItemDetails(item),
        ),
      ).animate().fadeIn(delay: (index * 40).ms).slideX(begin: 0.1, end: 0),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.bubble_chart_outlined, size: 100, color: Colors.grey[300]),
          Text("Empty Registry", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.grey)),
          const SizedBox(height: 10),
          ElevatedButton(onPressed: () => _showAddItemForm(context), child: const Text("Add First Sub-Category")),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 4. ADD SUB-CATEGORY FORM
  // ---------------------------------------------------------------------------

  void _showAddItemForm(BuildContext context) {
    final nameC = TextEditingController();
    final descC = TextEditingController();
    String selectedStatus = "ACTIVE";

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          height: MediaQuery.of(context).size.height * 0.85,
          decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(35))),
          child: Column(
            children: [
              _buildModalHeader("REGISTER NEW SUB-CATEGORY"),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildFieldLabel("SUB-CATEGORY NAME *"),
                      _buildFormField(nameC, "e.g. Comber Noil Grade A"),
                      const SizedBox(height: 20),
                      _buildFieldLabel("STATUS"),
                      _buildDropdown(["ACTIVE", "INACTIVE"], (val) => setModalState(() => selectedStatus = val!), selectedStatus),
                      const SizedBox(height: 20),
                      _buildFieldLabel("TECHNICAL SPECS"),
                      _buildFormField(descC, "Enter grade, quality, or origin details...", lines: 3),
                      const SizedBox(height: 40),
                      ElevatedButton(
                        onPressed: () {
                          if (nameC.text.isNotEmpty) {
                            setState(() {
                              // CRITICAL: INSERT AT TOP
                              items.insert(0, ItemModel(
                                id: DateTime.now().toString(),
                                name: nameC.text,
                                category: widget.categoryName,
                                status: selectedStatus,
                                description: descC.text,
                                attributes: [ItemAttribute(name: "Generic", unit: "Unit")],
                                createdAt: DateTime.now(),
                                icon: ItemPage._getAutoIcon(nameC.text),
                              ));
                              _filterItems(_searchC.text);
                              widget.onUpdate(items);
                            });
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("New Sub-category Added Successfully to Top!")));
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: widget.navyBlue,
                          minimumSize: const Size(double.infinity, 65),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        ),
                        child: Text("CONFIRM ENTRY", style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- UI HELPERS ---

  Widget _buildModalHeader(String title) {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(color: widget.navyBlue, borderRadius: const BorderRadius.vertical(top: Radius.circular(35))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold)),
          IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close, color: Colors.white)),
        ],
      ),
    );
  }

  Widget _buildFieldLabel(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(text, style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w900, color: Colors.blueGrey)),
  );

  Widget _buildFormField(TextEditingController ctrl, String hint, {int lines = 1}) {
    return TextField(
      controller: ctrl,
      maxLines: lines,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: const Color(0xFFF1F4F8),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
        contentPadding: const EdgeInsets.all(18),
      ),
    );
  }

  Widget _buildDropdown(List<String> options, Function(String?) onChanged, String current) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(color: const Color(0xFFF1F4F8), borderRadius: BorderRadius.circular(15)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: current,
          isExpanded: true,
          items: options.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  void _viewItemDetails(ItemModel item) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(30),
        decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(40))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(child: Container(width: 50, height: 5, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10)))),
            const SizedBox(height: 20),
            Text(item.name, style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold, color: widget.navyBlue)),
            const Divider(),
            _detailRow("Category", item.category),
            _detailRow("Status", item.status),
            _detailRow("Added On", item.createdAt.toString().split(' ')[0]),
            const SizedBox(height: 15),
            Text("Specifications:", style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
            Text(item.description.isEmpty ? "No detailed specs provided." : item.description),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(String label, String val) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey)),
        Text(val, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    ),
  );
}
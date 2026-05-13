import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'home.dart';
import 'item.dart';

class CustomFooter extends StatefulWidget {
  final int currentIndex;
  const CustomFooter({super.key, this.currentIndex = 0});

  @override
  State<CustomFooter> createState() => _CustomFooterState();
}

class _CustomFooterState extends State<CustomFooter> {
  // Theme Colors
  final Color navyBlue = const Color(0xFF003366);
  final Color cottonGold = const Color(0xFFC5A059);

  void _onItemTapped(int index) {
    if (index == widget.currentIndex) return;

    Widget nextStep;
    switch (index) {
      case 0:
        nextStep = const HomeScreen();
        break;
      case 1:
        nextStep = const ItemPage();
        break;
      case 2:
        _showSettingsBottomSheet(context);
        return; // Don't navigate, just show settings
      default:
        nextStep = const HomeScreen();
    }

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => nextStep,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 85,
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: navyBlue.withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.home_rounded, "Home", 0),
          _buildNavItem(Icons.inventory_2_rounded, "Items", 1),
          _buildNavItem(Icons.settings_suggest_rounded, "Settings", 2),
        ],
      ),
    ).animate().slideY(begin: 1, end: 0, duration: 600.ms, curve: Curves.easeOutCubic);
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    bool isActive = widget.currentIndex == index;

    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? cottonGold.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive ? navyBlue : Colors.grey[400],
              size: isActive ? 28 : 24,
            ).animate(target: isActive ? 1 : 0).scale(begin: const Offset(0.8, 0.8), end: const Offset(1.1, 1.1)),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                color: isActive ? navyBlue : Colors.grey[400],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Settings Bottom Sheet Implementation
  void _showSettingsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          padding: const EdgeInsets.all(25),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 50,
                height: 5,
                decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
              ),
              const SizedBox(height: 20),
              Text("Quick Settings", style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: navyBlue)),
              const SizedBox(height: 20),
              _settingRow(Icons.volume_up, "App Volume", true),
              _settingRow(Icons.notifications_active, "Notifications", true),
              _settingRow(Icons.dark_mode, "Dark Mode", false),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: navyBlue,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                child: Text("Done", style: GoogleFonts.poppins(color: Colors.white)),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _settingRow(IconData icon, String title, bool value) {
    return ListTile(
      leading: Icon(icon, color: cottonGold),
      title: Text(title, style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
      trailing: Switch(
        value: value,
        activeColor: navyBlue,
        onChanged: (val) {},
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'login.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  // Brand Color Palette
  static const Color navyBlue = Color(0xFF001A33);
  static const Color royalBlue = Color(0xFF0056b3);
  static const Color cottonGold = Color(0xFFC5A059);
  static const Color pureWhite = Color(0xFFFFFFFF);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // -------------------------------------------------------------------
          // 1. DYNAMIC BACKGROUND LAYER
          // -------------------------------------------------------------------
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [navyBlue, royalBlue, navyBlue],
                  stops: [0.0, 0.5, 1.0],
                ),
              ),
            ),
          ),

          // Decorative Golden Glow (Top Right)
          Positioned(
            top: -size.height * 0.1,
            right: -size.width * 0.2,
            child: _buildDecorativeOrb(350, cottonGold.withOpacity(0.15)),
          ).animate().fadeIn(duration: 2.seconds).scale(begin: const Offset(0.8, 0.8)),

          // Decorative Navy Glow (Bottom Left)
          Positioned(
            bottom: -size.height * 0.15,
            left: -size.width * 0.25,
            child: _buildDecorativeOrb(500, Colors.black.withOpacity(0.3)),
          ),

          // -------------------------------------------------------------------
          // 2. MAIN UI CONTENT
          // -------------------------------------------------------------------
          SafeArea(
            child: Column(
              children: [
                const Spacer(flex: 2),

                // THE LOGO: Diamond-Shield Shape
                Center(
                  child: _buildDiamondLogoContainer()
                      .animate()
                      .scale(
                        duration: 1200.ms,
                        curve: Curves.elasticOut,
                      )
                      .shimmer(
                        delay: 1500.ms,
                        duration: 2500.ms,
                        color: cottonGold.withOpacity(0.2),
                      ),
                ),

                const SizedBox(height: 50),

                // BUSINESS BRANDING
                Column(
                  children: [
                    Text(
                      "Shri Ishwar Trading",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 38,
                        fontWeight: FontWeight.w800,
                        color: pureWhite,
                        letterSpacing: 0.8,
                        height: 1.1,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.3),
                            offset: const Offset(0, 5),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                    ).animate().fadeIn(duration: 800.ms).slideY(begin: 0.3, end: 0),
                    
                    const SizedBox(height: 15),
                    
                    // TAGLINE WITH GOLDEN DIVIDERS
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildDivider(),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            "Your Cotton Commodity Partner",
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: cottonGold,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                        _buildDivider(),
                      ],
                    ).animate(delay: 600.ms).fadeIn().slideY(begin: 0.5, end: 0),
                  ],
                ),

                const Spacer(flex: 3),

                // INTERACTIVE GET STARTED BUTTON
                _buildGetStartedButton(context)
                    .animate(delay: 1200.ms)
                    .fadeIn()
                    .slideY(begin: 1, end: 0, curve: Curves.easeOutQuart),

                const SizedBox(height: 40),
                
                // VERSION INFO OR FOOTER TEXT
                Text(
                  "ESTD. 2025 • RELIABILITY IN EVERY FIBER",
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    color: pureWhite.withOpacity(0.4),
                    letterSpacing: 2.0,
                  ),
                ).animate(delay: 2000.ms).fadeIn(),
                
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // -------------------------------------------------------------------
  // UI COMPONENT METHODS
  // -------------------------------------------------------------------

  Widget _buildDiamondLogoContainer() {
    return Container(
      height: 320, // Expanded size for "Big" look
      width: 320,
      decoration: BoxDecoration(
        color: pureWhite,
        // The Diamond-Shield Shape logic via BorderRadius
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(140),
          topRight: Radius.circular(40),
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(140),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 30,
            spreadRadius: 2,
            offset: const Offset(15, 25),
          ),
          const BoxShadow(
            color: cottonGold,
            blurRadius: 2,
            spreadRadius: 1,
            offset: Offset(-2, -2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(140),
          topRight: Radius.circular(40),
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(140),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(45.0),
            child: Image.asset(
              'assets/images/welcome.png',
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => 
                const Icon(Icons.eco, size: 100, color: cottonGold),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGetStartedButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 45),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(35),
          boxShadow: [
            BoxShadow(
              color: cottonGold.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            )
          ],
        ),
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, anim1, anim2) => const LoginScreen(),
                transitionsBuilder: (context, anim1, anim2, child) => 
                  FadeTransition(opacity: anim1, child: child),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: cottonGold,
            foregroundColor: navyBlue,
            minimumSize: const Size(double.infinity, 70),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
            elevation: 0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "GET STARTED",
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(width: 15),
              const Icon(Icons.arrow_forward_rounded, weight: 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDecorativeOrb(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [color, Colors.transparent],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 1,
      width: 30,
      color: cottonGold.withOpacity(0.5),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/services.dart';
import 'home.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;
  bool _isFormValid = false;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Premium Theme Palette
  final Color navyBlue = const Color(0xFF002344); // Deeper Navy
  final Color cottonGold = const Color(0xFFD4AF37); // Metallic Gold
  final Color softWhite = const Color(0xFFF8F9FA);

  @override
  void initState() {
    super.initState();
    // Listen to changes to enable/disable button in real-time
    _emailController.addListener(_validateForm);
    _passwordController.addListener(_validateForm);
  }

  void _validateForm() {
    final emailValid = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(_emailController.text);
    final passwordValid = _passwordController.text.length == 8;
    
    setState(() {
      _isFormValid = emailValid && passwordValid;
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: softWhite,
      body: Stack(
        children: [
          // Background Design Elements
          Positioned(
            top: -50,
            left: -50,
            child: _buildBlurCircle(200, navyBlue.withOpacity(0.08)),
          ),
          Positioned(
            bottom: -50,
            right: -50,
            child: _buildBlurCircle(250, cottonGold.withOpacity(0.1)),
          ),
          
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 60),
                    
                    // 1. MODERN TRADING LOGO
                    FadeInDown(
                      duration: const Duration(milliseconds: 800),
                      child: Column(
                        children: [
                          Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: navyBlue.withOpacity(0.1),
                                  blurRadius: 20,
                                  spreadRadius: 5,
                                )
                              ],
                              border: Border.all(color: cottonGold, width: 2),
                            ),
                            child: Icon(Icons.analytics_rounded, color: navyBlue, size: 50),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            "SHRI ISHWAR",
                            style: GoogleFonts.cinzel(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: navyBlue,
                              letterSpacing: 2,
                            ),
                          ),
                          Text(
                            "TRADING COMPANY",
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: cottonGold,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 4,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 50),

                    // 2. GLASSMORPHIC LOGIN CARD
                    FadeInUp(
                      duration: const Duration(milliseconds: 1000),
                      child: GlassmorphicContainer(
                        width: double.infinity,
                        height: 380,
                        borderRadius: 25,
                        blur: 15,
                        alignment: Alignment.center,
                        border: 1.5,
                        linearGradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.white.withOpacity(0.8),
                            Colors.white.withOpacity(0.2),
                          ],
                        ),
                        borderGradient: LinearGradient(
                          colors: [cottonGold, navyBlue.withOpacity(0.5)],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(25.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Partner Login",
                                style: GoogleFonts.poppins(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: navyBlue,
                                ),
                              ),
                              const SizedBox(height: 30),

                              // Email Field
                              _buildTextField(
                                controller: _emailController,
                                label: "Email Address",
                                icon: Icons.email_outlined,
                                keyboardType: TextInputType.emailAddress,
                              ),
                              
                              const SizedBox(height: 20),

                              // Password Field
                              _buildTextField(
                                controller: _passwordController,
                                label: "Password (8 Digits)",
                                icon: Icons.lock_open_rounded,
                                isPassword: true,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(8),
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                              ),

                              const Spacer(),

                              // LOGIN BUTTON (State-Dependent)
                              SizedBox(
                                width: double.infinity,
                                height: 55,
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  child: ElevatedButton(
                                    onPressed: _isFormValid ? () {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(builder: (context) => const HomeScreen()),
                                      );
                                    } : null,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: _isFormValid ? navyBlue : Colors.grey[400],
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      elevation: _isFormValid ? 8 : 0,
                                    ),
                                    child: Text(
                                      "SECURE LOGIN",
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 40),
                    Text(
                      "© 2026 Shri Ishwar Trading Group",
                      style: GoogleFonts.poppins(fontSize: 10, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBlurCircle(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: navyBlue.withOpacity(0.7)),
        ),
        TextField(
          controller: controller,
          obscureText: isPassword ? !_isPasswordVisible : false,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          style: GoogleFonts.poppins(color: navyBlue, fontWeight: FontWeight.w500),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: cottonGold, size: 20),
            suffixIcon: isPassword ? IconButton(
              icon: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off, color: Colors.grey, size: 18),
              onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
            ) : null,
            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: navyBlue.withOpacity(0.1))),
            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: cottonGold, width: 2)),
          ),
        ),
      ],
    );
  }
}
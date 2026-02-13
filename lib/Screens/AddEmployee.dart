import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';

class AddEmployeeScreen extends StatefulWidget {
  const AddEmployeeScreen({super.key});

  @override
  State<AddEmployeeScreen> createState() => _AddEmployeeScreenState();
}

class _AddEmployeeScreenState extends State<AddEmployeeScreen> {
  File? imageFile;

  final _nameController = TextEditingController();
  final _codeController = TextEditingController();
  final _mobileController = TextEditingController();
  final _dobController = TextEditingController();
  final _addressController = TextEditingController();
  final _remarkController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Stack(
        children: [
          /// Background Gradient
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.topRight,
                  radius: 1.2,
                  colors: [Colors.white, Color(0xFFF5F5F5)],
                ),
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  _buildHeader(),
                  const SizedBox(height: 40),
                  _buildGlassForm(),
                  const SizedBox(height: 30),
                  _buildButton(),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// HEADER
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            height: 40,
            width: 40,
            decoration: _glassDecoration(),
            child: const Icon(Icons.chevron_left, color: Color(0xFF2196F3)),
          ),
        ),
        Text(
          "Add New Employee",
          style: GoogleFonts.manrope(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        const SizedBox(width: 40),
      ],
    );
  }

  /// GLASS FORM
  Widget _buildGlassForm() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: _glassDecoration(),
          child: Column(
            children: [
              _floatingField("Full Name", _nameController),
              const Divider(color: Color(0xFFE2E8F0)),
              _floatingField("Employee Code", _codeController),
              const Divider(color: Color(0xFFE2E8F0)),
              _floatingField("Mobile Number", _mobileController),
              const Divider(color: Color(0xFFE2E8F0)),
              _floatingField(
                "Date of Birth",
                _dobController,
                icon: Icons.calendar_today,
              ),
              const Divider(color: Color(0xFFE2E8F0)),
              _floatingField("Address", _addressController, maxLines: 2),
              const Divider(color: Color(0xFFE2E8F0)),
              _floatingField("Remarks", _remarkController, maxLines: 3),
              const Divider(color: Color(0xFFE2E8F0)),
            ],
          ),
        ),
      ),
    );
  }

  /// FLOATING FIELD
  Widget _floatingField(
    String label,
    TextEditingController controller, {
    IconData? icon,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,

      decoration: InputDecoration(
        labelText: label,
        prefixText: label == "Mobile Number" ? "+91 " : null,
        labelStyle: GoogleFonts.manrope(),
        suffixIcon: icon != null
            ? Icon(icon, color: const Color(0xFF2196F3))
            : null,
        border: InputBorder.none,
      ),
    );
  }

  /// BUTTON
  Widget _buildButton() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: const Color(0xFF2196F3),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2196F3).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Center(
        child: Text(
          "Add Employee",
          style: GoogleFonts.manrope(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  /// GLASS DECORATION
  BoxDecoration _glassDecoration() {
    return BoxDecoration(
      color: Colors.white.withOpacity(0.85),
      borderRadius: BorderRadius.circular(24),
      border: Border.all(color: const Color(0xFFE3F2FD)),
      boxShadow: const [
        BoxShadow(
          color: Color.fromRGBO(31, 38, 135, 0.07),
          blurRadius: 32,
          offset: Offset(0, 8),
        ),
      ],
    );
  }
}

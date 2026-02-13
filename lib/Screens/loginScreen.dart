import 'dart:ui';
import 'package:employee_management/Screens/DirectoryScreen.dart';
import 'package:employee_management/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EmployeeLoginScreen extends StatelessWidget {
  const EmployeeLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// Screen Content
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  header(),
                  SizedBox(height: 32),
                  loginCard(context: context),
                  SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  header() {
    return Column(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: const Color(0xFF4A90E2),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: const Icon(
            Icons.corporate_fare,
            color: Colors.white,
            size: 30,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          "Welcome Back",
          style: GoogleFonts.manrope(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          "Log in to your employee portal",
          style: GoogleFonts.manrope(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  loginCard({required BuildContext context}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 360,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.6),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.8)),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.09), blurRadius: 32),
          ],
        ),
        child: Column(
          children: [
            googleTile(context: context),
            SizedBox(height: 16),
            appleTile(),
          ],
        ),
      ),
    );
  }

  googleTile({required BuildContext context}) {
    return ElevatedButton(
      onPressed: () async {
        String result = await GoogleSignInService.signInWithGoogle(
          context: context,
        );
        print(result);
        if (result == "Sucess") {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => DirectoryScreen()),
          );
        }
      },
      style: ElevatedButton.styleFrom(
        elevation: 1,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        minimumSize: const Size(double.infinity, 56),
        shape: const StadiumBorder(),
        side: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      child: Text(
        "Login with Google",
        style: GoogleFonts.manrope(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.grey[700],
        ),
      ),
    );
  }

  appleTile() {
    return ElevatedButton.icon(
      onPressed: () {},
      icon: const Icon(Icons.apple),
      label: Text(
        "Login with Apple",
        style: GoogleFonts.manrope(fontSize: 14, fontWeight: FontWeight.bold),
      ),
      style: ElevatedButton.styleFrom(
        elevation: 8,
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 56),
        shape: const StadiumBorder(),
      ),
    );
  }
}

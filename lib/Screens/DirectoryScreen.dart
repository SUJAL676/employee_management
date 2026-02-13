import 'dart:ui';
import 'package:employee_management/Screens/AddEmployee.dart';
import 'package:employee_management/Screens/checkLogin.dart';
import 'package:employee_management/models/EmployeeModel.dart';
import 'package:employee_management/providers/employee_provider.dart';
import 'package:employee_management/services/auth_service.dart';
import 'package:employee_management/services/employee_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqlite_api.dart';

class DirectoryScreen extends StatefulWidget {
  const DirectoryScreen({super.key});

  @override
  State<DirectoryScreen> createState() => _DirectoryScreenState();
}

class _DirectoryScreenState extends State<DirectoryScreen> {
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    DatabaseHelper.instance.fecthList(context: context);
    super.initState();
  }

  void filterEmployees(String query) {
    EmployeeProvider provider = Provider.of<EmployeeProvider>(
      context,
      listen: false,
    );

    if (query.isEmpty) {
      provider.changeEmployee(list: provider.AllEmployee);
      return;
    }

    final filtered = provider.AllEmployee.where((emp) {
      final nameMatch = emp.name.toLowerCase().startsWith(query.toLowerCase());
      final codeMatch = emp.empCode.toLowerCase().startsWith(
        query.toLowerCase(),
      );

      return nameMatch || codeMatch;
    }).toList();

    provider.changeEmployee(list: filtered);
  }

  @override
  Widget build(BuildContext context) {
    EmployeeProvider provider = Provider.of<EmployeeProvider>(context);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topLeft,
            radius: 1.2,
            colors: [Color(0xFFFFFFFF), Color(0xFFF5F5F5)],
          ),
        ),
        child: Stack(
          children: [
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 12),
                    _buildHeader(),
                    const SizedBox(height: 32),
                    _buildSearchBar(),
                    const SizedBox(height: 24),
                    const SizedBox(height: 24),
                    Expanded(
                      child: provider.employee.isEmpty
                          ? Container()
                          : ListView.builder(
                              itemCount: provider.employee.length,
                              itemBuilder: (context, index) {
                                EmployeeModel emp = provider.employee[index];
                                return EmployeeCard(emp: emp, online: true);
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ),
            _buildFAB(context),
            _logOutButton(context: context),
          ],
        ),
      ),
    );
  }

  Widget _logOutButton({required BuildContext context}) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Align(
      alignment: Alignment.bottomCenter,
      child: GestureDetector(
        onTap: () async {
          await GoogleSignInService.signOut();

          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => CheckLogin()),
          );
        },
        child: Container(
          width: width,
          height: height * 0.07,
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
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
              "Log Out",
              style: GoogleFonts.manrope(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    EmployeeProvider provider = Provider.of<EmployeeProvider>(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "CORPORATE PORTAL",
              style: GoogleFonts.manrope(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
                color: const Color(0xFF2196F3),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "Directory",
              style: GoogleFonts.manrope(
                fontSize: 30,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF1F2937),
              ),
            ),
          ],
        ),
        CircleAvatar(
          radius: 24,
          backgroundImage: NetworkImage(provider.credential.photoURL!),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(40),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.7),
            borderRadius: BorderRadius.circular(40),
            border: Border.all(
              color: const Color(0xFF2196F3).withOpacity(0.12),
            ),
          ),
          child: Row(
            children: [
              const Icon(Icons.search, color: Color(0xFF2196F3)),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: searchController,
                  onChanged: (value) {
                    filterEmployees(value);
                  },
                  decoration: InputDecoration(
                    hintText: "Search by name or code...",
                    hintStyle: GoogleFonts.manrope(
                      fontSize: 14,
                      color: const Color(0xFF718096),
                    ),
                    border: InputBorder.none,
                  ),
                  style: GoogleFonts.manrope(fontSize: 14),
                ),
              ),
              if (searchController.text.isNotEmpty)
                GestureDetector(
                  onTap: () {
                    searchController.clear();
                    filterEmployees("");
                    setState(() {});
                  },
                  child: const Icon(Icons.close, color: Color(0xFF94A3B8)),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFAB(BuildContext context) {
    return Positioned(
      bottom: 110,
      right: 24,
      child: FloatingActionButton(
        elevation: 12,
        backgroundColor: const Color(0xFF2196F3),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AddEmployeeScreen(isEdit: false),
            ),
          );
        },
        child: const Icon(Icons.add, size: 30),
      ),
    );
  }
}

class EmployeeCard extends StatefulWidget {
  final EmployeeModel emp;
  final bool online;

  const EmployeeCard({super.key, required this.emp, required this.online});

  @override
  State<EmployeeCard> createState() => _EmployeeCardState();
}

class _EmployeeCardState extends State<EmployeeCard> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        margin: EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF2196F3).withOpacity(0.1),
              blurRadius: 12,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// TOP
            Row(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundImage: AssetImage(
                        "assets/avatars/avatar${widget.emp.avatar}.png",
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        height: 16,
                        width: 16,
                        decoration: BoxDecoration(
                          color: widget.online
                              ? const Color(0xFF22C55E)
                              : const Color(0xFF94A3B8),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.emp.name,
                        style: GoogleFonts.manrope(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1F2937),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.emp.empCode,
                        style: GoogleFonts.manrope(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.5,
                          color: const Color(0xFF2196F3),
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            AddEmployeeScreen(isEdit: true, model: widget.emp),
                      ),
                    );
                  },
                  child: Icon(Icons.more_horiz, color: Color(0xFF94A3B8)),
                ),
              ],
            ),

            const SizedBox(height: 14),

            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _infoRow(Icons.call, widget.emp.mobile),
                _infoRow(Icons.cake, widget.emp.dob),
              ],
            ),

            const SizedBox(height: 10),
            const Divider(color: Color(0xFFE2E8F0)),

            const SizedBox(height: 10),
            _infoRow(Icons.location_on, widget.emp.address),
            const SizedBox(height: 15),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isExpanded = !isExpanded;
                    });
                  },
                  child: Text(
                    "VIEW REMARKS",
                    style: GoogleFonts.manrope(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      // letterSpacing: 1.5,
                      color: const Color(0xFF2196F3),
                    ),
                  ),
                ),

                Icon(
                  isExpanded
                      ? Icons.keyboard_arrow_up_outlined
                      : Icons.keyboard_arrow_down_outlined,
                  color: const Color(0xFF2196F3),
                ),
              ],
            ),

            AnimatedSize(
              curve: Curves.easeInOut,
              alignment: Alignment.topCenter,
              duration: const Duration(milliseconds: 250),
              child: isExpanded
                  ? Text(
                      widget.emp.remark,
                      style: GoogleFonts.manrope(
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                        color: const Color(0xFF718096),
                      ),
                    )
                  : const SizedBox(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Row(
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: const Color(0xFF2196F3).withOpacity(0.1),
          child: Icon(icon, size: 16, color: const Color(0xFF2196F3)),
        ),
        const SizedBox(width: 12),
        Text(
          text,
          style: GoogleFonts.manrope(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF718096),
          ),
        ),
      ],
    );
  }
}

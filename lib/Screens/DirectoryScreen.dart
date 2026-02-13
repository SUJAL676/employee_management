import 'dart:ui';
import 'package:employee_management/Screens/AddEmployee.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DirectoryScreen extends StatelessWidget {
  const DirectoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                      child: ListView(
                        children: const [
                          EmployeeCard(
                            name: "Sarah Jenkins",
                            code: "EMP-1024",
                            phone: "+1 (555) 902-1144",
                            dob: "14 May 1994",
                            address:
                                "882 Silicon Blvd, Suite 400,\nMountain View, CA 94043",
                            remark:
                                '"Highly proactive team member with excellent attention to detail."',
                            online: true,
                          ),
                          SizedBox(height: 16),
                          EmployeeCard(
                            name: "Marcus Thorne",
                            code: "EMP-1108",
                            phone: "+1 (555) 321-8890",
                            dob: "02 Nov 1989",
                            address:
                                "12 Wall Street, Financial District,\nNew York, NY 10005",
                            remark:
                                '"Expertise in financial modeling and strategic planning."',
                            online: false,
                          ),
                          SizedBox(height: 16),
                          EmployeeCard(
                            name: "Elena Rodriguez",
                            code: "EMP-0982",
                            phone: "+1 (555) 445-9122",
                            dob: "27 Jan 1991",
                            address:
                                "450 Congress Ave, Suite 210,\nAustin, TX 78701",
                            remark:
                                '"Consistent high-performer with great creative vision."',
                            online: true,
                          ),
                          SizedBox(height: 120),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            _buildFAB(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
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
        const CircleAvatar(
          radius: 24,
          backgroundImage: NetworkImage("https://i.pravatar.cc/300"),
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
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
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
                child: Text(
                  "Search name, code, or role...",
                  style: GoogleFonts.manrope(
                    fontSize: 14,
                    color: const Color(0xFF718096),
                  ),
                ),
              ),
              const Icon(Icons.tune, color: Color(0xFF94A3B8)),
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
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (context) => AddEmployeeScreen()));
        },
        child: const Icon(Icons.add, size: 30),
      ),
    );
  }
}

class EmployeeCard extends StatefulWidget {
  final String name;
  final String code;
  final String phone;
  final String dob;
  final String address;
  final String remark;
  final bool online;

  const EmployeeCard({
    super.key,
    required this.name,
    required this.code,
    required this.phone,
    required this.dob,
    required this.address,
    required this.remark,
    required this.online,
  });

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
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF2196F3).withOpacity(0.1),
              blurRadius: 12,
              offset: const Offset(0, 6),
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
                    const CircleAvatar(
                      radius: 28,
                      backgroundImage: NetworkImage(
                        "https://i.pravatar.cc/300",
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
                        widget.name,
                        style: GoogleFonts.manrope(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1F2937),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.code,
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
                const Icon(Icons.more_horiz, color: Color(0xFF94A3B8)),
              ],
            ),

            const SizedBox(height: 14),

            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _infoRow(Icons.call, widget.phone),
                _infoRow(Icons.cake, widget.dob),
              ],
            ),

            const SizedBox(height: 10),
            const Divider(color: Color(0xFFE2E8F0)),

            const SizedBox(height: 10),
            _infoRow(Icons.location_on, widget.address),
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
                      widget.remark,
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

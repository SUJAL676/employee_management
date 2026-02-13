import 'dart:math';
import 'dart:ui';
import 'package:employee_management/helper/loadingScreen.dart';
import 'package:employee_management/models/EmployeeModel.dart';
import 'package:employee_management/services/employee_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';

class AddEmployeeScreen extends StatefulWidget {
  final bool isEdit;
  final EmployeeModel? model;
  const AddEmployeeScreen({super.key, required this.isEdit, this.model});

  @override
  State<AddEmployeeScreen> createState() => _AddEmployeeScreenState();
}

class _AddEmployeeScreenState extends State<AddEmployeeScreen> {
  final _nameController = TextEditingController();
  final _codeController = TextEditingController();
  final _mobileController = TextEditingController();
  final _monthController = TextEditingController(text: "MM");
  final _yearController = TextEditingController(text: "YYYY");
  final _dayController = TextEditingController(text: "DD");
  final _addressController = TextEditingController();
  final _remarkController = TextEditingController();

  bool isAnimating = false;

  String error = "";

  bool isValidDay() {
    final day = int.tryParse(_dayController.text);
    if (day == null) return false;
    return day >= 1 && day <= 31;
  }

  bool isValidMonth() {
    final month = int.tryParse(_monthController.text);
    if (month == null) return false;
    return month >= 1 && month <= 12;
  }

  bool isValidYear() {
    final year = int.tryParse(_yearController.text);
    if (year == null) return false;
    return year >= 1900 && year <= 2006;
  }

  void changeAnimationStatus({required String Error, required bool value}) {
    setState(() {
      isAnimating = value;
      error = Error;
    });
  }

  String avatarAssign() {
    Random random = Random();
    return "${random.nextInt(6)}";
  }

  void _add_edit_Employee() async {
    if (_nameController.text.isEmpty ||
        _codeController.text.isEmpty ||
        _mobileController.text.isEmpty) {
      changeAnimationStatus(
        Error: "Please fill all required fields",
        value: true,
      );
      return;
    } else if (!isValidDay() || !isValidMonth() || !isValidYear()) {
      changeAnimationStatus(Error: "Please fill correct date", value: true);
      return;
    } else if (_mobileController.text.length != 10) {
      changeAnimationStatus(Error: "Please enter valid number", value: true);
      return;
    }

    final employee = EmployeeModel(
      empCode: _codeController.text,
      name: _nameController.text,
      mobile: _mobileController.text,
      dob:
          "${_dayController.text}-${_monthController.text}-${_yearController.text}",
      address: _addressController.text,
      remark: _remarkController.text,
      avatar: widget.isEdit ? widget.model!.avatar : avatarAssign(),
    );

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Loadingscreen(
          field: widget.isEdit ? "edit" : "add",
          model: employee,
        ),
      ),
    );
  }

  assignValues() {
    List dates = widget.model!.dob.split("-");

    _nameController.text = widget.model!.name;
    _codeController.text = widget.model!.empCode;
    _mobileController.text = widget.model!.mobile;
    _addressController.text = widget.model!.address;
    _remarkController.text = widget.model!.remark;
    _dayController.text = dates[0];
    _monthController.text = dates[1];
    _yearController.text = dates[2];
  }

  @override
  void initState() {
    widget.isEdit ? assignValues() : null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      bottomSheet: ErrorMessage(context: context),
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
                  widget.isEdit ? _EditButtons() : _buildButton(),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget ErrorMessage({required BuildContext context}) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return AnimatedSize(
      duration: Duration(milliseconds: 400),
      child: Container(
        padding: EdgeInsets.all(20),
        width: width,
        height: isAnimating ? height * 0.2 : 0.0,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF2196F3).withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
          borderRadius: BorderRadius.all(Radius.circular(40)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,

          children: [
            Align(
              alignment: AlignmentGeometry.topRight,
              child: GestureDetector(
                onTap: () => changeAnimationStatus(Error: "", value: false),
                child: Icon(Icons.cancel_outlined),
              ),
            ),

            Text(
              "Attention !!!",
              style: GoogleFonts.manrope(
                fontSize: 30,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF1F2937),
              ),
            ),
            Text(
              error,
              style: GoogleFonts.manrope(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.5,
                color: const Color(0xFF718096),
              ),
            ),
          ],
        ),
      ),
    );
  }

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
          widget.isEdit ? "Edit Employee" : "Add New Employee",
          style: GoogleFonts.manrope(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        const SizedBox(width: 40),
      ],
    );
  }

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
              _floatingField("* Full Name", _nameController),
              const Divider(color: Color(0xFFE2E8F0)),
              _floatingField("* Employee Code", _codeController),
              const Divider(color: Color(0xFFE2E8F0)),
              _floatingField("* Mobile Number", _mobileController),
              const Divider(color: Color(0xFFE2E8F0)),
              dobField(context: context),
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

  List<TextInputFormatter> _getFormatters(String label) {
    switch (label) {
      case "* Full Name":
        return [
          FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Z\s]")),
          LengthLimitingTextInputFormatter(30),
        ];

      case "* Employee Code":
        return [LengthLimitingTextInputFormatter(10)];

      case "* Mobile Number":
        return [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(10),
        ];

      case "Address":
        return [LengthLimitingTextInputFormatter(60)];

      case "Remarks":
        return [LengthLimitingTextInputFormatter(100)];

      default:
        return [];
    }
  }

  Widget _floatingField(
    String label,
    TextEditingController controller, {
    IconData? icon,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      inputFormatters: _getFormatters(label),

      decoration: InputDecoration(
        labelText: label,
        prefixText: label == "* Mobile Number" ? "+91 " : null,
        labelStyle: GoogleFonts.manrope(),
        suffixIcon: icon != null
            ? Icon(icon, color: const Color(0xFF2196F3))
            : null,
        border: InputBorder.none,
      ),
    );
  }

  Widget dobField({required BuildContext context}) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Container(
      height: height * 0.07,
      width: width,
      color: Colors.transparent,

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: height * 0.01),
          Text("* Date of Birth", style: GoogleFonts.manrope(fontSize: 13)),
          SizedBox(height: height * 0.01),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              dobTile(width: 35, controller: _dayController, field: "day"),
              Text("/"),
              dobTile(width: 35, controller: _monthController, field: "month"),
              Text("/"),
              dobTile(width: 60, controller: _yearController, field: "year"),
            ],
          ),
        ],
      ),
    );
  }

  Widget dobTile({
    required double width,
    required String field,
    required TextEditingController controller,
  }) {
    return SizedBox(
      width: width,
      height: 10,
      child: TextField(
        controller: controller,
        onTap: () {
          if (controller.text == "DD" || controller.text == "MM") {
            controller.text = "";
          } else if (controller.text == "YYYY") {
            controller.text = "";
          }
        },
        onChanged: (value) {
          if (field == "month") {
            if (!isValidMonth() || !isValidDay()) {
              changeAnimationStatus(
                Error: "Invalid Month ${!isValidDay() ? "or Day" : ""}",
                value: true,
              );
            } else {
              changeAnimationStatus(Error: "", value: false);
            }
          } else if (field == "day") {
            if (!isValidDay()) {
              changeAnimationStatus(Error: "Invalid Day", value: true);
            } else {
              changeAnimationStatus(Error: "", value: false);
            }
          } else if (field == "year") {
            if (!isValidYear()) {
              changeAnimationStatus(Error: "Invalid Year", value: true);
            } else {
              changeAnimationStatus(Error: "", value: false);
            }
          }
        },
        keyboardType: TextInputType.number,
        inputFormatters: [
          LengthLimitingTextInputFormatter(width == 60 ? 4 : 2),
          FilteringTextInputFormatter.digitsOnly,
        ],
        decoration: InputDecoration(border: InputBorder.none),
      ),
    );
  }

  Widget _buildButton() {
    return GestureDetector(
      onTap: () => _add_edit_Employee(),
      child: Container(
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
            widget.isEdit ? "Update Employee" : "Add Employee",
            style: GoogleFonts.manrope(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _EditButtons() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () => _add_edit_Employee(),
          child: buttonTile(
            width: 165,
            text: "Save",
            color: Color(0xFF2196F3),
            textColor: Colors.white,
          ),
        ),

        GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) =>
                    Loadingscreen(field: "delete", model: widget.model),
              ),
            );
          },
          child: buttonTile(
            width: 165,
            text: "Delete",
            color: Colors.white,
            textColor: Colors.red,
          ),
        ),
      ],
    );
  }

  Widget buttonTile({
    required double width,
    required String text,
    required Color color,
    required Color textColor,
  }) {
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: color,
        boxShadow: [
          BoxShadow(
            color: text == "Delete"
                ? textColor.withOpacity(0.1)
                : const Color(0xFF2196F3).withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Center(
        child: Text(
          text,
          style: GoogleFonts.manrope(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: textColor,
          ),
        ),
      ),
    );
  }

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

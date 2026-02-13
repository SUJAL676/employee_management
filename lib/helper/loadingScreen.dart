import 'package:employee_management/models/EmployeeModel.dart';
import 'package:employee_management/services/employee_services.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class Loadingscreen extends StatefulWidget {
  final String field;
  final EmployeeModel? model;
  const Loadingscreen({super.key, required this.field, this.model});

  @override
  State<Loadingscreen> createState() => _LoadingscreenState();
}

class _LoadingscreenState extends State<Loadingscreen> {
  delete() async {
    try {

      await Future.delayed(const Duration(milliseconds: 400));

      DatabaseHelper.instance.deleteEmployee(widget.model!.empCode);

    //  DatabaseHelper.instance.fecthList(context: context); 

      Navigator.pop(context);
      Navigator.pop(context);
    } catch (e) {
      Navigator.pop(context);
    }
  }

  edit_add() async {

    bool isEdit = widget.field == "edit";

    try {
      await Future.delayed(const Duration(milliseconds: 400));

      await isEdit
          ? DatabaseHelper.instance.updateEmployee(widget.model!)
          : DatabaseHelper.instance.insertEmployee(widget.model!);

      // DatabaseHelper.instance.fecthList(context: context); 

      Navigator.pop(context);
      Navigator.pop(context);
    } catch (e) 
    {
      Navigator.pop(context);
      
    }
  }

  @override
  void initState() {

    switch (widget.field) 
    {
      case "edit" or "add":
        edit_add();
        break;

      case "delete":
        delete();
        break;  

    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white),
      body: Container(
        width: width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LottieBuilder.network(
              "https://lottie.host/5d46e235-fb2d-4bb7-96fd-6445e32f0670/hESa5K4y23.json",
            ),
            Text(
              "Updating Records",
              style: GoogleFonts.manrope(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

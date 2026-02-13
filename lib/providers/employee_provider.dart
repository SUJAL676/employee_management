import 'package:employee_management/models/EmployeeModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EmployeeProvider extends ChangeNotifier {
  List<EmployeeModel> employee = [];
  List<EmployeeModel> AllEmployee = [];

  late User credential;

  void changeEmployee({required List<EmployeeModel> list}) {
    employee = list;
    notifyListeners();
  }

  void changeAllEmployee({required List<EmployeeModel> list}) {
    AllEmployee = list;
    notifyListeners();
  }

  void initialCredentials({required User cred}) {
    credential = cred;
    notifyListeners();
  }
}

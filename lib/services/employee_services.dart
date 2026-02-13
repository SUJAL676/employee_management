import 'package:employee_management/models/EmployeeModel.dart';
import 'package:employee_management/providers/employee_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  bool fecthList({required BuildContext context}) {
    try {
      EmployeeProvider provider = Provider.of<EmployeeProvider>(
        context,
        listen: false,
      );
      DatabaseHelper.instance.getAllEmployees().then((employee) {
        provider.changeAllEmployee(list: employee);
        provider.changeEmployee(list: employee);
      });

      return true;
    } catch (e) {
      return false;
    }
  }

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('employee.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE employees(
        empCode TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        mobile TEXT NOT NULL,
        dob TEXT,
        address TEXT,
        remark TEXT,
        avatar TEXT
      )
    ''');
  }

  Future<void> insertEmployee(EmployeeModel employee) async {
    final db = await instance.database;

    await db.insert(
      'employees',
      employee.toMap(),
      conflictAlgorithm: ConflictAlgorithm.abort, // prevents duplicate empCode
    );
  }

  Future<List<EmployeeModel>> getAllEmployees() async {
    final db = await instance.database;

    final result = await db.query('employees');

    return result.map((e) => EmployeeModel.fromMap(e)).toList();
  }

  Future<int> updateEmployee(EmployeeModel employee) async {
    final db = await instance.database;

    return db.update(
      'employees',
      employee.toMap(),
      where: 'empCode = ?',
      whereArgs: [employee.empCode],
    );
  }

  Future<int> deleteEmployee(String empCode) async {
    final db = await instance.database;

    return db.delete('employees', where: 'empCode = ?', whereArgs: [empCode]);
  }
}

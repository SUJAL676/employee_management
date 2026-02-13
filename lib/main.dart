import 'package:employee_management/Screens/DirectoryScreen.dart';
import 'package:employee_management/Screens/checkLogin.dart';
import 'package:employee_management/Screens/loginScreen.dart';
import 'package:employee_management/Theme.dart';
import 'package:employee_management/firebase_options.dart';
import 'package:employee_management/providers/employee_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => EmployeeProvider()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: CheckLogin(),
      ),
    );
  }
}

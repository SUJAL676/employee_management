import 'package:employee_management/Screens/DirectoryScreen.dart';
import 'package:employee_management/Screens/loginScreen.dart';
import 'package:employee_management/providers/employee_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CheckLogin extends StatefulWidget {
  const CheckLogin({super.key});

  @override
  State<CheckLogin> createState() => _CheckLoginState();
}

class _CheckLoginState extends State<CheckLogin>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  double circleSize = 200;
  User? _user;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _controller.addListener(() {
      setState(() {
        circleSize = _animation.value;
      });
    });

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _navigateNext();
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _load();
    });
  }

  Future<void> _load() async {
    await Future.delayed(const Duration(milliseconds: 400));

    _user = FirebaseAuth.instance.currentUser;

    if (_user != null) {
      EmployeeProvider provider = Provider.of<EmployeeProvider>(
        context,
        listen: false,
      );
      provider.initialCredentials(cred: _user!);
    }

    _startAnimation();
  }

  void _startAnimation() {
    final size = MediaQuery.of(context).size;
    final double maxSize = 400;

    _animation = Tween<double>(
      begin: 200,
      end: maxSize,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _controller.forward();
  }

  void _navigateNext() {
    if (_user == null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => EmployeeLoginScreen()),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => DirectoryScreen()),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        width: width,
        child: Center(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: circleSize,
            width: circleSize,
            decoration: const BoxDecoration(
              color: Color(0xFF3F7D6B),
              shape: BoxShape.circle,
            ),

            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Text(
                  "EMPLOYEE",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "Management",
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.white70,
                    letterSpacing: 3,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

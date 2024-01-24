import 'package:flutter/material.dart';
import 'package:game/Login_Screens/signin_screen.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TempClass extends StatefulWidget {
  const TempClass({super.key});

  @override
  State<TempClass> createState() => _TempClassState();
}

class _TempClassState extends State<TempClass> {
  @override
  void method() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    Get.to(LoginScreen());
  }

  void initState() {
    // TODO: implement initState
    method();
  }

  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

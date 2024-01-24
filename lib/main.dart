import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:game/GameScreens/HomeScreen.dart';
import 'package:game/Login_Screens/signin_screen.dart';
import 'package:game/Login_Screens/user_check.dart';
import 'package:game/firebase_options.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? userPhoneNumber = prefs.getString('userPhoneNumber');

  final AuthService authService = AuthService();
  bool userLoggedIn = false;
  if (userPhoneNumber != null) {
    userLoggedIn = await authService.doesUserPhoneNumberExist(userPhoneNumber);

    if (!userLoggedIn) {
      // Clear userPhoneNumber from SharedPreferences
      await prefs.remove('userPhoneNumber');
    }
  }

  runApp(MyApp(
    userLoggdIn: userLoggedIn,
  ));
}

class MyApp extends StatelessWidget {
  final bool userLoggdIn;
  const MyApp({required this.userLoggdIn});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: userLoggdIn ? HomeScreen() : LoginScreen(),
    );
  }
}

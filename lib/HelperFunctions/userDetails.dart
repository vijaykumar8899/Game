import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserDetails {
  static String userPhoneNumber = '';
  static String userName = '';

  static Future<void> getUserDetails() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      userPhoneNumber = prefs.getString('userPhoneNumber') ?? '';
      userName = prefs.getString('userName') ?? '';
    } catch (e) {
      // Handle errors, log, or notify the user if needed
      print('Error retrieving user details: $e');
    }
  }
}

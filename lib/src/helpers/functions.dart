import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HelperFunctions {
  static String UserLoggedInKey = "isloggedin";
  static String UserEmailKey = "useremailkey";
  static String UserFullNameKey = "userfullname";

  // set data
  static Future<bool> setUserLoggedIn(bool isLoggedIn) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setBool(UserLoggedInKey, isLoggedIn);
  }

  static Future setUserFullName(firstName, lastName) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(
        UserFullNameKey, firstName + " " + lastName);
  }

  static Future<bool> setUserEmail(String email) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(UserEmailKey, email);
  }

  // get data
  static Future getUserLoggedIn() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getBool(UserLoggedInKey);
  }

  static Future getUserEmail() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(UserEmailKey);
  }

  static Future getUserFullName() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(UserFullNameKey);
  }

  static getTwoCharString(List<QueryDocumentSnapshot<Object?>> doc) {
    String twoCharString = doc[0]
        .get("name")
        .toString()
        .split(" ")[0]
        .characters
        .first;
    twoCharString += doc[0]
        .get("name")
        .toString()
        .split(" ")[1]
        .characters
        .first;
    return twoCharString;
  }
}
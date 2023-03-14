import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medical_chat_group/model/dropDownModel.dart';

class Constants {
  static String jobSearch = "Job Search";
  static String messageSearch = "Message Search";

  static String userID = "";
  static String chatRoom = "";
  static String userName = "";
  static String permissionDenied =
      "Permission not granted. Try Again with permission access";
  static String noFileSelected = "No Image Path Received";
  static bool jobIsExist = false;
  static List<String> registerType = ["Job Seeker", "Job Poster"];
  // static Color signUpColor = Color.fromARGB(255, 188, 42, 164);
  // static Color roomColor = Color.fromARGB(255, 122, 7, 122);

  static TextStyle fontStyle =
      const TextStyle(color: Colors.white, fontWeight: FontWeight.bold);
  static TextStyle fontStyleJoin = const TextStyle(
      color: Colors.red, fontSize: 14, fontWeight: FontWeight.bold);
  static double containerRadius = 20.0;
  static Color mainColor = Color.fromARGB(255, 165, 64, 157);
  static Color secondColor = Color.fromARGB(255, 196, 77, 186);

  static TextStyle senderName = TextStyle(
      color: Color.fromARGB(255, 255, 0, 234),
      fontWeight: FontWeight.bold,
      fontSize: 16);
  static TextStyle messageInfoStyle = TextStyle(
    color: Color.fromARGB(255, 165, 178, 182),
  );

  static List<DropDownModel> dropDownMenuItem = [
    DropDownModel("All Jobs", Icons.work_sharp),
    // DropDownModel("mute", Icons.volume_up),
    DropDownModel("Search", Icons.search),
    DropDownModel("Notification", Icons.notifications),
    DropDownModel("Settings", Icons.settings),
    DropDownModel("Logout", Icons.logout),
  ];

  // static List<DropDownModel> muteDropDown = [
  //   DropDownModel("All Jobs", Icons.work_sharp),
  //   DropDownModel("unmute", Icons.volume_off),
  //   DropDownModel("Disable Sound", Icons.music_off),
  //   // DropDownModel("mute For...", Icons.notifications_paused_outlined),
  //   // DropDownModel("Customize", Icons.output),
  // ];
  static Color groupColor = Color.fromARGB(255, 38, 50, 56);

  static Color settingColor = Colors.white;
  static TextStyle settingStyle = TextStyle(color: Colors.white);
}

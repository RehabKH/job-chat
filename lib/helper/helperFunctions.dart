import 'package:medical_chat_group/helper/constants.dart';
import 'package:medical_chat_group/model/userModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HelperFunctions {
  static String userNameKey = "USERNAME";
  static String userEmailKey = "EMAIL";
  static String userRegisterTypeKey = "REGISTERTYPE";
  static String _uid = "USER ID";
  static String userLoggedIn = "USERLOGGEDIN";

  static Future<bool> saveUserLoggedIn(bool IsUserLoggedIn) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return await pref.setBool(userLoggedIn, IsUserLoggedIn);
  }

  static Future<bool> saveUID(String uid) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return await pref.setString(_uid, uid);
  }

  static Future<bool> saveToken(String token) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return await pref.setString("token", token);
  }
  //   static Future<bool> saveUserName(String userName) async {
  //   SharedPreferences pref = await SharedPreferences.getInstance();
  //   return await pref.setString(userNameKey, userName);
  // }

  static Future<bool> saveUserInfo(UserModel userInfo) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString(userEmailKey, userInfo.userEmail);
    await pref.setString(userRegisterTypeKey, userInfo.registerType);
    await pref.setString("token", userInfo.token.toString());
    return await pref.setString(userNameKey, userInfo.userName);
  }

//get user data from shared preferences

  static Future<bool> getUserLoggedIn() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return await pref.getBool(userLoggedIn)!;
  }

  static Future<String> getUID() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return await pref.getString(_uid) ?? "";
  }

  static Future<UserModel> getUserData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    final username = await pref.getString(userNameKey);
    final userEmail = await pref.getString(userEmailKey);
    final userType = await pref.getString(userRegisterTypeKey);
    final uid = await getUID();
    final token = await getToken();
    UserModel userModel =
        UserModel( username ?? "", userEmail ?? "", userType ?? "",uid: uid);
    Constants.userName = userModel.userName;
    print("current user id::::" + userModel.toString());
    return userModel;
  }

  static Future<String> getUserEmail() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return await pref.getString(userEmailKey)!;
  }

  static Future<String> getToken() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString("token")!;
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:medical_chat_group/helper/constants.dart';
import 'package:medical_chat_group/helper/helperFunctions.dart';
import 'package:medical_chat_group/model/userModel.dart';
import 'package:medical_chat_group/services/database.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SocialMediaAuth extends ChangeNotifier {
  GoogleSignInAccount? _user;
  GoogleSignIn googleSignIn = new GoogleSignIn();

  GoogleSignInAccount get user => _user!;

  Future googleLogin() async {
    final googleUser = await googleSignIn.signIn();

    DataBaseMethods dbMethod = DataBaseMethods();
    if (googleUser == null) return;
    _user = googleUser;
    var currentUser;
    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
    UserCredential result =
        await FirebaseAuth.instance.signInWithCredential(credential);
    currentUser = FirebaseAuth.instance.currentUser;
    final String token = await HelperFunctions.getToken();
    print("token ::::::::::::::::::::::::::::::::::::: " + token.toString());
    Map<String, String> userModel = {
      "name": user.displayName.toString(),
      "email": user.email.toString(),
      "register type": Constants.registerType[0],
      "token": token
    };
    // User user1 = result.user!;
    print("user id====================== :::::::::::::::" +
        currentUser!.uid.toString());
    final UserModel userData = UserModel(
        uid:currentUser!.uid.toString(),
        token: token,
        userModel["name"]!,
        userModel["email"]!,
        userModel["register type"]!);
    await dbMethod.uploadUserInfo(userModel, currentUser.uid);
//  await dbMethod.saveToken(token, currentUser.uid.toString());

    HelperFunctions.saveUserInfo(userData).then((value) {
      print("save data result :::::::::::::::" + value.toString());
    });
    print("user id :::::" + currentUser.uid.toString());
    HelperFunctions.saveUID(currentUser.uid.toString());

    notifyListeners();
  }

  Future signOut() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    GoogleSignIn googleSignIn = new GoogleSignIn();
    try {
      pref.clear();
      Constants.userID = "";
      await googleSignIn.disconnect();
       await FirebaseMessaging.instance.getToken().then((token) {
         HelperFunctions.saveToken(token!).then((value) {
          print("result of saving token :::::::::::::::::::::: " +
              value.toString());
        });
      });
      
      return await FirebaseAuth.instance.signOut();
    } catch (e) {
      print("Error: "+e.toString());
    }
  }
}

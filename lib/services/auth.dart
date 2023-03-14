import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:medical_chat_group/helper/constants.dart';
import 'package:medical_chat_group/helper/helperFunctions.dart';
import 'package:medical_chat_group/model/userModel.dart';
import 'package:medical_chat_group/services/database.dart';

import '../model/user.dart';

class AuthMethods extends ChangeNotifier {
  FirebaseAuth _auth = FirebaseAuth.instance;

  AuthMethods() {
    Firebase.initializeApp();
  }
  UserID _userFromFirebaseUser(User user) {
    print("user id ::::::::::::::::::::::::::::" + user.uid);
    return UserID(user.uid);
  }

  Future signInWithEmailAndPass(String email, String pass) async {
    try {
      UserCredential result =
          await _auth.signInWithEmailAndPassword(email: email, password: pass);
      print("result of login :::::::::::::::::::::::::: " +
          result.user!.uid.toString());
      User? user = result.user;
      DataBaseMethods dbMethod = new DataBaseMethods();
      final String token = await HelperFunctions.getToken();
      print("user token from sign in  :::::::::::::::::::::::" +
          token.toString());

      //////////////////////////////

      dbMethod.getUserInfo(user!.uid.toString()).then((val) {
        UserModel userModel = new UserModel(val["name"].toString(),
            val["email"].toString(), val["register type"].toString(),
            token: token);

        HelperFunctions.saveUserInfo(userModel).then((value) {
          print("save data result :::::::::::::::" + value.toString());
        });
        // HelperFunctions.saveUID(user.uid.toString());
        dbMethod.saveToken(userModel, user.uid);
      });

      notifyListeners();
      return _userFromFirebaseUser(user);
    } on FirebaseAuthException catch (e) {
      // print("Error occur " + e.credential!.signInMethod.toString());
      // Fluttertoast.showToast(msg: "Error occur " + e.code.toString());
      return "Error: "+e.code;
    }
  }

  Future signUpWithEmailAndPass(String email, String pass) async {
    try {
      // DataBaseMethods dbMethod = DataBaseMethods();
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: pass);
      User? user = result.user;
      // final String token = await HelperFunctions.getToken();
      // await dbMethod.saveToken(token, user!.uid);
      return _userFromFirebaseUser(user!);
    } catch (e) {
      print("error sign up ::::::::::::::::::" + e.toString());
      return "Error"+e.toString();
    }
  }

  Future resetPass(String email) async {
    try {
      return await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print(e.toString());
    }
  }

  // Future signOut() async {
  //   try {
  //     return await _auth.signOut();
  //   } catch (e) {
  //     print("error in sign out :::::::" + e.toString());
  //   }
  // }
}

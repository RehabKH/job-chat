import 'package:fluttertoast/fluttertoast.dart';
import 'package:medical_chat_group/helper/constants.dart';
import 'package:medical_chat_group/helper/helperFunctions.dart';
import 'package:medical_chat_group/main.dart';
import 'package:medical_chat_group/model/userModel.dart';
import 'package:medical_chat_group/services/auth.dart';
import 'package:medical_chat_group/services/database.dart';
import 'package:medical_chat_group/services/socialMediaAuth.dart';
import 'package:medical_chat_group/views/allJobs.dart';
import 'package:medical_chat_group/views/chatRoomsScreen.dart';
import 'package:medical_chat_group/widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignIn extends StatefulWidget {
  final Function toggleAuth;
  SignIn(this.toggleAuth);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final key = GlobalKey<FormState>();
  bool _isLoading = false;
  TextEditingController email = new TextEditingController(),
      pass = new TextEditingController();
  QuerySnapshot? snapshotUserInfo;
  DataBaseMethods databaseMethods = new DataBaseMethods();
  bool isShow = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context, "SettingPage", "signIn"),
      body: (_isLoading)
          ? Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: Container(
                alignment: Alignment.bottomCenter,
                height: MediaQuery.of(context).size.height - 150,
                child: Form(
                  key: key,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextFormField(
                        controller: email,
                        validator: validate,
                        style: simpleTextStyle(),
                        decoration: inputDecoration("email"),
                      ),
                      TextFormField(
                        
                        controller: pass,
                        obscureText: isShow,
                        validator: validate,
                        style: simpleTextStyle(),
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
            icon: Icon(
              // Based on passwordVisible state choose the icon
               isShow
               ? Icons.visibility
               : Icons.visibility_off,
               color: Constants.mainColor,
               ),
            onPressed: () {
               // Update the state i.e. toogle the state of passwordVisible variable
               setState(() {
                   isShow = !isShow;
               });}),
                            hintText: "Password",
                            hintStyle: TextStyle(color: Colors.white54),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white54))),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      // Container(
                      //   alignment: Alignment.centerRight,
                      //   child: Container(
                      //     padding:
                      //         EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      //     child: Text(
                      //       "Forget Password?",
                      //       style: simpleTextStyle(),
                      //     ),
                      //   ),
                      // ),
                      // SizedBox(
                      //   height: 8,
                      // ),
                      InkWell(
                        onTap: () {
                          //    databaseMethods
                          //     .getDataByUserEmail(email.text)
                          //     .then((value) {
                          //   snapshotUserInfo = value;
                          //   HelperFunctions.saveUserName(
                          //       snapshotUserInfo!.docs[0].get("name"));
                          // });
                          if (key.currentState!.validate()) {
                            setState(() {
                              _isLoading = true;
                            });
                            authMethods
                                .signInWithEmailAndPass(
                                    email.text, pass.text.toString())
                                .then((message) {
                              if (message != null) {
                                if (!message.toString().contains("Error")) {
                                  HelperFunctions.saveUserLoggedIn(true)
                                      .then((value) {
                                    setState(() {
                                      _isLoading = false;
                                    });
                                    Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                new AllJobs()));
                                  });
                                } else {
                                  Fluttertoast.showToast(
                                      msg: message.toString(),
                                      backgroundColor: Constants.mainColor,
                                      toastLength: Toast.LENGTH_LONG,
                                      gravity: ToastGravity.CENTER,
                                      textColor: Colors.white);
                                       Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                new MyApp()));
                                }
                              }
                            });
                          } else {
                            // print error
                          }
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.symmetric(vertical: 20),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30.0),
                              gradient: LinearGradient(colors: [
                                Constants.mainColor,
                                Constants.secondColor
                              ])),
                          child: Text(
                            "Sign In",
                            style: simpleTextStyle(),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      GestureDetector(
                        onTap: () {
                          final provider = Provider.of<SocialMediaAuth>(context,
                              listen: false);
                          provider.googleLogin().then((value) async {
                            final user = FirebaseAuth.instance.currentUser;
                            // Map<String, String> userModel = {
                            //   "name": user!.displayName.toString(),
                            //   "email": user.email.toString(),
                            //   "register type": Constants.registerType[0],
                            //   "token":
                            // };

                            // await databaseMethods.uploadUserInfo(
                            //     userModel, user.uid);
                            // get data after login from firestore and then save register type in local database
                            databaseMethods.getUserInfo(user!.uid).then((val) {
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (c) => new AllJobs()));
                              //   UserModel userModel = new UserModel(
                              //       user!.displayName.toString(),
                              //       user.email.toString(),
                              //       val["registerType"]);
                              //   setState(() {
                              //     _isLoading = true;
                              //   });

                              //   HelperFunctions.saveUserLoggedIn(true);
                              //   setState(() {
                              //     _isLoading = false;
                              //   });
                            });
                          });
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.symmetric(vertical: 20),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30.0),
                              color: Colors.white),
                          child: Text(
                            "Sign In With Google",
                            style: TextStyle(color: Colors.black, fontSize: 16),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have account,",
                            style: simpleTextStyle(),
                          ),
                          InkWell(
                            onTap: () {
                              widget.toggleAuth();
                              // Navigator.of(context).push(MaterialPageRoute(
                              //     builder: (context) => new Authenticate()));
                            },
                            child: Text(
                              "Register Now?",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  decoration: TextDecoration.underline),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 50,
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  AuthMethods authMethods = new AuthMethods();
  signIn() {
    if (key.currentState!.validate()) {
      if (mounted) {
        setState(() {
          _isLoading = true;

          authMethods
              .signInWithEmailAndPass(email.text, pass.text)
              .then((value) {
            _isLoading = false;
            email.text = "";
            pass.text = "";

            print("valuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuue " + value.toString());
          });
        });
      }
    }
  }
}

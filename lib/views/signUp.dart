import 'package:medical_chat_group/helper/constants.dart';
import 'package:medical_chat_group/helper/helperFunctions.dart';
import 'package:medical_chat_group/main.dart';
import 'package:medical_chat_group/model/userModel.dart';
import 'package:medical_chat_group/services/auth.dart';
import 'package:medical_chat_group/services/database.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:medical_chat_group/services/socialMediaAuth.dart';
import 'package:medical_chat_group/views/allJobs.dart';
import 'package:medical_chat_group/views/chatRoomsScreen.dart';

import 'package:medical_chat_group/widgets/widget.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignUp extends StatefulWidget {
  final Function toggleAuth;
  SignUp(this.toggleAuth);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool _isLoading = false;
  String? selectedType;
  final key = GlobalKey<FormState>();
  TextEditingController userName = new TextEditingController(),
      email = new TextEditingController(),
      password = new TextEditingController();
  DataBaseMethods _dataBaseMethods = new DataBaseMethods();
  bool isShow = false;
  @override
  void initState() {
    super.initState();
    setState(() {
      selectedType = Constants.registerType[0];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context, "SettingPage", "signUp"),
      body: _isLoading
          ? Container(
              child: Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.white,
                  color: Constants.mainColor,
                ),
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
                      Container(
                        decoration: BoxDecoration(
                            // color: Constants.mainColor,
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8)),
                        child: DropdownButton(
                          isExpanded: true,

                          // Initial Value
                          value: selectedType,
                          dropdownColor: Constants.mainColor,
                          borderRadius: BorderRadius.circular(8),
                          // Down Arrow Icon
                          icon: const Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.white,
                          ),
                          underline: Container(),
                          // Array list of items
                          items: Constants.registerType.map((String items) {
                            return DropdownMenuItem(
                              value: items,
                              child: Text(
                                items,
                                style: simpleTextStyle(),
                              ),
                            );
                          }).toList(),
                          // After selecting the desired option,it will
                          // change button value to selected value
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedType = newValue!;
                            });
                          },
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      TextFormField(
                        validator: validate,
                        controller: userName,
                        style: simpleTextStyle(),
                        decoration: inputDecoration("User Name"),
                      ),
                      TextFormField(
                        validator: (val) {
                          return RegExp(
                                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(val!)
                              ? null
                              : "please provide valid email format";
                        },
                        controller: email,
                        style: simpleTextStyle(),
                        decoration: inputDecoration("email"),
                      ),
                      TextFormField(
                          obscureText: isShow,
                          validator: validate,
                          controller: password,
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
                                    });
                                  }),
                              hintText: "Password",
                              hintStyle: TextStyle(color: Colors.white54),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.white54)))),
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
                          signUp(false);
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
                            "Sign Up",
                            style: simpleTextStyle(),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      GestureDetector(
                        onTap: () {
                          signUp(true);
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.symmetric(vertical: 20),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30.0),
                              color: Colors.white),
                          child: Text(
                            "Sign Up With Google",
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
                            "Already have account,",
                            style: simpleTextStyle(),
                          ),
                          InkWell(
                            onTap: () {
                              widget.toggleAuth();
                            },
                            child: Text(
                              "Sign In Now?",
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
  signUp(bool socialSignIn) {
    if (!socialSignIn) {
      if (key.currentState!.validate()) {
        setState(() {
          _isLoading = true;
        });
        print("key.currentState!.validate() == trueeeeeeeeeeeeeeeeeee");
        authMethods
            .signUpWithEmailAndPass(email.text, password.text)
            .then((value) {
          if (value != null) {
            if (!value.toString().contains("Error")) {
              print("current user:::::::::::::" + value.userId.toString());
              // Map<String, String> userInfo = {
              //   "name": userName.text,
              //   "email": email.text,
              //   "register Type": selectedType!
              // };
              // }
              UserModel userModel =
                  new UserModel(userName.text, email.text, selectedType!);

              _dataBaseMethods.saveToken(userModel, value.userId);
              HelperFunctions.saveUserInfo(userModel);
              HelperFunctions.saveUserLoggedIn(true);
              setState(() {
                _isLoading = false;
                Constants.userName = userName.text;
                userName.text = "";
                email.text = "";
                password.text = "";
              });
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => AllJobs()));
            } else {
              Fluttertoast.showToast(
                  msg: value.toString(),
                  gravity: ToastGravity.CENTER,
                  backgroundColor: Constants.mainColor,
                  textColor: Colors.white,
                  toastLength: Toast.LENGTH_LONG);
              Navigator.of(context)
                  .pushReplacement(MaterialPageRoute(builder: (c) => MyApp()));
            }
          }
        });
      }
    } else {
      final provider = Provider.of<SocialMediaAuth>(context, listen: false);
      provider.googleLogin().then((value) {
        final _user = FirebaseAuth.instance.currentUser;
        Map<String, String> userInfo = {
          "name": _user!.displayName.toString(),
          "email": _user.email.toString()
        };

        Fluttertoast.showToast(
            msg: "current user name:  " + _user.displayName.toString());
        // HelperFunctions.saveUserEmail(_user.email.toString());
        // HelperFunctions.saveUserName(_user.displayName.toString());

        _dataBaseMethods.uploadUserInfo(userInfo, _user.uid);
        HelperFunctions.saveUserLoggedIn(true);
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => new AllJobs()));
      });
    }
  }
}

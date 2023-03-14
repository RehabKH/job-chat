import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:medical_chat_group/helper/constantSize.dart';
import 'package:medical_chat_group/helper/constants.dart';
import 'package:medical_chat_group/helper/helperFunctions.dart';
import 'package:medical_chat_group/services/database.dart';
import 'package:medical_chat_group/views/NotificationDetailsPage.dart';
import 'package:medical_chat_group/widgets/widget.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  TextEditingController name = TextEditingController(),
      email = TextEditingController();
  ConstantSize constantSize = new ConstantSize();
  bool loading = true;
  bool isSwitched = false;
  String saveChanges = "";
  DataBaseMethods dbMethods = new DataBaseMethods();
  User? user = FirebaseAuth.instance.currentUser;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // get user info
    getUserInfo();
    setState(() {
      loading = false;
    });
  }

  getUserInfo() {
    HelperFunctions.getUserData().then((value) {
      setState(() {
        email.text = value.userEmail;
        name.text = value.userName;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Profile Settings", style: TextStyle(color: Colors.white)),

        //  actions:[ Container(
        //     width: MediaQuery.of(context).size.width,
        //     height: 40,
        //     alignment: Alignment.topCenter,
        //     color: Colors.grey.withOpacity(0.2),
        //     child: Center(
        //       child: Row(
        //         mainAxisAlignment: MainAxisAlignment.spaceAround,
        //         children: [
        //           Icon(
        //             Icons.arrow_back_ios,
        //             color: Constants.settingColor,
        //             size: 16,
        //           ),

        //         ],
        //       ),
        //     ),
        //   )],
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {
                Map<String, dynamic> newData = {
                  "name": name.text,
                  "email": email.text
                };
                dbMethods.updateUserInfo(user!.uid, newData).then((v) {
                  Fluttertoast.showToast(
                      msg: "user info is updated successfully",
                      textColor: Colors.black,
                      backgroundColor: Constants.settingColor);
                  setState(() {
                    saveChanges = "";
                  });
                });
              },
              child: Center(
                  child: Text(saveChanges, style: Constants.settingStyle)),
            ),
          ),
          IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => new NotificationDetailsPage()));
              },
              icon: Icon(
                Icons.notifications_active_rounded,
                color: Colors.white,
              ))
        ],
      ),
      body: (loading)
          ? Center(
              child: CircularProgressIndicator(
                color: Constants.settingColor,
              ),
            )
          : SingleChildScrollView(
              child: Column(children: [
                SizedBox(
                  height: ConstantSize.s20,
                ),
                // list of user information
                Container(
                  height: 100,
                  width: 100,
                  alignment: Alignment.topCenter,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.rectangle,
                      image: DecorationImage(
                          image: AssetImage("assets/images/img.jpg"))),
                ),
                SizedBox(
                  height: ConstantSize.s10,
                ),
                EditableText(
                    textAlign: TextAlign.center,
                    onEditingComplete: () {
                      setState(() {
                        saveChanges = "Save";
                      });
                    },
                    controller: name,
                    focusNode: FocusNode(),
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                    cursorColor: Colors.white,
                    backgroundCursorColor: Constants.settingColor),
                // Text(
                //   name,
                //   style: Constants.fontStyle,
                // ),
                SizedBox(
                  height: ConstantSize.s10,
                ),

                // InkWell(
                //   onTap: () {
                //     // enter photos to choose
                //     dbMethods.uploadImage().then((val) {
                //       Fluttertoast.showToast(
                //           msg: val.toString(),
                //           textColor: Colors.black,
                //           backgroundColor: Constants.settingColor);
                //     });
                //   },
                //   child: Text(
                //     "Change Photo",
                //     style: Constants.settingStyle,
                //   ),
                // ),
                SizedBox(
                  height: ConstantSize.s80,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                  child: Divider(
                    color: Colors.grey,
                    endIndent: 20,
                  ),
                ),
                SizedBox(
                  height: ConstantSize.s20,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                  child: _buildRowUI(
                      "Name",
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 50.0,
                        ),
                        child: EditableText(
                            onEditingComplete: () {
                              setState(() {
                                saveChanges = "Save";
                              });
                            },
                            controller: name,
                            focusNode: FocusNode(),
                            style: Constants.settingStyle,
                            cursorColor: Color.fromARGB(255, 163, 107, 107),
                            backgroundCursorColor: Constants.settingColor),
                      )),
                  // Text(email, style: Constants.settingStyle)),
                ),
                SizedBox(
                  height: ConstantSize.s20,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                  child: Divider(
                    color: Colors.grey,
                    endIndent: 20,
                  ),
                ),
                SizedBox(
                  height: ConstantSize.s20,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                  child: _buildRowUI(
                      "Email Address",
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 50.0,
                        ),
                        child: EditableText(
                            controller: email,
                            focusNode: FocusNode(),
                            style: Constants.settingStyle,
                            cursorColor: Color.fromARGB(255, 163, 107, 107),
                            backgroundCursorColor: Constants.settingColor),
                      )),
                ),
                SizedBox(
                  height: ConstantSize.s20,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                  child: Divider(
                    color: Colors.grey,
                    endIndent: 20,
                  ),
                ),
                SizedBox(
                  height: ConstantSize.s20,
                ),
                // Padding(
                //   padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                //   child: _buildRowUI(
                //     "Make Private",
                //     Switch(
                //       activeColor: Constants.settingColor,
                //       value: isSwitched,
                //       onChanged: (value) {
                //         setState(() {
                //           isSwitched = value;
                //         });
                //       },
                //     ),
                //   ),
                // )
                // Padding(
                //   padding: const EdgeInsets.all(12.0),

                //   // child: Column(
                //   //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                //   //   children: [

                //   //   ],
                //   // ),
                // )
              ]),
            ),
    );
  }

  Widget _buildRowUI(String title, Widget subTitle) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
              color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
        ),
        Flexible(child: subTitle)
      ],
    );
  }
}

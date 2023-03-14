import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:medical_chat_group/helper/authenticate.dart';
import 'package:medical_chat_group/helper/constantSize.dart';
import 'package:medical_chat_group/helper/constants.dart';
import 'package:medical_chat_group/helper/helperFunctions.dart';
import 'package:medical_chat_group/main.dart';
import 'package:medical_chat_group/model/groupModel.dart';
import 'package:medical_chat_group/model/jobModel.dart';
import 'package:medical_chat_group/model/userModel.dart';
import 'package:medical_chat_group/services/auth.dart';
import 'package:medical_chat_group/services/database.dart';
import 'package:medical_chat_group/services/socialMediaAuth.dart';
import 'package:medical_chat_group/views/chatRoomsScreen.dart';
import 'package:medical_chat_group/views/JobChat.dart';
import 'package:medical_chat_group/views/jobDetails.dart';
import 'package:medical_chat_group/views/newJob.dart';
import 'package:medical_chat_group/views/searchScreen.dart';
import 'package:medical_chat_group/views/settingPage.dart';
import 'package:medical_chat_group/widgets/widget.dart';
import 'package:provider/provider.dart';

class AllJobs extends StatefulWidget {
  @override
  State<AllJobs> createState() => _AllJobsState();
}

class _AllJobsState extends State<AllJobs> {
  DataBaseMethods databaseMethods = new DataBaseMethods();
  UserModel? userModel;
  String? uid;
  Stream? allJobs;
  SocialMediaAuth auth = new SocialMediaAuth();
  bool _loading = true;
  @override
  void initState() {
    super.initState();

    getAllJobs().then((v) {
      setState(() {
        _loading = false;
      });
    });
  }

  getAllJobs() async {
    databaseMethods.getAllJobs().then((val) {
      setState(() {
        allJobs = val;
      });
    });
    HelperFunctions.getUID().then((val) {
      HelperFunctions.getUserData().then((val2) {
        setState(() {
          userModel = new UserModel(
              uid: val, val2.userName, val2.userEmail, val2.registerType);
          Constants.userID = val;
          uid = val;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "All Jobs",
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
          ),
          actions: [
            GestureDetector(
              onTap: () {
                if (userModel?.uid != null) {
                  if (userModel!.userName != null) {
                    print("user not null" + userModel!.userName.toString());
                    final provider =
                        Provider.of<SocialMediaAuth>(context, listen: false);
                    provider.signOut().then((value) {
                      if (value.toString().contains("Error")) {
                        Fluttertoast.showToast(
                            msg: value.toString(),
                            gravity: ToastGravity.CENTER,
                            backgroundColor: Constants.mainColor,
                            textColor: Colors.white,
                            toastLength: Toast.LENGTH_LONG);
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => new MyApp()));
                      } else
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => new Authenticate()));
                    });
                    ;
                  }
                } else {
                  print("sign out from email auth");
                  auth.signOut().then((value) {
                    if(value.toString().contains("Error")){
                        Fluttertoast.showToast(
                          msg: value.toString(),
                          gravity: ToastGravity.CENTER,
                          backgroundColor: Constants.mainColor,
                          textColor: Colors.white,
                          toastLength: Toast.LENGTH_LONG);
                          Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => new MyApp()));
                    }
                    else
                     Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => new Authenticate()));
                  });
                }
               
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Icon(Icons.exit_to_app),
              ),
            ),
            GestureDetector(
              onTap: () {
                // here setting pade of current user
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (c) => new SettingPage()));
              },
              child: Icon(Icons.settings),
            )
            // Text(user.toString(),style:Constants.fontStyle)
          ],
        ),

        //
        body: (_loading)
            ? Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.white,
                  color: Constants.mainColor,
                ),
              )
            : (allJobs == null)
                ? Center(
                    child: Text("No Jobs inside this group",
                        style: Constants.fontStyle),
                  )
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: StreamBuilder(
                        stream: allJobs,
                        builder: (context, AsyncSnapshot snapshot) {
                          if (snapshot.hasError)
                            return Text("Something went wrong");
                          else if (snapshot.connectionState ==
                              ConnectionState.waiting)
                            return Center(
                                child: Text(
                              "Loading........",
                              style: Constants.fontStyle,
                            ));
                          else {
                            final data = snapshot.requireData;

                            return GridView.count(
                                crossAxisCount: 3,
                                crossAxisSpacing: 2,
                                mainAxisSpacing: 2,
                                children: List.generate(data.size, (index) {
                                  return Center(
                                      child: Column(
                                    children: [
                                      Container(
                                        constraints: const BoxConstraints(
                                            maxWidth: 200,
                                            maxHeight: 60,
                                            minHeight: 50),
                                        child: Card(
                                          color: Colors.white,
                                          child: Center(
                                            child: Text(
                                              data.docs[index]["title"],
                                              style: TextStyle(
                                                color: Constants.mainColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      // Container(
                                      //   // height: 60,
                                      //   // width: 100,
                                      //   decoration: BoxDecoration(
                                      //       color: Constants.mainColor,
                                      //       borderRadius: BorderRadius.circular(
                                      //           Constants.containerRadius)),
                                      //   child: Center(
                                      //     child: Text(
                                      //       data.docs[index]["title"],
                                      //       style: Constants.fontStyle,
                                      //     ),
                                      //   ),
                                      // ),
                                      InkWell(
                                        onTap: () {
                                          JobModel jobModel = new JobModel(
                                            data.docs[index].id,
                                            data.docs[index]["title"],
                                            data.docs[index]["desc"],
                                            data.docs[index]["jobPoster"],
                                          );
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (c) =>
                                                      new JobDetails(
                                                          jobModel)));
                                        },
                                        child: Center(
                                          child: Text(
                                            "view",
                                            style: TextStyle(
                                                color: Constants.mainColor,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      )
                                    ],
                                  )
                                      // subtitle: Column(
                                      //   children: [
                                      //     Text(
                                      //       data.docs[index]["desc"]
                                      //           .toString()
                                      //           .substring(
                                      //               0,
                                      //               (data.docs[index]["desc"]
                                      //                           .toString()
                                      //                           .length /
                                      //                       2)
                                      //                   .toInt()),
                                      //       //[0]["name"]
                                      //       style: Constants.fontStyle,
                                      //     ),
                                      //   ],
                                      // ),
                                      );
                                }));
                          }
                        }),
                  ),
        floatingActionButton: (userModel!.registerType ==
                Constants.registerType[1])
            ? FloatingActionButton(
                backgroundColor: Constants.mainColor,
                child: Icon(Icons.search),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => SearchScreen("search about job")));
                })
            : Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                FloatingActionButton(
                    backgroundColor: Constants.mainColor,
                    child: Icon(Icons.search),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              SearchScreen("search about job")));
                    }),
                SizedBox(
                  width: ConstantSize.s10,
                ),
                FloatingActionButton(
                    backgroundColor: Constants.mainColor,
                    child: Icon(Icons.add),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => NewJob(uid!)));
                    }),
              ]));
  }
}

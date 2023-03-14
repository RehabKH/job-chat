import 'dart:io';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medical_chat_group/helper/constantSize.dart';
import 'package:medical_chat_group/helper/constants.dart';
import 'package:medical_chat_group/helper/helperFunctions.dart';
import 'package:medical_chat_group/model/dropDownModel.dart';
import 'package:medical_chat_group/model/groupModel.dart';
import 'package:medical_chat_group/model/jobModel.dart';
import 'package:medical_chat_group/model/notificationModel.dart';
import 'package:medical_chat_group/model/userModel.dart';
import 'package:medical_chat_group/services/database.dart';
import 'package:medical_chat_group/views/NotificationDetailsPage.dart';
import 'package:medical_chat_group/views/allJobs.dart';
import 'package:medical_chat_group/views/newJob.dart';
import 'package:medical_chat_group/views/searchScreen.dart';
import 'package:medical_chat_group/views/settingPage.dart';
import 'package:medical_chat_group/widgets/commonWidget.dart';
import 'package:medical_chat_group/widgets/widget.dart';

class JobChat extends StatefulWidget {
  JobModel jobModel;
  JobChat(this.jobModel);
  @override
  State<JobChat> createState() => _JobChatState();
}

class _JobChatState extends State<JobChat> {
  CommonWidget commonWidget = new CommonWidget();
  DataBaseMethods dataBaseMethods = new DataBaseMethods();
  Stream? groupDetails;
  TextEditingController _message = new TextEditingController();
  UserModel? userModel;
  String? _uid;
  DropDownModel dropdownvalue = Constants.dropDownMenuItem[0];
  getGroupDetails() async {
    print("job id" + widget.jobModel.id.toString());
    dataBaseMethods.getGroupInfo(widget.jobModel.id).then((val) {
      // print("chat details :::::::::::::::::::" + val!.first["message"].toString());
      setState(() {
        groupDetails = val;
      });

      // print("chat details :::::::::::::::::::"+groupDetails!.first.toString());
    });
  }

  bool emojiShowing = false;

  _onEmojiSelected(Emoji emoji) {
    print('_onEmojiSelected: ${emoji.emoji}');
  }

  _onBackspacePressed() {
    print('_onBackspacePressed');
  }

  getUserInfo() async {
    HelperFunctions.getUserData().then((value) {
      setState(() {
        userModel = value;
      });
    });
    HelperFunctions.getUID().then((uid) {
      setState(() {
        _uid = uid;
      });
    });
  }

  @override
  void dispose() {
    _message.dispose();
    super.dispose();
  }

  @override
  void initState() {
    getUserInfo().then((val) {
      getGroupDetails();
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
            backgroundColor: Constants.groupColor,
            // centerTitle: true,
            // leading:

            title: Row(
              children: [
                // group image
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Colors.white),
                    child: Center(
                        child: Text(
                      widget.jobModel.title.substring(0, 1),
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 25),
                    )),
                  ),
                ),
                // group title
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        widget.jobModel.title,
                        style: TextStyle(color: Colors.white),
                      ),
                      // Text(
                      //    widget.jobModel.title.members.length.toString() +
                      //       " members",
                      //   style: TextStyle(color: Colors.grey, fontSize: 15),
                      // ),
                    ],
                  ),
                )
              ],
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: 
                     DropdownButton(
                        // Initial Value
                        // value: dropdownvalue,

                        // Down Arrow Icon
                        icon: const Icon(
                          Icons.menu,
                          color: Colors.white,
                        ),
                        dropdownColor: Constants.groupColor,

                        underline: Container(),
                        // Array list of items
                        items: Constants.dropDownMenuItem
                            .map((DropDownModel items) {
                          return DropdownMenuItem(
                              value: items,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Icon(
                                    items.icon,
                                    color: Colors.grey,
                                  ),
                                  Text(
                                    items.name,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ));
                        }).toList(),
                        // After selecting the desired option,it will
                        // change button value to selected value
                        onChanged: (DropDownModel? val) {
                          // on chage selection => mute or unmute message , search , report , or leave channel
                          print(dropdownvalue.name);

                          setState(() {
                            dropdownvalue = val!;
                          });
                          switch (val!.name) {
                           
                            case "All Jobs":
                              {
                                // enter page of alljobs that have the same title of this group
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (c) => new AllJobs()));
                              }
                              break;
                            case "Notification":
                              {
                                // enter page of alljobs that have the same title of this group
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (c) =>
                                        new NotificationDetailsPage()));
                              }
                              break;
                            case "Settings":
                              {
                                // enter page of alljobs that have the same title of this group
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (c) => new SettingPage()));
                              }
                              break;
                               case "Search":
                              {
                                // enter page of alljobs that have the same title of this group
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (c) => new SearchScreen(Constants.messageSearch,jobId: widget.jobModel.id,)));
                              }
                              break;
                            default:
                          }
                        },
                      ),
              ),
            ]

            //   IconButton(onPressed: () {}, icon: Icon(Icons.menu))],
            // centerTitle: true,
            ),
        // commonWidget.streamWidget(groupDetails))
        body: Container(
          child: Stack(
            children: [
              commonWidget.streamWidget(groupDetails),
              Positioned(
                top: MediaQuery.of(context).size.height - 165,
                child: Container(
                  // constraints: const BoxConstraints(
                  //   maxHeight: 200,
                  // ),
                  alignment: Alignment.bottomCenter,
                  // padding: EdgeInsets.symmetric( vertical: MediaQuery.of(context).size.height - 165),
                  width: MediaQuery.of(context).size.width,
                  color: Colors.blueGrey[900],
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Material(
                        color: Constants.groupColor,
                        child: IconButton(
                          onPressed: () {
                            setState(() {
                              emojiShowing = !emojiShowing;
                            });
                          },
                          icon: const Icon(
                            Icons.emoji_emotions,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width - 120,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: TextFormField(
                              controller: _message,
                              style: const TextStyle(
                                  fontSize: 20.0, color: Colors.black87),
                              decoration: InputDecoration(
                                hintText: 'Type a message',
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: const EdgeInsets.only(
                                    left: 16.0,
                                    bottom: 8.0,
                                    top: 8.0,
                                    right: 16.0),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(50.0),
                                ),
                              )),
                        ),
                      ),
                      Material(
                        color: Constants.groupColor,
                        child: IconButton(
                            onPressed: () {
                              // send message
                              final user = FirebaseAuth.instance.currentUser;
                              setState(() {
                                Constants.userName =
                                    user?.displayName ?? user!.email ?? "";
                              });
                              
                                commonWidget.sendMessage(
                                    _message, widget.jobModel).then({
                                      setState(() {
                                  _message.text = "";
                                })
                                    });
                                
                            
                            },
                          
                            icon: const Icon(
                              Icons.send,
                              color: Colors.white,
                            )),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        )

        //  ),
        //  Container(
        //   height: 60,
        //   // alignment: Alignment.bottomCenter,

        //   color: Colors.blueGrey[900],
        //   child:
        //          ),
        // Container(
        //   // alignment: Alignment.bottomCenter,
        //   // padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        //   color: Colors.black38,
        //   child: Column(
        //     mainAxisAlignment: MainAxisAlignment.end,
        //     children: [

        //       // Offstage(
        //       //   offstage: !emojiShowing,
        //       //   child: SizedBox(
        //       //     height: 250,
        //       //     child: EmojiPicker(
        //       //         textEditingController: _message,
        //       //         onEmojiSelected: (Category category, Emoji emoji) {
        //       //           _onEmojiSelected(emoji);
        //       //         },
        //       //         onBackspacePressed: _onBackspacePressed,
        //       //         config: Config(
        //       //             columns: 7,
        //       //             // Issue: https://github.com/flutter/flutter/issues/28894
        //       //             emojiSizeMax:
        //       //                 32 * (Platform.isIOS ? 1.30 : 1.0),
        //       //             verticalSpacing: 0,
        //       //             horizontalSpacing: 0,
        //       //             gridPadding: EdgeInsets.zero,
        //       //             initCategory: Category.RECENT,
        //       //             bgColor: const Color(0xFFF2F2F2),
        //       //             indicatorColor: Colors.black26,
        //       //             iconColor: Colors.grey,
        //       //             iconColorSelected: Colors.black26,
        //       //             progressIndicatorColor: Colors.black26,
        //       //             backspaceColor: Colors.black26,
        //       //             skinToneDialogBgColor: Colors.white,
        //       //             skinToneIndicatorColor: Colors.grey,
        //       //             enableSkinTones: true,
        //       //             showRecentsTab: true,
        //       //             recentsLimit: 28,
        //       //             replaceEmojiOnLimitExceed: false,
        //       //             noRecents: const Text(
        //       //               'No Recents',
        //       //               style: TextStyle(
        //       //                   fontSize: 20, color: Colors.black26),
        //       //               textAlign: TextAlign.center,
        //       //             ),
        //       //             tabIndicatorAnimDuration: kTabScrollDuration,
        //       //             categoryIcons: const CategoryIcons(),
        //       //             buttonMode: ButtonMode.MATERIAL)),
        //       //   ),
        //       // ),
        //     ],
        //   ),
        //   // child: Row(
        //   //   children: [
        //   //     Expanded(
        //   //       child: TextField(
        //   //         controller: _message,
        //   //         style: TextStyle(color: Colors.white),
        //   //         decoration: InputDecoration(
        //   //             hintText: "Message",
        //   //             hintStyle: TextStyle(color: Colors.white54),
        //   //             border: InputBorder.none),
        //   //       ),
        //   //     ),
        //   //     GestureDetector(
        //   //       onTap: () {
        //   //         final user = FirebaseAuth.instance.currentUser;
        //   //         setState(() {
        //   //           Constants.userName =
        //   //               user?.displayName ?? user!.email ?? "";
        //   //         });
        //   //         commonWidget.sendMessage(_message, widget.groupModel);
        //   //         setState(() {
        //   //           _message.text = "";
        //   //         });
        //   //       },
        //   //       child: Container(
        //   //           height: 50,
        //   //           // width: 50,
        //   //           padding: EdgeInsets.all(12),
        //   //           decoration: BoxDecoration(
        //   //               gradient: LinearGradient(colors: [
        //   //                 Color(0x36FFFFFF),
        //   //                 Color(0x0FFFFFFF)
        //   //               ]),
        //   //               borderRadius: BorderRadius.circular(40)),
        //   //           child: Row(
        //   //             children: [
        //   //               Image.asset("assets/images/send.png"),
        //   //               SizedBox(
        //   //                 width: 10,
        //   //               ),
        //   //               emojiPicker(),
        //   //               // InkWell(
        //   //               //     onTap: () {

        //   //               //     },
        //   //               //     child:
        //   //               //         Image.asset("assets/images/emojy.png")),
        //   //             ],
        //   //           )),
        //   //     )
        //   //   ],
        //   // ),
        // ),

        // Container(
        //   alignment: Alignment.bottomCenter,
        //     height: 66.0,
        //     color: Colors.blue,
        //     child: ),

        // floatingActionButton: (userModel!.registerType ==
        //         Constants.registerType[1])
        //     ? FloatingActionButton(
        //         backgroundColor: Constants.mainColor,
        //         child: Column(
        //           children: [Icon(Icons.search)],
        //         ),
        //         onPressed: () {
        //           Navigator.of(context).push(
        //               MaterialPageRoute(builder: (context) => SearchScreen()));
        //         })
        //     : Row(mainAxisAlignment: MainAxisAlignment.end, children: [
        //         FloatingActionButton(
        //             backgroundColor: Constants.mainColor,
        //             child: Icon(Icons.search),
        //             onPressed: () {
        //               Navigator.of(context).push(MaterialPageRoute(
        //                   builder: (context) => SearchScreen()));
        //             }),
        //         SizedBox(
        //           width: ConstantSize.s10,
        //         ),
        //         FloatingActionButton(
        //             backgroundColor: Constants.mainColor,
        //             child: Icon(Icons.add),
        //             onPressed: () {
        //               Navigator.of(context).push(MaterialPageRoute(
        //                   builder: (context) => NewJob(_uid!)));
        //             }),
        // ]
        // )
        );
  }
}

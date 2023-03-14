// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:flutter/services.dart';
// import 'package:medical_chat_group/helper/authenticate.dart';
// import 'package:medical_chat_group/helper/constantSize.dart';
// import 'package:medical_chat_group/helper/constants.dart';
// import 'package:medical_chat_group/helper/helperFunctions.dart';
// import 'package:medical_chat_group/helper/textfile.dart';
// import 'package:medical_chat_group/model/groupModel.dart';
// import 'package:medical_chat_group/model/userModel.dart';
// import 'package:medical_chat_group/services/auth.dart';
// import 'package:medical_chat_group/services/database.dart';
// import 'package:medical_chat_group/services/notification.dart';
// import 'package:medical_chat_group/services/socialMediaAuth.dart';
// import 'package:medical_chat_group/views/conversitionScreen.dart';
// import 'package:medical_chat_group/views/emojyTest.dart';
// import 'package:medical_chat_group/views/groupDetails.dart';
// import 'package:medical_chat_group/views/newJob.dart';
// import 'package:medical_chat_group/views/searchScreen.dart';
// import 'package:medical_chat_group/views/settingPage.dart';
// import 'package:medical_chat_group/widgets/widget.dart';
// import 'package:provider/provider.dart';

// class ChatRoomsScreen extends StatefulWidget {
//   const ChatRoomsScreen({Key? key}) : super(key: key);

//   @override
//   _ChatRoomsScreenState createState() => _ChatRoomsScreenState();
// }

// class _ChatRoomsScreenState extends State<ChatRoomsScreen> {
//   AuthMethods auth = new AuthMethods();
//   DataBaseMethods databaseMethods = new DataBaseMethods();
//   Stream? chatRoomsStream;
//   UserModel? userModel;

//   final user = FirebaseAuth.instance.currentUser;
//   bool userExist = false;
//   @override
//   void initState() {
//     super.initState();
//     getUserInfo();
//   }

//   getUserInfo() async {
//     databaseMethods.getChatRoom().then((val) {
//       setState(() {
//         chatRoomsStream = val;
//       });
//     });
//     HelperFunctions.getUserData().then((value) {
//       setState(() {
//         userModel = value;
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     // print(userModel!.registerType+","+Constants.registerType[1]);

//     return Scaffold(
//       appBar: appBarMain(context,"ChatRoomsScreen",""),
//       appBar: AppBar(
//         title: Image.asset(
//           "assets/images/logo.png",
//           height: 50,
//         ),
//         actions: [
//           GestureDetector(
//             onTap: () {
//               if (user != null) {
//                 if (user!.displayName != null) {
//                   print("user not null" + user!.displayName.toString());
//                   final provider =
//                       Provider.of<SocialMediaAuth>(context, listen: false);
//                   provider.signOut();
//                 }
//               } else {
//                 print("sign out from email auth");
//                 auth.signOut();
//               }
//               Navigator.of(context).pushReplacement(
//                   MaterialPageRoute(builder: (context) => new Authenticate()));
//             },
//             child: Container(
//               padding: EdgeInsets.symmetric(horizontal: 16),
//               child: Icon(Icons.exit_to_app),
//             ),
//           ),
//           GestureDetector(
//             onTap: () {
//               // here setting pade of current user
//               Navigator.of(context)
//                   .push(MaterialPageRoute(builder: (c) => new SettingPage()));
//             },
//             child: Icon(Icons.settings),
//           )
//           // Text(user.toString(),style:Constants.fontStyle)
//         ],
//       ),
//       body: (chatRoomsStream == null)
//           ? Text(
//               "No Data Found",
//               style: Constants.fontStyle,
//             )
//           : StreamBuilder(
//               stream: chatRoomsStream,
//               builder: (context, AsyncSnapshot snapshot) {
//                 if (snapshot.hasError)
//                   return Text("Something went wrong");
//                 else if (snapshot.connectionState == ConnectionState.waiting)
//                   return Center(
//                       child: Text(
//                     "Loading........",
//                     style: Constants.fontStyle,
//                   ));
//                 else {
//                   final data = snapshot.requireData;

//                   return GridView.count(
//                       crossAxisCount: 3,
//                       crossAxisSpacing: 4,
//                       mainAxisSpacing: 7,
//                       children: List.generate(data.size, (index) {
//                         print("user id :::::::::" +
//                             user!.uid.toString() +
//                             "group id::" +
//                             snapshot.requireData.docs[index].id.toString());
//                         // final userExistance = databaseMethods.userExistance(
//                         //     user!.uid,
//                         //     snapshot.requireData.docs[index].id.toString());
//                         // print(userExistance);
//                         return Center(
//                           child: ListTile(
//                             title: InkWell(
//                               onTap: () {
//                                 // HelperFunctions.getToken().then((value) {
//                                 //   print("saved Token =================== $value");
//                                 //

//                                 print("group info::::::::::::" +
//                                     data.docs[index].id +
//                                     data.docs[index]["members"].toString() +
//                                     data.docs[index]["name"]);
//                                 GroupModel groupModel = GroupModel(
//                                     data.docs[index].id,
//                                     data.docs[index]["members"],
//                                     data.docs[index]["name"]);
//                                 Navigator.of(context).push(MaterialPageRoute(
//                                     builder: (c) => JobDetails(groupModel)));
//                               },
//                               child: Container(
//                                 height: 60,
//                                 // width: 100,
//                                 decoration: BoxDecoration(
//                                     color: Constants.mainColor,
//                                     borderRadius: BorderRadius.circular(
//                                         Constants.containerRadius)),
//                                 child: Center(
//                                   child: Text(
//                                     data.docs[index]["name"],
//                                     style: Constants.fontStyle,
//                                   ),
//                                 ),
//                               ),
//                             ),

//                             subtitle: Column(
//                               children: [
//                                 Text(
//                                   data.docs[index]["members"].length
//                                           .toString() +
//                                       TextFile.members,
//                                   //[0]["name"]
//                                   style: Constants.fontStyle,
//                                 ),
//                                 // Expanded(
//                                 //   child: InkWell(
//                                 //       onTap: () async {
//                                 //         // (after click member can see all job in this group)
//                                 //         // after click memberId and name of member will add to this group
//                                 //         //DataBaseMethods

//                                 //         //collection('users').doc(id).get()
//                                 //         // print("data.docs :::::"+ snapshot.data.docs[index].id.toString());
//                                 //         // createChatRoomAndStartConversition(context,
//                                 //         //     user?.displayName, data.docs[index].id);
//                                 //         // var userExistance =
//                                 //         //     await databaseMethods.userExistance(
//                                 //         //         user!.uid,
//                                 //         //         data.docs[index].id.toString());
//                                 //         Map<String, dynamic> newMember = {
//                                 //           "memberId": user!.uid,
//                                 //           "name": userModel!.userName,
//                                 //           "email": userModel!.userEmail,
//                                 //           "registerType": userModel!.registerType,

//                                 //         };
//                                 //         databaseMethods.addNewMember(
//                                 //             newMember, data.docs[index].id);

//                                 //         // if (userExistance == true) {
//                                 //         //   Navigator.of(context).push(
//                                 //         //       MaterialPageRoute(
//                                 //         //           builder: (c) =>
//                                 //         //               new ConversitionScreen(data
//                                 //         //                   .docs[index].id
//                                 //         //                   .toString())));
//                                 //         // }

//                                 //         // databaseMethods.userExistance(
//                                 //         //           user!.uid,
//                                 //         //           data.docs[index].id.toString()) ==
//                                 //         //       true
//                                 //       },
//                                 //       child: Text(
//                                 //         TextFile.join,
//                                 //         //[0]["name"]
//                                 //         style: Constants.fontStyleJoin,
//                                 //       )
//                                 //       // : Text(
//                                 //       //         "",
//                                 //       //         //[0]["name"]
//                                 //       //         style: Constants.fontStyleJoin,
//                                 //       //       ),
//                                 //       ),
//                                 // ),
//                               ],
//                             ),
//                             // Container(
//                             //   height: 100,
//                             //   width: 100,
//                             //   decoration: BoxDecoration(
//                             //       borderRadius: BorderRadius.circular(20),
//                             //       color: Constants.roomColor),
//                             //   child: Center(
//                             //     child: Row(
//                             //       children: [
//                             //      ,
//                             //         InkWell(
//                             //           onTap: () {},
//                             //           child: Text(
//                             //             "Join",
//                             //             style: Constants.fontStyleJoin,
//                             //           ),
//                             //         )
//                             //       ],
//                             //     ),
//                             //   ),
//                             // ),
//                           ),
//                         );
//                       }));
//                 }
//               }),
//       // add new job
//       floatingActionButton: FloatingActionButton(
//         onPressed: () async {
//           final userID = await HelperFunctions.getUID();

//           print("user id :::::::::::::::::::" + userID.toString());
//           Navigator.of(context)
//               .push(MaterialPageRoute(builder: (c) => new NewJob(userID)));
//         },
//         backgroundColor: Color.fromARGB(255, 165, 64, 157),
//         child: const Icon(Icons.add),
//       ),
//     );
//   }

//   Widget chatRoomList() {
//     return StreamBuilder(
//         stream: chatRoomsStream,
//         builder: (context, AsyncSnapshot snapshot) {
//           return snapshot.hasData
//               ? ListView.builder(
//                   itemCount: snapshot.data?.docs.length,
//                   itemBuilder: (context, index) {
//                     return Padding(
//                       padding: const EdgeInsets.only(left: 10, right: 10),
//                       child: GestureDetector(
//                         onTap: () {
//                           print("chat room id ::::::::::::::::::" +
//                               snapshot.data.docs[index]
//                                   .get("chatRoomId")
//                                   .toString());
//                           Navigator.of(context).push(MaterialPageRoute(
//                               builder: (context) => ConversitionScreen(snapshot
//                                   .data.docs[index]
//                                   .get("chatRoomId"))));
//                         },
//                         child: Row(
//                           children: [
//                             Container(
//                               padding: EdgeInsets.symmetric(
//                                   vertical: 24, horizontal: 16),
//                               alignment: Alignment.center,
//                               decoration: BoxDecoration(
//                                   color: Colors.blue, shape: BoxShape.circle),
//                               child: Text(
//                                 snapshot.data.docs[index]
//                                     .get("chatRoomId")
//                                     .substring(0, 1)
//                                     .toUpperCase(),
//                                 style: simpleTextStyle(),
//                               ),
//                             ),
//                             SizedBox(
//                               width: 10,
//                             ),
//                             Text(
//                               snapshot.data.docs[index]
//                                   .get("chatRoomId")
//                                   .toString()
//                                   .replaceAll("_", "")
//                                   .replaceAll(Constants.chatRooms, ""),
//                               style: simpleTextStyle(),
//                             )
//                           ],
//                         ),
//                       ),
//                     );
//                   })
//               : Container(
//                   child: Center(
//                     child: Text(
//                       "No data found",
//                       style: simpleTextStyle(),
//                     ),
//                   ),
//                 );
//         });
//   }

//   createChatRoomAndStartConversition(
//       BuildContext context, String? userName, String groupId) {
//     List<String> users = [userName!, Constants.chatRooms];
//     Map<String, dynamic> chatRoomMap = {
//       "users": users,
//       "chatRoomId": groupId,
//     };
//     databaseMethods.createChatRoom(groupId, chatRoomMap);
//     Navigator.of(context).push(MaterialPageRoute(
//         builder: (context) => new ConversitionScreen(groupId)));
//   }
// }

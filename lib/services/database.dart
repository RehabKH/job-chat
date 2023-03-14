import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medical_chat_group/helper/constants.dart';
import 'package:medical_chat_group/helper/helperFunctions.dart';
import 'package:medical_chat_group/model/jobModel.dart';
import 'package:medical_chat_group/model/messageModel.dart';
import 'package:medical_chat_group/model/notificationModel.dart';
import 'package:medical_chat_group/model/userModel.dart';
import 'package:medical_chat_group/services/notification.dart';
import 'package:permission_handler/permission_handler.dart';

import '../widgets/commonWidget.dart';

class DataBaseMethods {
  uploadUserInfo(Map<String, String> userInfo, String userID) {
    HelperFunctions.saveUID(userID);
    FirebaseFirestore.instance.collection("users").doc(userID).set(userInfo)
        // .add(userInfo)
        .catchError((e) {
      print("error in save user name and email ::::::::::::::" + e.toString());
    });
  }

  getUserInfo(String userID) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(userID)
        .get()
        // .add(userInfo)
        .catchError((e) {
      print("error in save user name and email ::::::::::::::" + e.toString());
    });
  }

  Future getGroupByGroupName(String groupName) async {
    return await FirebaseFirestore.instance
        .collection("chatRoom")
        .where("name", isEqualTo: groupName)
        .get();
  }

// get job by job title
  Future getJobByJobTitle(String jobTitle) async {
    List<JobModel> jobList = [];
    final result = await FirebaseFirestore.instance.collection("jobs").get();

    for (int i = 0; i < result.docs.length; i++) {
      print("result job search :::::::::::" + result.docs[i].data()["title"]);
      if (result.docs[i].data()["title"].toString().contains(jobTitle) ||
          result.docs[i].data()["desc"].toString().contains(jobTitle)) {
        JobModel jobModel = new JobModel(
            result.docs[i].id,
            result.docs[i].data()["title"],
            result.docs[i].data()["desc"],
            result.docs[i].data()["jobPoster"]);
        jobList.add(jobModel);
      }
    }
    print("job search result :::::::::::::::::::: " + jobList.toString());
    return jobList;
  }

  Future getDataByUserEmail(String userEmail) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .where("email", isEqualTo: userEmail)
        .get();
  }

  createChatRoom(String chatRoomId, chatRoomMap) async {
    print("job id from making room  :::::::: " + chatRoomId);
    await FirebaseFirestore.instance
        .collection("chatRooms")
        .doc(chatRoomId)
        .collection("chats")
        .add(chatRoomMap)
        .then((value) {
      // print("value of make chat room " + value.id.toString());
    }).catchError((e) {
      print(e.toString());
    });
  }

  addConversition(String chatRoomId, messageMap) {
    FirebaseFirestore.instance
        .collection("chatRooms")
        .doc(chatRoomId)
        .collection("chats")
        .add(messageMap)
        .catchError((e) {
      print("error message in save message :::: " + e.toString());
    });
  }

  saveToken(UserModel userModel, String userID) async {

    // final dataInfo =
    //     await FirebaseFirestore.instance.collection('users').doc(userID).get();
   
    // UserModel userModel = new UserModel(dataInfo.data()!["name"],
    //     dataInfo.data()!["email"], dataInfo.data()!["register type"],
    //     uid:userID,
    //     token: token);
    await FirebaseFirestore.instance
        .collection("users")
        .doc(userID)
        .set(userModel.toMap());
  }

// save notification to database
  saveNotification(NotificationModel notificationModel) async {
    // Random random = Random();
    await FirebaseFirestore.instance
        .collection('notifications')
        .add(notificationModel.toJson());
  }

// update notification to make isOpened = true
  updateNotification(NotificationModel notificationModel) async {
    // Random random = Random();
    await FirebaseFirestore.instance
        .collection('notifications')
        .doc(notificationModel.notificationId)
        .update(notificationModel.toJson());
  }
  // get notification from database

  Future getNotification(String userID) async {
    List<NotificationModel>? notifications = [];
    NotificationModel? notification;
    print("user id ::::::::::::::::::::::::" + userID);
    final result = await FirebaseFirestore.instance
        .collection('notifications')
        .where("userID", isEqualTo: userID)
        .get();
    result.docs.forEach((element) {
      notifications.add(NotificationModel(
          element.id,
          userID,
          element.data()["title"],
          element.data()["body"],
          element.data()["isOpened"]));
    });
    print(notifications.length.toString());
    return notifications;
    // result.reference.snapshots().forEach((val) {
    //   // val.reference.get().then((value) {
    //   //  print("notification::::::::::::::::::" + value.metadata.length.toString());
    //   // });

    //   val.reference.collection("10").get().then((v) {
    //     print(
    //         "notification ::::::::::::::::::" + v.docs.first.data().toString());
    //   });
    // });
  }

//get all users token
  getAllUsersTokens() async {
    List<String> tokens = [];

    final allUsersIDS =
        await FirebaseFirestore.instance.collection("users").get();
    for (int i = 0; i < allUsersIDS.size; i++) {
      // final val = await allUsersIDS.docs[i].reference.collection("token").get();
      final val = await allUsersIDS.docs[i].get("token");
      tokens.add(val);

      // print("tokens list::::::::::::::: $tokens");
    }
    print("tokens list::::::::::::::: ${tokens.length}");
    return tokens;
  }

  Future addNewJob(JobModel jobInfo, String userId,
      {String groupID = ""}) async {
    // Constants.jobIsExist = false;
    // await FirebaseFirestore.instance.collection("jobs").get().then((value) {
    //   print("job data :::::::::::::::" + value.docs.first.data()["title"]);
    //   // value.docs.forEach((element) {
    //   //   if (jobInfo.title == element.data()["title"]) {
    //   //     Constants.jobIsExist = true;
    //   //   }
    //   // });
    // });
    // if (!Constants.jobIsExist) {
    Map<String, dynamic> jobData = {
      "title": jobInfo.title,
      "desc": jobInfo.desc,
      "jobPoster": userId
    };
    // search for chat room that have the same title of this job and add this job to group
    // String? jobResult;

    await FirebaseFirestore.instance
        .collection("jobs")
        .add(jobData)
        .then((value) {
      print("adding job result :::::::::::::::::" + value.toString());
      print("job id  :::::::::::::::::" + value.id.toString());

      addNewGroup(value.id, jobInfo.title, userId);
      // createChatRoom(value.id,
      //     {"message": "", "sendBy": "", "time": DateTime.now().millisecond});
      return value.id;
    }).catchError((e) {
      print("error add job  :::: " + e.toString());
    });
  }

  getConversition(String chatRoomId) async {
    return await FirebaseFirestore.instance
        .collection("chatRooms")
        .doc(chatRoomId)
        .collection("chats")
        .orderBy("time", descending: false)
        .snapshots();
  }

// عمل جروب جديد باسم الوظيفه وبها صاحب الوظيفه
  addNewGroup(String jobID, String jobName, String uid) async {
    await FirebaseFirestore.instance.collection("groups").doc(jobID).set({
      "members": [
        {
          "memberID": uid,
        }
      ],
      "name": jobName
    });
  }

  // getGroupName(String groupId) async {
  //   String groupName = "";
  //   await FirebaseFirestore.instance
  //       .collection("chatRoom")
  //       .doc(groupId)
  //       .get()
  //       .then((value) {
  //     groupName = value.data()!["name"];
  //     print(value.data()!["name"].toString());
  //   });
  //   return groupName;
  // }

  getChatRooms(String userName) async {
    return await FirebaseFirestore.instance
        .collection("chatRooms")
        .where("users", arrayContains: userName)
        .snapshots();
  }

// // get all jobs that have the same title
//   getAllJobsByTitle(JobModel jobModel) async {
//     print("job title:::::::::::::::" + jobModel.title);
//     return FirebaseFirestore.instance
//         .collection("jobs")
//         // .where("title", arrayContains: jobModel.title)
//         .snapshots();
//   }

// get all jobs
  getAllJobs() async {
    return FirebaseFirestore.instance.collection("jobs").snapshots();
  }

  // get chat Room ex: محاسبين
  getChatRoom() async {
    return FirebaseFirestore.instance.collection("chatRoom").snapshots();
  }

  // get group details by group id
  getGroupInfo(String groupId) async {
    print("group id::::" + groupId);
    return await FirebaseFirestore.instance
        .collection("chatRooms")
        .doc(groupId)
        .collection("chats")
        .orderBy("time")
        .snapshots();
  }

  // delete notification by id
  deleteNotification(String notificationId) async {
    return await FirebaseFirestore.instance
        .collection("notifications")
        .doc(notificationId)
        .delete();
  }

  // add new member to group
  addNewMember(Map<String, dynamic> memberInfo, String jobID) {
    print("job id from add member:::::::::::::::::::::" + jobID);
    FirebaseFirestore.instance
        .collection("groups")
        .doc(jobID)
        .get()
        .then((value) {
      // print("old data::::::::::::::  " + value.data().toString());
      List<dynamic> listOfDynamic = value.data()!["members"];
      String groupName = value.data()!["name"];
      Map<String, dynamic> oldData = {};
      // listOfDynamic.add(data);
      listOfDynamic.forEach((element) {
        print("member:" + element["name"].toString());

        oldData.addAll(element);
        // oldData.addAll(element["memberId"]);
        // print(oldData["name"].toString());
      });
      print("old Data " + oldData.toString());
      List<Map<String, dynamic>> newData = [];

      newData.add(oldData);
      newData.add(memberInfo);

      FirebaseFirestore.instance.collection("groups").doc(jobID).set(
        {"members": newData, "name": groupName},
      ).catchError((e) {
        print("error adding new member :::: " + e.toString());
      });
      Fluttertoast.showToast(
          msg: "member added successfully",
          backgroundColor: Constants.settingColor);
      // upload all data to firestore
      // newData.forEach((element) {
      //   print("new  Data" + newData.toString());

      // });
    });
  }

  // // check user exist in group
  Future<String> userExistance(String memberId, String groupId) async {
    String userExist = "";
    FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(groupId)
        .get()
        .then((value) {
      List<dynamic> listOfDynamic = value.data()!["members"];

      // listOfDynamic.add(data);
      for (var element in listOfDynamic) {
        // if current user inside this group => return true else return false
        // if true => display (group details) else display (ex:5 members)

        if (memberId == element["memberId"].toString()) {
          print("member exist  " + element["name"].toString());
          userExist = "user Not Exist";
          break;
        }
      }
      userExist = "user Exist";
    });
    return userExist;
  }

  getChatRoomId(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else
      return "$a\_$b";
  }

  // update user info by uid
  updateUserInfo(String uid, userInfo) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .update(userInfo);
  }

  //listen to jobs table
  Future listenToFirestore() async {
    DataBaseMethods dbMethod = new DataBaseMethods();
    CollectionReference reference =
        FirebaseFirestore.instance.collection('Notifications');
    reference.snapshots().listen((querySnapshot) {
      querySnapshot.docChanges.forEach((change) {
        // Do something with change
        if (change.type == DocumentChangeType.added) {
          dbMethod.getAllUsersTokens().then((val) {
            sendNotification(change.doc.get("title").toString(),
                change.doc.get("body").toString());
            print("data of change ${change.doc.data()}");
          });
        }
      });
    });
  }

  uploadImage() async {
    final _firebaseStorage = FirebaseStorage.instance;
    final _imagePicker = ImagePicker();
    String? imageUrl;
    PickedFile image;
    //Check Permissions
    await Permission.photos.request();

    var permissionStatus = await Permission.photos.status;

    if (permissionStatus.isGranted) {
      //Select Image
      image = (await _imagePicker.pickImage(source: ImageSource.gallery))
          as PickedFile;
      var file = File(image.path);

      if (image != null) {
        //Upload to Firebase
        var snapshot = await _firebaseStorage
            .ref()
            .child('images/imageName')
            .putFile(file)
            .whenComplete(() {});
        var downloadUrl = await snapshot.ref.getDownloadURL();

        imageUrl = downloadUrl;
        return downloadUrl;
      } else {
        print(Constants.noFileSelected);
        return Constants.noFileSelected;
      }
    } else {
      print(Constants.permissionDenied);
      return Constants.permissionDenied;
    }
  }

  // search in chat table
  searchForMessage(String searchText, String jobId) async {
    List<MessageModel> resultList = [];
    final result = await FirebaseFirestore.instance
        .collection("chatRooms")
        .doc(jobId)
        .collection("chats")
        .get();

    for (int i = 0; i < result.size; i++) {
      print("result :::::::::::::::::::::" + result.docs[i].data()["message"]);
      if (result.docs[i].data()["message"].toString().contains(searchText)) {
        // var res = {
        //   "sendBy": result.docs[i].data()["sendBy"],
        //   "message": result.docs[i].data()["message"],
        //   "time": result.docs[i].data()["time"]
        // };
        // var messaeModel = new MessageModel(result.docs[i], message, sendBy, time)
        MessageModel messageModel = MessageModel(
            result.docs[i].id,
            result.docs[i].data()["message"],
            result.docs[i].data()["sendBy"],
            CommonWidget.convertTimestampToDate(result.docs[i].data()["time"]));
        messageModel.toJson();
        resultList.add(messageModel);
      }
    }
    print("list result ::::::::::::::" + resultList.toString());
    return resultList;
  }
}

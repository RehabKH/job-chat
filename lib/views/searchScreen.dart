import 'package:medical_chat_group/helper/constants.dart';
import 'package:medical_chat_group/helper/helperFunctions.dart';
import 'package:medical_chat_group/model/groupModel.dart';
import 'package:medical_chat_group/model/jobModel.dart';
import 'package:medical_chat_group/model/messageModel.dart';
import 'package:medical_chat_group/model/userModel.dart';
import 'package:medical_chat_group/services/database.dart';
import 'package:medical_chat_group/views/conversitionScreen.dart';
import 'package:medical_chat_group/views/JobChat.dart';
import 'package:medical_chat_group/views/jobDetails.dart';
import 'package:medical_chat_group/widgets/commonWidget.dart';
import 'package:medical_chat_group/widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  String searchTitle;
  String? jobId;
  SearchScreen(this.searchTitle, {this.jobId});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _search = new TextEditingController();
  List<JobModel> jobSearch = [];
  DataBaseMethods dataBaseMethods = new DataBaseMethods();
  final user = FirebaseAuth.instance.currentUser;
  List<MessageModel> searchMessage = [];
  searchResult() {
    if (widget.searchTitle == Constants.messageSearch) {
      dataBaseMethods.searchForMessage(_search.text, widget.jobId!).then((val) {
        setState(() {
          searchMessage = val;
        });
        print("message search result ::::::::::::" +
            searchMessage.length.toString());
      });
    } else {
        dataBaseMethods.getJobByJobTitle(_search.text).then((value) {
        setState(() {
          jobSearch = value;
        });
        // print("data result :::" + searchSnapshot!.docChanges.toString());
      });
    }
  }

  Widget messageListView() {
    return ListView.builder(
        padding: EdgeInsets.only(bottom: 100),
        // physics: NeverScrollableScrollPhysics(),
        // shrinkWrap: true,
        itemCount: searchMessage.length,
        itemBuilder: (context, index) {
          // MessageModel messageModel = new MessageModel(
          //     "",
          //     snapshot.data.docs[index]!.get("message").toString(),
          //     snapshot.data.docs[index]!.get("sendBy").toString(),
          //     convertTimestampToDate(snapshot.data.docs[index]!.get("time"))
          //         .toString());
          return MessageTile(searchMessage[index],
              isSendByMe: (searchMessage[index].sendBy == Constants.userName));
        });
  }

  Widget listViewResult() {
    return ListView.builder(
        itemCount: jobSearch.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(jobSearch[index].title,
                style: simpleTextStyle()),
            trailing: TextButton(
                style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: BorderSide(color: Colors.white))),
                    backgroundColor: MaterialStateProperty.all(Colors.blue)),
                onPressed: () {

                  
                  // GroupModel groupModel = GroupModel(
                  //     searchSnapshot!.docs[index].id,
                  //     searchSnapshot!.docs[index].get("members"),
                  //     searchSnapshot!.docs[index].get("name"));
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (c) => new JobDetails(jobSearch[index])));
                  
                },
                child: Padding(
                  padding: EdgeInsets.all(3),
                  child: Text(
                    "Job Details",
                    style: simpleTextStyle(),
                  ),
                )),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context, "Search Screen", ""),
      body: SingleChildScrollView(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              color: Color(0x36FFFFFF),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      onEditingComplete: () {
                        searchResult();
                        // Navigator.of(context).pop(true);
                      },
                      controller: _search,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                          hintText: widget.searchTitle,
                          hintStyle: TextStyle(color: Colors.white54),
                          border: InputBorder.none),
                    ),
                  ),
                  // GestureDetector(
                  //   onTap: () {
                  //     searchResult();
                  //   },
                  //   child: Container(
                  //     height: 50,
                  //     width: 50,
                  //     padding: EdgeInsets.all(12),
                  //     decoration: BoxDecoration(
                  //         gradient: LinearGradient(
                  //             colors: [Color(0x36FFFFFF), Color(0x0FFFFFFF)]),
                  //         borderRadius: BorderRadius.circular(40)),
                  //     child: Image.asset("assets/images/search_white.png"),
                  //   ),
                  // )
                ],
              ),
            ),
            (jobSearch == null && searchMessage.length == 0)
                ? Text("No Data To Show", style: Constants.fontStyle)
                : (jobSearch.length == 0 && searchMessage.length == 0)
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(_search.text + " Not Found",
                              style: Constants.fontStyle),
                        ],
                      )
                    :
                  

                    Container(
                        height: MediaQuery.of(context).size.height - 150,
                        child: 
                        (widget.searchTitle == Constants.messageSearch)?
                            messageListView()
                            : listViewResult(),
                      )
          ],
        ),
      ),
    );
  }

  UserModel? _userModel;
  getUserInfo() async {
    _userModel = await HelperFunctions.getUserData();
  }
}

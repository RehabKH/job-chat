import 'package:flutter/material.dart';
import 'package:medical_chat_group/widgets/commonWidget.dart';

import '../helper/constants.dart';
import '../services/database.dart';
import '../widgets/widget.dart';

// import 'package:intl/date_time_patterns.dart';
// ignore: must_be_immutable
class ConversitionScreen extends StatefulWidget {
  String chatRoomId;
  // Map<String, dynamic> conversitionList;
  ConversitionScreen(this.chatRoomId);

  @override
  _ConversitionScreenState createState() => _ConversitionScreenState();
}

class _ConversitionScreenState extends State<ConversitionScreen> {
  TextEditingController _message = new TextEditingController();
  DataBaseMethods dataBaseMethods = new DataBaseMethods();
  Stream? chatMessageStream;
  String? groupInfo;
  CommonWidget commonWidget = new CommonWidget();
  @override
  void initState() {
    dataBaseMethods.getConversition(widget.chatRoomId).then((val) {
      setState(() {
        chatMessageStream = val;
      });
    });
    dataBaseMethods.getGroupInfo(widget.chatRoomId).then((value) {
      setState(() {
        groupInfo = value;
      });
      //.data()!["name"]
      // print("name of group :::::::::::::::" +
      //     groupInfo.toString());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          groupInfo ?? "",
        ),
        elevation: 0,
        backgroundColor: Color.fromARGB(255, 31, 117, 187),
      ),
      body: Container(
        child: Stack(
          children: [
            commonWidget.streamWidget(chatMessageStream),
            Container(
              alignment: Alignment.bottomCenter,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              color: Color(0x36FFFFFF),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _message,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                          hintText: "Message",
                          hintStyle: TextStyle(color: Colors.white54),
                          border: InputBorder.none),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // commonWidget.sendMessage(_message);
                    },
                    child: Container(
                        height: 50,
                        // width: 50,
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: [Color(0x36FFFFFF), Color(0x0FFFFFFF)]),
                            borderRadius: BorderRadius.circular(40)),
                        child: Row(
                          children: [
                            Image.asset("assets/images/send.png"),
                            SizedBox(
                              width: 10,
                            ),
                            InkWell(
                                onTap: () {},
                                child: Image.asset("assets/images/emojy.png")),
                          ],
                        )),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

 
}

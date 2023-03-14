import 'package:flutter/material.dart';
import 'package:medical_chat_group/helper/constants.dart';
import 'package:medical_chat_group/model/groupModel.dart';
import 'package:medical_chat_group/model/jobModel.dart';
import 'package:medical_chat_group/model/messageModel.dart';
import 'package:medical_chat_group/model/notificationModel.dart';
import 'package:medical_chat_group/services/database.dart';
import 'package:medical_chat_group/services/notification.dart';
import 'package:medical_chat_group/widgets/widget.dart';

class CommonWidget {
  static convertTimestampToDate(int timeStamp) {
    final dt = DateTime.fromMillisecondsSinceEpoch(timeStamp * 1000);
    print(dt);
    return dt.hour.toString() + ":" + dt.minute.toString();
  }

  Widget buildTextField(TextEditingController controller, String hint) {
    return (hint == "Job Description")
        ? TextFormField(
            controller: controller,
            // minLines: 0,
            validator: validate,
            style: simpleTextStyle(),
            decoration: inputDecoration(hint),
          )
        : TextFormField(
            controller: controller,
            validator: validate,
            style: simpleTextStyle(),
            decoration: inputDecoration(hint),
          );
  }

  Widget streamWidget(Stream? stream) {
    return (stream == null)
        ? Center(
            child:
                Text("No Messages in this group", style: Constants.fontStyle),
          )
        : StreamBuilder(
            stream: stream,
            builder: (context, AsyncSnapshot snapshot) {
              return (snapshot.data == null)
                  ? Align(
                      alignment: Alignment.center,
                      child: Text(
                        "No Message in this group",
                        style: Constants.fontStyle,
                      ))
                  : (!snapshot.hasData)
                      ? Center(
                          child: Text(
                          "No Message in this group",
                          style: Constants.fontStyle,
                        ))
                      : ListView.builder(
                          padding: EdgeInsets.only(bottom: 100),
                          // physics: NeverScrollableScrollPhysics(),
                          // shrinkWrap: true,
                          itemCount: snapshot.data?.docs.length,
                          itemBuilder: (context, index) {
                            MessageModel messageModel = new MessageModel("",
                                snapshot.data.docs[index]!
                                    .get("message")
                                    .toString(),
                                snapshot.data.docs[index]!
                                    .get("sendBy")
                                    .toString(),
                                convertTimestampToDate(
                                        snapshot.data.docs[index]!.get("time"))
                                    .toString());
                            return MessageTile(messageModel,
                                isSendByMe:
                                    (snapshot.data.docs[index]!.get("sendBy") ==
                                        Constants.userName));
                          });
            });
  }

  sendMessage(TextEditingController message, JobModel jobModel) async {
    DataBaseMethods dataBaseMethods = new DataBaseMethods();

    if (message.text != "") {
      Map<String, dynamic> messageMap = {
        "message": message.text,
        "sendBy": Constants.userName,
        "time": DateTime.now().millisecondsSinceEpoch
      };
 print("message ::::::::::::::: " + message.text.toString());
      sendNotification( 
          "New message from chat ",
          message.text);
      await dataBaseMethods.addConversition(jobModel.id, messageMap);
      // final tokens = await dataBaseMethods.getAllUsersTokens();
     
    }
  }
  static showDialog1(BuildContext context, object) {
    return showDialog(
        barrierColor: Colors.black,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            // icon: Icon(Icons.close),
            title: Text(
              "notification Details",
              style: TextStyle(
                  color: Constants.mainColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            ),

            content: ListTile(
              title: Text(
                object.title!,
                style: TextStyle(color: Constants.mainColor),
              ),
              subtitle: Text(object.body!,
                  style: TextStyle(color: Constants.mainColor)),
            ),
            // content: Stack(
            //   children: <Widget>[
            //     // Positioned(
            //     //   right: -40.0,
            //     //   top: -40.0,
            //     //   child: InkResponse(
            //     //     onTap: () {
            //     //       Navigator.of(context).pop();
            //     //     },
            //     //     child: CircleAvatar(
            //     //       child: Icon(Icons.close),
            //     //       backgroundColor: Colors.red,
            //     //     ),
            //     //   ),
            //     // ),

            //   ],
            // ),
          );
        });
  }
}

class MessageTile extends StatelessWidget {
  final MessageModel messageModel;
  // final String message;
  // final String sendBy;
  final bool isSendByMe;
  MessageTile(this.messageModel, {this.isSendByMe = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 15.0),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8),
        alignment: (isSendByMe) ? Alignment.centerRight : Alignment.centerLeft,
        width: MediaQuery.of(context).size.width,
        child: Container(
            constraints: const BoxConstraints(
              maxWidth: 200,
            ),
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            // height: 50,width:150,
            decoration: (isSendByMe)
                ? BoxDecoration(
                    color: Constants.groupColor,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(23),
                      topLeft: Radius.circular(23),
                      topRight: Radius.circular(23),
                    ))
                : BoxDecoration(
                    color: Constants.groupColor,
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(23),
                      topLeft: Radius.circular(23),
                      topRight: Radius.circular(23),
                    )),
            child: Column(
              children: [
                Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      messageModel.sendBy == ""
                          ? "unknown"
                          : messageModel.sendBy!,
                      style: Constants.senderName,
                    )),
                Text(
                  messageModel.message!,
                  style: simpleTextStyle(),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(
                        Icons.visibility,
                        color: Color.fromARGB(255, 165, 178, 182),
                        size: 14,
                      ),
                      SizedBox(
                        width: 2,
                      ),
                      Text(
                        "4.2k, ",
                        style: Constants.messageInfoStyle,
                      ),
                      SizedBox(
                        width: 2,
                      ),
                      Text(
                        messageModel.time!,
                        style: Constants.messageInfoStyle,
                      ),
                      SizedBox(
                        width: 2,
                      ),
                      Text(
                        messageModel.sendBy != ""
                            ? messageModel.sendBy!.substring(0, 6)
                            : "",
                        style: Constants.messageInfoStyle,
                      ),
                    ],
                  ),
                )
              ],
            )),
      ),
    );
  }

 
}

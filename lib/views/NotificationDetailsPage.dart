import 'package:flutter/material.dart';
import 'package:medical_chat_group/helper/constants.dart';
import 'package:medical_chat_group/helper/helperFunctions.dart';
import 'package:medical_chat_group/model/notificationModel.dart';
import 'package:medical_chat_group/services/database.dart';
import 'package:medical_chat_group/widgets/commonWidget.dart';
import 'package:swipe/swipe.dart';
import '../widgets/widget.dart';

class NotificationDetailsPage extends StatefulWidget {
  const NotificationDetailsPage({Key? key}) : super(key: key);

  @override
  _NotificationDetailsPageState createState() =>
      _NotificationDetailsPageState();
}

class _NotificationDetailsPageState extends State<NotificationDetailsPage> {
  DataBaseMethods dataBaseMethods = DataBaseMethods();
  String? userID;
  List<NotificationModel> notificationResult = [];
  @override
  void initState() {
    super.initState();
    HelperFunctions.getUID().then((value) {
      setState(() {
        userID = value;
      });
      dataBaseMethods.getNotification(userID!).then((value) {
        setState(() {
          notificationResult = value;
        });
        print("notification ::::::::::::::::::::::::::::::::: " +
            notificationResult.length.toString());
      });
      // dataBaseMethods.getNotification(userID!);
      // .then((value) {
      //   notificationResult = value;
      // });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('All Notification'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: notificationsDisplay(),
      ),
    );
  }

  Widget notificationsDisplay() {
    return (notificationResult.length == 0)
        ? Center(
            child: Text(
              "No Notification",
              style: Constants.fontStyle,
            ),
          )
        : ListView.builder(
            itemCount: notificationResult.length,
            itemBuilder: (context, index) {
              return Dismissible(
                onDismissed: (direction) {
                  // delete notification from database
                  dataBaseMethods.deleteNotification(
                      notificationResult[index].notificationId!);
                },
                key: ValueKey("Delete"),
                secondaryBackground: Container(
                  color: Colors.white,
                ),
                background: Container(
                  color: Constants.mainColor,
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Text(
                      "Delete",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ),
                child: InkWell(
                  onTap: () {
                    //  mark as read
                    // update notification table to make isOpened = true
                    CommonWidget.showDialog1(context, notificationResult[index]);
                    setState(() {
                      notificationResult[index].isOpened = true;
                    });
                    dataBaseMethods
                        .updateNotification(notificationResult[index]);
                
                  },
                  child: Card(
                    color: (notificationResult[index].isOpened!)
                        ? Colors.white.withOpacity(0.1)
                        : Colors.white.withOpacity(0.5),
                    child: ListTile(
                      // IconButton(
                      //     onPressed: () {
                      //       // delete this notification from database
                      //       dataBaseMethods.deleteNotification(notificationResult[index].notificationId!);
                      //     },
                      //     icon: Icon(Icons.delete_forever_outlined)),
                      title: Text(notificationResult[index].title!,
                          style: TextStyle(
                              color: Constants.mainColor,
                              fontSize: 17,
                              fontWeight: FontWeight.bold)),
                      subtitle: Text(
                        notificationResult[index].body!,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
  }

  
}

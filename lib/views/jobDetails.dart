import 'package:flutter/material.dart';
import 'package:medical_chat_group/helper/constantSize.dart';
import 'package:medical_chat_group/helper/constants.dart';
import 'package:medical_chat_group/helper/helperFunctions.dart';
import 'package:medical_chat_group/model/jobModel.dart';
import 'package:medical_chat_group/model/userModel.dart';
import 'package:medical_chat_group/services/database.dart';
import 'package:medical_chat_group/views/JobChat.dart';

class JobDetails extends StatefulWidget {
  JobModel jobModel;
  JobDetails(this.jobModel);
  @override
  State<JobDetails> createState() => _JobDetailsState();
}

class _JobDetailsState extends State<JobDetails> {
  UserModel? userModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    HelperFunctions.getUserData().then((value) {
      setState(() {
        userModel = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Job Details",
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          cardRow(),
          InkWell(
            onTap: () {
              // add this user to groups table
              // DataBaseMethods dbMethod = new DataBaseMethods();
              // dbMethod.addNewMember(userModel!.toMap(), widget.jobModel.id);
              //
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (c) => new JobChat(widget.jobModel)));
            },
            child: Center(
              child: Text(
                "Chat",
                style: TextStyle(
                    color: Constants.mainColor,
                    fontSize: ConstantSize.s20,
                    fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget cardRow() {
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RichText(
            text: TextSpan(children: [
              TextSpan(
                  text: "Job Title: ",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: ConstantSize.s16,
                      color: Colors.black)),
              TextSpan(
                  text: widget.jobModel.title,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: ConstantSize.s16,
                      color: Colors.pink))
            ]),
          ),
          RichText(
            text: TextSpan(children: [
              TextSpan(
                  text: "Job Description: ",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: ConstantSize.s16,
                      color: Colors.black)),
              TextSpan(
                  text: widget.jobModel.desc,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: ConstantSize.s16,
                      color: Colors.pink))
            ]),
          )
        ],
      ),
    );
  }
}

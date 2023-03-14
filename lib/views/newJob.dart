import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:medical_chat_group/helper/constantSize.dart';
import 'package:medical_chat_group/helper/constants.dart';
import 'package:medical_chat_group/helper/helperFunctions.dart';
import 'package:medical_chat_group/model/jobModel.dart';
import 'package:medical_chat_group/model/notificationModel.dart';
import 'package:medical_chat_group/services/database.dart';
import 'package:medical_chat_group/services/notification.dart';
import 'package:medical_chat_group/widgets/commonWidget.dart';
import 'package:medical_chat_group/widgets/widget.dart';

class NewJob extends StatefulWidget {
  String uid;
  NewJob(this.uid);
  @override
  State<NewJob> createState() => _NewJobState();
}

class _NewJobState extends State<NewJob> {
  final key = GlobalKey<FormState>();
  DataBaseMethods dbMethod = new DataBaseMethods();
  TextEditingController _title = new TextEditingController(),
      desc = TextEditingController();
  CommonWidget commonWidget = new CommonWidget();
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context, "Add New Job", ""),
      body: SingleChildScrollView(
          child: Form(
        key: key,
        child: Column(
          children: [
            // SizedBox(height: ConstantSize.s30,),
            Container(
              height: MediaQuery.of(context).size.height / 4,
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.topCenter,
              decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.rectangle,
                  image: DecorationImage(
                      image: AssetImage("assets/images/jobg.png"))),
            ),
            SizedBox(
              height: ConstantSize.s20,
            ),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: commonWidget.buildTextField(_title, "Job Title"),
            ),
            SizedBox(
              height: ConstantSize.s20,
            ),

            Padding(
              padding: const EdgeInsets.all(18.0),
              child: commonWidget.buildTextField(desc, "Job Description"),
            ),
            SizedBox(
              height: ConstantSize.s20,
            ),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: InkWell(
                onTap: () {
                  if (key.currentState!.validate()) {
                    setState(() {
                      _loading = true;
                    });
                    JobModel jobModel =
                        new JobModel("", _title.text, desc.text, widget.uid);
                    dbMethod.addNewJob(jobModel, widget.uid).then((value) {
                      // send notification to all users

                      // if (Constants.jobIsExist) {
                      //   Fluttertoast.showToast(
                      //       msg: "Sorry this job title already exist",
                      //       backgroundColor: Constants.mainColor,
                      //       gravity: ToastGravity.CENTER);
                      // } else {
                      Fluttertoast.showToast(
                          msg: "Job is added successfully",
                          backgroundColor: Constants.mainColor,
                          gravity: ToastGravity.CENTER);
                      HelperFunctions.getUID().then((value) {
                        
                      
                      dbMethod.getAllUsersTokens().then((val) {
                        sendNotification( "new job: "+_title.text, desc.text);
                        setState(() {
                          _loading = false;
                          _title.text = "";
                          desc.text = "";
                        });
                      });});
                      Navigator.of(context).pop();
                       });
                    // } else {
                    // print error
                  }
                },
                child: Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.0),
                      gradient: LinearGradient(colors: [
                        Constants.mainColor,
                        Constants.secondColor
                      ])),
                  child: Text(
                    "Submit",
                    style: simpleTextStyle(),
                  ),
                ),
              ),
            )
          ],
        ),
      )),
    );
  }
}

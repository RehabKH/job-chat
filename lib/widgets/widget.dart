import 'dart:io';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:medical_chat_group/helper/authenticate.dart';
import 'package:medical_chat_group/helper/constants.dart';
import 'package:medical_chat_group/helper/helperFunctions.dart';
import 'package:medical_chat_group/main.dart';
import 'package:medical_chat_group/model/dropDownModel.dart';
import 'package:medical_chat_group/model/jobModel.dart';
import 'package:medical_chat_group/services/auth.dart';
import 'package:medical_chat_group/services/socialMediaAuth.dart';
import 'package:medical_chat_group/views/NotificationDetailsPage.dart';
import 'package:medical_chat_group/views/settingPage.dart';
import 'package:medical_chat_group/views/signUp.dart';

// getLoggedIn() async {
//   await HelperFunctions.getUserLoggedIn().then((value) {

//   });
// }

AppBar appBarMain(BuildContext context, String pageTitle1, pageTitle2) {
  return AppBar(
    title: Image.asset(
      "assets/images/logo.png",
      height: 50,
    ),
    actions: [
      (pageTitle2 == "signIn" || pageTitle2 == "signUp")
          ? Container()
          : (pageTitle1 == "SettingPage")
              ? Container()
              : actionOfAppBar(context),

      // Padding(
      //     padding: const EdgeInsets.only(left: 15.0, right: 15.0),
      //     child: InkWell(
      //       onTap: () {
      //         Navigator.of(context).pushReplacement(MaterialPageRoute(
      //             builder: (context) => new SettingPage()));
      //       },
      //       child: Icon(
      //         Icons.settings,
      //         color: Colors.white,
      //       ),
      //     ),
      //   ),
    ],
  );
}

Widget actionOfAppBar(BuildContext context) {
  SocialMediaAuth auth = new SocialMediaAuth();
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: DropdownButton(
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
      items: Constants.dropDownMenuItem.map((DropDownModel items) {
        return DropdownMenuItem(
            value: items,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
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

        switch (val!.name) {
         
          case "All Jobs":
            {
              // JobModel jobModel =
              //     JobModel(widget.groupModel.groupName, "");
              // // enter page of alljobs that have the same title of this group
              // Navigator.of(context).push(MaterialPageRoute(
              //     builder: (c) => new AllJobs(jobModel)));
            }
            break;
          case "Notification":
            Navigator.of(context).push(MaterialPageRoute(
                builder: (c) => new NotificationDetailsPage()));
            break;
          case "Settings":
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (c) => new SettingPage()));
            break;
          case "Logout":
            auth.signOut().then((value) {
               Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (c) => new Authenticate()));
            });
           
            break;
          default:
        }
      },
    ),
  );
}

InputDecoration inputDecoration(String hint) {
  return InputDecoration(
    
      hintText: hint,
      hintStyle: TextStyle(color: Colors.white54),
      focusedBorder:
          UnderlineInputBorder(borderSide: BorderSide(color: Colors.white54)));
}

TextStyle simpleTextStyle() {
  return TextStyle(color: Colors.white, fontSize: 16);
}

String? validate(String? val) {
  return (val!.isEmpty) || (val.length < 6)
      ? "Please enter valid value length"
      : null;
}

_onEmojiSelected(Emoji emoji) {
  print('_onEmojiSelected: ${emoji.emoji}');
}

_onBackspacePressed() {
  print('_onBackspacePressed');
}

Widget emojiPicker() {
  TextEditingController textEditionController = new TextEditingController();
  bool emojiShowing = false;

  return Offstage(
    offstage: !emojiShowing,
    child: SizedBox(
      height: 250,
      child: EmojiPicker(
          textEditingController: textEditionController,
          onEmojiSelected: (Category category, Emoji emoji) {
            _onEmojiSelected(emoji);
          },
          onBackspacePressed: _onBackspacePressed,
          config: Config(
              columns: 7,
              // Issue: https://github.com/flutter/flutter/issues/28894
              emojiSizeMax: 32 * (Platform.isIOS ? 1.30 : 1.0),
              verticalSpacing: 0,
              horizontalSpacing: 0,
              gridPadding: EdgeInsets.zero,
              initCategory: Category.RECENT,
              bgColor: const Color(0xFFF2F2F2),
              indicatorColor: Colors.blue,
              iconColor: Colors.grey,
              iconColorSelected: Colors.blue,
              progressIndicatorColor: Colors.blue,
              backspaceColor: Colors.blue,
              skinToneDialogBgColor: Colors.white,
              skinToneIndicatorColor: Colors.grey,
              enableSkinTones: true,
              showRecentsTab: true,
              recentsLimit: 28,
              replaceEmojiOnLimitExceed: false,
              noRecents: const Text(
                'No Recents',
                style: TextStyle(fontSize: 20, color: Colors.black26),
                textAlign: TextAlign.center,
              ),
              tabIndicatorAnimDuration: kTabScrollDuration,
              categoryIcons: const CategoryIcons(),
              buttonMode: ButtonMode.MATERIAL)),
    ),
  );
}

// Widget muteOption() {
//   return Padding(
//     padding: const EdgeInsets.all(8.0),
//     child: DropdownButton(
//       // Initial Value
//       // value: dropdownvalue,

//       // Down Arrow Icon
//       icon: const Icon(
//         Icons.menu,
//         color: Colors.white,
//       ),
//       dropdownColor: Constants.groupColor,

//       underline: Container(),
//       // Array list of items
//       items: Constants.muteDropDown.map((DropDownModel items) {
//         return DropdownMenuItem(
//             value: items,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 Icon(
//                   items.icon,
//                   color: Colors.grey,
//                 ),
//                 Text(
//                   items.name,
//                   style: TextStyle(color: Colors.white),
//                 ),
//               ],
//             ));
//       }).toList(),
//       // After selecting the desired option,it will
//       // change button value to selected value
//       onChanged: (DropDownModel? val) {
//         // on chage selection => mute or unmute message , search , report , or leave channel
//       },
//     ),
//   );
// }

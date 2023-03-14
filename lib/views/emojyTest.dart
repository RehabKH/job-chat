import 'dart:io';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:medical_chat_group/widgets/widget.dart';

/// Example for EmojiPickerFlutter
class EmojyTest extends StatefulWidget {
  @override
  _EmojyTestState createState() => _EmojyTestState();
}

class _EmojyTestState extends State<EmojyTest> {
 

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Emoji Picker Example App'),
        ),
        body: Column(
          children: [
            Expanded(child: Container()),
            
          ],
        ),
      ),
    );
  }
}

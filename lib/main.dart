import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:medical_chat_group/helper/authenticate.dart';
import 'package:medical_chat_group/helper/constants.dart';
import 'package:medical_chat_group/helper/helperFunctions.dart';
import 'package:medical_chat_group/services/database.dart';
import 'package:medical_chat_group/services/notification.dart';
import 'package:medical_chat_group/services/socialMediaAuth.dart';
import 'package:medical_chat_group/views/allJobs.dart';
import 'package:medical_chat_group/widgets/widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'package:instabug_flutter/instabug_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Instabug.start(
      '5d67a7de4feca70a7a70b48e07da414f', [InvocationEvent.shake]);
  await Firebase.initializeApp();
  await FirebaseMessaging.instance.getInitialMessage();
  FirebaseMessaging.onBackgroundMessage(onBackGroundNotification);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLoggedIn = false;
  DataBaseMethods dbMethod = new DataBaseMethods();
  @override
  void initState() {
    requestPermisson();
    dbMethod.listenToFirestore();
    
    getToken();
    initInfo(context);
    getLoggedIn();
    super.initState();
  }

  getLoggedIn() async {
    await HelperFunctions.getUserLoggedIn().then((value) {
      setState(() {
        isLoggedIn = value;
      });
    });
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  @override
  Widget build(BuildContext context) {
    firebaseMessagingListener(context);
    return ChangeNotifierProvider(
      create: (context) => SocialMediaAuth(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'job Chat',
        theme: ThemeData(
          appBarTheme: AppBarTheme(color: Color.fromARGB(255, 165, 64, 157)),
          scaffoldBackgroundColor: Color.fromARGB(255, 0, 0, 0),
          visualDensity: VisualDensity.adaptivePlatformDensity,
          // primarySwatch: Color.fromARGB(255, 142, 179, 209),
        ),
        // home: isLoggedIn != null ? isLoggedIn?
        // ChatRoomsScreen() : Authenticate():BlankPage()
        home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              return 
              (snapshot.connectionState == ConnectionState.waiting)
                  ? Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.white,
                        color: Constants.mainColor,
                      ),
                    ):(snapshot.connectionState == ConnectionState.none)?
                    Authenticate()
                  : (snapshot.hasError)
                      ? Center(
                          child: Text(snapshot.error.toString()),
                        )
                      : (snapshot.hasData)
                          ? isLoggedIn?AllJobs()
                          : 
                              // ? AllJobs()
                          Authenticate():BlankPage();
            }),
      ),
    );
  }
}

class BlankPage extends StatelessWidget {
  const BlankPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Center(
            child: Text(
              "I am Blank Page",
              style: simpleTextStyle(),
            ),
          ),
        ),
      ),
    );
  }
}

// import 'dart:io';

// import 'package:admob_flutter/admob_flutter.dart';

// class AdsManager {
//   static bool _testMode = true;

//   static String get appID {
//     if (Platform.isAndroid) {
//       return "ca-app-pub-7998263779273497/1762218518";
//     } else if (Platform.isIOS) {
//       return "id for ios from website";
//     } else
//       throw new UnsupportedError("Unsupported platform");
//   }

//   static String get bannerAdID {
//     if (_testMode) return AdmobBanner.testAdUnitId;
//     else if (Platform.isAndroid) {
//       return "android id from website";
//     } else if (Platform.isIOS) {
//       return "id for ios from website";
//     } else
//       throw new UnsupportedError("Unsupported platform");
//   }

//    static String get nativeAdID {
//     if (_testMode)
//       return AdmobBanner.testAdUnitId;
//     else if (Platform.isAndroid) {
//       return "android id from website";
//     } else if (Platform.isIOS) {
//       return "id for ios from website";
//     } else
//       throw new UnsupportedError("Unsupported platform");
//   }

//    static String get interstitialAdID {
//     if (_testMode)
//       return AdmobBanner.testAdUnitId;
//     else if (Platform.isAndroid) {
//       return "android id from website";
//     } else if (Platform.isIOS) {
//       return "id for ios from website";
//     } else
//       throw new UnsupportedError("Unsupported platform");
//   }
// }

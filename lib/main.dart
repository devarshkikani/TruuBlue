// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dating/common/internet_error.dart';
import 'package:dating/common/no_internet.dart';
import 'package:dating/model/ConversationModel.dart';
import 'package:dating/model/HomeConversationModel.dart';
import 'package:dating/onboarding_screen.dart';
import 'package:dating/services/FirebaseHelper.dart';
import 'package:dating/services/helper.dart';
import 'package:dating/ui/chat/ChatScreen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_multi_formatter/formatters/phone_input_formatter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import 'constants.dart' as Constants;
import 'model/User.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void _enablePlatformOverrideForDesktop() {
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux)) {
    debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  }
}

final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

final StreamController<int> streamController = StreamController.broadcast();

// Rx<UserLocation>? userLocation;

void main() async {
  HttpOverrides.global = new MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  InAppPurchaseAndroidPlatformAddition.enablePendingPurchases();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp();
  HttpOverrides.global = new MyHttpOverrides();
  Provider.debugCheckInvalidValueType = null;
  _enablePlatformOverrideForDesktop();

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    EasyLocalization(
      supportedLocales: [Locale('en'), Locale('ar'), Locale('fr')],
      path: 'assets/translations',
      fallbackLocale: Locale('en'),
      useFallbackTranslations: true,
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> with WidgetsBindingObserver {
  static User? currentUser;
  late StreamSubscription tokenStream;

  Stream<ConnectivityResult> onConnectivityChangedStream =
      Connectivity().onConnectivityChanged;
  RxBool isInternet = true.obs;
  // bool _initialized = false;
  // bool _error = false;

  void initializeFlutterFire() async {
    FlutterAppBadger.removeBadge();
    try {
      if (await InternetError.hasNetwork()) {
        // setState(() {
        isInternet.value = true;
        // });
      } else {
        // setState(() {
        isInternet.value = false;
        // });
      }
      RemoteMessage? initialMessage =
          await FirebaseMessaging.instance.getInitialMessage();

      if (initialMessage != null) {
        initPlatformState();
        _handleNotification(initialMessage.data, navigatorKey);
      }
      FirebaseMessaging.onMessageOpenedApp
          .listen((RemoteMessage? remoteMessage) {
        if (remoteMessage != null) {
          _handleNotification(remoteMessage.data, navigatorKey);
        }
      });

      FirebaseMessaging.onBackgroundMessage(backgroundMessageHandler);

      tokenStream =
          FireStoreUtils.firebaseMessaging.onTokenRefresh.listen((event) {
        if (currentUser != null) {
          print('token $event');
          currentUser!.fcmToken = event;
          currentUser!.active = true;
          currentUser!.lastOnlineTimestamp =
              DateTime.now().toUtc().millisecondsSinceEpoch;
          // if (userLocation != null) {
          //   currentUser!.location = userLocation!.value;
          // }
          FireStoreUtils.updateCurrentUser(currentUser!);
        }
      });
      await checkPermissions();
      // setState(() {
      //   _initialized = true;
      // });
    } catch (e) {
      // setState(() {
      //   _error = true;
      // });
    }
  }

  initPlatformState() async {
    try {
      bool res = await FlutterAppBadger.isAppBadgeSupported();
      if (res) {
        print("supported");

        FlutterAppBadger.updateBadgeCount(1);
      } else {
        print("Not supported");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: Duration(seconds: 3),
            content: Text(
              'Not supported'.tr(),
              style: TextStyle(fontSize: 17),
            ),
          ),
        );
      }
    } on PlatformException {
      print("Failed to get badge support.");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(seconds: 3),
          content: Text(
            'Failed to get badge support.'.tr(),
            style: TextStyle(fontSize: 17),
          ),
        ),
      );
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    // if (_error) {
    //   return Container(
    //     color: Colors.white,
    //     child: Center(
    //         child: Column(
    //       children: [
    //         Icon(
    //           Icons.error_outline,
    //           color: Colors.red,
    //           size: 25,
    //         ),
    //         SizedBox(height: 16),
    //         Text(
    //           'Failed to initialise firebase!'.tr(),
    //           style: TextStyle(color: Colors.red, fontSize: 25),
    //         ),
    //       ],
    //     )),
    //   );
    // }
    // if (!_initialized) {
    //   return Container(
    //     color: Colors.white,
    //     child: Center(
    //       child: CircularProgressIndicator.adaptive(),
    //     ),
    //   );
    // }
    return GetMaterialApp(
      navigatorKey: navigatorKey,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: Locale('en'),
      title: 'TruuBlue'.tr(),
      theme: ThemeData(
        fontFamily: 'Calibri',
        bottomSheetTheme:
            BottomSheetThemeData(backgroundColor: Colors.white.withOpacity(.9)),
        accentColor: Color(Constants.COLOR_PRIMARY),
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        fontFamily: 'Calibri',
        bottomSheetTheme: BottomSheetThemeData(
            backgroundColor: Colors.black12.withOpacity(.3)),
        accentColor: Color(Constants.COLOR_PRIMARY),
        brightness: Brightness.dark,
      ),
      debugShowCheckedModeBanner: false,
      color: Color(Constants.COLOR_PRIMARY),
      home: Obx(
        () => isInternet.value
            ? OnBoarding()
            : NoInternet(
                tryAgain: () {
                  initializeFlutterFire();
                },
              ),
      ),
    );
  }

  Future<void> checkPermissions() async {
    //   Position? position = await getCurrentLocation();
    //   if (position != null) {
    //     userLocation?.value = UserLocation(
    //       latitude: position.latitude,
    //       longitude: position.longitude,
    //     );
    // setState(() {});
    // }

    Map<Permission, PermissionStatus> statuses = await [
      Permission.notification,
    ].request();
    // print(statuses);
  }

  @override
  void initState() {
    PhoneInputFormatter.addAlternativePhoneMasks(
      countryCode: 'US',
      alternativeMasks: [
        '+0 (000) 000-0000',
      ],
    );
    PhoneInputFormatter.addAlternativePhoneMasks(
      countryCode: 'IN',
      alternativeMasks: [
        '+00 00000 00000',
      ],
    );
    onConnectivityChangedStream.listen((event) {
      if (event.name == 'wifi' || event.name == 'mobile') {
        if (InternetError().isShow) {
          InternetError().hide();
        }
        // setState(() {
        isInternet.value = true;
        // });
      } else {
        if (InternetError().isShow) {
          InternetError().hide();
        }
        if (navigatorKey.currentContext != null) {
          InternetError().show(navigatorKey.currentState!.context, null);
        }
        // setState(() {
        isInternet.value = false;
        // });
      }
    });

    initializeFlutterFire();

    WidgetsBinding.instance?.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    tokenStream.cancel();
    onConnectivityChangedStream.drain();
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (auth.FirebaseAuth.instance.currentUser != null && currentUser != null) {
      if (state == AppLifecycleState.paused) {
        tokenStream.pause();
        currentUser!.active = false;
        currentUser!.lastOnlineTimestamp =
            DateTime.now().toUtc().millisecondsSinceEpoch;
        if (state == AppLifecycleState.resumed) {
          tokenStream.resume();
          currentUser!.active = true;
          currentUser!.lastOnlineTimestamp =
              DateTime.now().toUtc().millisecondsSinceEpoch;
          FireStoreUtils.updateCurrentUser(currentUser!);
        } else if (state == AppLifecycleState.detached) {
          tokenStream.resume();
          currentUser!.active = true;
          currentUser!.lastOnlineTimestamp =
              DateTime.now().toUtc().millisecondsSinceEpoch;
        }
        FireStoreUtils.updateCurrentUser(currentUser!);
      }
    }
  }
}

Future<void> _handleNotification(
  Map<String, dynamic> message,
  GlobalKey<NavigatorState> navigatorKey,
) async {
  try {
    if (message.containsKey('members') &&
        message.containsKey('isGroup') &&
        message.containsKey('conversationModel')) {
      User member = await FireStoreUtils().getUser(message['members']);

      bool isGroup = jsonDecode(message['isGroup']);
      ConversationModel conversationModel = ConversationModel.fromPayload(
          jsonDecode(message['conversationModel']));
      navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (_) => ChatScreen(
            homeConversationModel: HomeConversationModel(
              members: [member],
              isGroupChat: isGroup,
              conversationModel: conversationModel,
            ),
          ),
        ),
      );
    }
  } catch (e, s) {
    print('MyAppState._handleNotification $e $s');
  }
}

var badgeCount = 0;
Future<dynamic> backgroundMessageHandler(RemoteMessage remoteMessage) async {
  await Firebase.initializeApp();
  badgeCount = badgeCount + 1;
  FlutterAppBadger.updateBadgeCount(badgeCount);
  print('Handling a background22 message ${remoteMessage.notification?.title}');
  Map<dynamic, dynamic> message = remoteMessage.data;
  if (message.containsKey('data')) {
    print('backgroundMessageHandler ${message['data']}');
    final dynamic data = message['data'];
  }

  if (message.containsKey('notification')) {
    final dynamic notification = message['notification'];
    print('backgroundMessageHandler ${message['notification']}');
  }
}

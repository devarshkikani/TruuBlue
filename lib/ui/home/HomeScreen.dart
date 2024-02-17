import 'package:dating/main.dart';
import 'package:dating/model/User.dart';
import 'package:dating/services/FirebaseHelper.dart';
import 'package:dating/services/helper.dart';
import 'package:dating/ui/homeBottom/HomeBottomNavScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dating/main.dart' as main;

enum DrawerSelection { Conversations, Contacts, Search, Profile }

class HomeScreen extends StatefulWidget {
  final User user;
  final int index;
  HomeScreen({
    Key? key,
    required this.user,
    required this.index,
  }) : super(key: key);

  @override
  _HomeState createState() {
    return _HomeState();
  }
}

class _HomeState extends State<HomeScreen> {
  late User user;
  late int tabIndex;

  @override
  void initState() {
    super.initState();
    if (MyAppState.currentUser!.isVip) {
      checkSubscription();
    }
    user = widget.user;
    tabIndex = widget.index;
    _updateGenderPreference();
    FireStoreUtils.firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    main.streamController.stream.asBroadcastStream().listen((event) {
      setState(() {
        tabIndex = 2;
      });
    });
  }

  _updateGenderPreference() async {
    user.settings.genderPreference = "All";
    User? updateUser = await FireStoreUtils.updateCurrentUser(user);
    //hideProgress();
    if (updateUser != null) {
      this.user = updateUser;
      MyAppState.currentUser = user;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: user,
      child: Consumer<User>(
        builder: (context, user, _) {
          return HomeBottomNavScreen(
            user: user,
            index: tabIndex,
          );
        },
      ),
    );
  }

  void checkSubscription() async {
    await showProgress(context, 'Loading...', false);
    await FireStoreUtils.isSubscriptionActive();
    await hideProgress();
  }
}

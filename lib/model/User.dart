import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';

class User with ChangeNotifier {
  String email;
  String userCount;

  String firstName;

  String lastName;

  UserSettings settings;

  String phoneNumber;

  bool active;

  int lastOnlineTimestamp;

  DateTime? profileBoostAt;

  int isUserBoost;

  String userID;

  String profilePictureURL;

  String appIdentifier = 'Flutter Dating ${Platform.operatingSystem}';

  String fcmToken;

  bool isVip;

  //tinder related fields
  UserLocation location;

  UserLocation signUpLocation;

  bool showMe;

  String bio;

  String school;

  String age;
  List? prompt;

  List<dynamic> photos;
  List<dynamic> answeredQuestion;

  //internal use only, don't save to db
  String milesAway = '0 Miles Away';

  bool selected = false;

  String preferPronoun;

  String birthdate = "03/01/1994";
  String prefreance_age_start;
  String prefreance_age_end;
  Where_do_you_stand where_do_you_stand;
  String your_gender;
  String genderWantToDate;

  String your_Sexuality;
  String sexualityrWantToDate;

  String your_Ethnicity;
  String ethnicityWantToDate;

  String? you_Drink;
  String? drinkWantToDate;

  String? you_Smoke;
  String? smokeWantToDate;

  String? have_Children;
  String? childrenWantToDate;

  bool ultraLike;

  bool otherLike;
  YourDetails your_details;
  TheirSpecifics theirSpecifics;

  User(
      {this.email = '',
      this.userCount = '',
      this.userID = '',
      this.profilePictureURL = '',
      this.firstName = '',
      this.phoneNumber = '',
      this.lastName = '',
      this.active = false,
      lastOnlineTimestamp,
      this.isUserBoost = 0,
      this.profileBoostAt,
      settings,
      this.fcmToken = '',
      this.isVip = false,
      //tinder related fields
      this.showMe = true,
      UserLocation? location,
      UserLocation? signUpLocation,
      this.school = '',
      this.age = '',
      this.bio = '',
      this.prompt = const [],
      this.photos = const [],
      this.answeredQuestion = const [],
      this.preferPronoun = '',
      Where_do_you_stand? where_do_you_stand,
      this.birthdate = '',
      this.prefreance_age_start = '',
      this.prefreance_age_end = '',
      this.your_gender = '',
      this.genderWantToDate = '',
      this.your_Sexuality = '',
      this.sexualityrWantToDate = '',
      this.your_Ethnicity = '',
      this.ethnicityWantToDate = '',
      this.you_Drink,
      this.drinkWantToDate,
      this.you_Smoke,
      this.smokeWantToDate,
      this.have_Children,
      this.childrenWantToDate,
      this.ultraLike = false,
      this.otherLike = false,
      YourDetails? your_details,
      TheirSpecifics? theirSpecifics})
      : this.lastOnlineTimestamp = lastOnlineTimestamp != null
            ? lastOnlineTimestamp is Timestamp
                ? lastOnlineTimestamp.millisecondsSinceEpoch
                : lastOnlineTimestamp
            : DateTime.now().toUtc().millisecondsSinceEpoch,
        this.settings = settings ?? UserSettings(),
        this.location = location ?? UserLocation(),
        this.signUpLocation = signUpLocation ?? UserLocation(),
        this.where_do_you_stand = where_do_you_stand ?? Where_do_you_stand(),
        this.your_details = your_details ?? YourDetails(),
        this.theirSpecifics = theirSpecifics ?? TheirSpecifics();

  String fullName() {
    return '$firstName'; //$lastName
  }

  calculateAge() {
    final df = new DateFormat('MM/dd/yyyy');
    if (birthdate == "") {
      birthdate = "03/01/1994";
    }
    var birthDatess = df.parse(birthdate);
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthDatess.year;
    int month1 = currentDate.month;
    int month2 = birthDatess.month;
    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      int day1 = currentDate.day;
      int day2 = birthDatess.day;
      if (day2 > day1) {
        age--;
      }
    }
    return age;
  }

  profileAge() {
    final df = new DateFormat('MM/dd/yyyy');
    if (birthdate == "") {
      birthdate = "03/01/1994";
    }
    var birthDatess = df.parse(birthdate);

    final dff = new DateFormat('MMMM dd,yyyy');

    return dff.format(birthDatess);
  }

  factory User.fromJson(Map<String, dynamic> parsedJson) {
    return User(
        email: parsedJson['email'] ?? '',
        userCount: parsedJson['userCount'] ?? '',
        firstName: parsedJson['firstName'] ?? '',
        lastName: parsedJson['lastName'] ?? '',
        active: parsedJson['active'] ?? false,
        lastOnlineTimestamp: parsedJson['lastOnlineTimestamp'],
        isUserBoost: parsedJson['isUserBoost'] ?? 0,
        profileBoostAt: parsedJson['profileBoostAt'] != null
            ? (parsedJson['profileBoostAt'] as Timestamp).toDate()
            : null,
        settings: parsedJson.containsKey('settings')
            ? UserSettings.fromJson(parsedJson['settings'])
            : UserSettings(),
        phoneNumber: parsedJson['phoneNumber'] ?? '',
        userID: parsedJson['id'] ?? parsedJson['userID'] ?? '',
        profilePictureURL: parsedJson['profilePictureURL'] ?? '',
        fcmToken: parsedJson['fcmToken'] ?? '',
        isVip: parsedJson['isVip'] ?? false,
        //dating app related fields
        showMe: parsedJson['showMe'] ?? parsedJson['showMeOnTinder'] ?? true,
        location: parsedJson.containsKey('location')
            ? UserLocation.fromJson(parsedJson['location'])
            : UserLocation(),
        signUpLocation: parsedJson.containsKey('signUpLocation')
            ? UserLocation.fromJson(parsedJson['signUpLocation'])
            : UserLocation(),
        school: parsedJson['school'] ?? 'N/A',
        age: parsedJson['age'] ?? '',
        bio: parsedJson['bio'] ?? 'N/A',
        photos: parsedJson['photos'] ?? [].cast<String>(),
        prompt: parsedJson['prompt'] == null ? [] : parsedJson['prompt'],
        answeredQuestion: parsedJson['answeredQuestion'] ?? [],
        preferPronoun: parsedJson['preferPronoun'] ?? '',
        where_do_you_stand: parsedJson.containsKey('where_do_you_stand')
            ? Where_do_you_stand.fromJson(parsedJson['where_do_you_stand'])
            : Where_do_you_stand(),
        birthdate: parsedJson['birthdate'] ?? '',
        prefreance_age_start: parsedJson['prefreance_age_start'].toString(),
        prefreance_age_end: parsedJson['prefreance_age_end'].toString(),
        your_gender: parsedJson['your_gender'] ?? '',
        genderWantToDate: parsedJson['genderWantToDate'] ?? '',
        your_Sexuality: parsedJson['your_Sexuality'] ?? '',
        sexualityrWantToDate: parsedJson['sexualityrWantToDate'] ?? '',
        your_Ethnicity: parsedJson['your_Ethnicity'] ?? '',
        ethnicityWantToDate: parsedJson['ethnicityWantToDate'] ?? '',
        you_Drink: parsedJson['you_Drink'] ?? null,
        drinkWantToDate: parsedJson['drinkWantToDate'] ?? null,
        you_Smoke: parsedJson['you_Smoke'] ?? null,
        smokeWantToDate: parsedJson['smokeWantToDate'] ?? null,
        have_Children: parsedJson['have_Children'] ?? null,
        childrenWantToDate: parsedJson['childrenWantToDate'] ?? null,
        ultraLike: parsedJson['ultraLike'] ?? false,
        otherLike: parsedJson['otherLike'] ?? false,
        your_details: parsedJson.containsKey('your_details')
            ? YourDetails.fromJson(parsedJson['your_details'])
            : YourDetails(),
        theirSpecifics: parsedJson.containsKey('theirSpecifics')
            ? TheirSpecifics.fromJson(parsedJson['theirSpecifics'])
            : TheirSpecifics());
  }

  factory User.fromPayload(Map<String, dynamic> parsedJson) {
    return User(
      email: parsedJson['email'] ?? '',
      userCount: parsedJson['userCount'] ?? '',
      firstName: parsedJson['firstName'] ?? '',
      lastName: parsedJson['lastName'] ?? '',
      active: parsedJson['active'] ?? false,
      isUserBoost: parsedJson['isUserBoost'] ?? 0,
      profileBoostAt: parsedJson['profileBoostAt'] != null
          ? (parsedJson['profileBoostAt'] as Timestamp).toDate()
          : null,
      lastOnlineTimestamp: Timestamp.fromMillisecondsSinceEpoch(
          parsedJson['lastOnlineTimestamp']),
      settings: parsedJson.containsKey('settings')
          ? UserSettings.fromJson(parsedJson['settings'])
          : UserSettings(),
      phoneNumber: parsedJson['phoneNumber'] ?? '',
      userID: parsedJson['id'] ?? parsedJson['userID'] ?? '',
      profilePictureURL: parsedJson['profilePictureURL'] ?? '',
      fcmToken: parsedJson['fcmToken'] ?? '',
      location: parsedJson.containsKey('location')
          ? UserLocation.fromJson(parsedJson['location'])
          : UserLocation(),
      signUpLocation: parsedJson.containsKey('signUpLocation')
          ? UserLocation.fromJson(parsedJson['signUpLocation'])
          : UserLocation(),
      school: parsedJson['school'] ?? 'N/A',
      age: parsedJson['age'] ?? '',
      bio: parsedJson['bio'] ?? 'N/A',
      isVip: parsedJson['isVip'] ?? false,
      showMe: parsedJson['showMe'] ?? parsedJson['showMeOnTinder'] ?? true,
      photos: parsedJson['photos'] ?? [].cast<String>(),
      answeredQuestion: parsedJson['answeredQuestion'] ?? [],
      preferPronoun: parsedJson['preferPronoun'] ?? '',
      prompt: parsedJson['prompt'] ?? [],
      where_do_you_stand:
          parsedJson['where_do_you_stand'] ?? Where_do_you_stand(),
      birthdate: parsedJson['birthdate'] ?? '',
      prefreance_age_start: parsedJson['prefreance_age_start'] ?? '',
      prefreance_age_end: parsedJson['prefreance_age_end'] ?? '',
      your_gender: parsedJson['your_gender'] ?? '',
      genderWantToDate: parsedJson['genderWantToDate'] ?? '',
      your_Sexuality: parsedJson['your_Sexuality'] ?? '',
      sexualityrWantToDate: parsedJson['sexualityrWantToDate'] ?? '',
      your_Ethnicity: parsedJson['your_Ethnicity'] ?? '',
      ethnicityWantToDate: parsedJson['ethnicityWantToDate'] ?? '',
      you_Drink: parsedJson['you_Drink'] ?? '',
      drinkWantToDate: parsedJson['drinkWantToDate'] ?? '',
      you_Smoke: parsedJson['you_Smoke'] ?? '',
      smokeWantToDate: parsedJson['smokeWantToDate'] ?? '',
      have_Children: parsedJson['have_Children'] ?? '',
      childrenWantToDate: parsedJson['childrenWantToDate'] ?? '',
      ultraLike: parsedJson['ultraLike'] ?? false,
      otherLike: parsedJson['otherLike'] ?? false,
      your_details: parsedJson['your_details'] ?? YourDetails(),
      theirSpecifics: parsedJson['theirSpecifics'] ?? TheirSpecifics(),
    );
  }

  Map<String, dynamic> toJson(User? user) {
    photos.toList().removeWhere((element) => element == null);
    return {
      'email': user != null ? user.email : this.email,
      'userCount': user != null ? user.userCount : this.userCount,
      'firstName': user != null ? user.firstName : this.firstName,
      'lastName': user != null ? user.lastName : this.lastName,
      'settings':
          user != null ? user.settings.toJson() : this.settings.toJson(),
      'phoneNumber': user != null ? user.phoneNumber : this.phoneNumber,
      'id': user != null ? user.userID : this.userID,
      'active': user != null ? user.active : this.active,
      'isUserBoost': user != null ? user.isUserBoost : this.isUserBoost,
      'profileBoostAt':
          user != null ? user.profileBoostAt : this.profileBoostAt,
      'lastOnlineTimestamp':
          user != null ? user.lastOnlineTimestamp : this.lastOnlineTimestamp,
      'profilePictureURL':
          user != null ? user.profilePictureURL : this.profilePictureURL,
      'appIdentifier': user != null ? user.appIdentifier : this.appIdentifier,
      'fcmToken': user != null ? user.fcmToken : this.fcmToken,
      'isVip': user != null ? user.isVip : this.isVip,
      'prompt': user != null ? user.prompt : this.prompt,
      //tinder related fields
      'showMe': user != null ? user.settings.showMe : this.settings.showMe,
      'location':
          user != null ? user.location.toJson() : this.location.toJson(),
      'signUpLocation': user != null
          ? user.signUpLocation.toJson()
          : this.signUpLocation.toJson(),
      'bio': user != null ? user.bio : this.bio,
      'school': user != null ? user.school : this.school,
      'age': user != null ? user.age : this.age,
      'photos': user != null ? user.photos : this.photos,
      'answeredQuestion':
          user != null ? user.answeredQuestion : this.answeredQuestion,
      'preferPronoun': user != null ? user.preferPronoun : this.preferPronoun,
      'where_do_you_stand': user != null
          ? user.where_do_you_stand
          : this.where_do_you_stand.toJson(),
      "birthdate": user != null ? user.birthdate : this.birthdate,
      "prefreance_age_start":
          user != null ? user.prefreance_age_end : this.prefreance_age_start,
      "prefreance_age_end":
          user != null ? user.prefreance_age_end : this.prefreance_age_end,
      "your_gender": user != null ? user.your_gender : this.your_gender,
      "genderWantToDate":
          user != null ? user.genderWantToDate : this.genderWantToDate,
      "your_Sexuality":
          user != null ? user.your_Sexuality : this.your_Sexuality,
      "sexualityrWantToDate":
          user != null ? user.sexualityrWantToDate : this.sexualityrWantToDate,
      "your_Ethnicity":
          user != null ? user.your_Ethnicity : this.your_Ethnicity,
      "ethnicityWantToDate":
          user != null ? user.ethnicityWantToDate : this.ethnicityWantToDate,
      "you_Drink": user != null ? user.you_Drink : this.you_Drink,
      "drinkWantToDate":
          user != null ? user.drinkWantToDate : this.drinkWantToDate,
      "you_Smoke": user != null ? user.you_Smoke : this.you_Smoke,
      "smokeWantToDate":
          user != null ? user.smokeWantToDate : this.smokeWantToDate,
      "have_Children": user != null ? user.have_Children : this.have_Children,
      "childrenWantToDate":
          user != null ? user.childrenWantToDate : this.childrenWantToDate,
      'ultraLike': user != null ? user.ultraLike : this.ultraLike,
      'otherLike': user != null ? user.otherLike : this.otherLike,
      'your_details': user != null
          ? user.your_details.toJson()
          : this.your_details.toJson(),
      'theirSpecifics': user != null
          ? user.theirSpecifics.toJson()
          : this.theirSpecifics.toJson()
    };
  }

  Map<String, dynamic> toPayload() {
    photos.toList().removeWhere((element) => element == null);
    return {
      'email': this.email,
      'userCount': this.userCount,
      'firstName': this.firstName,
      'lastName': this.lastName,
      'settings': this.settings.toJson(),
      'phoneNumber': this.phoneNumber,
      'id': this.userID,
      'active': this.active,
      'lastOnlineTimestamp': this.lastOnlineTimestamp,
      'isUserBoost': this.isUserBoost,
      'profileBoostAt': this.profileBoostAt,
      'profilePictureURL': this.profilePictureURL,
      'appIdentifier': this.appIdentifier,
      'fcmToken': this.fcmToken,
      'location': this.location.toJson(),
      'signUpLocation': this.signUpLocation.toJson(),
      'showMe': this.settings.showMe,
      'bio': this.bio,
      'school': this.school,
      'age': this.age,
      'isVip': this.isVip,
      'photos': this.photos,
      'answeredQuestion': this.answeredQuestion,
      'preferPronoun': this.preferPronoun,
      'where_do_you_stand': this.where_do_you_stand.toJson(),
      "birthdate": this.birthdate,
      "prefreance_age_start": this.prefreance_age_start,
      "prefreance_age_end": this.prefreance_age_end,
      "your_gender": this.your_gender,
      "genderWantToDate": this.genderWantToDate,
      "your_Sexuality": this.your_Sexuality,
      "sexualityrWantToDate": this.sexualityrWantToDate,
      "your_Ethnicity": this.your_Ethnicity,
      "ethnicityWantToDate": this.ethnicityWantToDate,
      "you_Drink": this.you_Drink,
      "drinkWantToDate": this.drinkWantToDate,
      "you_Smoke": this.you_Smoke,
      "smokeWantToDate": this.smokeWantToDate,
      "have_Children": this.have_Children,
      "childrenWantToDate": this.childrenWantToDate,
      'ultraLike': this.ultraLike,
      'otherLike': this.otherLike,
      'your_details': this.your_details.toJson(),
      'theirSpecifics': this.theirSpecifics.toJson(),
      'prompt': this.prompt,
    };
  }

  static String encode(List<User> users) => json.encode(
        users.map<Map<String, dynamic>>((user) => User().toJson(user)).toList(),
      );

  static List<User> decode(String users) =>
      (json.decode(users) as List<dynamic>)
          .map<User>((item) => User.fromJson(item))
          .toList();
}

class UserSettings {
  bool pushNewMessages;

  bool pushNewMatchesEnabled;

  bool pushSuperLikesEnabled;

  bool pushTopPicksEnabled;

  bool pushFeaturesUpdatesEnabled;
  bool pushOffersNewsEnabled;

  String genderPreference; // should be either 'Male' or 'Female' // or 'All'

  String gender; // should be either 'Male' or 'Female'

  String distanceRadius;

  bool showMe;

  UserSettings({
    this.pushNewMessages = true,
    this.pushNewMatchesEnabled = true,
    this.pushSuperLikesEnabled = true,
    this.pushTopPicksEnabled = true,
    this.pushFeaturesUpdatesEnabled = true,
    this.pushOffersNewsEnabled = true,
    this.genderPreference = 'All',
    this.gender = 'Male',
    this.distanceRadius = '',
    this.showMe = true,
  });

  factory UserSettings.fromJson(Map<dynamic, dynamic> parsedJson) {
    return UserSettings(
      pushNewMessages: parsedJson['pushNewMessages'] ?? true,
      pushNewMatchesEnabled: parsedJson['pushNewMatchesEnabled'] ?? true,
      pushSuperLikesEnabled: parsedJson['pushSuperLikesEnabled'] ?? true,
      pushTopPicksEnabled: parsedJson['pushTopPicksEnabled'] ?? true,
      pushFeaturesUpdatesEnabled:
          parsedJson['pushFeaturesUpdatesEnabled'] ?? true,
      pushOffersNewsEnabled: parsedJson['pushOffersNewsEnabled'] ?? true,
      genderPreference: parsedJson['genderPreference'] ?? 'All',
      gender: parsedJson['gender'] ?? 'Male',
      distanceRadius: parsedJson['distanceRadius'] ?? '',
      showMe: parsedJson['showMe'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pushNewMessages': this.pushNewMessages,
      'pushNewMatchesEnabled': this.pushNewMatchesEnabled,
      'pushSuperLikesEnabled': this.pushSuperLikesEnabled,
      'pushTopPicksEnabled': this.pushTopPicksEnabled,
      'pushFeaturesUpdatesEnabled': this.pushFeaturesUpdatesEnabled,
      'pushOffersNewsEnabled': this.pushOffersNewsEnabled,
      'genderPreference': this.genderPreference,
      'gender': this.gender,
      'distanceRadius': this.distanceRadius,
      'showMe': this.showMe
    };
  }
}

class UserLocation {
  double latitude;

  double longitude;

  UserLocation({this.latitude = 00.1, this.longitude = 00.1});

  factory UserLocation.fromJson(Map<dynamic, dynamic>? parsedJson) {
    return UserLocation(
      latitude: parsedJson?['latitude'] ?? 00.1,
      longitude: parsedJson?['longitude'] ?? 00.1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': this.latitude,
      'longitude': this.longitude,
    };
  }
}

class Where_do_you_stand {
  String woman_Right_to_Choose;
  String better_Climate_Legislation;
  String expanded_LGBTQ_Rights;
  String stronger_Gun_Controls;
  String softer_Immigration_Laws;
  String more_Religious_Freedoms;

  String woman_Right_to_Choose_Deal_Breaker;
  String better_Climate_Legislation_Deal_Breaker;
  String expanded_LGBTQ_Rights_Deal_Breaker;
  String stronger_Gun_Controls_Deal_Breaker;
  String softer_Immigration_Laws_Deal_Breaker;
  String more_Religious_Freedoms_Deal_Breaker;

  Where_do_you_stand(
      {this.woman_Right_to_Choose = "0",
      this.better_Climate_Legislation = "0",
      this.expanded_LGBTQ_Rights = "0",
      this.stronger_Gun_Controls = "0",
      this.softer_Immigration_Laws = "0",
      this.more_Religious_Freedoms = "0",
      this.woman_Right_to_Choose_Deal_Breaker = "",
      this.better_Climate_Legislation_Deal_Breaker = "",
      this.expanded_LGBTQ_Rights_Deal_Breaker = "",
      this.stronger_Gun_Controls_Deal_Breaker = "",
      this.softer_Immigration_Laws_Deal_Breaker = "",
      this.more_Religious_Freedoms_Deal_Breaker = ""});

  factory Where_do_you_stand.fromJson(Map<dynamic, dynamic>? parsedJson) {
    return Where_do_you_stand(
      woman_Right_to_Choose: parsedJson?['woman_Right_to_Choose'] ?? "0",
      better_Climate_Legislation:
          parsedJson?['better_Climate_Legislation'] ?? "0",
      expanded_LGBTQ_Rights: parsedJson?['expanded_LGBTQ_Rights'] ?? "0",
      stronger_Gun_Controls: parsedJson?['stronger_Gun_Controls'] ?? "0",
      softer_Immigration_Laws: parsedJson?['softer_Immigration_Laws'] ?? "0",
      more_Religious_Freedoms: parsedJson?['more_Religious_Freedoms'] ?? "0",
      woman_Right_to_Choose_Deal_Breaker:
          parsedJson?['woman_Right_to_Choose_Deal_Breaker'] ?? "",
      better_Climate_Legislation_Deal_Breaker:
          parsedJson?['better_Climate_Legislation_Deal_Breaker'] ?? "",
      expanded_LGBTQ_Rights_Deal_Breaker:
          parsedJson?['expanded_LGBTQ_Rights_Deal_Breaker'] ?? "",
      stronger_Gun_Controls_Deal_Breaker:
          parsedJson?['stronger_Gun_Controls_Deal_Breaker'] ?? "",
      softer_Immigration_Laws_Deal_Breaker:
          parsedJson?['softer_Immigration_Laws_Deal_Breaker'] ?? "",
      more_Religious_Freedoms_Deal_Breaker:
          parsedJson?['more_Religious_Freedoms_Deal_Breaker'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'woman_Right_to_Choose': this.woman_Right_to_Choose,
      'better_Climate_Legislation': this.better_Climate_Legislation,
      'expanded_LGBTQ_Rights': this.expanded_LGBTQ_Rights,
      'stronger_Gun_Controls': this.stronger_Gun_Controls,
      'softer_Immigration_Laws': this.softer_Immigration_Laws,
      'more_Religious_Freedoms': this.more_Religious_Freedoms,
      'woman_Right_to_Choose_Deal_Breaker':
          this.woman_Right_to_Choose_Deal_Breaker,
      'better_Climate_Legislation_Deal_Breaker':
          this.better_Climate_Legislation_Deal_Breaker,
      'expanded_LGBTQ_Rights_Deal_Breaker':
          this.expanded_LGBTQ_Rights_Deal_Breaker,
      'stronger_Gun_Controls_Deal_Breaker':
          this.stronger_Gun_Controls_Deal_Breaker,
      'softer_Immigration_Laws_Deal_Breaker':
          this.softer_Immigration_Laws_Deal_Breaker,
      'more_Religious_Freedoms_Deal_Breaker':
          this.more_Religious_Freedoms_Deal_Breaker,
    };
  }
}

class YourDetails {
  String work;
  String title;
  String educational_level;
  String univerties;
  String height;
  String weight;

  String body_type;
  String astrologic_sign;
  String religiose_belief;
  String use_marijuana;
  String home_town;
  String current_home;

  YourDetails(
      {this.work = "",
      this.title = "",
      this.educational_level = "",
      this.univerties = "",
      this.height = "",
      this.weight = "",
      this.body_type = "",
      this.astrologic_sign = "",
      this.religiose_belief = "",
      this.use_marijuana = "",
      this.home_town = "",
      this.current_home = ""});

  factory YourDetails.fromJson(Map<dynamic, dynamic>? parsedJson) {
    return YourDetails(
      work: parsedJson?['work'] ?? "",
      title: parsedJson?['title'] ?? "",
      educational_level: parsedJson?['educational_level'] ?? "",
      univerties: parsedJson?['univerties'] ?? "",
      height: parsedJson?['height'] ?? "",
      weight: parsedJson?['weight'] ?? "",
      body_type: parsedJson?['body_type'] ?? "",
      astrologic_sign: parsedJson?['astrologic_sign'] ?? "",
      religiose_belief: parsedJson?['religiose_belief'] ?? "",
      use_marijuana: parsedJson?['use_marijuana'] ?? "",
      home_town: parsedJson?['home_town'] ?? "",
      current_home: parsedJson?['current_home'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'work': this.work,
      'title': this.title,
      'educational_level': this.educational_level,
      'univerties': this.univerties,
      'height': this.height,
      'weight': this.weight,
      'body_type': this.body_type,
      'astrologic_sign': this.astrologic_sign,
      'religiose_belief': this.religiose_belief,
      'use_marijuana': this.use_marijuana,
      'home_town': this.home_town,
      'current_home': this.current_home,
    };
  }
}

class TheirSpecifics {
  String educational;
  String weight;
  String body_type;
  String astrologic_sign;
  String religiose_belief;
  String use_marijuana;

  TheirSpecifics(
      {this.educational = "",
      this.weight = "",
      this.body_type = "",
      this.astrologic_sign = "",
      this.religiose_belief = "",
      this.use_marijuana = ""});

  factory TheirSpecifics.fromJson(Map<dynamic, dynamic>? parsedJson) {
    return TheirSpecifics(
      educational: parsedJson?['educational'] ?? "",
      weight: parsedJson?['weight'] ?? "",
      body_type: parsedJson?['body_type'] ?? "",
      astrologic_sign: parsedJson?['astrologic_sign'] ?? "",
      religiose_belief: parsedJson?['religiose_belief'] ?? "",
      use_marijuana: parsedJson?['use_marijuana'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'educational': this.educational,
      'weight': this.weight,
      'body_type': this.body_type,
      'astrologic_sign': this.astrologic_sign,
      'religiose_belief': this.religiose_belief,
      'use_marijuana': this.use_marijuana,
    };
  }
}

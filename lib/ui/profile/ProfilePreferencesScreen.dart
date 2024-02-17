import 'package:dating/constants.dart';
import 'package:dating/main.dart';
import 'package:dating/model/User.dart';
import 'package:dating/services/FirebaseHelper.dart';
import 'package:dating/services/helper.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class ProfilePreferencesScreen extends StatefulWidget {
  final User user;
  const ProfilePreferencesScreen({Key? key, required this.user})
      : super(key: key);

  @override
  _ProfilePreferencesScreenState createState() =>
      _ProfilePreferencesScreenState();
}

class _ProfilePreferencesScreenState extends State<ProfilePreferencesScreen> {
  final bioController = TextEditingController();
  late User user;
  final ScrollController _controller = ScrollController();

  late String radius;

  bool checkBoxFour = true;
  bool checkBoxFive = false;
  bool checkBoxSix = false;

  bool checkBoxFourdrink = false;
  bool checkBoxFivedrink = false;
  bool checkBoxSixdrink = false;
  bool checkBoxSixOnedrink = false;

  bool checkBoxFourSmoke = false;
  bool checkBoxFiveSmoke = false;
  bool checkBoxSixSmoke = false;
  bool checkBoxSixOneSmoke = false;

  bool checkBoxFourChild = false;
  bool checkBoxFiveChild = false;
  bool checkBoxSixChild = false;
  bool checkBoxSixOneChild = false;

  final Map<String, bool> _SexualityMAp = {
    'Straight'.tr(): false,
    'Gay'.tr(): false,
    'Lesbian'.tr(): false,
    'Bisexual'.tr(): false,
    'Demisexual'.tr(): false,
    'Pansexual'.tr(): false,
    'Queer'.tr(): false,
    'Questioning'.tr(): false,
    'No Preference'.tr(): false,
  };

  final Map<String, bool> _EthnicityMAp = {
    'American Indian'.tr(): false,
    'Black/African Decent'.tr(): false,
    'East Asian'.tr(): false,
    'Hispanic Latino'.tr(): false,
    'Middle Eastern'.tr(): false,
    'Pacifica Islander'.tr(): false,
    'South Asian'.tr(): false,
    'White/Caucasian'.tr(): false,
    'Other'.tr(): false,
    'No Preference'.tr(): false,
    'Everyone'.tr(): false,
  };

  @override
  void initState() {
    super.initState();
    user = widget.user;
    radius = user.settings.distanceRadius;
    if (user.prefreance_age_start == "") {
      user.prefreance_age_start = "25";
    }
    if (user.prefreance_age_end == "") {
      user.prefreance_age_end = "40";
    }
    _OneSliderValue = SfRangeValues(
        int.parse(user.prefreance_age_start.split('.').first),
        int.parse(user.prefreance_age_end.split('.').first));
    var gender = user.genderWantToDate.split(",");
    if (gender[0] != null) {
      checkBoxFour = true;
    } else {
      checkBoxFour = false;
    }

    if (gender.length > 1) {
      if (gender[1] != null) {
        checkBoxFive = true;
      }
    } else {
      checkBoxFive = false;
    }
    if (gender.length > 2) {
      if (gender[2] != null) {
        checkBoxSix = true;
      }
    } else {
      checkBoxSix = false;
    }
    var sexuality = user.sexualityrWantToDate.split(",");
    sexuality.forEach((element) {
      _SexualityMAp.forEach((key, value) {
        if (element == key) {
          setState(() {
            _SexualityMAp[key] = true;
          });
        }
      });
    });

    var ethinicity = user.ethnicityWantToDate.split(",");
    ethinicity.forEach((element) {
      _EthnicityMAp.forEach((key, value) {
        if (element == key) {
          setState(() {
            _EthnicityMAp[key] = true;
          });
        }
      });
    });

    if (user.drinkWantToDate == "No") {
      checkBoxFourdrink = true;
    } else if (user.drinkWantToDate == "Yes,Socially") {
      checkBoxFivedrink = true;
    } else if (user.drinkWantToDate == "Yes,Regularly") {
      checkBoxSixdrink = true;
    } else if (user.drinkWantToDate == "No Preference") {
      checkBoxSixOnedrink = true;
    }

    if (user.smokeWantToDate == "No") {
      checkBoxFourSmoke = true;
    } else if (user.smokeWantToDate == "Yes,Socially") {
      checkBoxFiveSmoke = true;
    } else if (user.smokeWantToDate == "Yes,Regularly") {
      checkBoxSixSmoke = true;
    } else if (user.smokeWantToDate == "No Preference") {
      checkBoxSixOneSmoke = true;
    }

    if (user.childrenWantToDate == "Yes") {
      checkBoxFourChild = true;
    } else if (user.childrenWantToDate == "No") {
      checkBoxFiveChild = true;
    } else if (user.childrenWantToDate == "No Preference") {
      checkBoxSixChild = true;
    } else if (user.childrenWantToDate == "No Preference") {
      checkBoxSixOneChild = true;
    }
  }

  void _onDistanceRadiusClick() {
    final action = CupertinoActionSheet(
      message: Text(
        'Distance Radius'.tr(),
        style: TextStyle(fontSize: 15.0),
      ),
      actions: <Widget>[
        CupertinoActionSheetAction(
          child: Text('5 Miles'.tr()),
          isDefaultAction: false,
          onPressed: () {
            Navigator.pop(context);
            radius = '5';
            setState(() {
              _updateMails();
            });
          },
        ),
        CupertinoActionSheetAction(
          child: Text('10 Miles'.tr()),
          isDestructiveAction: false,
          onPressed: () {
            Navigator.pop(context);
            radius = '10';
            setState(() {
              _updateMails();
            });
          },
        ),
        CupertinoActionSheetAction(
          child: Text('15 Miles'.tr()),
          isDestructiveAction: false,
          onPressed: () {
            Navigator.pop(context);
            radius = '15';
            setState(() {
              _updateMails();
            });
          },
        ),
        CupertinoActionSheetAction(
          child: Text('20 Miles'.tr()),
          isDestructiveAction: false,
          onPressed: () {
            Navigator.pop(context);
            radius = '20';
            setState(() {
              _updateMails();
            });
          },
        ),
        CupertinoActionSheetAction(
          child: Text('25 Miles'.tr()),
          isDestructiveAction: false,
          onPressed: () {
            Navigator.pop(context);
            radius = '25';
            setState(() {
              _updateMails();
            });
          },
        ),
        CupertinoActionSheetAction(
          child: Text('50 Miles'.tr()),
          isDestructiveAction: false,
          onPressed: () {
            Navigator.pop(context);
            radius = '50';
            setState(() {
              _updateMails();
            });
          },
        ),
        CupertinoActionSheetAction(
          child: Text('100 Miles'.tr()),
          isDestructiveAction: false,
          onPressed: () {
            Navigator.pop(context);
            radius = '100';
            setState(() {
              _updateMails();
            });
          },
        ),
        CupertinoActionSheetAction(
          child: Text('Unlimited'.tr()),
          isDestructiveAction: false,
          onPressed: () {
            Navigator.pop(context);
            radius = '';
            setState(() {
              _updateMails();
            });
          },
        ),
      ],
      cancelButton: CupertinoActionSheetAction(
        child: Text('Cancel'.tr()),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
    showCupertinoModalPopup(context: context, builder: (context) => action);
  }

  _updateMails() async {
    showProgress(context, 'Saving changes...'.tr(), true);
    user.settings.distanceRadius = radius;
    User? updateUser = await FireStoreUtils.updateCurrentUser(user);
    hideProgress();
    if (updateUser != null) {
      this.user = updateUser;
      MyAppState.currentUser = user;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(seconds: 3),
          content: Text(
            'Settings saved successfully'.tr(),
            style: TextStyle(fontSize: 17),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: ListView(
        controller: _controller,
        children: [
          SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Distance'.tr(),
                textScaleFactor: 1.0,
                style: TextStyle(
                    color: Color(0xFF7b7b7b),
                    fontWeight: FontWeight.bold,
                    fontSize: 22),
                textAlign: TextAlign.start,
              ),
              GestureDetector(
                onTap: _onDistanceRadiusClick,
                child: Row(
                  children: [
                    Text(
                      radius.isNotEmpty
                          ? '$radius Miles'.tr()
                          : 'Unlimited'.tr(),
                      textScaleFactor: 1.0,
                      style: TextStyle(color: Color(0xFF949494), fontSize: 14),
                      textAlign: TextAlign.start,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 15,
                      color: Color(0xFF949494),
                    ),
                  ],
                ),
              )
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            'Your Preferences'.tr(),
            textScaleFactor: 1.0,
            style: TextStyle(
              color: Color(0xFF7b7b7b),
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
            textAlign: TextAlign.start,
          ),
          _Preferences(),
          SizedBox(
            height: 30,
          ),
          Text(
            'Their Specifics (requires subscription)'.tr(),
            textScaleFactor: 1.0,
            style: TextStyle(
              color: Color(0xFF7b7b7b),
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
            textAlign: TextAlign.start,
          ),
          _Specifics(),
          SizedBox(
            height: 30,
          ),
          InkWell(
            onTap: () {
              _controller.animateTo(
                _controller.position.minScrollExtent,
                duration: Duration(seconds: 2),
                curve: Curves.fastOutSlowIn,
              );
            },
            child: Text(
              'Back to Top'.tr(),
              textScaleFactor: 1.0,
              style: TextStyle(
                color: Color(COLOR_BLUE_BUTTON),
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
                fontSize: 22,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }

  var editAgeRangeFlag = false;
  var editGenderFlag = false;
  var editSexuiltyFlag = false;
  var editEthinicityFlag = false;
  var editDrinksAlcoholFlag = false;
  var editSmokesTobaccolFlag = false;
  var editHaveChildrenFlag = false;
  late SfRangeValues _OneSliderValue;
  _Preferences() {
    return Column(
      children: [
        SizedBox(
          height: 5,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Age Range'.tr(),
                    textScaleFactor: 1.0,
                    style: TextStyle(color: Color(0xFF949494), fontSize: 14),
                    textAlign: TextAlign.start,
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        if (editAgeRangeFlag) {
                          editAgeRangeFlag = false;
                        } else {
                          editAgeRangeFlag = true;
                        }
                      });
                    },
                    child: Row(
                      children: [
                        Text(
                          'Edit',
                          textScaleFactor: 1.0,
                          style:
                              TextStyle(color: Color(0xFF949494), fontSize: 12),
                          textAlign: TextAlign.start,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 15,
                          color: Color(0xFF949494),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              editAgeRangeFlag
                  ? Column(
                      children: [
                        Align(
                          alignment: Alignment.topRight,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 20.0),
                            child: InkWell(
                              onTap: () async {
                                showProgress(
                                    context, 'Saving changes...'.tr(), false);
                                user.prefreance_age_start =
                                    _OneSliderValue.start!.toStringAsFixed(0);
                                user.prefreance_age_end =
                                    _OneSliderValue.end!.toStringAsFixed(0);
                                User? updateUser =
                                    await FireStoreUtils.updateCurrentUser(
                                        user);
                                hideProgress();
                                if (updateUser != null) {
                                  this.user = updateUser;
                                  MyAppState.currentUser = user;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      duration: Duration(seconds: 3),
                                      content: Text(
                                        'Settings saved successfully'.tr(),
                                        style: TextStyle(fontSize: 17),
                                      ),
                                    ),
                                  );
                                  setState(() {
                                    editAgeRangeFlag = false;
                                  });
                                }
                              },
                              child: Text(
                                'Save',
                                textScaleFactor: 1.0,
                                style: TextStyle(
                                    color: Color(0xFF949494),
                                    decoration: TextDecoration.underline,
                                    fontSize: 14),
                                textAlign: TextAlign.start,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 20, top: 10, right: 20, bottom: 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "18".tr(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.black, fontSize: 10.0),
                              ),
                              Text(
                                "99".tr(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.black, fontSize: 10.0),
                              ),
                            ],
                          ),
                        ),
                        SfRangeSlider(
                          min: 18.0,
                          max: 99.0,
                          values: _OneSliderValue,
                          interval: 20,
                          showTicks: false,
                          showLabels: false,
                          activeColor: Color(0xFF68cf00),
                          inactiveColor: Colors.grey,
                          enableTooltip: true,
                          tooltipTextFormatterCallback:
                              (dynamic actualValue, String formattedText) {
                            return actualValue.toStringAsFixed(0);
                          },
                          minorTicksPerInterval: 1,
                          startThumbIcon: Stack(children: [
                            Container(
                              decoration: new BoxDecoration(
                                color: Color(COLOR_BLUE_BUTTON),
                                shape: BoxShape.circle,
                              ),
                            ),
                            Center(
                                child: Text(
                                    _OneSliderValue.start!.toStringAsFixed(0),
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 10)))
                          ]),
                          endThumbIcon: Center(
                            child: Stack(
                              children: [
                                Container(
                                  decoration: new BoxDecoration(
                                    color: Color(COLOR_BLUE_BUTTON),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                Center(
                                    child: Text(
                                  _OneSliderValue.end!.toStringAsFixed(0),
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 10),
                                ))
                              ],
                            ),
                          ),
                          onChanged: (SfRangeValues values) {
                            setState(() {
                              _OneSliderValue = values;
                            });
                          },
                        ),
                      ],
                    )
                  : InkWell(
                      onTap: () {
                        setState(() {
                          if (editAgeRangeFlag) {
                            editAgeRangeFlag = false;
                          } else {
                            editAgeRangeFlag = true;
                          }
                        });
                      },
                      child: Text(
                        user.prefreance_age_start.split('.').first +
                            " - " +
                            user.prefreance_age_end.split('.').first,
                        textScaleFactor: 1.0,
                        style:
                            TextStyle(color: Color(0xFF949494), fontSize: 12),
                        textAlign: TextAlign.start,
                      ),
                    ),
            ],
          ),
        ),
        Divider(
          color: Color(0xFF7e7e7e),
          height: 0.3,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Gender'.tr(),
                    textScaleFactor: 1.0,
                    style: TextStyle(color: Color(0xFF949494), fontSize: 14),
                    textAlign: TextAlign.start,
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        if (editGenderFlag) {
                          editGenderFlag = false;
                        } else {
                          editGenderFlag = true;
                        }
                      });
                    },
                    child: Row(
                      children: [
                        Text(
                          'Edit',
                          textScaleFactor: 1.0,
                          style:
                              TextStyle(color: Color(0xFF949494), fontSize: 12),
                          textAlign: TextAlign.start,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 15,
                          color: Color(0xFF949494),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              editGenderFlag
                  ? _prefer_gender()
                  : InkWell(
                      onTap: () {
                        setState(() {
                          if (editGenderFlag) {
                            editGenderFlag = false;
                          } else {
                            editGenderFlag = true;
                          }
                        });
                      },
                      child: Text(
                        user.genderWantToDate,
                        textScaleFactor: 1.0,
                        style:
                            TextStyle(color: Color(0xFF949494), fontSize: 12),
                        textAlign: TextAlign.start,
                      ),
                    ),
            ],
          ),
        ),
        Divider(
          color: Color(0xFF7e7e7e),
          height: 0.3,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sexuality'.tr(),
                    textScaleFactor: 1.0,
                    style: TextStyle(color: Color(0xFF949494), fontSize: 14),
                    textAlign: TextAlign.start,
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        if (editSexuiltyFlag) {
                          editSexuiltyFlag = false;
                        } else {
                          editSexuiltyFlag = true;
                        }
                      });
                    },
                    child: Row(
                      children: [
                        Text(
                          'Edit',
                          textScaleFactor: 1.0,
                          style:
                              TextStyle(color: Color(0xFF949494), fontSize: 12),
                          textAlign: TextAlign.start,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 15,
                          color: Color(0xFF949494),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              editSexuiltyFlag
                  ? Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 20.0),
                          child: Align(
                            alignment: Alignment.topRight,
                            child: InkWell(
                              onTap: () async {
                                showProgress(
                                    context, 'Saving changes...'.tr(), false);
                                String whowant = "";
                                _SexualityMAp.forEach((key, value) {
                                  if (value) {
                                    if (whowant == "") {
                                      whowant = key;
                                    } else {
                                      whowant = whowant + "," + key;
                                    }
                                  }
                                });
                                user.sexualityrWantToDate = whowant;
                                User? updateUser =
                                    await FireStoreUtils.updateCurrentUser(
                                        user);
                                hideProgress();
                                if (updateUser != null) {
                                  this.user = updateUser;
                                  MyAppState.currentUser = user;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      duration: Duration(seconds: 3),
                                      content: Text(
                                        'Settings saved successfully'.tr(),
                                        style: TextStyle(fontSize: 17),
                                      ),
                                    ),
                                  );
                                  setState(() {
                                    editGenderFlag = false;
                                  });
                                }
                              },
                              child: Text(
                                'Save',
                                textScaleFactor: 1.0,
                                style: TextStyle(
                                    color: Color(0xFF949494),
                                    decoration: TextDecoration.underline,
                                    fontSize: 14),
                                textAlign: TextAlign.start,
                              ),
                            ),
                          ),
                        ),
                        Container(
                            child: GridView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: _SexualityMAp.length,
                          itemBuilder: (BuildContext context, int index) {
                            return _WhoYItem(
                                _SexualityMAp.entries.elementAt(index).key,
                                index);
                          },
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  childAspectRatio: 5, crossAxisCount: 2),
                        )),
                      ],
                    )
                  : InkWell(
                      onTap: () {
                        setState(() {
                          if (editSexuiltyFlag) {
                            editSexuiltyFlag = false;
                          } else {
                            editSexuiltyFlag = true;
                          }
                        });
                      },
                      child: Text(
                        user.sexualityrWantToDate,
                        textScaleFactor: 1.0,
                        style:
                            TextStyle(color: Color(0xFF949494), fontSize: 12),
                        textAlign: TextAlign.start,
                      ),
                    ),
            ],
          ),
        ),
        Divider(
          color: Color(0xFF7e7e7e),
          height: 0.3,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ethnicity'.tr(),
                    textScaleFactor: 1.0,
                    style: TextStyle(color: Color(0xFF949494), fontSize: 14),
                    textAlign: TextAlign.start,
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        if (editEthinicityFlag) {
                          editEthinicityFlag = false;
                        } else {
                          editEthinicityFlag = true;
                        }
                      });
                    },
                    child: Row(
                      children: [
                        Text(
                          'Edit',
                          textScaleFactor: 1.0,
                          style:
                              TextStyle(color: Color(0xFF949494), fontSize: 12),
                          textAlign: TextAlign.start,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 15,
                          color: Color(0xFF949494),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              editEthinicityFlag
                  ? Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 20.0),
                          child: Align(
                            alignment: Alignment.topRight,
                            child: InkWell(
                              onTap: () async {
                                showProgress(
                                    context, 'Saving changes...'.tr(), false);
                                String whowant = "";
                                _EthnicityMAp.forEach((key, value) {
                                  if (value) {
                                    if (whowant == "") {
                                      whowant = key;
                                    } else {
                                      whowant = whowant + "," + key;
                                    }
                                  }
                                });
                                user.ethnicityWantToDate = whowant;
                                User? updateUser =
                                    await FireStoreUtils.updateCurrentUser(
                                        user);
                                hideProgress();
                                if (updateUser != null) {
                                  this.user = updateUser;
                                  MyAppState.currentUser = user;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      duration: Duration(seconds: 3),
                                      content: Text(
                                        'Settings saved successfully'.tr(),
                                        style: TextStyle(fontSize: 17),
                                      ),
                                    ),
                                  );
                                  setState(() {
                                    editEthinicityFlag = false;
                                  });
                                }
                              },
                              child: Text(
                                'Save',
                                textScaleFactor: 1.0,
                                style: TextStyle(
                                    color: Color(0xFF949494),
                                    decoration: TextDecoration.underline,
                                    fontSize: 14),
                                textAlign: TextAlign.start,
                              ),
                            ),
                          ),
                        ),
                        Container(
                            child: GridView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: _EthnicityMAp.length,
                          itemBuilder: (BuildContext context, int index) {
                            return _WhoEthnicityItem(
                                _EthnicityMAp.entries.elementAt(index).key,
                                index);
                          },
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  childAspectRatio: 5, crossAxisCount: 2),
                        )),
                      ],
                    )
                  : InkWell(
                      onTap: () {
                        setState(() {
                          if (editEthinicityFlag) {
                            editEthinicityFlag = false;
                          } else {
                            editEthinicityFlag = true;
                          }
                        });
                      },
                      child: Text(
                        user.ethnicityWantToDate,
                        textScaleFactor: 1.0,
                        style:
                            TextStyle(color: Color(0xFF949494), fontSize: 12),
                        textAlign: TextAlign.start,
                      ),
                    ),
            ],
          ),
        ),
        Divider(
          color: Color(0xFF7e7e7e),
          height: 0.3,
        ),
        if (user.drinkWantToDate != null)
          Padding(
            padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Drinks Alcohol'.tr(),
                      textScaleFactor: 1.0,
                      style: TextStyle(color: Color(0xFF949494), fontSize: 14),
                      textAlign: TextAlign.start,
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          if (editDrinksAlcoholFlag) {
                            editDrinksAlcoholFlag = false;
                          } else {
                            editDrinksAlcoholFlag = true;
                          }
                        });
                      },
                      child: Row(
                        children: [
                          Text(
                            'Edit',
                            textScaleFactor: 1.0,
                            style: TextStyle(
                                color: Color(0xFF949494), fontSize: 12),
                            textAlign: TextAlign.start,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 15,
                            color: Color(0xFF949494),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                editDrinksAlcoholFlag
                    ? _drinkAlchohol()
                    : user.drinkWantToDate != null
                        ? InkWell(
                            onTap: () {
                              setState(() {
                                if (editDrinksAlcoholFlag) {
                                  editDrinksAlcoholFlag = false;
                                } else {
                                  editDrinksAlcoholFlag = true;
                                }
                              });
                            },
                            child: Text(
                              user.drinkWantToDate!,
                              textScaleFactor: 1.0,
                              style: TextStyle(
                                  color: Color(0xFF949494), fontSize: 12),
                              textAlign: TextAlign.start,
                            ),
                          )
                        : SizedBox(),
              ],
            ),
          ),
        if (user.drinkWantToDate != null)
          Divider(
            color: Color(0xFF7e7e7e),
            height: 0.3,
          ),
        if (user.smokeWantToDate != null)
          Padding(
            padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Smokes Tobacco'.tr(),
                      textScaleFactor: 1.0,
                      style: TextStyle(color: Color(0xFF949494), fontSize: 14),
                      textAlign: TextAlign.start,
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          if (editSmokesTobaccolFlag) {
                            editSmokesTobaccolFlag = false;
                          } else {
                            editSmokesTobaccolFlag = true;
                          }
                        });
                      },
                      child: Row(
                        children: [
                          Text(
                            'Edit',
                            textScaleFactor: 1.0,
                            style: TextStyle(
                                color: Color(0xFF949494), fontSize: 12),
                            textAlign: TextAlign.start,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 15,
                            color: Color(0xFF949494),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                editSmokesTobaccolFlag
                    ? _Smoke()
                    : InkWell(
                        onTap: () {
                          setState(() {
                            if (editSmokesTobaccolFlag) {
                              editSmokesTobaccolFlag = false;
                            } else {
                              editSmokesTobaccolFlag = true;
                            }
                          });
                        },
                        child: Text(
                          user.smokeWantToDate!,
                          textScaleFactor: 1.0,
                          style:
                              TextStyle(color: Color(0xFF949494), fontSize: 12),
                          textAlign: TextAlign.start,
                        ),
                      ),
              ],
            ),
          ),
        if (user.smokeWantToDate != null)
          Divider(
            color: Color(0xFF7e7e7e),
            height: 0.3,
          ),
        if (user.childrenWantToDate != null)
          Padding(
            padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Have Children'.tr(),
                      textScaleFactor: 1.0,
                      style: TextStyle(
                          color: Color(0xFF949494),
                          fontWeight: FontWeight.normal,
                          fontSize: 14),
                      textAlign: TextAlign.start,
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          if (editHaveChildrenFlag) {
                            editHaveChildrenFlag = false;
                          } else {
                            editHaveChildrenFlag = true;
                          }
                        });
                      },
                      child: Row(
                        children: [
                          Text(
                            'Edit',
                            textScaleFactor: 1.0,
                            style: TextStyle(
                                color: Color(0xFF949494), fontSize: 12),
                            textAlign: TextAlign.start,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 15,
                            color: Color(0xFF949494),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                editHaveChildrenFlag
                    ? _haveChildren()
                    : InkWell(
                        onTap: () {
                          setState(() {
                            if (editHaveChildrenFlag) {
                              editHaveChildrenFlag = false;
                            } else {
                              editHaveChildrenFlag = true;
                            }
                          });
                        },
                        child: Text(
                          user.childrenWantToDate!,
                          textScaleFactor: 1.0,
                          style:
                              TextStyle(color: Color(0xFF949494), fontSize: 12),
                          textAlign: TextAlign.start,
                        ),
                      ),
              ],
            ),
          ),
        if (user.childrenWantToDate != null)
          Divider(
            color: Color(0xFF7e7e7e),
            height: 0.3,
          ),
      ],
    );
  }

  var editeducationFlag = false;
  var editWeightFlag = false;
  var editBodyTypeFlag = false;
  var editAstrologicalFlag = false;
  var editReligiousFlag = false;
  var editMarijuanaFlag = false;
  _Specifics() {
    return Column(
      children: [
        SizedBox(
          height: 5,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Education'.tr(),
                    textScaleFactor: 1.0,
                    style: TextStyle(color: Color(0xFF949494), fontSize: 14),
                    textAlign: TextAlign.start,
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        if (editeducationFlag) {
                          editeducationFlag = false;
                        } else {
                          editeducationFlag = true;
                        }
                      });
                    },
                    child: Row(
                      children: [
                        Text(
                          'Join',
                          textScaleFactor: 1.0,
                          style:
                              TextStyle(color: Color(0xFF949494), fontSize: 12),
                          textAlign: TextAlign.start,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 15,
                          color: Color(0xFF949494),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              editeducationFlag
                  ? _education()
                  : InkWell(
                      onTap: () {
                        setState(() {
                          if (editeducationFlag) {
                            editeducationFlag = false;
                          } else {
                            editeducationFlag = true;
                          }
                        });
                      },
                      child: Text(
                        user.theirSpecifics.educational,
                        textScaleFactor: 1.0,
                        style:
                            TextStyle(color: Color(0xFF949494), fontSize: 12),
                        textAlign: TextAlign.start,
                      ),
                    ),
            ],
          ),
        ),
        Divider(
          color: Color(0xFF7e7e7e),
          height: 0.3,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Weight'.tr(),
                    textScaleFactor: 1.0,
                    style: TextStyle(color: Color(0xFF949494), fontSize: 14),
                    textAlign: TextAlign.start,
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        if (editWeightFlag) {
                          editWeightFlag = false;
                        } else {
                          editWeightFlag = true;
                        }
                      });
                    },
                    child: Row(
                      children: [
                        Text(
                          'Edit',
                          textScaleFactor: 1.0,
                          style:
                              TextStyle(color: Color(0xFF949494), fontSize: 12),
                          textAlign: TextAlign.start,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 15,
                          color: Color(0xFF949494),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              editWeightFlag
                  ? _weight()
                  : InkWell(
                      onTap: () {
                        setState(() {
                          if (editWeightFlag) {
                            editWeightFlag = false;
                          } else {
                            editWeightFlag = true;
                          }
                        });
                      },
                      child: Text(
                        user.theirSpecifics.weight == ''
                            ? ''
                            : '${user.theirSpecifics.weight} lbs',
                        textScaleFactor: 1.0,
                        style:
                            TextStyle(color: Color(0xFF949494), fontSize: 12),
                        textAlign: TextAlign.start,
                      ),
                    ),
            ],
          ),
        ),
        Divider(
          color: Color(0xFF7e7e7e),
          height: 0.3,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Body Type'.tr(),
                    textScaleFactor: 1.0,
                    style: TextStyle(color: Color(0xFF949494), fontSize: 14),
                    textAlign: TextAlign.start,
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        if (editBodyTypeFlag) {
                          editBodyTypeFlag = false;
                        } else {
                          editBodyTypeFlag = true;
                        }
                      });
                    },
                    child: Row(
                      children: [
                        Text(
                          'Edit',
                          textScaleFactor: 1.0,
                          style:
                              TextStyle(color: Color(0xFF949494), fontSize: 12),
                          textAlign: TextAlign.start,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 15,
                          color: Color(0xFF949494),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              editBodyTypeFlag
                  ? _bodyType()
                  : InkWell(
                      onTap: () {
                        setState(() {
                          if (editBodyTypeFlag) {
                            editBodyTypeFlag = false;
                          } else {
                            editBodyTypeFlag = true;
                          }
                        });
                      },
                      child: Text(
                        user.theirSpecifics.astrologic_sign,
                        textScaleFactor: 1.0,
                        style:
                            TextStyle(color: Color(0xFF949494), fontSize: 12),
                        textAlign: TextAlign.start,
                      ),
                    ),
            ],
          ),
        ),
        Divider(
          color: Color(0xFF7e7e7e),
          height: 0.3,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Astrological Sign'.tr(),
                    textScaleFactor: 1.0,
                    style: TextStyle(color: Color(0xFF949494), fontSize: 14),
                    textAlign: TextAlign.start,
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        if (editAstrologicalFlag) {
                          editAstrologicalFlag = false;
                        } else {
                          editAstrologicalFlag = true;
                        }
                      });
                    },
                    child: Row(
                      children: [
                        Text(
                          'Edit',
                          textScaleFactor: 1.0,
                          style:
                              TextStyle(color: Color(0xFF949494), fontSize: 12),
                          textAlign: TextAlign.start,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 15,
                          color: Color(0xFF949494),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              editAstrologicalFlag
                  ? _astrolgical()
                  : InkWell(
                      onTap: () {
                        setState(() {
                          if (editAstrologicalFlag) {
                            editAstrologicalFlag = false;
                          } else {
                            editAstrologicalFlag = true;
                          }
                        });
                      },
                      child: Text(
                        user.theirSpecifics.astrologic_sign,
                        textScaleFactor: 1.0,
                        style:
                            TextStyle(color: Color(0xFF949494), fontSize: 12),
                        textAlign: TextAlign.start,
                      ),
                    ),
            ],
          ),
        ),
        Divider(
          color: Color(0xFF7e7e7e),
          height: 0.3,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Religious Beliefs'.tr(),
                    textScaleFactor: 1.0,
                    style: TextStyle(color: Color(0xFF949494), fontSize: 14),
                    textAlign: TextAlign.start,
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        if (editReligiousFlag) {
                          editReligiousFlag = false;
                        } else {
                          editReligiousFlag = true;
                        }
                      });
                    },
                    child: Row(
                      children: [
                        Text(
                          'Edit',
                          textScaleFactor: 1.0,
                          style:
                              TextStyle(color: Color(0xFF949494), fontSize: 12),
                          textAlign: TextAlign.start,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 15,
                          color: Color(0xFF949494),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              editReligiousFlag
                  ? _religious()
                  : InkWell(
                      onTap: () {
                        setState(() {
                          if (editReligiousFlag) {
                            editReligiousFlag = false;
                          } else {
                            editReligiousFlag = true;
                          }
                        });
                      },
                      child: Text(
                        user.theirSpecifics.religiose_belief,
                        textScaleFactor: 1.0,
                        style:
                            TextStyle(color: Color(0xFF949494), fontSize: 12),
                        textAlign: TextAlign.start,
                      ),
                    ),
            ],
          ),
        ),
        Divider(
          color: Color(0xFF7e7e7e),
          height: 0.3,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Use Marijuana'.tr(),
                    textScaleFactor: 1.0,
                    style: TextStyle(color: Color(0xFF949494), fontSize: 14),
                    textAlign: TextAlign.start,
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        if (editMarijuanaFlag) {
                          editMarijuanaFlag = false;
                        } else {
                          editMarijuanaFlag = true;
                        }
                      });
                    },
                    child: Row(
                      children: [
                        Text(
                          'Edit',
                          textScaleFactor: 1.0,
                          style:
                              TextStyle(color: Color(0xFF949494), fontSize: 12),
                          textAlign: TextAlign.start,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 15,
                          color: Color(0xFF949494),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              editMarijuanaFlag
                  ? _Marijuana()
                  : InkWell(
                      onTap: () {
                        setState(() {
                          if (editMarijuanaFlag) {
                            editMarijuanaFlag = false;
                          } else {
                            editMarijuanaFlag = true;
                          }
                        });
                      },
                      child: Text(
                        user.theirSpecifics.use_marijuana,
                        textScaleFactor: 1.0,
                        style:
                            TextStyle(color: Color(0xFF949494), fontSize: 12),
                        textAlign: TextAlign.start,
                      ),
                    ),
            ],
          ),
        ),
        Divider(
          color: Color(0xFF7e7e7e),
          height: 0.3,
        ),
      ],
    );
  }

  _prefer_gender() {
    return Column(
      children: [
        SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.only(right: 20.0),
          child: Align(
            alignment: Alignment.topRight,
            child: InkWell(
              onTap: () async {
                showProgress(context, 'Saving changes...'.tr(), false);
                var wantto = "";
                if (checkBoxFour) {
                  if (wantto == "") {
                    wantto = "Female";
                  } else {
                    wantto = wantto + ",Female";
                  }
                }
                if (checkBoxFive) {
                  if (wantto == "") {
                    wantto = "Male";
                  } else {
                    wantto = wantto + ",Male";
                  }
                }
                if (checkBoxSix) {
                  if (wantto == "") {
                    wantto = "Non-Binary";
                  } else {
                    wantto = wantto + ",Non-Binary";
                  }
                }

                if (wantto == "") {
                  SnackBar(
                    duration: Duration(seconds: 3),
                    content: Text(
                      'Please enter all fields.',
                      style: TextStyle(fontSize: 17),
                    ),
                  );
                } else {
                  user.genderWantToDate = wantto;
                }

                User? updateUser = await FireStoreUtils.updateCurrentUser(user);
                hideProgress();
                if (updateUser != null) {
                  this.user = updateUser;
                  MyAppState.currentUser = user;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      duration: Duration(seconds: 3),
                      content: Text(
                        'Settings saved successfully'.tr(),
                        style: TextStyle(fontSize: 17),
                      ),
                    ),
                  );
                  setState(() {
                    editGenderFlag = false;
                  });
                }
              },
              child: Text(
                'Save',
                textScaleFactor: 1.0,
                style: TextStyle(
                    color: Color(0xFF949494),
                    decoration: TextDecoration.underline,
                    fontSize: 14),
                textAlign: TextAlign.start,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
              child: Transform.scale(
                scale: 1.3,
                child: Checkbox(
                    value: checkBoxFour,
                    activeColor: Color(0xFF66BB6A),
                    onChanged: (bool? newValue) {
                      setState(() {
                        checkBoxFour = newValue!;
                        //checkBoxFive=false;
                        //checkBoxSix=false;
                      });
                    }),
              ),
            ),
            Text(
              'Female',
              textScaleFactor: 1.0,
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
              child: Transform.scale(
                scale: 1.3,
                child: Checkbox(
                    value: checkBoxFive,
                    activeColor: Color(0xFF66BB6A),
                    onChanged: (bool? newValue) {
                      setState(() {
                        checkBoxFive = newValue!;
                        //checkBoxFour=false;
                        // checkBoxSix=false;
                      });
                    }),
              ),
            ),
            Text(
              'Male',
              textScaleFactor: 1.0,
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
              child: Transform.scale(
                scale: 1.3,
                child: Checkbox(
                    value: checkBoxSix,
                    activeColor: Color(0xFF66BB6A),
                    onChanged: (bool? newValue) {
                      setState(() {
                        checkBoxSix = newValue!;
                        //checkBoxFour=false;
                        //checkBoxFive=false;
                      });
                    }),
              ),
            ),
            Text(
              'Non-Binary',
              textScaleFactor: 1.0,
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
      ],
    );
  }

  _WhoYItem(String _list, int index) {
    return Container(
      color: Colors.white,
      child: Padding(
          padding: const EdgeInsets.only(left: 0, top: 0, right: 0, bottom: 0),
          child: Column(
            children: [
              InkWell(
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 0, top: 5, right: 0, bottom: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 20,
                        child: Transform.scale(
                          scale: 1.3,
                          child: Checkbox(
                              value:
                                  _SexualityMAp.entries.elementAt(index).value,
                              activeColor: Color(0xFF66BB6A),
                              onChanged: (bool? newValue) {
                                setState(() {
                                  _SexualityMAp[_list] = newValue!;
                                });
                              }),
                        ),
                      ),
                      /*Visibility(
                        visible:SelectedIndex==index,child: Icon(Icons.check,color: Colors.blue,)),*/
                      Padding(
                        padding: const EdgeInsets.only(top: 0, bottom: 0),
                        child: Text(
                          _list.tr(),
                          textScaleFactor: 1.0,
                          style: TextStyle(fontSize: 12, color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  setState(() {
                    /* SelectedIndex=index;
                Cache().setPreferPronoun(_list);
                selection=_list;*/
                  });
                },
              ),
              //Divider(color: Colors.grey,height: 1,)
            ],
          )),
    );
  }

  _WhoEthnicityItem(String _list, int index) {
    return Container(
      color: Colors.white,
      child: Padding(
          padding: const EdgeInsets.only(left: 0, top: 0, right: 0, bottom: 0),
          child: Column(
            children: [
              InkWell(
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 0, top: 5, right: 0, bottom: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 20,
                        child: Transform.scale(
                          scale: 1.3,
                          child: Checkbox(
                              value:
                                  _EthnicityMAp.entries.elementAt(index).value,
                              activeColor: Color(0xFF66BB6A),
                              onChanged: (bool? newValue) {
                                setState(() {
                                  _EthnicityMAp[_list] = newValue!;
                                });
                              }),
                        ),
                      ),
                      /*Visibility(
                        visible:SelectedIndex==index,child: Icon(Icons.check,color: Colors.blue,)),*/
                      Padding(
                        padding: const EdgeInsets.only(top: 0, bottom: 0),
                        child: Text(
                          _list.tr(),
                          textScaleFactor: 1.0,
                          style: TextStyle(fontSize: 12, color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  setState(() {
                    /* SelectedIndex=index;
                Cache().setPreferPronoun(_list);
                selection=_list;*/
                  });
                },
              ),
              //Divider(color: Colors.grey,height: 1,)
            ],
          )),
    );
  }

  _drinkAlchohol() {
    return Column(
      children: [
        SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.only(right: 20.0),
          child: Align(
            alignment: Alignment.topRight,
            child: InkWell(
              onTap: () async {
                showProgress(context, 'Saving changes...'.tr(), false);
                var wantto = "No";
                if (checkBoxFourdrink) {
                  wantto = "No";
                } else if (checkBoxFivedrink) {
                  wantto = "Yes,Socially";
                } else if (checkBoxSixdrink) {
                  wantto = "Yes,Regularly";
                } else if (checkBoxSixOnedrink) {
                  wantto = "No Preference";
                }
                user.drinkWantToDate = wantto;
                User? updateUser = await FireStoreUtils.updateCurrentUser(user);
                hideProgress();
                if (updateUser != null) {
                  this.user = updateUser;
                  MyAppState.currentUser = user;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      duration: Duration(seconds: 3),
                      content: Text(
                        'Settings saved successfully'.tr(),
                        style: TextStyle(fontSize: 17),
                      ),
                    ),
                  );
                  setState(() {
                    editDrinksAlcoholFlag = false;
                  });
                }
              },
              child: Text(
                'Save',
                textScaleFactor: 1.0,
                style: TextStyle(
                    color: Color(0xFF949494),
                    decoration: TextDecoration.underline,
                    fontSize: 14),
                textAlign: TextAlign.start,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
              child: Transform.scale(
                scale: 1.3,
                child: Checkbox(
                    value: checkBoxFourdrink,
                    activeColor: Color(0xFF66BB6A),
                    onChanged: (bool? newValue) {
                      setState(() {
                        checkBoxFourdrink = newValue!;
                        checkBoxFivedrink = false;
                        checkBoxSixdrink = false;
                        checkBoxSixOnedrink = false;
                      });
                    }),
              ),
            ),
            Text(
              'No',
              textScaleFactor: 1.0,
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
              child: Transform.scale(
                scale: 1.3,
                child: Checkbox(
                    value: checkBoxFivedrink,
                    activeColor: Color(0xFF66BB6A),
                    onChanged: (bool? newValue) {
                      setState(() {
                        checkBoxFivedrink = newValue!;
                        checkBoxFourdrink = false;
                        checkBoxSixdrink = false;
                        checkBoxSixOnedrink = false;
                      });
                    }),
              ),
            ),
            Text(
              'Yes, socially',
              textScaleFactor: 1.0,
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
              child: Transform.scale(
                scale: 1.3,
                child: Checkbox(
                    value: checkBoxSixdrink,
                    activeColor: Color(0xFF66BB6A),
                    onChanged: (bool? newValue) {
                      setState(() {
                        checkBoxSixdrink = newValue!;
                        checkBoxFourdrink = false;
                        checkBoxFivedrink = false;
                        checkBoxSixOnedrink = false;
                      });
                    }),
              ),
            ),
            Text(
              'Yes, regularly',
              textScaleFactor: 1.0,
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
              child: Transform.scale(
                scale: 1.3,
                child: Checkbox(
                    value: checkBoxSixOnedrink,
                    activeColor: Color(0xFF66BB6A),
                    onChanged: (bool? newValue) {
                      setState(() {
                        checkBoxSixOnedrink = newValue!;
                        checkBoxFourdrink = false;
                        checkBoxFivedrink = false;
                        checkBoxSixdrink = false;
                      });
                    }),
              ),
            ),
            Text(
              'No Preference',
              textScaleFactor: 1.0,
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
      ],
    );
  }

  _Smoke() {
    return Column(
      children: [
        SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.only(right: 20.0),
          child: Align(
            alignment: Alignment.topRight,
            child: InkWell(
              onTap: () async {
                showProgress(context, 'Saving changes...'.tr(), false);
                var wantto = "No";
                if (checkBoxFourSmoke) {
                  wantto = "No";
                } else if (checkBoxFiveSmoke) {
                  wantto = "Yes,Socially";
                } else if (checkBoxSixSmoke) {
                  wantto = "Yes,Regularly";
                } else if (checkBoxSixOneSmoke) {
                  wantto = "No Preference";
                }
                user.smokeWantToDate = wantto;
                User? updateUser = await FireStoreUtils.updateCurrentUser(user);
                hideProgress();
                if (updateUser != null) {
                  this.user = updateUser;
                  MyAppState.currentUser = user;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      duration: Duration(seconds: 3),
                      content: Text(
                        'Settings saved successfully'.tr(),
                        style: TextStyle(fontSize: 17),
                      ),
                    ),
                  );
                  setState(() {
                    editSmokesTobaccolFlag = false;
                  });
                }
              },
              child: Text(
                'Save',
                textScaleFactor: 1.0,
                style: TextStyle(
                    color: Color(0xFF949494),
                    decoration: TextDecoration.underline,
                    fontSize: 14),
                textAlign: TextAlign.start,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
              child: Transform.scale(
                scale: 1.3,
                child: Checkbox(
                    value: checkBoxFourSmoke,
                    activeColor: Color(0xFF66BB6A),
                    onChanged: (bool? newValue) {
                      setState(() {
                        checkBoxFourSmoke = newValue!;
                        checkBoxFiveSmoke = false;
                        checkBoxSixSmoke = false;
                        checkBoxSixOneSmoke = false;
                      });
                    }),
              ),
            ),
            Text(
              'No',
              textScaleFactor: 1.0,
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
              child: Transform.scale(
                scale: 1.3,
                child: Checkbox(
                    value: checkBoxFiveSmoke,
                    activeColor: Color(0xFF66BB6A),
                    onChanged: (bool? newValue) {
                      setState(() {
                        checkBoxFiveSmoke = newValue!;
                        checkBoxFourSmoke = false;
                        checkBoxSixSmoke = false;
                        checkBoxSixOneSmoke = false;
                      });
                    }),
              ),
            ),
            Text(
              'Yes, socially',
              textScaleFactor: 1.0,
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
              child: Transform.scale(
                scale: 1.3,
                child: Checkbox(
                    value: checkBoxSixSmoke,
                    activeColor: Color(0xFF66BB6A),
                    onChanged: (bool? newValue) {
                      setState(() {
                        checkBoxSixSmoke = newValue!;
                        checkBoxFourSmoke = false;
                        checkBoxFiveSmoke = false;
                        checkBoxSixOneSmoke = false;
                      });
                    }),
              ),
            ),
            Text(
              'Yes, regularly',
              textScaleFactor: 1.0,
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
              child: Transform.scale(
                scale: 1.3,
                child: Checkbox(
                    value: checkBoxSixOneSmoke,
                    activeColor: Color(0xFF66BB6A),
                    onChanged: (bool? newValue) {
                      setState(() {
                        checkBoxSixOneSmoke = newValue!;
                        checkBoxFourSmoke = false;
                        checkBoxFiveSmoke = false;
                        checkBoxSixSmoke = false;
                      });
                    }),
              ),
            ),
            Text(
              'No Preference',
              textScaleFactor: 1.0,
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
      ],
    );
  }

  _haveChildren() {
    return Column(
      children: [
        SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.only(right: 20.0),
          child: Align(
            alignment: Alignment.topRight,
            child: InkWell(
              onTap: () async {
                showProgress(context, 'Saving changes...'.tr(), false);
                var wantto = "Yes";
                if (checkBoxFour) {
                  wantto = "Yes";
                } else if (checkBoxFive) {
                  wantto = "No";
                } else if (checkBoxSix) {
                  wantto = "No Preference";
                }
                user.childrenWantToDate = wantto;
                User? updateUser = await FireStoreUtils.updateCurrentUser(user);
                hideProgress();
                if (updateUser != null) {
                  this.user = updateUser;
                  MyAppState.currentUser = user;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      duration: Duration(seconds: 3),
                      content: Text(
                        'Settings saved successfully'.tr(),
                        style: TextStyle(fontSize: 17),
                      ),
                    ),
                  );
                  setState(() {
                    editHaveChildrenFlag = false;
                  });
                }
              },
              child: Text(
                'Save',
                textScaleFactor: 1.0,
                style: TextStyle(
                    color: Color(0xFF949494),
                    decoration: TextDecoration.underline,
                    fontSize: 14),
                textAlign: TextAlign.start,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20,
                  child: Transform.scale(
                    scale: 1.3,
                    child: Checkbox(
                        value: checkBoxFourChild,
                        activeColor: Color(0xFF66BB6A),
                        onChanged: (bool? newValue) {
                          setState(() {
                            checkBoxFourChild = newValue!;
                            checkBoxFiveChild = false;
                            checkBoxSixChild = false;
                            checkBoxSixOneChild = false;
                          });
                        }),
                  ),
                ),
                Text(
                  'Yes',
                  textScaleFactor: 1.0,
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20,
                  child: Transform.scale(
                    scale: 1.3,
                    child: Checkbox(
                        value: checkBoxFiveChild,
                        activeColor: Color(0xFF66BB6A),
                        onChanged: (bool? newValue) {
                          setState(() {
                            checkBoxFiveChild = newValue!;
                            checkBoxFourChild = false;
                            checkBoxSixChild = false;
                            checkBoxSixOneChild = false;
                          });
                        }),
                  ),
                ),
                Text(
                  'No',
                  textScaleFactor: 1.0,
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20,
                  child: Transform.scale(
                    scale: 1.3,
                    child: Checkbox(
                        value: checkBoxSixChild,
                        activeColor: Color(0xFF66BB6A),
                        onChanged: (bool? newValue) {
                          setState(() {
                            checkBoxSixChild = newValue!;
                            checkBoxFourChild = false;
                            checkBoxFiveChild = false;
                            checkBoxSixOneChild = false;
                          });
                        }),
                  ),
                ),
                Text(
                  'No Preference',
                  textScaleFactor: 1.0,
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  final educationController = TextEditingController();
  _education() {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10.0, right: 10.0),
          child: Container(
            width: 250,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                shape: BoxShape.rectangle,
                border: Border.all(color: Colors.grey.shade200)),
            child: TextFormField(
              textAlignVertical: TextAlignVertical.center,
              textInputAction: TextInputAction.done,
              textCapitalization: TextCapitalization.words,
              style: TextStyle(fontSize: 18.0),
              controller: educationController,
              keyboardType: TextInputType.text,
              cursorColor: Colors.grey.shade500,
              textAlign: TextAlign.start,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 10, right: 10),
                hintText: ''.tr(),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide:
                        BorderSide(color: Colors.grey.shade500, width: 2.0)),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).errorColor),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).errorColor),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade200),
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
          ),
        ),
        InkWell(
          onTap: () async {
            showProgress(context, 'Saving changes...'.tr(), false);
            user.theirSpecifics.educational = educationController.text;
            User? updateUser = await FireStoreUtils.updateCurrentUser(user);
            hideProgress();
            if (updateUser != null) {
              this.user = updateUser;
              MyAppState.currentUser = user;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  duration: Duration(seconds: 3),
                  content: Text(
                    'Settings saved successfully'.tr(),
                    style: TextStyle(fontSize: 17),
                  ),
                ),
              );
              setState(() {
                editeducationFlag = false;
              });
            }
          },
          child: Text(
            'Save',
            textScaleFactor: 1.0,
            style: TextStyle(
                color: Color(0xFF949494),
                decoration: TextDecoration.underline,
                fontSize: 14),
            textAlign: TextAlign.start,
          ),
        ),
      ],
    );
  }

  final weightController = TextEditingController();
  _weight() {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10.0, right: 10.0),
          child: Container(
            width: 250,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                shape: BoxShape.rectangle,
                border: Border.all(color: Colors.grey.shade200)),
            child: TextFormField(
              textAlignVertical: TextAlignVertical.center,
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.number,
              textCapitalization: TextCapitalization.words,
              style: TextStyle(fontSize: 18.0),
              controller: weightController,
              cursorColor: Colors.grey.shade500,
              textAlign: TextAlign.start,
              maxLength: 3,
              decoration: InputDecoration(
                counterText: '',
                floatingLabelBehavior: FloatingLabelBehavior.always,
                contentPadding: EdgeInsets.all(10),
                hintText: '',
                isDense: true,
                suffixText: 'lbs',
                suffixStyle: TextStyle(color: Colors.grey),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide:
                        BorderSide(color: Colors.grey.shade500, width: 2.0)),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).errorColor),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).errorColor),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade200),
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
          ),
        ),
        InkWell(
          onTap: () async {
            showProgress(context, 'Saving changes...'.tr(), true);
            user.theirSpecifics.weight = weightController.text;
            User? updateUser = await FireStoreUtils.updateCurrentUser(user);
            hideProgress();
            if (updateUser != null) {
              this.user = updateUser;
              MyAppState.currentUser = user;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  duration: Duration(seconds: 3),
                  content: Text(
                    'Settings saved successfully'.tr(),
                    style: TextStyle(fontSize: 17),
                  ),
                ),
              );
              setState(() {
                editWeightFlag = false;
              });
            }
          },
          child: Text(
            'Save',
            textScaleFactor: 1.0,
            style: TextStyle(
                color: Color(0xFF949494),
                decoration: TextDecoration.underline,
                fontSize: 14),
            textAlign: TextAlign.start,
          ),
        ),
      ],
    );
  }

  final bodyTypeController = TextEditingController();
  _bodyType() {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10.0, right: 10.0),
          child: Container(
            width: 250,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                shape: BoxShape.rectangle,
                border: Border.all(color: Colors.grey.shade200)),
            child: TextFormField(
              textAlignVertical: TextAlignVertical.center,
              textInputAction: TextInputAction.done,
              textCapitalization: TextCapitalization.words,
              style: TextStyle(fontSize: 18.0),
              controller: bodyTypeController,
              keyboardType: TextInputType.text,
              cursorColor: Colors.grey.shade500,
              textAlign: TextAlign.start,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 10, right: 10),
                hintText: ''.tr(),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide:
                        BorderSide(color: Colors.grey.shade500, width: 2.0)),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).errorColor),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).errorColor),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade200),
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
          ),
        ),
        InkWell(
          onTap: () async {
            showProgress(context, 'Saving changes...'.tr(), false);
            user.theirSpecifics.body_type = bodyTypeController.text;
            User? updateUser = await FireStoreUtils.updateCurrentUser(user);
            hideProgress();
            if (updateUser != null) {
              this.user = updateUser;
              MyAppState.currentUser = user;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  duration: Duration(seconds: 3),
                  content: Text(
                    'Settings saved successfully'.tr(),
                    style: TextStyle(fontSize: 17),
                  ),
                ),
              );
              setState(() {
                editBodyTypeFlag = false;
              });
            }
          },
          child: Text(
            'Save',
            textScaleFactor: 1.0,
            style: TextStyle(
                color: Color(0xFF949494),
                decoration: TextDecoration.underline,
                fontSize: 14),
            textAlign: TextAlign.start,
          ),
        ),
      ],
    );
  }

  final astrolicaController = TextEditingController();
  _astrolgical() {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10.0, right: 10.0),
          child: Container(
            width: 250,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                shape: BoxShape.rectangle,
                border: Border.all(color: Colors.grey.shade200)),
            child: TextFormField(
              textAlignVertical: TextAlignVertical.center,
              textInputAction: TextInputAction.done,
              textCapitalization: TextCapitalization.words,
              style: TextStyle(fontSize: 18.0),
              controller: astrolicaController,
              keyboardType: TextInputType.text,
              cursorColor: Colors.grey.shade500,
              textAlign: TextAlign.start,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 10, right: 10),
                hintText: ''.tr(),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide:
                        BorderSide(color: Colors.grey.shade500, width: 2.0)),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).errorColor),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).errorColor),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade200),
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
          ),
        ),
        InkWell(
          onTap: () async {
            showProgress(context, 'Saving changes...'.tr(), false);
            user.theirSpecifics.astrologic_sign = astrolicaController.text;
            User? updateUser = await FireStoreUtils.updateCurrentUser(user);
            hideProgress();
            if (updateUser != null) {
              this.user = updateUser;
              MyAppState.currentUser = user;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  duration: Duration(seconds: 3),
                  content: Text(
                    'Settings saved successfully'.tr(),
                    style: TextStyle(fontSize: 17),
                  ),
                ),
              );
              setState(() {
                editAstrologicalFlag = false;
              });
            }
          },
          child: Text(
            'Save',
            textScaleFactor: 1.0,
            style: TextStyle(
                color: Color(0xFF949494),
                decoration: TextDecoration.underline,
                fontSize: 14),
            textAlign: TextAlign.start,
          ),
        ),
      ],
    );
  }

  final religiousController = TextEditingController();
  _religious() {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10.0, right: 10.0),
          child: Container(
            width: 250,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                shape: BoxShape.rectangle,
                border: Border.all(color: Colors.grey.shade200)),
            child: TextFormField(
              textAlignVertical: TextAlignVertical.center,
              textInputAction: TextInputAction.done,
              textCapitalization: TextCapitalization.words,
              style: TextStyle(fontSize: 18.0),
              controller: religiousController,
              keyboardType: TextInputType.text,
              cursorColor: Colors.grey.shade500,
              textAlign: TextAlign.start,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 10, right: 10),
                hintText: ''.tr(),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide:
                        BorderSide(color: Colors.grey.shade500, width: 2.0)),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).errorColor),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).errorColor),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade200),
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
          ),
        ),
        InkWell(
          onTap: () async {
            showProgress(context, 'Saving changes...'.tr(), false);
            user.theirSpecifics.religiose_belief = religiousController.text;
            User? updateUser = await FireStoreUtils.updateCurrentUser(user);
            hideProgress();
            if (updateUser != null) {
              this.user = updateUser;
              MyAppState.currentUser = user;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  duration: Duration(seconds: 3),
                  content: Text(
                    'Settings saved successfully'.tr(),
                    style: TextStyle(fontSize: 17),
                  ),
                ),
              );
              setState(() {
                editReligiousFlag = false;
              });
            }
          },
          child: Text(
            'Save',
            textScaleFactor: 1.0,
            style: TextStyle(
                color: Color(0xFF949494),
                decoration: TextDecoration.underline,
                fontSize: 14),
            textAlign: TextAlign.start,
          ),
        ),
      ],
    );
  }

  final marijuanaController = TextEditingController();
  _Marijuana() {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10.0, right: 10.0),
          child: Container(
            width: 250,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                shape: BoxShape.rectangle,
                border: Border.all(color: Colors.grey.shade200)),
            child: TextFormField(
              textAlignVertical: TextAlignVertical.center,
              textInputAction: TextInputAction.done,
              textCapitalization: TextCapitalization.words,
              style: TextStyle(fontSize: 18.0),
              controller: marijuanaController,
              keyboardType: TextInputType.text,
              cursorColor: Colors.grey.shade500,
              textAlign: TextAlign.start,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 10, right: 10),
                hintText: ''.tr(),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide:
                        BorderSide(color: Colors.grey.shade500, width: 2.0)),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).errorColor),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).errorColor),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade200),
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
          ),
        ),
        InkWell(
          onTap: () async {
            showProgress(context, 'Saving changes...'.tr(), false);
            user.theirSpecifics.use_marijuana = marijuanaController.text;
            User? updateUser = await FireStoreUtils.updateCurrentUser(user);
            hideProgress();
            if (updateUser != null) {
              this.user = updateUser;
              MyAppState.currentUser = user;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  duration: Duration(seconds: 3),
                  content: Text(
                    'Settings saved successfully'.tr(),
                    style: TextStyle(fontSize: 17),
                  ),
                ),
              );
              setState(() {
                editMarijuanaFlag = false;
              });
            }
          },
          child: Text(
            'Save',
            textScaleFactor: 1.0,
            style: TextStyle(
                color: Color(0xFF949494),
                decoration: TextDecoration.underline,
                fontSize: 14),
            textAlign: TextAlign.start,
          ),
        ),
      ],
    );
  }
}

import 'package:dating/common/buttons.dart';
import 'package:dating/common/onboarding_app_bar.dart';
import 'package:dating/constants.dart';
import 'package:dating/services/FirebaseHelper.dart';
import 'package:dating/services/helper.dart';
import 'package:dating/theme/textstyle.dart';
import 'package:dating/ui/onBoarding/onBoarding_hobby_question.dart';
// import 'package:dropdown_search/dropdown_search.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class OnBoardingQuestionFourScreen extends StatefulWidget {
  const OnBoardingQuestionFourScreen({Key? key}) : super(key: key);

  @override
  _OnBoardingQuestionFourScreenState createState() =>
      _OnBoardingQuestionFourScreenState();
}

String age = '';
TextEditingController dateController = TextEditingController();
TextEditingController religionController = TextEditingController();
TextEditingController collegeController = TextEditingController();
Map<String, dynamic>? collegeMap;
TextEditingController homwtownController = TextEditingController();
Map<String, dynamic>? homwtownMap;
SfRangeValues OneSliderValue = SfRangeValues(30.0, 50.0);
bool userCanMove = false;

class _OnBoardingQuestionFourScreenState
    extends State<OnBoardingQuestionFourScreen> with TickerProviderStateMixin {
  late AnimationController animationController1;
  late AnimationController animationController2;
  GlobalKey<FormState> _key = GlobalKey();
  AutovalidateMode _validate = AutovalidateMode.disabled;
  var datePicked;
  var datepickerDate;
  DateTime? selectedDate;
  List<Map<String, dynamic>> uniList = [];
  List<Map<String, dynamic>> cityList = [];

  @override
  void initState() {
    animationController1 = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    animationController2 =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500))
          ..forward();
    super.initState();
    getData();
    print(dateController.text);
    if (dateController.text.length == 2) {
      dateController.text = dateController.text + "/";
    } else if (dateController.text.length == 5) {
      dateController.text = dateController.text + "/";
    }
  }

  void getData() async {
    uniList = await FireStoreUtils.getUniversities();
    cityList = await FireStoreUtils.getUSState();
    setState(() {});
  }

  Future<void> _selectDate(BuildContext context) async {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 216,
        padding: const EdgeInsets.only(top: 6.0),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Done'),
                  ),
                ),
              ),
              Expanded(
                child: CupertinoDatePicker(
                  initialDateTime: selectedDate ?? DateTime(1974, 1, 1),
                  maximumDate: DateTime.now(),
                  mode: CupertinoDatePickerMode.date,
                  dateOrder: DatePickerDateOrder.mdy,
                  onDateTimeChanged: (DateTime newDate) {
                    datepickerDate = newDate;
                    selectedDate = newDate;
                    datePicked = DateFormat('MM/dd/yyyy').format(newDate);
                    dateController.text = datePicked;
                    setState(() {});
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    animationController1.dispose();
    animationController2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (dateController.text.isEmpty
        // ||
        //     religionController.text.isEmpty ||
        //     collegeController.text.isEmpty ||
        //     homwtownController.text.isEmpty
        ) {
      userCanMove = false;
    } else {
      userCanMove = true;
    }
    return Scaffold(
      backgroundColor: Color(COLOR_PRIMARY),
      appBar: onBoardingAppBar(
        backOnTap: () {
          animationController1.forward();
          setState(() {});
          Future.delayed(Duration(milliseconds: 500), () {
            Navigator.of(context).pop();
            animationController1.reverse();
          });
        },
        userCanMove: userCanMove,
        nextOnTap: nextButtonOnTap,
        animationController1: animationController1,
        animationController2: animationController2,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(
            vertical: 30,
            horizontal: 20,
          ),
          child: Form(
            key: _key,
            autovalidateMode: _validate,
            child: Column(
              children: <Widget>[
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'What is your birth date?',
                    textScaleFactor: 1.0,
                    style: boldText20.copyWith(
                      color: Color(0xFF0573ac),
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      shape: BoxShape.rectangle,
                      border: Border.all(color: Colors.grey.shade200)),
                  child: InkWell(
                    onTap: () {
                      _selectDate(context);
                    },
                    child: TextFormField(
                      textAlignVertical: TextAlignVertical.center,
                      textInputAction: TextInputAction.next,
                      style: TextStyle(fontSize: 18.0),
                      enabled: false,
                      controller: dateController,
                      onSaved: (val) {},
                      keyboardType: TextInputType.text,
                      cursorColor: Colors.black.withOpacity(0.5),
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.only(left: 16, right: 16, bottom: 12),
                        hintText: 'MM/DD/YYYY',
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(
                                color: Colors.grey.shade500, width: 2.0)),
                        errorBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Theme.of(context).errorColor),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Theme.of(context).errorColor),
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
                SizedBox(
                  height: 20,
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "What is your age preference?",
                    textScaleFactor: 1.0,
                    textAlign: TextAlign.start,
                    style: boldText20.copyWith(
                      color: Color(0xFF0573ac),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 12, top: 0, right: 12, bottom: 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "18",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black, fontSize: 10.0),
                      ),
                      Text(
                        "75+",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black, fontSize: 10.0),
                      ),
                    ],
                  ),
                ),
                SfRangeSlider(
                  min: 18.0,
                  max: 75.0,
                  values: OneSliderValue,
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
                  startThumbIcon: Stack(
                    children: [
                      Container(
                        decoration: new BoxDecoration(
                          color: Color(COLOR_BLUE_BUTTON),
                          shape: BoxShape.circle,
                        ),
                      ),
                      Center(
                          child: Text(OneSliderValue.start!.toStringAsFixed(0),
                              style:
                                  TextStyle(color: Colors.white, fontSize: 10)))
                    ],
                  ),
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
                            OneSliderValue.end!.toStringAsFixed(0),
                            style: TextStyle(color: Colors.white, fontSize: 10),
                          ),
                        )
                      ],
                    ),
                  ),
                  onChanged: (SfRangeValues values) {
                    setState(() {
                      OneSliderValue = values;
                    });
                  },
                ),
                // SizedBox(
                //   height: 20,
                // ),
                // Align(
                //   alignment: Alignment.topLeft,
                //   child: Text(
                //     'What is your religion?',
                //     textScaleFactor: 1.0,
                //     style: TextStyle(
                //       color: Color(0xFF0573ac),
                //       fontWeight: FontWeight.bold,
                //       fontSize: 20,
                //     ),
                //     textAlign: TextAlign.start,
                //   ),
                // ),
                // SizedBox(
                //   height: 10,
                // ),
                // DropdownSearch<String>(
                //   items: [
                //     "Agnostic",
                //     "Atheist",
                //     "Buddhist",
                //     "Catholic",
                //     "Christian",
                //     "Hindu",
                //     "Jain",
                //     "Jewish",
                //     "Mormon",
                //     "Muslim",
                //     "Sikh",
                //     "Spiritual",
                //     "Zoroastrian",
                //     "Other",
                //     "No Preference",
                //   ],
                //   selectedItem: religionController.text == ''
                //       ? null
                //       : religionController.text,
                //   dropdownDecoratorProps: DropDownDecoratorProps(
                //     dropdownSearchDecoration: InputDecoration(
                //       hintText: 'Select your religion',
                //       isDense: true,
                //       border: OutlineInputBorder(
                //         borderSide: BorderSide(
                //           color: Colors.blue,
                //         ),
                //       ),
                //     ),
                //   ),
                //   onChanged: (String? value) {
                //     if (value != null) {
                //       religionController.text = value;
                //     }
                //   },
                //   popupProps: PopupProps.menu(
                //     showSearchBox: true,
                //     searchFieldProps: TextFieldProps(
                //       autofocus: true,
                //       decoration: InputDecoration(
                //         hintText: 'Enter Religion',
                //         isDense: true,
                //         border: OutlineInputBorder(
                //           borderSide: BorderSide(
                //             color: Colors.blue,
                //           ),
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
                // SizedBox(
                //   height: 20,
                // ),
                // Align(
                //   alignment: Alignment.topLeft,
                //   child: Text(
                //     'What is your College?',
                //     textScaleFactor: 1.0,
                //     style: TextStyle(
                //       color: Color(0xFF0573ac),
                //       fontWeight: FontWeight.bold,
                //       fontSize: 20,
                //     ),
                //     textAlign: TextAlign.start,
                //   ),
                // ),
                // SizedBox(
                //   height: 10,
                // ),
                // DropdownSearch<Map<String, dynamic>>(
                //   // asyncItems: (String filter) =>
                //   //     FireStoreUtils.getUniversities(),
                //   selectedItem: collegeMap,
                //   itemAsString: (Map<String, dynamic> u) =>
                //       u['university_name'],
                //   items: uniList,
                //   dropdownDecoratorProps: DropDownDecoratorProps(
                //     dropdownSearchDecoration: InputDecoration(
                //       hintText: 'Enter your college',
                //       isDense: true,
                //       border: OutlineInputBorder(
                //         borderSide: BorderSide(
                //           color: Colors.blue,
                //         ),
                //       ),
                //     ),
                //   ),
                //   onChanged: (Map<String, dynamic>? data) {
                //     if (data != null) {
                //       collegeController.text = data['university_name'];
                //       collegeMap = data;
                //     }
                //     setState(() {});
                //   },
                //   popupProps: PopupProps.menu(
                //     showSearchBox: true,
                //     searchFieldProps: TextFieldProps(
                //       autofocus: true,
                //       decoration: InputDecoration(
                //         hintText: 'Enter University',
                //         isDense: true,
                //         border: OutlineInputBorder(
                //           borderSide: BorderSide(
                //             color: Colors.blue,
                //           ),
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
                // SizedBox(
                //   height: 20,
                // ),
                // Align(
                //   alignment: Alignment.topLeft,
                //   child: Text(
                //     'What is your Hometown?',
                //     textScaleFactor: 1.0,
                //     style: TextStyle(
                //       color: Color(0xFF0573ac),
                //       fontWeight: FontWeight.bold,
                //       fontSize: 20,
                //     ),
                //     textAlign: TextAlign.start,
                //   ),
                // ),
                // SizedBox(
                //   height: 10,
                // ),
                // DropdownSearch<Map<String, dynamic>>(
                //   // asyncItems: (String filter) => FireStoreUtils.getUSState(),
                //   items: cityList,
                //   selectedItem: homwtownMap,
                //   itemAsString: (Map<String, dynamic> u) =>
                //       u['city'] + ', ' + u['state'],
                //   dropdownDecoratorProps: DropDownDecoratorProps(
                //     dropdownSearchDecoration: InputDecoration(
                //       hintText: 'Enter your hometown',
                //       isDense: true,
                //       border: OutlineInputBorder(
                //         borderSide: BorderSide(
                //           color: Colors.blue,
                //         ),
                //       ),
                //     ),
                //   ),
                //   onChanged: (Map<String, dynamic>? data) {
                //     if (data != null) {
                //       homwtownController.text =
                //           data['city'] + ', ' + data['state'];
                //       homwtownMap = data;
                //     }
                //     setState(() {});
                //   },
                //   popupProps: PopupProps.menu(
                //     showSearchBox: true,
                //     searchFieldProps: TextFieldProps(
                //       autofocus: true,
                //       decoration: InputDecoration(
                //         hintText: 'Enter Hometown',
                //         isDense: true,
                //         border: OutlineInputBorder(
                //           borderSide: BorderSide(
                //             color: Colors.blue,
                //           ),
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
                SizedBox(
                  height: 30,
                ),
                nextButton(
                  isActive: userCanMove,
                  onTap: nextButtonOnTap,
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          height: 60,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Text(
            "We only show your age to potential matches, never your birthdate. You can adjust the age range later.",
            textScaleFactor: 1.0,
            style: TextStyle(
                color: Color(0xff525354),
                fontWeight: FontWeight.normal,
                fontSize: 13.0),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  void nextButtonOnTap() {
    if (dateController.text.isEmpty
        // ||
        // religionController.text.isEmpty ||
        // collegeController.text.isEmpty ||
        // homwtownController.text.isEmpty
        ) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please enter all field.',
          ),
        ),
      );
    } else {
      setSetQuestionPreferences("age", age);
      setSetQuestionPreferences("birthdate", dateController.text);
      // setSetQuestionPreferences("religion", religionController.text);
      // setSetQuestionPreferences("college", collegeController.text);
      // setSetQuestionPreferences("hometown", homwtownController.text);
      setSetQuestionPreferences(
          "age_prefrance_start", OneSliderValue.start!.toString());
      setSetQuestionPreferences(
          "age_prefrance_end", OneSliderValue.end!.toString());

      push(context, OnBoardingHobbyQuestion());
    }
  }

  Future<bool> setSetQuestionPreferences(String key, String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(key, value);
  }
}

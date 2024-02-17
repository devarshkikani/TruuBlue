import 'dart:convert';
import 'dart:io';

import 'package:dating/common/buttons.dart';
import 'package:dating/common/common_widget.dart';
import 'package:dating/common/onboarding_app_bar.dart';
import 'package:dating/constants.dart';
import 'package:dating/services/helper.dart';
import 'package:dating/theme/textstyle.dart';
import 'package:dating/ui/onBoarding/OnBoardingQuestionEndScreen.dart';
import 'package:dating/ui/onBoarding/add_caption_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnBoardingQuestionElevenScreen extends StatefulWidget {
  const OnBoardingQuestionElevenScreen({Key? key}) : super(key: key);

  @override
  _OnBoardingQuestionElevenScreenState createState() =>
      _OnBoardingQuestionElevenScreenState();
}

List<String> promptTextList = [];
List<String> imageList = [];

class _OnBoardingQuestionElevenScreenState
    extends State<OnBoardingQuestionElevenScreen>
    with TickerProviderStateMixin {
  late AnimationController animationController1;
  late AnimationController animationController2;
  final ImagePicker _imagePicker = ImagePicker();

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
  }

  @override
  void dispose() {
    animationController1.dispose();
    animationController2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
        userCanMove: imageList.length >= 3,
        nextOnTap: nextButtonOnTap,
        animationController1: animationController1,
        animationController2: animationController2,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(30),
          child: Column(
            children: <Widget>[
              Align(
                alignment: Directionality.of(context) == TextDirection.ltr
                    ? Alignment.topLeft
                    : Alignment.topLeft,
                child: Text(
                  'Add Photos & Captions',
                  textScaleFactor: 1.0,
                  style: boldText28.copyWith(
                    color: Color(0xFF0573ac),
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "A minimum of three quality photos are required",
                textScaleFactor: 1.0,
                style: regualrText20.copyWith(
                  color: Color(0xFF707070),
                ),
                textAlign: TextAlign.start,
              ),
              SizedBox(
                height: 50,
              ),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: List.generate(6, (index) {
                  bool showImage = imageList.length >= (index + 1);
                  return InkWell(
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Color(0xFF68ce09),
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          width: 100,
                          height: 100,
                          child: !showImage
                              ? Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                  size: 30,
                                )
                              : Stack(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                      ),
                                      child: Center(
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Image.file(
                                            File(imageList[index]),
                                            width: 100,
                                            height: 100,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                    if ((index + 1) <= promptTextList.length)
                                      if (promptTextList[index] != '')
                                        Positioned(
                                          top: 5,
                                          right: 5,
                                          child: Container(
                                            height: 25,
                                            width: 25,
                                            padding: EdgeInsets.all(3),
                                            decoration: BoxDecoration(
                                              color: Colors.green,
                                              shape: BoxShape.circle,
                                            ),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              child: Image.asset(
                                                'assets/images/chat_icon.png',
                                                fit: BoxFit.cover,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                  ],
                                ),
                        ),
                      ],
                    ),
                    onTap: () {
                      _onCameraClick(index);
                    },
                  );
                }),
              ),
              sizedBox30,
              nextButton(
                isActive: imageList.length >= 3,
                onTap: nextButtonOnTap,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          height: 60,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Text(
            "Photos are shared with other members.\nYou can add and edit photos later.",
            textScaleFactor: 1.0,
            style: TextStyle(
              color: Color(0xff525354),
              fontWeight: FontWeight.normal,
              fontSize: 13.0,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  _onCameraClick(int index) {
    final action = CupertinoActionSheet(
      message: Text(
        'Add profile picture',
        style: TextStyle(fontSize: 15.0),
      ),
      actions: <Widget>[
        if ((index + 1) <= imageList.length)
          CupertinoActionSheetAction(
            child: Text(
                promptTextList[index] != '' ? 'Update caption' : 'Add caption'),
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddPromptScreen(
                    image: imageList[index],
                    isFromProfileView: false,
                    prompt: promptTextList[index],
                    onDone: (prompt) {
                      promptTextList[index] = prompt;
                      setState(() {});
                    },
                  ),
                ),
              );
            },
          ),
        if ((index + 1) <= imageList.length)
          CupertinoActionSheetAction(
            child: Text('Remove image'),
            onPressed: () {
              Navigator.pop(context);
              imageList.removeAt(index);
              promptTextList.removeAt(index);
              setState(() {});
            },
          ),
        CupertinoActionSheetAction(
          child: Text('Choose from gallery'),
          onPressed: () async {
            Navigator.pop(context);
            XFile? imagess =
                await _imagePicker.pickImage(source: ImageSource.gallery);
            imagePath(imagess: imagess, index: (index + 1));
            setState(() {});
          },
        ),
        CupertinoActionSheetAction(
          child: Text('Take a picture'),
          onPressed: () async {
            Navigator.pop(context);
            XFile? image =
                await _imagePicker.pickImage(source: ImageSource.camera);
            imagePath(imagess: image, index: (index + 1));
            setState(() {});
          },
        ),
      ],
      cancelButton: CupertinoActionSheetAction(
        child: Text('Cancel'),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
    showCupertinoModalPopup(context: context, builder: (context) => action);
  }

  imagePath({XFile? imagess, required int index}) {
    int originalIndex = 0;
    if (imagess != null) {
      if (index <= imageList.length) {
        imageList[index] = imagess.path;
        originalIndex = index;
      } else {
        imageList.add(imagess.path);
        promptTextList.add('');
        originalIndex = imageList.length - 1;
      }
      setState(() {});
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddPromptScreen(
            image: imagess.path,
            isFromProfileView: false,
            onDone: (prompt) {
              promptTextList[originalIndex] = prompt;
              setState(() {});
            },
          ),
        ),
      );
    }
  }

  void nextButtonOnTap() async {
    if (imageList.length >= 3) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (promptTextList.length != 0) {
        await prefs.setString("prompt", jsonEncode(promptTextList));
      }
      await setSetQuestionPreferences("imageOne", imageList[0]);
      await setSetQuestionPreferences("imageTwo", imageList[1]);
      await setSetQuestionPreferences("imageThree", imageList[2]);
      await setSetQuestionPreferences(
          "imageFour", imageList.length >= 4 ? imageList[3] : "");
      await setSetQuestionPreferences(
          "imageFive", imageList.length >= 5 ? imageList[4] : "");
      await setSetQuestionPreferences(
          "imageSix", imageList.length >= 6 ? imageList[5] : "");
      push(
        context,
        OnBoardingQuestionEndScreen(),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please upload at least three photos'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  Future<bool> setSetQuestionPreferences(String key, String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(key, value);
  }

  List promptList = [
    'A little bubbly',
    'Bad hair day',
    "Bet you can't do this",
    'Christmas is the best time of year',
    'Dancing makes me happy',
    'Dancing the night away',
    'Dating me is like',
    'Do you like this costume',
    'Do you love animals as much as I do?',
    'Do you love cats as much as I do?',
    'Do you love dogs as much as I do?',
    'Do you love kids as much as I do?',
    "Don't judge me",
    'Feeling frisky',
    'Friends for life',
    'Fun in the sun',
    'Guess where I am in this photo',
    'How would you describe this pic',
    'I feel fab!',
    'I feel great!',
    'I must be crazy',
    'I need my morning coffee',
    "I'm a country girl",
    "I'm a cowboy at heart",
    "I'm famous for this",
    'Life at the beach',
    'Life on the water',
    'Me and my doppelgänger',
    'Me at my favorite concert',
    'Me being serious',
    'Me in my big hair days',
    'Me in my rowdy days',
    'Mondays suck',
    'Mountain life',
    'My alter ego',
    'My best friend and me',
    'My best life',
    'My BFF',
    'My family',
    'My favorite activity',
    'My favorite dress',
    'My favorite place on earth',
    'My favorite suit',
    'My favorite vacation',
    'My funniest moment',
    'My funny face',
    'My greatest achievement',
    'My kids are my world',
    'My love',
    'My mom would kill me',
    'My newest adventure',
    'My newest talent',
    'My proudest moment',
    'My serious face',
    'My work buddies',
    'My world',
    'People say I look like',
    'Silly kid stuff',
    'Simple pleasures',
    'Sunny days make me happy',
    'The best night of my life',
    'The bigger the risk',
    'The outdoor life',
    'They caught me',
    'This is candid me',
    'This takes years of practice'
        'Two is better than one',
    'Wanna do this with me?',
    'Weekends are the best',
    'What one word best describes this?',
    'Wish you were here',
    'You had to be there'
  ];
}

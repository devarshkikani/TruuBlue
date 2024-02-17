import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dating/constants.dart';
import 'package:dating/services/helper.dart';
import 'package:dating/theme/textstyle.dart';
import 'package:dating/ui/onBoarding/OnBoardingQuestionFiveScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../model/User.dart';

List answeredQuestionList = [];
List<List<TextEditingController>> questionTextController = [
  <TextEditingController>[],
  <TextEditingController>[],
  <TextEditingController>[]
];

class OnBoardingHobbyQuestion extends StatefulWidget {
  const OnBoardingHobbyQuestion({Key? key}) : super(key: key);

  @override
  State<OnBoardingHobbyQuestion> createState() =>
      _OnBoardingHobbyQuestionState();
}

class _OnBoardingHobbyQuestionState extends State<OnBoardingHobbyQuestion>
    with TickerProviderStateMixin {
  late AnimationController animationController1;
  late AnimationController animationController2;
  PageController pageController = PageController();
  late User user;
  bool isShown = false;
  List questionCategories = [];
  List<Map<String, List<QueryDocumentSnapshot<Map<String, dynamic>>>>>
      questionByCategories = [];
  String? dropDownValue;
  TabController? tabController;
  bool isLoading = true;
  RxBool isShowDialog = false.obs;
  int tabSelectedIndex = 0;
  int answerComplete = 0;
  @override
  void initState() {
    animationController1 = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    animationController2 =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    getQuestion();
    super.initState();
  }

  Future<void> getQuestion() async {
    await FirebaseFirestore.instance
        .collection('question')
        .get()
        .then((value) async {
      questionCategories = [];
      questionCategories.addAll(value.docs);
      tabController =
          TabController(length: questionCategories.length, vsync: this);
      await getQuestionList();
    });
  }

  Future<void> getQuestionList() async {
    for (var i = 0; i < questionCategories.length; i++) {
      await FirebaseFirestore.instance
          .collection('question')
          .doc(questionCategories[i].id)
          .collection(questionCategories[i].id + "Question")
          .get()
          .then((value) async {
        questionByCategories.add({'${questionCategories[i].id}': value.docs});
      });
    }

    for (int i = 0;
        i < questionByCategories[0].values.toList().first.length;
        i++) questionTextController[0].add(TextEditingController());
    for (int i = 0;
        i < questionByCategories[1].values.toList().first.length;
        i++) questionTextController[1].add(TextEditingController());
    for (int i = 0;
        i < questionByCategories[2].values.toList().first.length;
        i++) questionTextController[2].add(TextEditingController());
    setState(() {
      isLoading = false;
    });
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
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    animationController1.forward();
                    setState(() {});
                    Future.delayed(Duration(milliseconds: 500), () {
                      Navigator.of(context).pop();
                      animationController1.reverse();
                    });
                  },
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    transitionBuilder: (child, anim) => RotationTransition(
                      turns: animationController1,
                      child: FadeTransition(
                          opacity: anim,
                          child: child,
                          alwaysIncludeSemantics: true),
                    ),
                    child: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 30,
                      color: Color(0xFF0573ac),
                      key: const ValueKey('icon2'),
                    ),
                  ),
                ),
                Image.asset(
                  'assets/images/truubluenew.png',
                ),
                // tabSelectedIndex == (questionCategories.length - 1)
                answerComplete >= 3
                    ? InkWell(
                        onTap: () async {
                          await moveForward();
                        },
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          transitionBuilder: (child, anim) =>
                              RotationTransition(
                            turns: animationController2,
                            child: FadeTransition(opacity: anim, child: child),
                          ),
                          child: Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 30,
                            color: Color(0xFF0573ac),
                            key: const ValueKey('icon2'),
                          ),
                        ),
                      )
                    : SizedBox(
                        width: 30,
                      )
              ],
            ),
          ),
        ),
      ),
      body: isLoading
          ? Center(
              child: CupertinoActivityIndicator(),
            )
          : Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 10),
                        child: Text(
                          'Answered $answerComplete of 3',
                          style: TextStyle(
                              color: Color(0xFF0573ac),
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 10),
                      child: Text(
                        "Answer three Ice Breaker questions:",
                        style: mediumText16,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: TabBar(
                        controller: tabController,
                        labelStyle: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w700),
                        labelColor: Colors.white,
                        indicatorColor: Color(0xFF0573ac),
                        indicator: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            15.0,
                          ),
                          color: Color(0xFF0573ac),
                        ),
                        unselectedLabelColor: Colors.black,
                        physics: NeverScrollableScrollPhysics(),
                        onTap: (int index) {
                          answerComplete = 0;
                          for (int i = 0;
                              i < questionTextController.length;
                              i++) {
                            for (var j = 0;
                                j < questionTextController[i].length;
                                j++) {
                              if (questionTextController[i][j].text.length >=
                                  3) {
                                answerComplete++;
                                // break;
                              }
                            }
                          }
                          tabSelectedIndex = index;
                          if (index == 2) {
                            animationController2.forward();
                          } else {
                            animationController2.reverse();
                          }
                          setState(() {});
                        },
                        tabs: List.generate(
                          questionCategories.length,
                          (index) => Tab(
                            text: questionCategories[index]["name"],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      child: TabBarView(
                        controller: tabController,
                        children: List.generate(
                          questionCategories.length,
                          (index) {
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: AlwaysScrollableScrollPhysics(),
                              padding: EdgeInsets.zero,
                              itemCount: questionByCategories[index]
                                  .values
                                  .toList()
                                  .first
                                  .length,
                              itemBuilder: (context, i) {
                                return questionWiget(
                                  controller: questionTextController[index][i],
                                  question: questionByCategories[index]
                                      .values
                                      .toList()
                                      .first[i]['question'],
                                  hinttext: questionByCategories[index]
                                      .values
                                      .toList()
                                      .first[i]['question'],
                                  onChange: (value) {
                                    answerComplete = 0;
                                    int answerAttempt = 0;
                                    for (int i = 0;
                                        i < questionTextController.length;
                                        i++) {
                                      for (var j = 0;
                                          j < questionTextController[i].length;
                                          j++) {
                                        if (questionTextController[i][j]
                                            .text
                                            .isNotEmpty) {
                                          answerAttempt++;
                                        }
                                        if (questionTextController[i][j]
                                                .text
                                                .length >=
                                            3) {
                                          if (answerComplete <= 3) {
                                            answerComplete++;
                                          }
                                        } else {
                                          if (answerAttempt > 3) {
                                            questionTextController[i][j]
                                                .clear();
                                            if (!isShowDialog.value) {
                                              isShowDialog.value = true;
                                              showAlertDialog(context);
                                            }
                                          }
                                        }
                                      }
                                    }
                                    if (answerComplete <= 3) {
                                      Map<String, dynamic> answerMap = {
                                        "question": questionByCategories[index]
                                            .values
                                            .toList()
                                            .first[i]['question'],
                                        "answer": value,
                                        "category_question_id":
                                            questionCategories[index].id,
                                        "id": questionByCategories[index]
                                            .values
                                            .toList()
                                            .first[i]["id"]
                                      };
                                      answerQuestion(answerMap, value, i);
                                    } else {
                                      if (!isShowDialog.value) {
                                        isShowDialog.value = true;
                                        showAlertDialog(context);
                                      }
                                    }
                                  },
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                if (answerComplete >= 3)
                  Positioned(
                    bottom: 0,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.black,
                      ),
                      child: Text(
                        'Now you are able to move on next page.',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
    );
  }

  showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Image.asset(
            'assets/images/check_green.png',
            height: 100,
            width: 100,
          ),
          content: Text(
            "You have answered the maximum of three Ice Breakers. If you want to change or edit an Ice Breaker, tap “Edit” below to return to the prior screen or tap “Next” to continue. You can edit Ice Breakers at any time in your Profile.",
            textAlign: TextAlign.center,
          ),
          contentPadding: EdgeInsets.only(left: 15, top: 12, right: 15),
          actions: [
            TextButton(
              child: Text("Edit"),
              onPressed: () async {
                isShowDialog.value = false;
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text("Next"),
              onPressed: () async {
                await moveForward();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> moveForward() async {
    answerComplete = 0;
    for (int i = 0; i < questionTextController.length; i++) {
      for (var j = 0; j < questionTextController[i].length; j++) {
        if (questionTextController[i][j].text.length >= 3) {
          answerComplete++;
          // break;
        }
      }
    }
    if (answerComplete >= 3) {
      // int hasQuirkyMequestion = answeredQuestionList
      //     .where((element) => element['category_question_id'] == 'QuirkyMe')
      //     .toList()
      //     .length;
      // if (hasQuirkyMequestion == 0) {
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(
      //       duration: Duration(seconds: 2),
      //       content: Text(
      //         "A total of three ice breaker answers are required.",
      //         style: TextStyle(fontSize: 17),
      //       ),
      //     ),
      //   );
      // } else {
      // int hasSeriousMequestion = answeredQuestionList
      //     .where((element) => element['category_question_id'] == 'SeriousMe')
      //     .toList()
      //     .length;
      // if (hasSeriousMequestion == 0) {
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(
      //       duration: Duration(seconds: 2),
      //       content: Text(
      //         "A total of three ice breaker answers are required.",
      //         style: TextStyle(fontSize: 17),
      //       ),
      //     ),
      //   );
      // } else {
      // int hasLovingMequestion = answeredQuestionList
      //     .where((element) => element['category_question_id'] == 'LovingMe')
      //     .toList()
      //     .length;
      // if (hasLovingMequestion == 0) {
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(
      //       duration: Duration(seconds: 2),
      //       content: Text(
      //         "A total of three ice breaker answers are required.",
      //         style: TextStyle(fontSize: 17),
      //       ),
      //     ),
      //   );
      // } else {
      print(answeredQuestionList);
      push(context, OnBoardingQuestionFiveScreen());
      // }
      // }
      // }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(seconds: 2),
          content: Text(
            "A total of three ice breaker answers are required.",
            style: TextStyle(fontSize: 17),
          ),
        ),
      );
    }
  }

  void answerQuestion(answerMap, value, index) {
    if (answeredQuestionList.isNotEmpty) {
      int isExists = answeredQuestionList
          .where(
            (element) => (element['id'] ==
                questionByCategories[tabSelectedIndex]
                    .values
                    .toList()
                    .first[index]
                    .id),
          )
          .toList()
          .length;
      if (isExists == 0) {
        answeredQuestionList.add(answerMap);
      } else {
        for (var i = 0; i < answeredQuestionList.length; i++) {
          if (answeredQuestionList[i]['id'] ==
              questionByCategories[tabSelectedIndex]
                  .values
                  .toList()
                  .first[index]
                  .id) {
            answeredQuestionList[i]['answer'] = value;
          }
        }
        questionByCategories[tabSelectedIndex].values.toList().first[index].id;
      }
    } else {
      answeredQuestionList.add(answerMap);
    }
    if (value == '') {
      answeredQuestionList.removeWhere((element) => element['answer'] == '');
    }
    setState(() {});
  }

  Future<bool> setSetQuestionPreferences(String key, String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(key, value);
  }

  Widget questionWiget({question, controller, hinttext, onChange}) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              childrenPadding: EdgeInsets.symmetric(vertical: 10),
              initiallyExpanded: controller.text.isNotEmpty,
              title: Row(
                children: [
                  Expanded(
                    child: Text(
                      question,
                      style: mediumText16.copyWith(
                        color: Color(0xFF0573ac),
                      ),
                    ),
                  ),
                  if (controller.text.isNotEmpty)
                    Icon(
                      Icons.check,
                      color: Colors.green,
                    ),
                ],
              ),
              children: [
                commmonTextBox(
                    hinttext: hinttext,
                    controller: controller,
                    onChangeString: onChange),
              ],
            ),
          ),
        ),
        Container(
          height: 1,
          color: Colors.black.withOpacity(0.2),
        ),
      ],
    );
  }

  Widget commmonTextBox({controller, hinttext, onChangeString}) {
    return ConstrainedBox(
      constraints: BoxConstraints(minWidth: double.infinity),
      child: Padding(
        padding: const EdgeInsets.only(top: 6.0),
        child: TextFormField(
          onChanged: onChangeString,
          textAlignVertical: TextAlignVertical.center,
          textInputAction: TextInputAction.done,
          controller: controller,
          style: TextStyle(fontSize: 18.0, color: Colors.black),
          keyboardType: TextInputType.name,
          cursorColor: Colors.black.withOpacity(0.5),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.only(left: 16, right: 16, bottom: 12),
            hintText: hinttext,
            hintStyle: TextStyle(color: Colors.black.withOpacity(0.2)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(color: Colors.black, width: 1.0)),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Theme.of(context).errorColor),
              borderRadius: BorderRadius.circular(10.0),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Theme.of(context).errorColor),
              borderRadius: BorderRadius.circular(10.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
      ),
    );
  }
}

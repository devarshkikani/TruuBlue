import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dating/common/common_widget.dart';
import 'package:dating/constants.dart';
import 'package:dating/help/responsive_ui.dart';
import 'package:dating/main.dart';
import 'package:dating/model/MessageData.dart';
import 'package:dating/model/User.dart';
import 'package:dating/services/FirebaseHelper.dart';
import 'package:dating/services/helper.dart';
import 'package:dating/ui/fullScreenImageViewer/FullScreenImageViewer.dart';
import 'package:dating/ui/onBoarding/add_caption_screen.dart';
import 'package:dating/ui/profile/account_settings/edit_email/edit_email_screen.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:dating/model/User.dart' as us;

class NewProfileScreen extends StatefulWidget {
  final User user;

  const NewProfileScreen({Key? key, required this.user}) : super(key: key);

  @override
  _NewProfileScreenState createState() => _NewProfileScreenState();
}

class _NewProfileScreenState extends State<NewProfileScreen> {
  GlobalKey<FormState> key = GlobalKey();
  AutovalidateMode validate = AutovalidateMode.disabled;
  bool? isLoading, _large, _medium;
  double? _pixelRatio, bottom1;
  Size? size;
  final bioController = TextEditingController();
  late User user;
  final ScrollController _controller = ScrollController();
  // late String radius;
  late double _OneSliderValue;
  // bool checkBoxOne = false;
  List images = [];
  List _pages = [];
  final ImagePicker _imagePicker = ImagePicker();
  FireStoreUtils fireStoreUtils = FireStoreUtils();
  List<Map<String, dynamic>> uniList = [];
  List<Map<String, dynamic>> cityList = [];
  Map<String, dynamic>? collegeMap;
  Map<String, dynamic>? homwtownMap;

  @override
  void initState() {
    super.initState();
    getData();
    user = widget.user;
    // radius = user.settings.distanceRadius;
    _OneSliderValue =
        getQuestion(user.where_do_you_stand.woman_Right_to_Choose);
    // checkBoxOne =
    //     user.where_do_you_stand.woman_Right_to_Choose_Deal_Breaker == "1"
    //         ? true
    //         : false;
    for (var i = 0; i < user.answeredQuestion.length; i++) {
      controllers.add(TextEditingController());
      editFlags.add(false);
      controllers[i].text = user.answeredQuestion[i]['answer'];
    }
    images.clear();
    images.addAll(user.photos);
    if (images.isNotEmpty) {
      if (images[images.length - 1] != null) {
        images.add(null);
      }
    } else {
      images.add(null);
    }
  }

  void getData() async {
    uniList = await FireStoreUtils.getUniversities();
    cityList = await FireStoreUtils.getUSState();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    var scrWidth = MediaQuery.of(context).size.width;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    _large = ResponsiveWidget.isScreenLarge(scrWidth, _pixelRatio!);
    _medium = ResponsiveWidget.isScreenMedium(scrWidth, _pixelRatio!);
    bioController.text = user.bio;
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: ListView(
          controller: _controller,
          children: [
            // Padding(
            //   padding: const EdgeInsets.only(top: 10.0),
            //   child: Align(
            //     alignment: Alignment.topLeft,
            //     child: Text(
            //       'About Me',
            //       textScaleFactor: 1.0,
            //       style: TextStyle(
            //           color: Color(0xFF7b7b7b),
            //           fontWeight: FontWeight.bold,
            //           fontSize: 22),
            //       textAlign: TextAlign.start,
            //     ),
            //   ),
            // ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     Text(
            //       'How would your friends describe you',
            //       textScaleFactor: 1.0,
            //       style: TextStyle(color: Color(0xFF949494), fontSize: 15),
            //       textAlign: TextAlign.start,
            //     ),
            //     Padding(
            //       padding: const EdgeInsets.only(right: 10.0),
            //       child: InkWell(
            //         onTap: () {
            //           if (bioController.text.length == 0) {
            //             ScaffoldMessenger.of(context).showSnackBar(
            //               SnackBar(
            //                 duration: Duration(seconds: 3),
            //                 content: Text(
            //                   'Please enter bio',
            //                   style: TextStyle(fontSize: 17),
            //                 ),
            //               ),
            //             );
            //           } else {
            //             _updateBio();
            //           }
            //         },
            //         child: Text(
            //           'Save',
            //           textScaleFactor: 1.0,
            //           style: TextStyle(
            //               color: Color(0xFF949494),
            //               decoration: TextDecoration.underline,
            //               fontSize: 14),
            //           textAlign: TextAlign.start,
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
            // Padding(
            //   padding:
            //       const EdgeInsets.only(left: 0, top: 10, right: 0, bottom: 8),
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       Container(
            //         decoration: BoxDecoration(
            //             borderRadius: BorderRadius.circular(10),
            //             shape: BoxShape.rectangle,
            //             border: Border.all(color: Color(0xFF505050))),
            //         child: TextFormField(
            //           textAlignVertical: TextAlignVertical.top,
            //           textInputAction: TextInputAction.next,
            //           style: TextStyle(fontSize: 18.0),
            //           controller: bioController,
            //           keyboardType: TextInputType.multiline,
            //           maxLines: 3,
            //           cursorColor: Colors.grey.shade500,
            //           textAlign: TextAlign.start,
            //           decoration: InputDecoration(
            //             contentPadding: EdgeInsets.only(
            //                 left: 16, right: 16, top: 5, bottom: 5),
            //             hintText: '',
            //             focusedBorder: OutlineInputBorder(
            //                 borderRadius: BorderRadius.circular(10.0),
            //                 borderSide: BorderSide(
            //                     color: Colors.grey.shade500, width: 2.0)),
            //             errorBorder: OutlineInputBorder(
            //               borderSide:
            //                   BorderSide(color: Theme.of(context).errorColor),
            //               borderRadius: BorderRadius.circular(10.0),
            //             ),
            //             focusedErrorBorder: OutlineInputBorder(
            //               borderSide:
            //                   BorderSide(color: Theme.of(context).errorColor),
            //               borderRadius: BorderRadius.circular(10.0),
            //             ),
            //             enabledBorder: OutlineInputBorder(
            //               borderSide: BorderSide(color: Colors.grey.shade200),
            //               borderRadius: BorderRadius.circular(10.0),
            //             ),
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            SizedBox(
              height: 15,
            ),
            profilePituresWidget(),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            // Text(
            //   'Distance',
            //   textScaleFactor: 1.0,
            //   style: TextStyle(
            //       color: Color(0xFF7b7b7b),
            //       fontWeight: FontWeight.bold,
            //       fontSize: 22),
            //   textAlign: TextAlign.start,
            // ),
            // GestureDetector(
            //   onTap: _onDistanceRadiusClick,
            //   child: Row(
            //     children: [
            //       Text(
            //         radius.isNotEmpty
            //             ? '${radius} Miles'
            //             : 'Unlimited',
            //         textScaleFactor: 1.0,
            //         style:
            //             TextStyle(color: Color(0xFF949494), fontSize: 14),
            //         textAlign: TextAlign.start,
            //       ),
            //       SizedBox(
            //         width: 10,
            //       ),
            //       Icon(
            //         Icons.arrow_forward_ios,
            //         size: 15,
            //         color: Color(0xFF949494),
            //       ),
            //     ],
            //   ),
            // )
            //   ],
            // ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Your Essentials',
              textScaleFactor: 1.0,
              style: TextStyle(
                color: Color(0xFF7b7b7b),
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
              textAlign: TextAlign.start,
            ),
            _Essentials(),
            SizedBox(
              height: 20,
            ),
            Text(
              'Your Political Views',
              textScaleFactor: 1.0,
              style: TextStyle(
                color: Color(0xFF7b7b7b),
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
              textAlign: TextAlign.start,
            ),
            _Political(),
            SizedBox(
              height: 20,
            ),
            Text(
              'Your Details',
              textScaleFactor: 1.0,
              style: TextStyle(
                color: Color(0xFF7b7b7b),
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
              textAlign: TextAlign.start,
            ),
            _Details(),
            SizedBox(
              height: 10,
            ),
            Text(
              'Ice Breakers',
              textScaleFactor: 1.0,
              style: TextStyle(
                color: Color(0xFF7b7b7b),
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
              textAlign: TextAlign.start,
            ),
            _IceBreakers(),
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
                'Back to Top',
                textScaleFactor: 1.0,
                style: TextStyle(
                  color: Color(COLOR_BLUE_BUTTON),
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                  fontSize: _large! ? 26 : (_medium! ? 22 : 20),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }

  profilePituresWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Manage Profile Pictures',
          textScaleFactor: 1.0,
          style: TextStyle(
            color: Color(0xFF7b7b7b),
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
          textAlign: TextAlign.center,
        ),
        Padding(
          padding: EdgeInsets.only(top: 16, bottom: 0),
          child: SizedBox(
            height: 260,
            width: MediaQuery.of(context).size.width,
            child: PageView(
              children: _buildGridView(),
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              'Double tap to add or edit prompt',
              style: TextStyle(
                color: Colors.grey.shade600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildGridView() {
    _pages.clear();
    List<Widget> gridViewPages = [];
    var len = images.length;
    var size = 6;
    for (var i = 0; i < len; i += size) {
      var end = (i + size < len) ? i + size : len;
      _pages.add(images.sublist(i, end));
    }
    _pages.forEach((elements) {
      gridViewPages.add(
        GridView.builder(
          padding: EdgeInsets.only(right: 0, left: 0),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 1,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10),
          itemBuilder: (context, index) {
            return _imageBuilder(
                (index + 1) >= elements.length ? null : elements[index], index);
          },
          itemCount: 6,
          physics: BouncingScrollPhysics(),
        ),
      );
    });
    return gridViewPages;
  }

  Widget _imageBuilder(String? url, int index) {
    bool isLastItem = url == null;
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            isLastItem ? _pickImage() : _viewOrDeleteImage(url, index);
          },
          onDoubleTap: () {
            if (!isLastItem) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddPromptScreen(
                    image: url,
                    isFromProfileView: true,
                    prompt: user.prompt != null &&
                            user.prompt != [] &&
                            user.prompt!.isNotEmpty
                        ? user.prompt![index]
                        : null,
                    onDone: (prompt) async {
                      if (user.prompt!.isEmpty) {
                        for (int i = 0; i < images.length - 1; i++) {
                          user.prompt!.add('');
                        }
                        user.prompt![index] = prompt;
                      } else {
                        user.prompt![index] = prompt;
                      }
                      us.User? newUser =
                          await FireStoreUtils.updateCurrentUser(user);
                      if (newUser != null) {
                        MyAppState.currentUser = newUser;
                        user = newUser;
                      }
                      setState(() {});
                    },
                  ),
                ),
              );
            }
          },
          child: Card(
            shape: RoundedRectangleBorder(
              side: BorderSide.none,
              borderRadius: BorderRadius.circular(12),
            ),
            color: Color(0xFF68ce09),
            child: isLastItem
                ? SizedBox(
                    height: double.maxFinite,
                    width: double.maxFinite,
                    child: Icon(
                      Icons.camera_alt,
                      size: 50,
                      color: isDarkMode(context) ? Colors.black : Colors.white,
                    ),
                  )
                : SizedBox(
                    height: double.maxFinite,
                    width: double.maxFinite,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: CachedNetworkImage(
                        fit: BoxFit.cover,
                        imageUrl: user.profilePictureURL == DEFAULT_AVATAR_URL
                            ? ''
                            : url,
                        placeholder: (context, imageUrl) {
                          return Icon(
                            Icons.hourglass_empty,
                            size: 75,
                            color: isDarkMode(context)
                                ? Colors.black
                                : Colors.white,
                          );
                        },
                        errorWidget: (context, imageUrl, error) {
                          return Icon(
                            Icons.error_outline,
                            size: 75,
                            color: isDarkMode(context)
                                ? Colors.black
                                : Colors.white,
                          );
                        },
                      ),
                    ),
                  ),
          ),
        ),
        if (!isLastItem)
          if (index != images.length - 1)
            if (user.prompt!.isNotEmpty && user.prompt![index] != '')
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  height: 25,
                  width: 25,
                  padding: EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image.asset(
                      'assets/images/chat_icon.png',
                      fit: BoxFit.cover,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
      ],
    );
  }

  _pickImage() {
    final action = CupertinoActionSheet(
      message: Text(
        'Add picture',
        style: TextStyle(fontSize: 15.0),
      ),
      actions: <Widget>[
        CupertinoActionSheetAction(
          child: Text('Choose from gallery'),
          isDefaultAction: false,
          onPressed: () async {
            Navigator.pop(context);
            XFile? image =
                await _imagePicker.pickImage(source: ImageSource.gallery);
            if (image != null) {
              Url imageUrl = await fireStoreUtils.uploadChatImageToFireStorage(
                  File(image.path), context);
              images.removeLast();
              images.add(imageUrl.url);
              user.photos = images;
              if (user.prompt!.isEmpty) {
                for (int i = 0; i < images.length; i++) {
                  user.prompt!.add('');
                }
              } else {
                user.prompt!.add('');
              }
              us.User? newUser = await FireStoreUtils.updateCurrentUser(user);
              if (newUser != null) {
                MyAppState.currentUser = newUser;
                user = newUser;
              }
              images.add(null);
              setState(() {});
            }
          },
        ),
        CupertinoActionSheetAction(
          child: Text('Take a picture'),
          isDestructiveAction: false,
          onPressed: () async {
            Navigator.pop(context);
            XFile? image =
                await _imagePicker.pickImage(source: ImageSource.camera);
            if (image != null) {
              Url imageUrl = (await fireStoreUtils.uploadChatImageToFireStorage(
                  File(image.path), context));
              images.removeLast();
              images.add(imageUrl.url);
              user.photos = images;
              us.User? newUser = await FireStoreUtils.updateCurrentUser(user);
              if (newUser != null) {
                MyAppState.currentUser = newUser;
                user = newUser;
              }
              images.add(null);
              setState(() {});
            }
          },
        )
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

  _viewOrDeleteImage(String url, int index) {
    final action = CupertinoActionSheet(
      actions: <Widget>[
        CupertinoActionSheetAction(
          onPressed: () async {
            Navigator.pop(context);
            images.removeLast();
            images.remove(url);
            await fireStoreUtils.deleteImage(url);
            user.photos = images;
            user.prompt?.removeAt(index);
            us.User? newUser = await FireStoreUtils.updateCurrentUser(user);
            MyAppState.currentUser = newUser;
            if (newUser != null) {
              user = newUser;
              images.add(null);
              setState(() {});
            }
          },
          child: Text('Remove Picture'),
          isDestructiveAction: true,
        ),
        CupertinoActionSheetAction(
          onPressed: () {
            Navigator.pop(context);
            push(context, FullScreenImageViewer(imageUrl: url));
          },
          isDefaultAction: true,
          child: Text('View Picture'),
        ),
        CupertinoActionSheetAction(
          onPressed: () async {
            Navigator.pop(context);
            user.profilePictureURL = url;
            dynamic result = await FireStoreUtils.updateCurrentUser(user);
            if (result != null) {
              user = result;
            }
            setState(() {});
          },
          isDefaultAction: true,
          child: Text('Make Profile Picture'),
        )
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

  var editNameFlag = false;
  var editGenderFlag = false;
  var editPreferPronounFlag = false;
  var editEthnicityFlag = false;
  var editSexualityFlag = false;
  var editDrinkFlag = false;
  var editSmokeFlag = false;
  var editChildFlag = false;
  final nameController = TextEditingController();
  late String selection;
  final List<String> _PreferPronounList = [
    'She/her/hers',
    'He/him/his',
    'They/them/theirs',
    'Ze/hir/hirs',
    'Ze/zir/zirs',
    'Prefer not to include',
  ];

  final List<String> _SexualityList = [
    'Straight',
    'Gay',
    'Lesbian',
    'Bisexual',
    'Demisexual',
    'Pansexual',
    'Queer',
    'Questioning',
    'No Preference',
  ];

  final List<String> _EthinicityList = [
    'American Indian',
    'Black/African Decent',
    'East Asian',
    'Hispanic Latino',
    'Middle Eastern',
    'Pacifica Islander',
    'South Asian',
    'White/Caucasian',
    'Other',
    'No Preference',
  ];

  _Essentials() {
    selection = user.preferPronoun;
    nameController.text = user.firstName;
    return Column(
      children: [
        SizedBox(
          height: 5,
        ),
        Divider(
          color: Color(0xFF7e7e7e),
          height: 0.3,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'First Name',
                    textScaleFactor: 1.0,
                    style: TextStyle(color: Color(0xFF949494), fontSize: 14),
                    textAlign: TextAlign.start,
                  ),
                  editNameFlag
                      ? Padding(
                          padding: const EdgeInsets.only(top: 0.0, right: 10.0),
                          child: Container(
                            width: 150,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                shape: BoxShape.rectangle,
                                border:
                                    Border.all(color: Colors.grey.shade200)),
                            child: TextFormField(
                              textAlignVertical: TextAlignVertical.center,
                              textInputAction: TextInputAction.done,
                              textCapitalization: TextCapitalization.words,
                              style: TextStyle(fontSize: 18.0),
                              controller: nameController,
                              keyboardType: TextInputType.text,
                              cursorColor: Colors.grey.shade500,
                              textAlign: TextAlign.start,
                              decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.only(left: 10, right: 10),
                                hintText: '',
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: BorderSide(
                                        color: Colors.grey.shade500,
                                        width: 2.0)),
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context).errorColor),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context).errorColor),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.grey.shade200),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                            ),
                          ),
                        )
                      : InkWell(
                          onTap: () {
                            setState(() {
                              editNameFlag = true;
                            });
                          },
                          child: Text(
                            user.firstName,
                            textScaleFactor: 1.0,
                            style: TextStyle(
                                color: Color(0xFF949494), fontSize: 12),
                            textAlign: TextAlign.start,
                          ),
                        )
                ],
              ),
              Column(
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        if (editNameFlag) {
                          editNameFlag = false;
                        } else {
                          editNameFlag = true;
                        }
                      });
                    },
                    child: Row(
                      children: [
                        Text(
                          'Edit',
                          textScaleFactor: 1.0,
                          style:
                              TextStyle(color: Color(0xFF949494), fontSize: 14),
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
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Visibility(
                      visible: editNameFlag,
                      child: InkWell(
                        onTap: () {
                          _updateFirstName();
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
                  )
                ],
              )
            ],
          ),
        ),
        Divider(
          color: Color(0xFF7e7e7e),
          height: 0.3,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Age',
                    textScaleFactor: 1.0,
                    style: TextStyle(color: Color(0xFF949494), fontSize: 14),
                    textAlign: TextAlign.start,
                  ),
                  InkWell(
                    onTap: () {
                      _UpdateBithDate(context);
                    },
                    child: Text(
                      user.profileAge(),
                      textScaleFactor: 1.0,
                      style: TextStyle(color: Color(0xFF949494), fontSize: 12),
                      textAlign: TextAlign.start,
                    ),
                  ),
                ],
              ),
              Align(
                  alignment: Alignment.topRight,
                  child: InkWell(
                    onTap: () {
                      _UpdateBithDate(context);
                    },
                    child: Row(
                      children: [
                        Text(
                          'Edit',
                          textScaleFactor: 1.0,
                          style:
                              TextStyle(color: Color(0xFF949494), fontSize: 14),
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
                  ))
            ],
          ),
        ),
        Divider(
          color: Color(0xFF7e7e7e),
          height: 0.3,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Preferred Pronouns',
                    textScaleFactor: 1.0,
                    style: TextStyle(color: Color(0xFF949494), fontSize: 14),
                    textAlign: TextAlign.start,
                  ),
                  editPreferPronounFlag
                      ? Container(
                          width: 200,
                          child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: _PreferPronounList.length,
                              itemBuilder: (BuildContext context, int index) {
                                return _PreferPronounItem(
                                    _PreferPronounList[index], index);
                              }),
                        )
                      : InkWell(
                          onTap: () {
                            setState(() {
                              editPreferPronounFlag = true;
                            });
                          },
                          child: Text(
                            user.preferPronoun,
                            textScaleFactor: 1.0,
                            style: TextStyle(
                                color: Color(0xFF949494), fontSize: 12),
                            textAlign: TextAlign.start,
                          ),
                        ),
                ],
              ),
              Align(
                  alignment: Alignment.topRight,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        if (editPreferPronounFlag) {
                          editPreferPronounFlag = false;
                        } else {
                          editPreferPronounFlag = true;
                        }
                      });
                    },
                    child: Row(
                      children: [
                        Text(
                          'Edit',
                          textScaleFactor: 1.0,
                          style:
                              TextStyle(color: Color(0xFF949494), fontSize: 14),
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
                  ))
            ],
          ),
        ),
        Divider(
          color: Color(0xFF7e7e7e),
          height: 0.3,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Gender',
                    textScaleFactor: 1.0,
                    style: TextStyle(color: Color(0xFF949494), fontSize: 14),
                    textAlign: TextAlign.start,
                  ),
                  editGenderFlag
                      ? Container(
                          width: 200,
                          child: Column(
                            children: [
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
                                          value: user.your_gender == "Female",
                                          activeColor: Color(0xFF66BB6A),
                                          onChanged: (bool? newValue) {
                                            setState(() {
                                              _updateGender("Female");
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
                                          value: user.your_gender == "Male",
                                          activeColor: Color(0xFF66BB6A),
                                          onChanged: (bool? newValue) {
                                            setState(() {
                                              _updateGender("Male");
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
                                          value:
                                              user.your_gender == "Non-Binary",
                                          activeColor: Color(0xFF66BB6A),
                                          onChanged: (bool? newValue) {
                                            setState(() {
                                              _updateGender("Non-Binary");
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
                          ),
                        )
                      : InkWell(
                          onTap: () {
                            setState(() {
                              editGenderFlag = true;
                            });
                          },
                          child: Text(
                            user.your_gender,
                            textScaleFactor: 1.0,
                            style: TextStyle(
                                color: Color(0xFF949494), fontSize: 12),
                            textAlign: TextAlign.start,
                          ),
                        ),
                ],
              ),
              Align(
                  alignment: Alignment.topRight,
                  child: InkWell(
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
                              TextStyle(color: Color(0xFF949494), fontSize: 14),
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
                  ))
            ],
          ),
        ),
        Divider(
          color: Color(0xFF7e7e7e),
          height: 0.3,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sexuality',
                    textScaleFactor: 1.0,
                    style: TextStyle(color: Color(0xFF949494), fontSize: 14),
                    textAlign: TextAlign.start,
                  ),
                  editSexualityFlag
                      ? Container(
                          width: 300,
                          child: GridView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: _SexualityList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return _SexualityItem(
                                  _SexualityList[index], index);
                            },
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    childAspectRatio: 5, crossAxisCount: 2),
                          ))
                      : InkWell(
                          onTap: () {
                            setState(() {
                              editSexualityFlag = true;
                            });
                          },
                          child: Text(
                            user.your_Sexuality,
                            textScaleFactor: 1.0,
                            style: TextStyle(
                                color: Color(0xFF949494), fontSize: 12),
                            textAlign: TextAlign.start,
                          ),
                        ),
                ],
              ),
              Align(
                  alignment: Alignment.topRight,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        if (editSexualityFlag) {
                          editSexualityFlag = false;
                        } else {
                          editSexualityFlag = true;
                        }
                      });
                    },
                    child: Row(
                      children: [
                        Text(
                          'Edit',
                          textScaleFactor: 1.0,
                          style:
                              TextStyle(color: Color(0xFF949494), fontSize: 14),
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
                  ))
            ],
          ),
        ),
        Divider(
          color: Color(0xFF7e7e7e),
          height: 0.3,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ethnicity',
                    textScaleFactor: 1.0,
                    style: TextStyle(color: Color(0xFF949494), fontSize: 14),
                    textAlign: TextAlign.start,
                  ),
                  editEthnicityFlag
                      ? Container(
                          width: 300,
                          child: GridView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: _EthinicityList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return _EthnicityItem(
                                  _EthinicityList[index], index);
                            },
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    childAspectRatio: 5, crossAxisCount: 2),
                          ))
                      : InkWell(
                          onTap: () {
                            setState(() {
                              if (editEthnicityFlag) {
                                editEthnicityFlag = false;
                              } else {
                                editEthnicityFlag = true;
                              }
                            });
                          },
                          child: Text(
                            user.your_Ethnicity,
                            textScaleFactor: 1.0,
                            style: TextStyle(
                                color: Color(0xFF949494), fontSize: 12),
                            textAlign: TextAlign.start,
                          ),
                        ),
                ],
              ),
              Align(
                alignment: Alignment.topRight,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      if (editEthnicityFlag) {
                        editEthnicityFlag = false;
                      } else {
                        editEthnicityFlag = true;
                      }
                    });
                  },
                  child: Row(
                    children: [
                      Text(
                        'Edit',
                        textScaleFactor: 1.0,
                        style:
                            TextStyle(color: Color(0xFF949494), fontSize: 14),
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
                ),
              )
            ],
          ),
        ),
        Divider(
          color: Color(0xFF7e7e7e),
          height: 0.3,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Drink Alcohol',
                    textScaleFactor: 1.0,
                    style: TextStyle(color: Color(0xFF949494), fontSize: 14),
                    textAlign: TextAlign.start,
                  ),
                  editDrinkFlag
                      ? _DrinkList()
                      : user.you_Drink != null
                          ? InkWell(
                              onTap: () {
                                setState(() {
                                  editDrinkFlag = true;
                                });
                              },
                              child: Text(
                                user.you_Drink!,
                                textScaleFactor: 1.0,
                                style: TextStyle(
                                    color: Color(0xFF949494), fontSize: 12),
                                textAlign: TextAlign.start,
                              ),
                            )
                          : SizedBox(),
                ],
              ),
              Align(
                alignment: Alignment.topRight,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      if (editDrinkFlag) {
                        editDrinkFlag = false;
                      } else {
                        editDrinkFlag = true;
                      }
                    });
                  },
                  child: Row(
                    children: [
                      Text(
                        'Edit',
                        textScaleFactor: 1.0,
                        style:
                            TextStyle(color: Color(0xFF949494), fontSize: 14),
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
                ),
              )
            ],
          ),
        ),
        Divider(
          color: Color(0xFF7e7e7e),
          height: 0.3,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Smoke Tobacco',
                    textScaleFactor: 1.0,
                    style: TextStyle(color: Color(0xFF949494), fontSize: 14),
                    textAlign: TextAlign.start,
                  ),
                  editSmokeFlag
                      ? _SmokeList()
                      : user.you_Smoke != null
                          ? InkWell(
                              onTap: () {
                                setState(() {
                                  editSmokeFlag = true;
                                });
                              },
                              child: Text(
                                user.you_Smoke!,
                                textScaleFactor: 1.0,
                                style: TextStyle(
                                    color: Color(0xFF949494), fontSize: 12),
                                textAlign: TextAlign.start,
                              ),
                            )
                          : SizedBox(),
                ],
              ),
              Align(
                alignment: Alignment.topRight,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      if (editSmokeFlag) {
                        editSmokeFlag = false;
                      } else {
                        editSmokeFlag = true;
                      }
                    });
                  },
                  child: Row(
                    children: [
                      Text(
                        'Edit',
                        textScaleFactor: 1.0,
                        style:
                            TextStyle(color: Color(0xFF949494), fontSize: 14),
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
                ),
              )
            ],
          ),
        ),
        Divider(
          color: Color(0xFF7e7e7e),
          height: 0.3,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Have Children',
                    textScaleFactor: 1.0,
                    style: TextStyle(color: Color(0xFF949494), fontSize: 14),
                    textAlign: TextAlign.start,
                  ),
                  editChildFlag
                      ? _ChildrenList()
                      : user.have_Children != null
                          ? InkWell(
                              onTap: () {
                                setState(() {
                                  editChildFlag = true;
                                });
                              },
                              child: Text(
                                user.have_Children!,
                                textScaleFactor: 1.0,
                                style: TextStyle(
                                    color: Color(0xFF949494), fontSize: 12),
                                textAlign: TextAlign.start,
                              ),
                            )
                          : SizedBox(),
                ],
              ),
              Align(
                alignment: Alignment.topRight,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      if (editChildFlag) {
                        editChildFlag = false;
                      } else {
                        editChildFlag = true;
                      }
                    });
                  },
                  child: Row(
                    children: [
                      Text(
                        'Edit',
                        textScaleFactor: 1.0,
                        style:
                            TextStyle(color: Color(0xFF949494), fontSize: 14),
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
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  var editSupportProFlag = false;
  var editQTwo = false;
  var editQThree = false;
  var editQFour = false;
  var editQFive = false;
  var editQSix = false;
  _Political() {
    return Column(children: [
      SizedBox(
        height: 5,
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
                  'Support Pro-Choice',
                  textScaleFactor: 1.0,
                  style: TextStyle(color: Color(0xFF949494), fontSize: 14),
                  textAlign: TextAlign.start,
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      if (editSupportProFlag) {
                        editSupportProFlag = false;
                      } else {
                        editSupportProFlag = true;
                        editQTwo = false;
                        editQThree = false;
                        editQFour = false;
                        editQFive = false;
                        editQSix = false;
                        _OneSliderValue = getQuestion(
                            user.where_do_you_stand.woman_Right_to_Choose);
                        // checkBoxOne = user.where_do_you_stand
                        //             .woman_Right_to_Choose_Deal_Breaker ==
                        //         "1"
                        //     ? true
                        //     : false;
                      }
                    });
                  },
                  child: Row(
                    children: [
                      Text(
                        'Edit',
                        textScaleFactor: 1.0,
                        style:
                            TextStyle(color: Color(0xFF949494), fontSize: 14),
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
            editSupportProFlag
                ? _Support_Pro(1)
                : InkWell(
                    onTap: () {
                      setState(() {
                        if (editSupportProFlag) {
                          editSupportProFlag = false;
                        } else {
                          editSupportProFlag = true;
                          editQTwo = false;
                          editQThree = false;
                          editQFour = false;
                          editQFive = false;
                          editQSix = false;
                          _OneSliderValue = getQuestion(
                              user.where_do_you_stand.woman_Right_to_Choose);
                          // checkBoxOne = user.where_do_you_stand
                          //             .woman_Right_to_Choose_Deal_Breaker ==
                          //         "1"
                          //     ? true
                          //     : false;
                        }
                      });
                    },
                    child: Text(
                      user.where_do_you_stand.woman_Right_to_Choose == ""
                          ? "3 out of 5"
                          : (int.parse(user.where_do_you_stand
                                          .woman_Right_to_Choose) +
                                      3)
                                  .toString() +
                              " out of 5",
                      textScaleFactor: 1.0,
                      style: TextStyle(color: Color(0xFF949494), fontSize: 12),
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
                  'Better Climate Legislation',
                  textScaleFactor: 1.0,
                  style: TextStyle(color: Color(0xFF949494), fontSize: 14),
                  textAlign: TextAlign.start,
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      if (editQTwo) {
                        editQTwo = false;
                      } else {
                        editQTwo = true;
                        editSupportProFlag = false;
                        editQThree = false;
                        editQFour = false;
                        editQFive = false;
                        editQSix = false;
                        _OneSliderValue = getQuestion(
                            user.where_do_you_stand.better_Climate_Legislation);
                        // checkBoxOne = user.where_do_you_stand
                        //             .better_Climate_Legislation_Deal_Breaker ==
                        //         "1"
                        //     ? true
                        //     : false;
                      }
                    });
                  },
                  child: Row(
                    children: [
                      Text(
                        'Edit',
                        textScaleFactor: 1.0,
                        style:
                            TextStyle(color: Color(0xFF949494), fontSize: 14),
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
            editQTwo
                ? _Support_Pro(2)
                : InkWell(
                    onTap: () {
                      setState(() {
                        if (editQTwo) {
                          editQTwo = false;
                        } else {
                          editQTwo = true;
                          editSupportProFlag = false;
                          editQThree = false;
                          editQFour = false;
                          editQFive = false;
                          editQSix = false;
                          _OneSliderValue = getQuestion(user
                              .where_do_you_stand.better_Climate_Legislation);
                          // checkBoxOne = user.where_do_you_stand
                          //             .better_Climate_Legislation_Deal_Breaker ==
                          //         "1"
                          //     ? true
                          //     : false;
                        }
                      });
                    },
                    child: Text(
                      user.where_do_you_stand.better_Climate_Legislation == ""
                          ? "0 out of 5"
                          : (int.parse(user.where_do_you_stand
                                          .better_Climate_Legislation) +
                                      3)
                                  .toString() +
                              " out of 5",
                      textScaleFactor: 1.0,
                      style: TextStyle(color: Color(0xFF949494), fontSize: 12),
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
                    'Expand LGBTQ+ Rights',
                    textScaleFactor: 1.0,
                    style: TextStyle(color: Color(0xFF949494), fontSize: 14),
                    textAlign: TextAlign.start,
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        if (editQThree) {
                          editQThree = false;
                        } else {
                          editQThree = true;
                          editSupportProFlag = false;
                          editQTwo = false;
                          editQFour = false;
                          editQFive = false;
                          editQSix = false;
                          _OneSliderValue = getQuestion(
                              user.where_do_you_stand.expanded_LGBTQ_Rights);
                          // checkBoxOne = user.where_do_you_stand
                          //             .expanded_LGBTQ_Rights_Deal_Breaker ==
                          //         "1"
                          //     ? true
                          //     : false;
                        }
                      });
                    },
                    child: Row(
                      children: [
                        Text(
                          'Edit',
                          textScaleFactor: 1.0,
                          style:
                              TextStyle(color: Color(0xFF949494), fontSize: 14),
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
              editQThree
                  ? _Support_Pro(3)
                  : InkWell(
                      onTap: () {
                        setState(() {
                          if (editQThree) {
                            editQThree = false;
                          } else {
                            editQThree = true;
                            editSupportProFlag = false;
                            editQTwo = false;
                            editQFour = false;
                            editQFive = false;
                            editQSix = false;
                            _OneSliderValue = getQuestion(
                                user.where_do_you_stand.expanded_LGBTQ_Rights);
                            // checkBoxOne = user.where_do_you_stand
                            //             .expanded_LGBTQ_Rights_Deal_Breaker ==
                            //         "1"
                            //     ? true
                            //     : false;
                          }
                        });
                      },
                      child: Text(
                        user.where_do_you_stand.expanded_LGBTQ_Rights == ""
                            ? "0 out of 5"
                            : (int.parse(user.where_do_you_stand
                                            .expanded_LGBTQ_Rights) +
                                        3)
                                    .toString() +
                                " out of 5",
                        textScaleFactor: 1.0,
                        style:
                            TextStyle(color: Color(0xFF949494), fontSize: 12),
                        textAlign: TextAlign.start,
                      ),
                    ),
            ],
          )),
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
                  'Stronger Gun Controls',
                  textScaleFactor: 1.0,
                  style: TextStyle(color: Color(0xFF949494), fontSize: 14),
                  textAlign: TextAlign.start,
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      if (editQFour) {
                        editQFour = false;
                      } else {
                        editQFour = true;
                        editSupportProFlag = false;
                        editQTwo = false;
                        editQThree = false;
                        editQFive = false;
                        editQSix = false;
                        _OneSliderValue = getQuestion(
                            user.where_do_you_stand.stronger_Gun_Controls);
                        // checkBoxOne = user.where_do_you_stand
                        //             .stronger_Gun_Controls_Deal_Breaker ==
                        //         "1"
                        //     ? true
                        //     : false;
                      }
                    });
                  },
                  child: Row(
                    children: [
                      Text(
                        'Edit',
                        textScaleFactor: 1.0,
                        style:
                            TextStyle(color: Color(0xFF949494), fontSize: 14),
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
            editQFour
                ? _Support_Pro(4)
                : InkWell(
                    onTap: () {
                      setState(() {
                        if (editQFour) {
                          editQFour = false;
                        } else {
                          editQFour = true;
                          editSupportProFlag = false;
                          editQTwo = false;
                          editQThree = false;
                          editQFive = false;
                          editQSix = false;
                          _OneSliderValue = getQuestion(
                              user.where_do_you_stand.stronger_Gun_Controls);
                          // checkBoxOne = user.where_do_you_stand
                          //             .stronger_Gun_Controls_Deal_Breaker ==
                          //         "1"
                          //     ? true
                          //     : false;
                        }
                      });
                    },
                    child: Text(
                      user.where_do_you_stand.stronger_Gun_Controls == ""
                          ? "0 out of 5"
                          : (int.parse(user.where_do_you_stand
                                          .stronger_Gun_Controls) +
                                      3)
                                  .toString() +
                              " out of 5",
                      textScaleFactor: 1.0,
                      style: TextStyle(color: Color(0xFF949494), fontSize: 12),
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
                    'Relaxed Immigration Laws',
                    textScaleFactor: 1.0,
                    style: TextStyle(color: Color(0xFF949494), fontSize: 14),
                    textAlign: TextAlign.start,
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        if (editQFive) {
                          editQFive = false;
                        } else {
                          editQFive = true;
                          editSupportProFlag = false;
                          editQTwo = false;
                          editQThree = false;
                          editQFour = false;
                          editQSix = false;
                          _OneSliderValue = getQuestion(
                              user.where_do_you_stand.softer_Immigration_Laws);
                          // checkBoxOne = user.where_do_you_stand
                          //             .softer_Immigration_Laws_Deal_Breaker ==
                          //         "1"
                          //     ? true
                          //     : false;
                        }
                      });
                    },
                    child: Row(
                      children: [
                        Text(
                          'Edit',
                          textScaleFactor: 1.0,
                          style:
                              TextStyle(color: Color(0xFF949494), fontSize: 14),
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
              editQFive
                  ? _Support_Pro(5)
                  : InkWell(
                      onTap: () {
                        setState(() {
                          if (editQFive) {
                            editQFive = false;
                          } else {
                            editQFive = true;
                            editSupportProFlag = false;
                            editQTwo = false;
                            editQThree = false;
                            editQFour = false;
                            editQSix = false;
                            _OneSliderValue = getQuestion(user
                                .where_do_you_stand.softer_Immigration_Laws);
                            // checkBoxOne = user.where_do_you_stand
                            //             .softer_Immigration_Laws_Deal_Breaker ==
                            //         "1"
                            //     ? true
                            //     : false;
                          }
                        });
                      },
                      child: Text(
                        user.where_do_you_stand.softer_Immigration_Laws == ""
                            ? "0 out of 5"
                            : (int.parse(user.where_do_you_stand
                                            .softer_Immigration_Laws) +
                                        3)
                                    .toString() +
                                " out of 5",
                        textScaleFactor: 1.0,
                        style:
                            TextStyle(color: Color(0xFF949494), fontSize: 12),
                        textAlign: TextAlign.start,
                      ),
                    ),
            ],
          )),
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
                  'Support same-sex marriage',
                  textScaleFactor: 1.0,
                  style: TextStyle(color: Color(0xFF949494), fontSize: 14),
                  textAlign: TextAlign.start,
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      if (editQSix) {
                        editQSix = false;
                      } else {
                        editQSix = true;
                        editSupportProFlag = false;
                        editQTwo = false;
                        editQThree = false;
                        editQFour = false;
                        editQFive = false;
                        _OneSliderValue = getQuestion(
                            user.where_do_you_stand.more_Religious_Freedoms);
                        // checkBoxOne = user.where_do_you_stand
                        //             .more_Religious_Freedoms_Deal_Breaker ==
                        //         "1"
                        //     ? true
                        //     : false;
                      }
                    });
                  },
                  child: Row(
                    children: [
                      Text(
                        'Edit',
                        textScaleFactor: 1.0,
                        style:
                            TextStyle(color: Color(0xFF949494), fontSize: 14),
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
            editQSix
                ? _Support_Pro(6)
                : InkWell(
                    onTap: () {
                      setState(() {
                        if (editQSix) {
                          editQSix = false;
                        } else {
                          editQSix = true;
                          editSupportProFlag = false;
                          editQTwo = false;
                          editQThree = false;
                          editQFour = false;
                          editQFive = false;
                          _OneSliderValue = getQuestion(
                              user.where_do_you_stand.more_Religious_Freedoms);
                          // checkBoxOne = user.where_do_you_stand
                          //             .more_Religious_Freedoms_Deal_Breaker ==
                          //         "1"
                          //     ? true
                          //     : false;
                        }
                      });
                    },
                    child: Text(
                      user.where_do_you_stand.more_Religious_Freedoms == ""
                          ? "0 out of 5"
                          : (int.parse(user.where_do_you_stand
                                          .more_Religious_Freedoms) +
                                      3)
                                  .toString() +
                              " out of 5",
                      textScaleFactor: 1.0,
                      style: TextStyle(color: Color(0xFF949494), fontSize: 12),
                      textAlign: TextAlign.start,
                    ),
                  ),
          ],
        ),
      )
    ]);
  }

  var editWorkFlag = false;
  var editTitleFlag = false;
  var editEduationalFlag = false;
  var editUniverciteslFlag = false;
  var editHeightFlag = false;
  var editWeightFlag = false;
  var editBodyTypeFlag = false;
  var editAstrologicalFlag = false;
  var editReligiousFlag = false;
  var editMarijuanaFlag = false;
  var editHomeTownFlag = false;
  var editCurrentHomeFlag = false;
  _Details() {
    return Column(
      children: [
        SizedBox(
          height: 5,
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
                    'Place of Employment',
                    textScaleFactor: 1.0,
                    style: TextStyle(color: Color(0xFF949494), fontSize: 14),
                    textAlign: TextAlign.start,
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        if (editWorkFlag) {
                          editWorkFlag = false;
                        } else {
                          editWorkFlag = true;
                        }
                      });
                    },
                    child: Row(
                      children: [
                        Text(
                          'Edit',
                          textScaleFactor: 1.0,
                          style:
                              TextStyle(color: Color(0xFF949494), fontSize: 14),
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
              editWorkFlag
                  ? _work()
                  : InkWell(
                      onTap: () {
                        setState(() {
                          if (editWorkFlag) {
                            editWorkFlag = false;
                          } else {
                            editWorkFlag = true;
                          }
                        });
                      },
                      child: Text(
                        user.your_details.work,
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
                    'Email',
                    textScaleFactor: 1.0,
                    style: TextStyle(color: Color(0xFF949494), fontSize: 14),
                    textAlign: TextAlign.start,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditEmailScreen(),
                        ),
                      ).then((value) {
                        user = MyAppState.currentUser!;
                        setState(() {});
                      });
                    },
                    child: Row(
                      children: [
                        Text(
                          'Edit',
                          textScaleFactor: 1.0,
                          style:
                              TextStyle(color: Color(0xFF949494), fontSize: 14),
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
              Text(
                user.email,
                textScaleFactor: 1.0,
                style: TextStyle(color: Color(0xFF949494), fontSize: 12),
                textAlign: TextAlign.start,
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
                    'Title',
                    textScaleFactor: 1.0,
                    style: TextStyle(color: Color(0xFF949494), fontSize: 14),
                    textAlign: TextAlign.start,
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        if (editTitleFlag) {
                          editTitleFlag = false;
                        } else {
                          editTitleFlag = true;
                        }
                      });
                    },
                    child: Row(
                      children: [
                        Text(
                          'Edit',
                          textScaleFactor: 1.0,
                          style:
                              TextStyle(color: Color(0xFF949494), fontSize: 14),
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
              editTitleFlag
                  ? _title()
                  : InkWell(
                      onTap: () {
                        setState(() {
                          if (editTitleFlag) {
                            editTitleFlag = false;
                          } else {
                            editTitleFlag = true;
                          }
                        });
                      },
                      child: Text(
                        user.your_details.title,
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
                    'Education Level',
                    textScaleFactor: 1.0,
                    style: TextStyle(color: Color(0xFF949494), fontSize: 14),
                    textAlign: TextAlign.start,
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        if (editEduationalFlag) {
                          editEduationalFlag = false;
                        } else {
                          editEduationalFlag = true;
                        }
                      });
                    },
                    child: Row(
                      children: [
                        Text(
                          'Edit',
                          textScaleFactor: 1.0,
                          style:
                              TextStyle(color: Color(0xFF949494), fontSize: 14),
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
              editEduationalFlag
                  ? _educational()
                  : InkWell(
                      onTap: () {
                        setState(() {
                          if (editEduationalFlag) {
                            editEduationalFlag = false;
                          } else {
                            editEduationalFlag = true;
                          }
                        });
                      },
                      child: Text(
                        user.your_details.educational_level,
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
                    'Universities',
                    textScaleFactor: 1.0,
                    style: TextStyle(color: Color(0xFF949494), fontSize: 14),
                    textAlign: TextAlign.start,
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        if (editUniverciteslFlag) {
                          editUniverciteslFlag = false;
                        } else {
                          editUniverciteslFlag = true;
                        }
                      });
                    },
                    child: Row(
                      children: [
                        Text(
                          'Edit',
                          textScaleFactor: 1.0,
                          style:
                              TextStyle(color: Color(0xFF949494), fontSize: 14),
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
              editUniverciteslFlag
                  ? _universites()
                  : InkWell(
                      onTap: () {
                        univercitesController.text =
                            user.your_details.univerties;
                        if (editUniverciteslFlag) {
                          editUniverciteslFlag = false;
                        } else {
                          editUniverciteslFlag = true;
                        }
                        setState(() {});
                      },
                      child: Text(
                        user.your_details.univerties != 'null'
                            ? user.your_details.univerties
                            : '',
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
                    'Height',
                    textScaleFactor: 1.0,
                    style: TextStyle(color: Color(0xFF949494), fontSize: 14),
                    textAlign: TextAlign.start,
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        if (editHeightFlag) {
                          editHeightFlag = false;
                        } else {
                          editHeightFlag = true;
                        }
                      });
                    },
                    child: Row(
                      children: [
                        Text(
                          'Edit',
                          textScaleFactor: 1.0,
                          style:
                              TextStyle(color: Color(0xFF949494), fontSize: 14),
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
              editHeightFlag
                  ? _height()
                  : InkWell(
                      onTap: () {
                        setState(() {
                          if (editHeightFlag) {
                            editHeightFlag = false;
                          } else {
                            editHeightFlag = true;
                          }
                        });
                      },
                      child: Text(
                        user.your_details.height,
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
                    'Weight',
                    textScaleFactor: 1.0,
                    style: TextStyle(color: Color(0xFF949494), fontSize: 14),
                    textAlign: TextAlign.start,
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        if (editWeightFlag) {
                          editWeightFlag = true;
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
                              TextStyle(color: Color(0xFF949494), fontSize: 14),
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
                            editWeightFlag = true;
                          } else {
                            editWeightFlag = true;
                          }
                        });
                      },
                      child: Text(
                        user.your_details.weight == ''
                            ? ''
                            : '${user.your_details.weight} lbs',
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
                    'Body Type',
                    textScaleFactor: 1.0,
                    style: TextStyle(color: Color(0xFF949494), fontSize: 14),
                    textAlign: TextAlign.start,
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        if (editBodyTypeFlag) {
                          editBodyTypeFlag = true;
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
                              TextStyle(color: Color(0xFF949494), fontSize: 14),
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
                            editBodyTypeFlag = true;
                          } else {
                            editBodyTypeFlag = true;
                          }
                        });
                      },
                      child: Text(
                        user.your_details.body_type,
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
                    'Astrological Sign',
                    textScaleFactor: 1.0,
                    style: TextStyle(color: Color(0xFF949494), fontSize: 14),
                    textAlign: TextAlign.start,
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        if (editAstrologicalFlag) {
                          editAstrologicalFlag = true;
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
                              TextStyle(color: Color(0xFF949494), fontSize: 14),
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
                  ? _astrologic()
                  : InkWell(
                      onTap: () {
                        setState(() {
                          if (editAstrologicalFlag) {
                            editAstrologicalFlag = true;
                          } else {
                            editAstrologicalFlag = true;
                          }
                        });
                      },
                      child: Text(
                        user.your_details.astrologic_sign,
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
                    'Religious Beliefs',
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
                              TextStyle(color: Color(0xFF949494), fontSize: 14),
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
                  ? _religoius()
                  : InkWell(
                      onTap: () {
                        religoiusController.text =
                            user.your_details.religiose_belief;
                        if (editReligiousFlag) {
                          editReligiousFlag = false;
                        } else {
                          editReligiousFlag = true;
                        }
                        setState(() {});
                      },
                      child: Text(
                        user.your_details.religiose_belief != 'null'
                            ? user.your_details.religiose_belief
                            : '',
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
                    'Use Marijuana',
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
                              TextStyle(color: Color(0xFF949494), fontSize: 14),
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
                  ? _marijaun()
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
                        user.your_details.use_marijuana,
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
                      'Home Town',
                      textScaleFactor: 1.0,
                      style: TextStyle(color: Color(0xFF949494), fontSize: 14),
                      textAlign: TextAlign.start,
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          if (editHomeTownFlag) {
                            editHomeTownFlag = false;
                          } else {
                            editHomeTownFlag = true;
                          }
                        });
                      },
                      child: Row(
                        children: [
                          Text(
                            'Edit',
                            textScaleFactor: 1.0,
                            style: TextStyle(
                                color: Color(0xFF949494), fontSize: 14),
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
                editHomeTownFlag
                    ? _homeTown()
                    : InkWell(
                        onTap: () {
                          homeTownController.text = user.your_details.home_town;
                          if (editHomeTownFlag) {
                            editHomeTownFlag = false;
                          } else {
                            editHomeTownFlag = true;
                          }
                          setState(() {});
                        },
                        child: Text(
                          user.your_details.home_town != 'null'
                              ? user.your_details.home_town
                              : '',
                          textScaleFactor: 1.0,
                          style:
                              TextStyle(color: Color(0xFF949494), fontSize: 12),
                          textAlign: TextAlign.start,
                        ),
                      ),
              ],
            )),
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
                    'Current Home',
                    textScaleFactor: 1.0,
                    style: TextStyle(color: Color(0xFF949494), fontSize: 14),
                    textAlign: TextAlign.start,
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        if (editCurrentHomeFlag) {
                          editCurrentHomeFlag = false;
                        } else {
                          editCurrentHomeFlag = true;
                        }
                      });
                    },
                    child: Row(
                      children: [
                        Text(
                          'Edit',
                          textScaleFactor: 1.0,
                          style:
                              TextStyle(color: Color(0xFF949494), fontSize: 14),
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
              editCurrentHomeFlag
                  ? _currentHome()
                  : InkWell(
                      onTap: () {
                        setState(() {
                          if (editCurrentHomeFlag) {
                            editCurrentHomeFlag = false;
                          } else {
                            editCurrentHomeFlag = true;
                          }
                        });
                      },
                      child: Text(
                        user.your_details.current_home,
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

  List<TextEditingController> controllers = [];
  List<bool> editFlags = [];
  _IceBreakers() {
    return Column(
      children: [
        SizedBox(
          height: 15,
        ),
        ListView.builder(
          itemCount: user.answeredQuestion.length,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.answeredQuestion[index]['question'],
                        textScaleFactor: 1.0,
                        style:
                            TextStyle(color: Color(0xFF949494), fontSize: 14),
                        textAlign: TextAlign.start,
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            if (editFlags[index]) {
                              editFlags[index] = false;
                            } else {
                              editFlags[index] = true;
                            }
                          });
                        },
                        child: Row(
                          children: [
                            Text(
                              'Edit',
                              textScaleFactor: 1.0,
                              style: TextStyle(
                                  color: Color(0xFF949494), fontSize: 14),
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
                  sizedBox5,
                  editFlags[index]
                      ? editFlagsView(index)
                      : Text(
                          user.answeredQuestion[index]['answer'],
                          textScaleFactor: 1.0,
                          style:
                              TextStyle(color: Color(0xFF949494), fontSize: 12),
                          textAlign: TextAlign.start,
                        ),
                  sizedBox10,
                  Divider(
                    color: Color(0xFF7e7e7e),
                    height: 0.3,
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget editFlagsView(int index) {
    return Row(
      children: [
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(top: 0.0, right: 10.0),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                shape: BoxShape.rectangle,
                border: Border.all(color: Colors.grey.shade200)),
            child: TextFormField(
              textAlignVertical: TextAlignVertical.center,
              textInputAction: TextInputAction.done,
              textCapitalization: TextCapitalization.words,
              style: TextStyle(fontSize: 14.0),
              controller: controllers[index],
              keyboardType: TextInputType.text,
              cursorColor: Colors.grey.shade500,
              textAlign: TextAlign.start,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 10, right: 10),
                hintText: '',
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
            showProgress(context, 'Saving changes...', false);
            user.answeredQuestion[index]['answer'] = controllers[index].text;
            User? updateUser = await FireStoreUtils.updateCurrentUser(user);
            hideProgress();
            if (updateUser != null) {
              this.user = updateUser;
              MyAppState.currentUser = user;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  duration: Duration(seconds: 3),
                  content: Text(
                    'Settings saved successfully',
                    style: TextStyle(fontSize: 17),
                  ),
                ),
              );
              setState(() {
                editFlags[index] = false;
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

  // _onDistanceRadiusClick() {
  //   final action = CupertinoActionSheet(
  //     message: Text(
  //       'Distance Radius',
  //       style: TextStyle(fontSize: 15.0),
  //     ),
  //     actions: <Widget>[
  //       CupertinoActionSheetAction(
  //         child: Text('5 Miles'),
  //         isDefaultAction: false,
  //         onPressed: () {
  //           Navigator.pop(context);
  //           radius = '5';
  //           setState(() async {
  //             _updateMails();
  //           });
  //         },
  //       ),
  //       CupertinoActionSheetAction(
  //         child: Text('10 Miles'),
  //         isDestructiveAction: false,
  //         onPressed: () {
  //           Navigator.pop(context);
  //           radius = '10';
  //           setState(() {
  //             _updateMails();
  //           });
  //         },
  //       ),
  //       CupertinoActionSheetAction(
  //         child: Text('15 Miles'),
  //         isDestructiveAction: false,
  //         onPressed: () {
  //           Navigator.pop(context);
  //           radius = '15';
  //           setState(() {
  //             _updateMails();
  //           });
  //         },
  //       ),
  //       CupertinoActionSheetAction(
  //         child: Text('20 Miles'),
  //         isDestructiveAction: false,
  //         onPressed: () {
  //           Navigator.pop(context);
  //           radius = '20';
  //           setState(() {
  //             _updateMails();
  //           });
  //         },
  //       ),
  //       CupertinoActionSheetAction(
  //         child: Text('25 Miles'),
  //         isDestructiveAction: false,
  //         onPressed: () {
  //           Navigator.pop(context);
  //           radius = '25';
  //           setState(() {
  //             _updateMails();
  //           });
  //         },
  //       ),
  //       CupertinoActionSheetAction(
  //         child: Text('50 Miles'),
  //         isDestructiveAction: false,
  //         onPressed: () {
  //           Navigator.pop(context);
  //           radius = '50';
  //           setState(() {
  //             _updateMails();
  //           });
  //         },
  //       ),
  //       CupertinoActionSheetAction(
  //         child: Text('100 Miles'),
  //         isDestructiveAction: false,
  //         onPressed: () {
  //           Navigator.pop(context);
  //           radius = '100';
  //           setState(() {
  //             _updateMails();
  //           });
  //         },
  //       ),
  //       CupertinoActionSheetAction(
  //         child: Text('Unlimited'),
  //         isDestructiveAction: false,
  //         onPressed: () {
  //           Navigator.pop(context);
  //           radius = '';
  //           setState(() {
  //             _updateMails();
  //           });
  //         },
  //       ),
  //     ],
  //     cancelButton: CupertinoActionSheetAction(
  //       child: Text('Cancel'),
  //       onPressed: () {
  //         Navigator.pop(context);
  //       },
  //     ),
  //   );
  //   showCupertinoModalPopup(context: context, builder: (context) => action);
  // }

  // _updateMails() async {
  //   showProgress(context, 'Saving changes...', true);
  //   user.settings.distanceRadius = radius;
  //   User? updateUser = await FireStoreUtils.updateCurrentUser(user);
  //   hideProgress();
  //   if (updateUser != null) {
  //     this.user = updateUser;
  //     MyAppState.currentUser = user;
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         duration: Duration(seconds: 3),
  //         content: Text(
  //           'Settings saved successfully',
  //           style: TextStyle(fontSize: 17),
  //         ),
  //       ),
  //     );
  //   }
  // }

  updateBio() async {
    showProgress(context, 'Saving changes...', false);
    user.bio = bioController.text;
    User? updateUser = await FireStoreUtils.updateCurrentUser(user);
    hideProgress();
    if (updateUser != null) {
      this.user = updateUser;
      MyAppState.currentUser = user;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(seconds: 3),
          content: Text(
            'Settings saved successfully',
            style: TextStyle(fontSize: 17),
          ),
        ),
      );
      setState(() {
        editNameFlag = false;
      });
    }
  }

  _updateFirstName() async {
    showProgress(context, 'Saving changes...', false);
    user.firstName = nameController.text;
    User? updateUser = await FireStoreUtils.updateCurrentUser(user);
    hideProgress();
    if (updateUser != null) {
      this.user = updateUser;
      MyAppState.currentUser = user;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(seconds: 3),
          content: Text(
            'Settings saved successfully',
            style: TextStyle(fontSize: 17),
          ),
        ),
      );
      setState(() {
        editNameFlag = false;
      });
    }
  }

  _updateGender(String name) async {
    showProgress(context, 'Saving changes...', false);
    user.your_gender = name;
    User? updateUser = await FireStoreUtils.updateCurrentUser(user);
    hideProgress();
    if (updateUser != null) {
      this.user = updateUser;
      MyAppState.currentUser = user;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(seconds: 3),
          content: Text(
            'Settings saved successfully',
            style: TextStyle(fontSize: 17),
          ),
        ),
      );
      setState(() {
        editGenderFlag = false;
      });
    }
  }

  _UpdateBithDate(BuildContext context) async {
    DateTime? datePicked;
    await showCupertinoModalPopup<void>(
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
          child: CupertinoDatePicker(
            initialDateTime: DateFormat("MM/dd/yyyy").parse(user.birthdate),
            maximumDate: DateTime.now(),
            mode: CupertinoDatePickerMode.date,
            dateOrder: DatePickerDateOrder.dmy,
            onDateTimeChanged: (DateTime newDate) {
              datePicked = newDate;
              setState(() {});
            },
          ),
        ),
      ),
    );
    if (datePicked != null) {
      showProgress(context, 'Saving changes...', false);
      user.birthdate = DateFormat('MM/dd/yyyy').format(datePicked!);
      User? updateUser = await FireStoreUtils.updateCurrentUser(user);
      hideProgress();
      if (updateUser != null) {
        this.user = updateUser;
        MyAppState.currentUser = user;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: Duration(seconds: 3),
            content: Text(
              'Settings saved successfully',
              style: TextStyle(fontSize: 17),
            ),
          ),
        );
        setState(() {
          editNameFlag = false;
        });
      }
    }
  }

  _PreferPronounItem(String _list, int index) {
    return Container(
      // color: Colors.white,
      child: Padding(
          padding: const EdgeInsets.only(left: 5, top: 0, right: 5, bottom: 0),
          child: Column(
            children: [
              InkWell(
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 5, top: 5, right: 5, bottom: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 20,
                        child: Transform.scale(
                          scale: 1.3,
                          child: Checkbox(
                              value: selection == _list,
                              activeColor: Color(0xFF66BB6A),
                              onChanged: (bool? newValue) {
                                setState(() async {
                                  showProgress(
                                      context, 'Saving changes...', false);
                                  user.preferPronoun = _list;
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
                                          'Settings saved successfully',
                                          style: TextStyle(fontSize: 17),
                                        ),
                                      ),
                                    );
                                    setState(() {
                                      editPreferPronounFlag = false;
                                    });
                                  }
                                });
                              }),
                        ),
                      ),
                      /*Visibility(
                        visible:SelectedIndex==index,child: Icon(Icons.check,color: Colors.blue,)),*/
                      Padding(
                        padding: const EdgeInsets.only(top: 0, bottom: 0),
                        child: Text(
                          _list,
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
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

  _SexualityItem(String _list, int index) {
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
                              value: user.your_Sexuality == _list,
                              activeColor: Color(0xFF66BB6A),
                              onChanged: (bool? newValue) {
                                setState(() async {
                                  showProgress(
                                      context, 'Saving changes...', false);
                                  user.your_Sexuality = _list;
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
                                          'Settings saved successfully',
                                          style: TextStyle(fontSize: 17),
                                        ),
                                      ),
                                    );
                                    setState(() {
                                      editSexualityFlag = false;
                                    });
                                  }
                                });
                              }),
                        ),
                      ),
                      /*Visibility(
                        visible:SelectedIndex==index,child: Icon(Icons.check,color: Colors.blue,)),*/
                      Padding(
                        padding: const EdgeInsets.only(top: 0, bottom: 0),
                        child: Text(
                          _list,
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

  _EthnicityItem(String _list, int index) {
    return Container(
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
                              value: user.your_Ethnicity == _list,
                              activeColor: Color(0xFF66BB6A),
                              onChanged: (bool? newValue) {
                                setState(() async {
                                  showProgress(
                                      context, 'Saving changes...', false);
                                  user.your_Ethnicity = _list;
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
                                          'Settings saved successfully',
                                          style: TextStyle(fontSize: 17),
                                        ),
                                      ),
                                    );
                                    setState(() {
                                      editEthnicityFlag = false;
                                    });
                                  }
                                });
                              }),
                        ),
                      ),
                      /*Visibility(
                        visible:SelectedIndex==index,child: Icon(Icons.check,color: Colors.blue,)),*/
                      Flexible(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 0, bottom: 0),
                          child: Text(_list,
                              textScaleFactor: 1.0,
                              style:
                                  TextStyle(fontSize: 12, color: Colors.black)),
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

  _DrinkList() {
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                        value: user.you_Drink == 'No',
                        activeColor: Color(0xFF66BB6A),
                        onChanged: (bool? newValue) {
                          setState(() {
                            _updateDrink('No');
                          });
                        }),
                  ),
                ),
                Text(
                  'Never',
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
                        value: user.you_Drink == 'Socially',
                        activeColor: Color(0xFF66BB6A),
                        onChanged: (bool? newValue) {
                          setState(() {
                            _updateDrink('Socially');
                          });
                        }),
                  ),
                ),
                Text(
                  'Socially',
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
                        value: user.you_Drink == 'Frequently',
                        activeColor: Color(0xFF66BB6A),
                        onChanged: (bool? newValue) {
                          setState(() {
                            _updateDrink('Frequently');
                          });
                        }),
                  ),
                ),
                Text(
                  'Frequently',
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
                        value: user.you_Drink == 'No Preference',
                        activeColor: Color(0xFF66BB6A),
                        onChanged: (bool? newValue) {
                          setState(() {
                            _updateDrink('No Preference');
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
      ),
    );
  }

  _updateDrink(String name) async {
    showProgress(context, 'Saving changes...', false);
    user.you_Drink = name;
    User? updateUser = await FireStoreUtils.updateCurrentUser(user);
    hideProgress();
    if (updateUser != null) {
      this.user = updateUser;
      MyAppState.currentUser = user;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(seconds: 3),
          content: Text(
            'Settings saved successfully',
            style: TextStyle(fontSize: 17),
          ),
        ),
      );
      setState(() {
        editDrinkFlag = false;
      });
    }
  }

  _SmokeList() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                      value: user.you_Smoke == 'No',
                      activeColor: Color(0xFF66BB6A),
                      onChanged: (bool? newValue) {
                        setState(() {
                          _updateSmoke('No');
                        });
                      }),
                ),
              ),
              Text(
                'Never',
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
                      value: user.you_Smoke == 'Socially',
                      activeColor: Color(0xFF66BB6A),
                      onChanged: (bool? newValue) {
                        setState(() {
                          _updateSmoke('Socially');
                        });
                      }),
                ),
              ),
              Text(
                'Socially',
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
                      value: user.you_Smoke == 'Frequently',
                      activeColor: Color(0xFF66BB6A),
                      onChanged: (bool? newValue) {
                        setState(() {
                          _updateSmoke('Frequently');
                        });
                      }),
                ),
              ),
              Text(
                'Frequently',
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
                      value: user.you_Smoke == 'No Preference',
                      activeColor: Color(0xFF66BB6A),
                      onChanged: (bool? newValue) {
                        setState(() {
                          _updateSmoke('No Preference');
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
    );
  }

  _updateSmoke(String name) async {
    showProgress(context, 'Saving changes...', false);
    user.you_Smoke = name;
    User? updateUser = await FireStoreUtils.updateCurrentUser(user);
    hideProgress();
    if (updateUser != null) {
      this.user = updateUser;
      MyAppState.currentUser = user;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(seconds: 3),
          content: Text(
            'Settings saved successfully',
            style: TextStyle(fontSize: 17),
          ),
        ),
      );
      setState(() {
        editSmokeFlag = false;
      });
    }
  }

  _ChildrenList() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
                    value: user.have_Children == 'Someday',
                    activeColor: Color(0xFF66BB6A),
                    onChanged: (bool? newValue) {
                      setState(() {
                        _updateChild("Someday");
                      });
                    }),
              ),
            ),
            Text(
              'Someday',
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
                    value: user.have_Children == "Don't want",
                    activeColor: Color(0xFF66BB6A),
                    onChanged: (bool? newValue) {
                      setState(() {
                        _updateChild("Don't want");
                      });
                    }),
              ),
            ),
            Text(
              "Don't want",
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
                    value: user.have_Children == "Have & want more",
                    activeColor: Color(0xFF66BB6A),
                    onChanged: (bool? newValue) {
                      setState(() {
                        _updateChild("Have & want more");
                      });
                    }),
              ),
            ),
            Text(
              'Have & want more',
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
                    value: user.have_Children == "Have & do not want more",
                    activeColor: Color(0xFF66BB6A),
                    onChanged: (bool? newValue) {
                      setState(() {
                        _updateChild("Have & do not want more");
                      });
                    }),
              ),
            ),
            Text(
              'Have & do not want more',
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
                    value: user.have_Children == "Not sure yet",
                    activeColor: Color(0xFF66BB6A),
                    onChanged: (bool? newValue) {
                      setState(() {
                        _updateChild("Not sure yet");
                      });
                    }),
              ),
            ),
            Text(
              'Not sure yet',
              textScaleFactor: 1.0,
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
      ],
    );
  }

  _updateChild(String name) async {
    showProgress(context, 'Saving changes...', false);
    user.have_Children = name;
    User? updateUser = await FireStoreUtils.updateCurrentUser(user);
    hideProgress();
    if (updateUser != null) {
      this.user = updateUser;
      MyAppState.currentUser = user;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(seconds: 3),
          content: Text(
            'Settings saved successfully',
            style: TextStyle(fontSize: 17),
          ),
        ),
      );
      setState(() {
        editChildFlag = false;
      });
    }
  }

  double getQuestion(String value) {
    if (value == "-2") {
      return 0;
    } else if (value == "-1") {
      return 4;
    } else if (value == "0") {
      return 8;
    } else if (value == "1") {
      return 12;
    } else {
      return 16;
    }
  }

  String setQuestion(double value) {
    if (value == 0) {
      return "-2";
    } else if (value == 4) {
      return "-1";
    } else if (value == 8) {
      return "0";
    } else if (value == 12) {
      return "1";
    } else {
      return "2";
    }
  }

  _Support_Pro(int one) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Container(
          color: Color(0xFFf3fbff),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 10.0, top: 5, bottom: 10),
                child: Align(
                  alignment: Alignment.topRight,
                  child: InkWell(
                    onTap: () async {
                      showProgress(context, 'Saving changes...', false);
                      if (one == 1) {
                        user.where_do_you_stand.woman_Right_to_Choose =
                            setQuestion(_OneSliderValue);
                        // user.where_do_you_stand
                        //         .woman_Right_to_Choose_Deal_Breaker =
                        //     !checkBoxOne ? "0" : "1";
                      } else if (one == 2) {
                        user.where_do_you_stand.better_Climate_Legislation =
                            setQuestion(_OneSliderValue);
                        // user.where_do_you_stand
                        //         .better_Climate_Legislation_Deal_Breaker =
                        //     !checkBoxOne ? "0" : "1";
                      } else if (one == 3) {
                        user.where_do_you_stand.expanded_LGBTQ_Rights =
                            setQuestion(_OneSliderValue);
                        // user.where_do_you_stand
                        //         .expanded_LGBTQ_Rights_Deal_Breaker =
                        //     !checkBoxOne ? "0" : "1";
                      } else if (one == 4) {
                        user.where_do_you_stand.stronger_Gun_Controls =
                            setQuestion(_OneSliderValue);
                        // user.where_do_you_stand
                        //         .stronger_Gun_Controls_Deal_Breaker =
                        //     !checkBoxOne ? "0" : "1";
                      } else if (one == 5) {
                        user.where_do_you_stand.softer_Immigration_Laws =
                            setQuestion(_OneSliderValue);
                        // user.where_do_you_stand
                        //         .softer_Immigration_Laws_Deal_Breaker =
                        //     !checkBoxOne ? "0" : "1";
                      } else {
                        user.where_do_you_stand.more_Religious_Freedoms =
                            setQuestion(_OneSliderValue);
                        // user.where_do_you_stand
                        //         .more_Religious_Freedoms_Deal_Breaker =
                        //     !checkBoxOne ? "0" : "1";
                      }

                      User? updateUser =
                          await FireStoreUtils.updateCurrentUser(user);
                      hideProgress();
                      if (updateUser != null) {
                        this.user = updateUser;
                        MyAppState.currentUser = user;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            duration: Duration(seconds: 3),
                            content: Text(
                              'Settings saved successfully',
                              style: TextStyle(fontSize: 17),
                            ),
                          ),
                        );
                        setState(() {
                          editSupportProFlag = false;
                          editQTwo = false;
                          editQThree = false;
                          editQFour = false;
                          editQFive = false;
                          editQSix = false;
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
                    left: 10, top: 0, right: 10, bottom: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Fully\nAgainst",
                      textScaleFactor: 1.0,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black, fontSize: 10.0),
                    ),
                    Text(
                      "Against",
                      textScaleFactor: 1.0,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black, fontSize: 10.0),
                    ),
                    Text(
                      "Neutral",
                      textScaleFactor: 1.0,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black, fontSize: 10.0),
                    ),
                    Text(
                      "Support",
                      textScaleFactor: 1.0,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black, fontSize: 10.0),
                    ),
                    Text(
                      "Fully\nSupport",
                      textScaleFactor: 1.0,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black, fontSize: 10.0),
                    ),
                  ],
                ),
              ),
              SfSlider(
                value: _OneSliderValue,
                max: 16,
                interval: 4,
                stepSize: 4,
                showTicks: true,
                thumbIcon: Container(
                  width: 10.0,
                  height: 10.0,
                  decoration: new BoxDecoration(
                    color: Color(COLOR_BLUE_BUTTON),
                    shape: BoxShape.circle,
                  ),
                ),
                activeColor: Colors.grey,
                inactiveColor: Colors.grey,
                onChanged: (dynamic value) {
                  print(value);
                  setState(() {
                    _OneSliderValue = value;
                  });
                },
              ),
              // Padding(
              //   padding: const EdgeInsets.only(bottom: 8.0),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [
              //       Text(
              //         'Deal Breaker :',
              //         textScaleFactor: 1.0,
              //         style: TextStyle(fontSize: 12),
              //       ),
              //       SizedBox(
              //         height: 20,
              //         child: Transform.scale(
              //           scale: 1.3,
              //           child: Checkbox(
              //               value: checkBoxOne,
              //               activeColor: Color(0xFF66BB6A),
              //               onChanged: (bool? newValue) {
              //                 setState(() {
              //                   checkBoxOne = newValue!;
              //                 });
              //               }),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
            ],
          )),
    );
  }

  final workController = TextEditingController();

  _work() {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 0.0, right: 10.0),
          child: Container(
            width: 250,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                shape: BoxShape.rectangle,
                border: Border.all(color: Colors.grey.shade200)),
            child: TextFormField(
              textAlignVertical: TextAlignVertical.center,
              style: TextStyle(fontSize: 18.0),
              controller: workController,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.done,
              textCapitalization: TextCapitalization.words,
              cursorColor: Colors.grey.shade500,
              textAlign: TextAlign.start,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 10, right: 10),
                hintText: '',
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
            showProgress(context, 'Saving changes...', false);
            user.your_details.work = workController.text;
            User? updateUser = await FireStoreUtils.updateCurrentUser(user);
            hideProgress();
            if (updateUser != null) {
              this.user = updateUser;
              MyAppState.currentUser = user;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  duration: Duration(seconds: 3),
                  content: Text(
                    'Settings saved successfully',
                    style: TextStyle(fontSize: 17),
                  ),
                ),
              );
              setState(() {
                editWorkFlag = false;
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

  final titleController = TextEditingController();
  _title() {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 0.0, right: 10.0),
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
              controller: titleController,
              keyboardType: TextInputType.text,
              cursorColor: Colors.grey.shade500,
              textAlign: TextAlign.start,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 10, right: 10),
                hintText: '',
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
            showProgress(context, 'Saving changes...', false);
            user.your_details.title = titleController.text;
            User? updateUser = await FireStoreUtils.updateCurrentUser(user);
            hideProgress();
            if (updateUser != null) {
              this.user = updateUser;
              MyAppState.currentUser = user;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  duration: Duration(seconds: 3),
                  content: Text(
                    'Settings saved successfully',
                    style: TextStyle(fontSize: 17),
                  ),
                ),
              );
              setState(() {
                editTitleFlag = false;
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

  final educationController = TextEditingController();
  _educational() {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 0.0, right: 10.0),
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
                hintText: '',
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
            showProgress(context, 'Saving changes...', false);
            user.your_details.educational_level = educationController.text;
            User? updateUser = await FireStoreUtils.updateCurrentUser(user);
            hideProgress();
            if (updateUser != null) {
              this.user = updateUser;
              MyAppState.currentUser = user;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  duration: Duration(seconds: 3),
                  content: Text(
                    'Settings saved successfully',
                    style: TextStyle(fontSize: 17),
                  ),
                ),
              );
              setState(() {
                editEduationalFlag = false;
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

  final univercitesController = TextEditingController();
  _universites() {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 10.0, right: 10.0),
            child: DropdownSearch<Map<String, dynamic>>(
              selectedItem: collegeMap,
              itemAsString: (Map<String, dynamic> u) => u['university_name'],
              items: uniList,
              // dropdownDecoratorProps: DropDownDecoratorProps(
              dropdownSearchDecoration: InputDecoration(
                hintText: 'Enter your college',
                isDense: true,
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.blue,
                  ),
                ),
              ),
              // ),
              onChanged: (Map<String, dynamic>? data) {
                if (data != null) {
                  univercitesController.text = data['university_name'];
                  collegeMap = data;
                }
                setState(() {});
              },
              popupProps: PopupProps.menu(
                showSearchBox: true,
                searchFieldProps: TextFieldProps(
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: 'Enter University',
                    isDense: true,
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        InkWell(
          onTap: () async {
            showProgress(context, 'Saving changes...', false);
            user.your_details.univerties = univercitesController.text.isEmpty
                ? user.your_details.univerties
                : univercitesController.text;
            User? updateUser = await FireStoreUtils.updateCurrentUser(user);
            hideProgress();
            if (updateUser != null) {
              this.user = updateUser;
              MyAppState.currentUser = user;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  duration: Duration(seconds: 3),
                  content: Text(
                    'Settings saved successfully',
                    style: TextStyle(fontSize: 17),
                  ),
                ),
              );
              setState(() {
                editUniverciteslFlag = false;
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

  double height = 100.0;
  final heightController = TextEditingController();
  _height() {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 0.0, right: 10.0),
          child: Slider(
              value: height,
              min: 70,
              max: 241,
              onChanged: (value) {
                setState(() {
                  height = value;
                  heightController.text =
                      "${((height / 2.54) / 12).ceil()}'${((height / 2.54) % 12).ceil()}''";
                });
              }),
        ),
        Text(
          heightController.text,
        ),
        SizedBox(
          width: 10,
        ),
        InkWell(
          onTap: () async {
            showProgress(context, 'Saving changes...', false);
            user.your_details.height = heightController.text;
            User? updateUser = await FireStoreUtils.updateCurrentUser(user);
            hideProgress();
            if (updateUser != null) {
              this.user = updateUser;
              MyAppState.currentUser = user;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  duration: Duration(seconds: 3),
                  content: Text(
                    'Settings saved successfully',
                    style: TextStyle(fontSize: 17),
                  ),
                ),
              );
              setState(() {
                editHeightFlag = false;
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
          padding: const EdgeInsets.only(top: 0.0, right: 10.0),
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
              controller: weightController,
              keyboardType: TextInputType.number,
              cursorColor: Colors.grey.shade500,
              textAlign: TextAlign.start,
              maxLength: 3,
              decoration: InputDecoration(
                counterText: '',
                contentPadding: EdgeInsets.all(10),
                floatingLabelBehavior: FloatingLabelBehavior.always,
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
            showProgress(context, 'Saving changes...', false);
            user.your_details.weight = weightController.text;
            User? updateUser = await FireStoreUtils.updateCurrentUser(user);
            hideProgress();
            if (updateUser != null) {
              this.user = updateUser;
              MyAppState.currentUser = user;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  duration: Duration(seconds: 3),
                  content: Text(
                    'Settings saved successfully',
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
          padding: const EdgeInsets.only(top: 0.0, right: 10.0),
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
                hintText: '',
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
            showProgress(context, 'Saving changes...', false);
            user.your_details.body_type = bodyTypeController.text;
            User? updateUser = await FireStoreUtils.updateCurrentUser(user);
            hideProgress();
            if (updateUser != null) {
              this.user = updateUser;
              MyAppState.currentUser = user;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  duration: Duration(seconds: 3),
                  content: Text(
                    'Settings saved successfully',
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

  final astrologicController = TextEditingController();
  _astrologic() {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 0.0, right: 10.0),
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
              controller: astrologicController,
              keyboardType: TextInputType.text,
              cursorColor: Colors.grey.shade500,
              textAlign: TextAlign.start,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 10, right: 10),
                hintText: '',
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
            showProgress(context, 'Saving changes...', false);
            user.your_details.astrologic_sign = astrologicController.text;
            User? updateUser = await FireStoreUtils.updateCurrentUser(user);
            hideProgress();
            if (updateUser != null) {
              this.user = updateUser;
              MyAppState.currentUser = user;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  duration: Duration(seconds: 3),
                  content: Text(
                    'Settings saved successfully',
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

  final religoiusController = TextEditingController();
  _religoius() {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 10.0, right: 10.0),
            child: DropdownSearch<String>(
              items: [
                "Agnostic",
                "Atheist",
                "Buddhist",
                "Catholic",
                "Christian",
                "Hindu",
                "Jain",
                "Jewish",
                "Mormon",
                "Muslim",
                "Sikh",
                "Spiritual",
                "Zoroastrian",
                "Other",
                "No Preference",
              ],
              // dropdownDecoratorProps: DropDownDecoratorProps(
              dropdownSearchDecoration: InputDecoration(
                hintText: 'Select your religion',
                isDense: true,
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.blue,
                  ),
                ),
                // ),
              ),
              onChanged: (String? value) {
                if (value != null) {
                  religoiusController.text = value;
                }
              },
              popupProps: PopupProps.menu(
                showSearchBox: true,
                searchFieldProps: TextFieldProps(
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: 'Enter Religion',
                    isDense: true,
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        InkWell(
          onTap: () async {
            showProgress(context, 'Saving changes...', false);
            user.your_details.religiose_belief =
                religoiusController.text.isEmpty
                    ? user.your_details.religiose_belief
                    : religoiusController.text;
            User? updateUser = await FireStoreUtils.updateCurrentUser(user);
            hideProgress();
            if (updateUser != null) {
              this.user = updateUser;
              MyAppState.currentUser = user;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  duration: Duration(seconds: 3),
                  content: Text(
                    'Settings saved successfully',
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
        )
      ],
    );
  }

  final marijaController = TextEditingController();
  _marijaun() {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 0.0, right: 10.0),
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
              controller: marijaController,
              keyboardType: TextInputType.text,
              cursorColor: Colors.grey.shade500,
              textAlign: TextAlign.start,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 10, right: 10),
                hintText: '',
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
            showProgress(context, 'Saving changes...', false);
            user.your_details.use_marijuana = marijaController.text;
            User? updateUser = await FireStoreUtils.updateCurrentUser(user);
            hideProgress();
            if (updateUser != null) {
              this.user = updateUser;
              MyAppState.currentUser = user;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  duration: Duration(seconds: 3),
                  content: Text(
                    'Settings saved successfully',
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

  final homeTownController = TextEditingController();
  _homeTown() {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 10.0, right: 10.0),
            child: DropdownSearch<Map<String, dynamic>>(
              items: cityList,
              selectedItem: homwtownMap,
              itemAsString: (Map<String, dynamic> u) =>
                  u['city'] + ', ' + u['state'],
              // dropdownDecoratorProps: DropDownDecoratorProps(
              dropdownSearchDecoration: InputDecoration(
                hintText: 'Enter your hometown',
                isDense: true,
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.blue,
                  ),
                ),
                // ),
              ),
              onChanged: (Map<String, dynamic>? data) {
                if (data != null) {
                  homeTownController.text = data['city'];
                  homwtownMap = data;
                }
                setState(() {});
              },
              popupProps: PopupProps.menu(
                showSearchBox: true,
                searchFieldProps: TextFieldProps(
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: 'Enter Hometown',
                    isDense: true,
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        InkWell(
          onTap: () async {
            showProgress(context, 'Saving changes...', false);
            user.your_details.home_town = homeTownController.text.isEmpty
                ? user.your_details.home_town
                : homeTownController.text;
            User? updateUser = await FireStoreUtils.updateCurrentUser(user);
            hideProgress();
            if (updateUser != null) {
              this.user = updateUser;
              MyAppState.currentUser = user;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  duration: Duration(seconds: 3),
                  content: Text(
                    'Settings saved successfully',
                    style: TextStyle(fontSize: 17),
                  ),
                ),
              );
              setState(() {
                editHomeTownFlag = false;
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

  final currentHomeController = TextEditingController();
  _currentHome() {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 0.0, right: 10.0),
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
              controller: currentHomeController,
              keyboardType: TextInputType.text,
              cursorColor: Colors.grey.shade500,
              textAlign: TextAlign.start,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 10, right: 10),
                hintText: '',
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
            showProgress(context, 'Saving changes...', false);
            user.your_details.current_home = currentHomeController.text;
            User? updateUser = await FireStoreUtils.updateCurrentUser(user);
            hideProgress();
            if (updateUser != null) {
              this.user = updateUser;
              MyAppState.currentUser = user;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  duration: Duration(seconds: 3),
                  content: Text(
                    'Settings saved successfully',
                    style: TextStyle(fontSize: 17),
                  ),
                ),
              );
              setState(() {
                editCurrentHomeFlag = false;
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

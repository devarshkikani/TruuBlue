import 'package:cached_network_image/cached_network_image.dart';
import 'package:dating/constants.dart';
import 'package:dating/model/User.dart';
import 'package:dating/services/FirebaseHelper.dart';
import 'package:dating/services/helper.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ExpireMatchsScreen extends StatefulWidget {
  final User user;
  const ExpireMatchsScreen({Key? key, required this.user}) : super(key: key);

  @override
  _ExpireMatchsScreenState createState() => _ExpireMatchsScreenState();
}

class _ExpireMatchsScreenState extends State<ExpireMatchsScreen> {
  late User user;
  final fireStoreUtils = FireStoreUtils();
  late Future<List<User>> _matchesFuture;
  @override
  void initState() {
    super.initState();
    user = widget.user;
    fireStoreUtils.getBlocks().listen((shouldRefresh) {
      if (shouldRefresh) {
        setState(() {});
      }
    });
    _matchesFuture = fireStoreUtils.getMatchedUserObject(user.userID);
  }
  @override
  Widget build(BuildContext context) {
    var scrWidth = MediaQuery.of(context).size.width;
    var scrHeight = MediaQuery.of(context).size.height;
    final orientation = MediaQuery.of(context).orientation;
    return FutureBuilder<List<User>>(
      future: _matchesFuture,
      initialData: [],
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting)
          return Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height-200,
            child: Center(
              child: CircularProgressIndicator.adaptive(
                valueColor:
                AlwaysStoppedAnimation<Color>(Color(COLOR_ACCENT)),
              ),
            ),
          );
        if (!snap.hasData || (snap.data?.isEmpty ?? true)) {
          return SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height-200,
            child: Center(
              child: Text(
                'No Matches found.'.tr(),
                style: TextStyle(fontSize: 18),
              ),
            ),
          );
        } else {
          return Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height-200,
            child: ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: snap.data!.length,
                itemBuilder: (context, index) {
                  final homeConversationModel = snap.data![index];

                  return fireStoreUtils.validateIfUserBlocked(
                      homeConversationModel.userID)
                      ? Container(
                    width: 0,
                    height: 0,
                  )
                      : Padding(
                    padding: const EdgeInsets.only(
                        left: 16.0, right: 16, top: 8, bottom: 8),
                    child: _buildConversationRow(homeConversationModel),
                  );

                }),
          );
        }
      },
    );
  }
  Widget _buildConversationRow(User homeConversationModel) {
    String user1Image = '';
    String user2Image = '';
    if (homeConversationModel!=null) {
      user1Image = homeConversationModel.profilePictureURL;
      user2Image = homeConversationModel.profilePictureURL;
    }
    return
      InkWell(
        onTap: () {
          // push(context,
          //   ChatScreen(homeConversationModel: homeConversationModel));
        },
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                children: <Widget>[
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: <Widget>[
                      ColorFiltered(
                        colorFilter: ColorFilter.mode(
                          Colors.grey,
                          BlendMode.saturation,
                        ),
                        child: displayCircleImage(
                            homeConversationModel.profilePictureURL,
                            50,
                            false),
                      ),
                      Positioned(
                          right: 2.4,
                          bottom: 2.4,
                          child: Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                                color: homeConversationModel.active
                                    ? Colors.green
                                    : Colors.grey,
                                borderRadius: BorderRadius.circular(100),
                                border: Border.all(
                                    color: isDarkMode(context)
                                        ? Color(0xFF303030).withOpacity(0.5)
                                        : Colors.white.withOpacity(0.5),
                                    width: 1.6)),
                          ))
                    ],
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8, right: 8, left: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${homeConversationModel.fullName()}',
                                textScaleFactor: 1.0,
                                style: TextStyle(
                                    fontSize: 20,
                                    color: isDarkMode(context)
                                        ? Colors.white
                                        : Color(0xffd7d7d7),fontWeight: FontWeight.bold),
                              ),Text(
                                '',
                                maxLines: 1,
                                textScaleFactor: 1.0,
                                style: TextStyle(
                                    fontSize: 16, color: Color(0xff000000)),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: Text(
                              'Nice to meet you!',//'${homeConversationModel.bio} ',
                              textScaleFactor: 1.0,
                              maxLines: 1,
                              style: TextStyle(
                                  fontSize: 16, color: Color(0xffd7d7d7)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Divider(color: Color(0xff000000) ,height: 1,),
            )
          ],
        ),
      );
  }
}

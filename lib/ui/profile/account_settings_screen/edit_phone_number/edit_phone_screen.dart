import 'package:dating/constants.dart';
import 'package:dating/main.dart';
import 'package:dating/services/helper.dart';
import 'package:dating/ui/profile/account_settings/edit_phone_number/cell_number_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class EditPhoneScreen extends StatefulWidget {
  const EditPhoneScreen({Key? key}) : super(key: key);

  @override
  State<EditPhoneScreen> createState() => _EditPhoneScreenState();
}

class _EditPhoneScreenState extends State<EditPhoneScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios_new_rounded,
            color:
                isDarkMode(context) ? Colors.white : Color(COLOR_BLUE_BUTTON),
          ),
        ),
        title: Text(
          'Phone Update'.tr(),
          textScaleFactor: 1.0,
          style: TextStyle(
            color: Color(0xff000000),
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
        child: Column(
          children: [
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
                        'Phone'.tr(),
                        textScaleFactor: 1.0,
                        style:
                            TextStyle(color: Color(0xFF949494), fontSize: 14),
                        textAlign: TextAlign.start,
                      ),
                      Text(
                        MyAppState.currentUser!.phoneNumber
                            .replaceAll('+91', '')
                            .replaceAll('+1', ''),
                        textScaleFactor: 1.0,
                        style:
                            TextStyle(color: Color(0xFF949494), fontSize: 12),
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: () {
                      push(context, EditCellNumberScreen());
                    },
                    child: Row(
                      children: [
                        Text(
                          'Update',
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
            ),
            Divider(
              color: Color(0xFF7e7e7e),
              height: 0.3,
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              'You can update your phone number once. Click the Update link above, enter your new cell number, and well send you a new code to verify your account.',
              textScaleFactor: 1.0,
              style: TextStyle(color: Color(0xFF949494), fontSize: 12),
              textAlign: TextAlign.start,
            ),
          ],
        ),
      ),
    );
  }
}

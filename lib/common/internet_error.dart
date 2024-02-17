import 'dart:io';

import 'package:dating/common/no_internet.dart';
import 'package:dating/main.dart';
import 'package:flutter/material.dart';

class InternetError {
  static final _instance = InternetError.internal();
  factory InternetError() => _instance;
  InternetError.internal();

  static OverlayEntry? entry;

  void show(BuildContext context, page) => addOverlayEntry(context);
  void hide() => removeOverlay();

  bool get isShow => entry != null;

  addOverlayEntry(BuildContext context) {
    if (entry != null) return;
    entry = OverlayEntry(
      builder: (BuildContext buildContext) {
        return LayoutBuilder(
          builder: (_, BoxConstraints constraints) {
            return Material(
              color: Colors.white,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/offline.jpeg',
                        height: 300,
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Text(
                        'No Internet Connection',
                        style: TextStyle(
                          fontSize: 24,
                          letterSpacing: 1,
                          fontWeight: FontWeight.w700,
                          color: Colors.lightBlueAccent,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "You are not connected with internet. make sure your Wi-fi is on, Airplane Mode off and try again.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.blueGrey,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      SizedBox(
                        height: 40,
                        width: 150,
                        child: TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.redAccent.shade200,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          onPressed: () async {
                            if (await hasNetwork()) {
                              removeOverlay();
                            }
                          },
                          child: Text(
                            'Try again',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );

    addoverlay(entry!, context);
  }

  addoverlay(OverlayEntry entry, BuildContext context) async {
    navigatorKey.currentState?.push(
      MaterialPageRoute(
        builder: (_) => NoInternet(tryAgain: () {
          removeOverlay();
          Navigator.pop(_);
        }),
      ),
    );
  }

  static Future<bool> hasNetwork() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }

  removeOverlay() {
    entry = null;
    entry?.remove();
  }
}

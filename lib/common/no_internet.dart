import 'package:dating/common/internet_error.dart';
import 'package:flutter/material.dart';

class NoInternet extends StatelessWidget {
  final Function() tryAgain;
  const NoInternet({
    Key? key,
    required this.tryAgain,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                    if (await InternetError.hasNetwork()) {
                      await tryAgain();
                      InternetError.entry = null;
                      InternetError.entry?.remove();
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
  }
}

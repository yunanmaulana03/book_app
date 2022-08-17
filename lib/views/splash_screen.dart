import 'dart:async';

import 'package:book_app/helper/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    Timer(Duration(seconds: 5), () {
      Navigator.pushReplacementNamed(context, '/home');
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/logo.png'),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 70,
          ),
          Text(
            'BOOK APP',
            style: SplashTextStyle.copyWith(
              fontSize: 45,
              fontWeight: bold,
              letterSpacing: 15,
            ),
          )
        ],
      ),
    );
  }
}

import 'dart:async';

import 'package:barbershop/screenLogin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class screenSplash extends StatefulWidget {
  const screenSplash({super.key});

  @override
  State<screenSplash> createState() => _screenSplashState();
}

class _screenSplashState extends State<screenSplash> {
  // initState initializes the „first“ state of a widget at the beginning, when it is built for the first time.
  // Contrary, setState updates or overrides an already established state of a widget

  void initState() {
    super.initState();
    Timer(
        Duration(seconds: 3),
        () => Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => screenLogin())));
  }

  //Black = #212121
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff212121),
      body: Center(
        child: SvgPicture.asset(
          'asset/logo.svg',
        ),
      ),
    );
  }
}

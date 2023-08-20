import 'dart:async';
import 'dart:convert';

import 'package:barbershop/screenHome.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class screenLogin extends StatefulWidget {
  const screenLogin({super.key});

  @override
  State<screenLogin> createState() => _screenLoginState();
}

class _screenLoginState extends State<screenLogin> {
  //Variables are created here

  TextEditingController icNum = TextEditingController();
  TextEditingController password = TextEditingController();

  var username = '';

  Future<List?> login() async {
    // Convert the URL string into a Uri object
    final Uri url = Uri.parse("http://192.168.1.18/barber/login.php");
    final response = await http.post(url, body: {
      "icNum": icNum.text,
      "password": password.text,
    });

    // print(response.body);
    var dataUser = jsonDecode(response.body);

    if (dataUser.length == 0) {
      setState(() {
        final snackBar = authError();
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(snackBar);
      });
    } else {
      username = dataUser[0]['username'];
      // print(username);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => screenHome(username: username),
        ),
      );
    }
  }

  SnackBar authError() {
    return SnackBar(
      /// need to set following properties for best effect of awesome_snackbar_content
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Color(0xffD5133A),
          borderRadius: BorderRadius.circular(10), // Add border radius here
        ),
        child: Row(
          children: [
            Icon(Icons.error, color: Colors.white),
            SizedBox(width: 20),
            Text(
              'INVALID CREDENTIALS',
              style: GoogleFonts.montserrat(fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  //Black = #212121
  //White = #F9F9F9
  //Red = #D5133A

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff212121),
      body: SafeArea(
        child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.all(18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 40.0),
                  Center(
                    child: SvgPicture.asset(
                      'asset/logo.svg',
                      height: 100,
                      width: 100,
                      fit: BoxFit.scaleDown,
                    ),
                  ),
                  SizedBox(height: 50.0),
                  Text(
                    'Welcome Back !',
                    style: GoogleFonts.montserrat(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xffF9F9F9)),
                  ),
                  SizedBox(height: 30.0),
                  //Textfield IC & Password
                  TextField(Icon(Icons.perm_identity), false,
                      TextInputType.number, 'Enter IC', icNum),
                  SizedBox(height: 30.0),
                  TextField(Icon(Icons.security), true, TextInputType.text,
                      'Enter Password', password),
                  SizedBox(height: 25.0),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xffD5133A),
                      minimumSize: const Size.fromHeight(50), // NEW
                    ),
                    onPressed: () {
                      login();
                    },
                    child: Text(
                      'LOGIN',
                      style: GoogleFonts.montserrat(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xffF9F9F9)),
                    ),
                  ),

                  Text(username)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextFormField TextField(Icon icon, bool condition, TextInputType type,
      String hints, TextEditingController cont) {
    return TextFormField(
      controller: cont,
      obscureText: condition,
      keyboardType: type,
      decoration: InputDecoration(
          hintText: hints,
          prefixIcon: icon,
          border: OutlineInputBorder(),
          filled: true,
          fillColor: Color(0xffF9F9F9)),
    );
  }
}

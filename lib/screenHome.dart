import 'dart:convert';

import 'package:barbershop/screenLogin.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

// ignore: camel_case_types
class screenHome extends StatefulWidget {
  String? username;
  screenHome({super.key, required this.username});

  @override
  State<screenHome> createState() => _screenHomeState();
}

class _screenHomeState extends State<screenHome> {
  bool fadeCut = false;
  bool shaving = false;
  bool dyeHair = false;
  String? SelectedChxBxName;
  String? barberList;
  int? SelectedChkBxPrice;

  Future<void> addData() async {
    // Convert the URL string into a Uri object
    final Uri url = Uri.parse("http://192.168.1.18/barber/insert.php");
    http.post(url, body: {
      "cust_selection": barberList,
      "price": SelectedChkBxPrice.toString() ,
    });
  }

  @override
  Widget build(BuildContext context) {
    // print(widget.username);
    return Scaffold(
      backgroundColor: Color(0xff212121),
      body: SafeArea(
        child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Wrap(
                        children: [
                          Text(
                            'Hello',
                            style: GoogleFonts.montserrat(
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            ' ${widget.username} ',
                            style: GoogleFonts.montserrat(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          )
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => screenLogin(),
                            ),
                          );
                        },
                        child: Icon(
                          Icons.logout,
                          color: Color(0xffD5133A),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: chkboxListTile(
                          'FADE CUT',
                          fadeCut,
                          'RM 15',
                          (newVal) => setState(() => fadeCut = newVal ?? false),
                        ),
                      ),
                      Expanded(
                        child: chkboxListTile(
                          'SHAVING',
                          shaving,
                          'RM 5',
                          (newVal) => setState(() => shaving = newVal ?? false),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: chkboxListTile(
                          'DYE HAIR',
                          dyeHair,
                          'RM 12',
                          (newValue) =>
                              setState(() => dyeHair = newValue ?? false),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        height: 50,
        margin: const EdgeInsets.all(10),
        child: ElevatedButton(
          onPressed: () {
            // Increment the selected price based on the selected checkboxes
            if (!fadeCut && !shaving && !dyeHair) {
              SelectedChkBxPrice = 0; // Reset to 0 if none are selected
              print("Selected price: $SelectedChkBxPrice");
              print("No checkbox selected");
            } else {
              List<String> nameArr = [];
              int totalPrice = 0; // Create a new variable to hold the calculated price
              SelectedChkBxPrice = 0; // Reset to 0 before calculating
              SelectedChxBxName = '';
              DateTime now = DateTime.now();
              String formattedDate = DateFormat('dd/MM/yyyy').format(now);
              String formattedTime = DateFormat('hh:mm a').format(now);

              if (fadeCut) {
                nameArr.add('FADE CUT'); //single;
                totalPrice += 15;
              }
              if (shaving) {
                nameArr.add('SHAVING'); //single;
                totalPrice += 5;
              }
              if (dyeHair) {
                nameArr.add('DYE HAIR'); //single;
                totalPrice += 12;
              }

              barberList= jsonEncode(nameArr);

              print(barberList);

              SelectedChkBxPrice = totalPrice;

              // Display the selected price
              print("Selected price: $SelectedChkBxPrice");

              _dialogBuilder(context, SelectedChkBxPrice , barberList ,formattedDate,formattedTime);
            }
          },
          child: Text(
            'SUBMIT',
            style: TextStyle(fontSize: 20),
          ),
          style: ElevatedButton.styleFrom(
            primary: Color(0xffD5133A),
            minimumSize: const Size.fromHeight(40), // NEW
          ),
        ),
      ),
    );
  }


  Future<void> _dialogBuilder(BuildContext context,SelectedChkBxPrice,barberList ,formattedDate, formattedTime) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xffD5133A),
          title:  Text(
            'TOTAL RM $SelectedChkBxPrice',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color:Colors.white,
            ),
          ),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "$formattedDate",
                style : TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color:Colors.white,
                ),
              ),
              SizedBox(
                height: 25,
                child: VerticalDivider(
                  color: Colors.white,
                  thickness: 1,
                ),
              ),
              Text(
                  "$formattedTime",
                  style : TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color:Colors.white,
                  )
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: Text(
                'OK',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                addData();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  CheckboxListTile chkboxListTile(String title, bool value, String price, ValueSetter<bool?> selectedChkBox) {
    return CheckboxListTile(
      title: Text(
        title,
        style: TextStyle(color: Colors.white, fontSize: 13),
      ),
      subtitle: Text(
        price,
        style: TextStyle(
            color: Colors.white, fontWeight: FontWeight.w900, fontSize: 12),
      ),
      value: value,
      onChanged: selectedChkBox,
      //     (newValue) {
      //   selectedChkBox(newValue); // Call the provided onChanged callback
      //   // Add your custom logic to identify the checkbox
      //   if (newValue == true) {
      //     // print("$title is checked, Price is  $priceChxBox");
      //   } else {
      //     // print("$title is unchecked");
      //   }
      // },
      activeColor: Color(0xffD5133A),
      checkColor: Color(0xffF9F9F9),
      side: MaterialStateBorderSide.resolveWith(
        (states) => (value == true)
            ? BorderSide(width: 1.0, color: Color(0xffD5133A))
            : BorderSide(width: 1.0, color: Color(0xffF9F9F9)),
      ),
      controlAffinity: ListTileControlAffinity.leading,
    );
  }
}

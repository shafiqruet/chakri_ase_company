import 'package:flutter/material.dart';

String apiBaseUrl = "http://192.168.0.104/chakri_ase_api/";
//String apiBaseUrl = "https://www.leadrcorp.com/chakri_ase_api/";

InputDecoration myInputDecoration({String? label, IconData? icon}) {
  return InputDecoration(
    //hintText: label,
    labelStyle: TextStyle(fontSize: 12, color: Color(0xFF000000)),
    labelText: label, //show label as placeholder
    hintStyle: TextStyle(color: Color(0xFF000000), fontSize: 12), //hint text style
    prefixIcon: Padding(
        padding: EdgeInsets.only(left: 10, right: 5),
        child: Icon(
          icon,
          color: Color(0xFFA56E57),
          size: 15,
        )
        //padding and icon for prefix
        ),

    //contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 10),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Color(0xFFA56E57), width: 1.0),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Color(0xFFA56E57), width: 1.0),
    ),

    fillColor: Color(0xFFFFFFFF),
    filled: true, //set true if you want to show input background
  );
}

InputDecoration myInputDecorationWithoutIcon({String? label}) {
  return InputDecoration(
    /*  hintText: label, */
    labelStyle: TextStyle(fontSize: 12, color: Color(0xFF000000)),
    labelText: label, //show label as placeholder
    hintStyle: TextStyle(color: Color(0xFF000000), fontSize: 12), //hint text style

    //contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 10),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Color(0xFFA56E57), width: 1.0),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Color(0xFFA56E57), width: 1.0),
    ),

    fillColor: Color(0xFFFFFFFF),
    filled: true, //set true if you want to show input background
  );
}

Widget showMessage(String text, responseTypeStatus) {
  //error message widget.
  int color = responseTypeStatus != false ? 0xFF54A34C : 0xFFA56E57;
  return Container(
    width: double.infinity,
    padding: EdgeInsets.fromLTRB(10, 12, 10, 12),
    margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Color(color), border: Border.all(color: Color(color), width: 2)),
    child: Column(
      children: [
        RichText(
          text: TextSpan(
            children: [
              WidgetSpan(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 2),
                  /* child: Icon(Icons.info, color: Colors.white), */
                ),
              ),
              TextSpan(text: text, style: TextStyle(color: Color(0xFFFFFFFF), fontSize: 13, fontWeight: FontWeight.bold)),
            ],
          ),
        )
      ],
    ),
  );
}

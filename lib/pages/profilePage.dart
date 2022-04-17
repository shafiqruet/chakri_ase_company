import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:chakri_ase_company/navigationDrawer/memberNavigationDrawer.dart';
import 'package:chakri_ase_company/pages/homePage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:chakri_ase_company/helper/globals.dart';

class ProfilePage extends StatefulWidget {
  static const String routeName = '/ProfilePage';
  @override
  State<StatefulWidget> createState() {
    return _ProfilePage();
  }
}

class _ProfilePage extends State<ProfilePage> {
  late String errormsg, uid, email, phone, name, address;

  late bool error, showprogress;

  late SharedPreferences logindata;
  late bool isUserLoginIn;

  @override
  void initState() {
    errormsg = "";
    error = false;
    showprogress = false;
    email = "";
    phone = "";
    name = "";
    address = "";

    super.initState();
    checkIfAlreadyLogin();
    getUserInfo();
  }

  void checkIfAlreadyLogin() async {
    logindata = await SharedPreferences.getInstance();
    //isUserLoginIn = logindata.getBool('isLoggedIn')!;
    if (logindata.getBool('isLoggedIn') != null) {
      isUserLoginIn = true;
    } else {
      isUserLoginIn = false;
    }

    if (isUserLoginIn == false) {
      Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context) => HomePage()));
    }
  }

  void getUserInfo() async {
    logindata = await SharedPreferences.getInstance();

    uid = logindata.getString('memberUid')!;

    String apiurl = apiBaseUrl + "company.php"; //api url

    var response = await http.post(Uri.parse(apiurl), body: {'uid': uid, 'action': 'get_profile'});

    if (response.statusCode == 200) {
      var jsondata = json.decode(response.body);
      // print(jsondata);

      if (jsondata["errorCode"] == 0) {
        Map<String, dynamic> userMap = jsonDecode(jsondata["response_data"]);
        setState(() {
          error = false;
          showprogress = false;
          email = userMap['email'] != null ? userMap['email'] : '';
          phone = userMap['phone'];
          name = userMap['name'] != null ? userMap['name'] : '';
          address = userMap['address'] != null ? userMap['address'] : '';
        });
      } else {
        showprogress = false; //don't show progress indicator
        error = true;
        errormsg = jsondata["message"];
      }
    } else {
      setState(() {
        showprogress = false; //don't show progress indicator
        error = true;
        errormsg = "Error during connecting to server.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Profile'),
      ),
      drawer: MemberNavigationDrawer(),
      body: SingleChildScrollView(
          child: Column(children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(25),
          child: Table(
            /*  columnWidths: {0: FixedColumnWidth(30), 1: FlexColumnWidth()}, */
            children: [
              TableRow(children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Full Name'),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(name),
                )
              ]),
              TableRow(children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('E-mail'),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(email),
                )
              ]),
              TableRow(children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Address'),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(address),
                )
              ]),
              TableRow(children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Mobile phone'),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(phone),
                )
              ]),
            ],
            border: TableBorder.all(width: 1, color: Colors.purple),
          ),
        )
      ])),
    );
  }
}

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:chakri_ase_company/navigationDrawer/homeNavigationDrawer.dart';
import 'package:chakri_ase_company/pages/dashboardPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chakri_ase_company/helper/globals.dart';

class RegisterPage extends StatefulWidget {
  static const String routeName = '/RegisterPage';

  @override
  State<StatefulWidget> createState() {
    return _RegisterPage();
  }
}

class _RegisterPage extends State<RegisterPage> {
  late String errormsg, tokenValue, email, phone, password;
  late bool error, showprogress, isUserLoginIn, responseTypeStatus = false;

  late SharedPreferences logindata;

  var _phone = TextEditingController();
  var _password = TextEditingController();
  var _email = TextEditingController();

  // ignore: missing_return
  Future<void> startLogin() async {
    String apiurl = apiBaseUrl + "company.php"; //api url
    //dont use http://localhost , because emulator don't get that address
    //insted use your local IP address or use live URL
    //hit "ipconfig" in windows or "ip a" in linux to get you local IP
    //print(phone);

    var response = await http.post(Uri.parse(apiurl), body: {'phone': phone, 'password': password, 'email': email, 'action': 'register_profile'});

    if (response.statusCode == 200) {
      var jsondata = json.decode(response.body);

      if (jsondata["errorCode"] == 0) {
        setState(() {
          error = true;
          showprogress = false;
          errormsg = jsondata["message"];
          responseTypeStatus = true;
        });
      } else {
        setState(() {
          showprogress = false; //don't show progress indicator
          error = false;
          errormsg = jsondata["message"];
        });
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
  void initState() {
    phone = "";
    password = "";
    errormsg = "";
    error = false;
    showprogress = false;
    email = "";
    responseTypeStatus = false;
    super.initState();

    /* checkIfAlreadyLogin(); */
  }

  void checkIfAlreadyLogin() async {
    logindata = await SharedPreferences.getInstance();
    //isUserLoginIn = logindata.getBool('isLoggedIn');
    //isUserLoginIn = logindata.getBool('isLoggedIn')!;
    if (logindata.getBool('isLoggedIn') != null) {
      isUserLoginIn = true;
    } else {
      isUserLoginIn = false;
    }
    if (isUserLoginIn == true) {
      Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context) => DashboardPage()));
    }
  }

  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.transparent
        //color set to transperent or set your own color
        ));

    return Scaffold(
      appBar: AppBar(
        title: Text('Registration Page'),
      ),
      drawer: HomeNavigationDrawer(),
      body: SingleChildScrollView(
          child: Container(
        constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height
            //set minimum height equal to 100% of VH
            ),
        width: MediaQuery.of(context).size.width,
        //make width of outer wrapper to 100%
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Color(0xFFFFFFFF),
              Color(0xFFFFFFFF),
              Color(0xFFFFFFFF),
              Color(0xFFFFFFFF),
            ],
          ),
        ), //show linear gradient background of page

        padding: EdgeInsets.all(20),
        child: Column(children: <Widget>[
          /* Container(
            margin: EdgeInsets.only(top: 20),
            child: Text(
              "Sign Into System",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold),
            ), //title text
          ), */
          Container(
            color: Color(0xFFa56e57),
            margin: EdgeInsets.only(top: 20),
            padding: EdgeInsets.all(10),
            child: Text(
              "Please enter your company information for register",
              style: TextStyle(
                color: Colors.white,
                fontSize: 11,
                height: 1.4,
              ),
            ), //subtitle text
          ),
          Container(
            //show error message here
            margin: EdgeInsets.only(top: 20),
            padding: EdgeInsets.all(10),
            child: error ? showMessage(errormsg, responseTypeStatus) : Container(),
            //if error == true then show error message
            //else set empty container as child
          ),
          Container(
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            margin: EdgeInsets.only(top: 10),
            child: TextField(
              controller: _email, //set phone controller
              style: TextStyle(color: Color(0xFF000000), fontSize: 10),
              decoration: myInputDecoration(
                label: "Company Email",
                icon: Icons.male,
              ),
              onChanged: (value) {
                //set phone  text on change
                email = value;
              },
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            margin: EdgeInsets.only(top: 10),
            child: TextField(
              controller: _phone, //set phone controller
              style: TextStyle(color: Color(0xFF000000), fontSize: 10),
              decoration: myInputDecoration(
                label: "Phone",
                icon: Icons.phone,
              ),
              onChanged: (value) {
                //set phone  text on change
                phone = value;
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            child: TextField(
              controller: _password, //set password controller
              style: TextStyle(color: Color(0xFF000000), fontSize: 10),
              obscureText: true,
              decoration: myInputDecoration(
                label: "Password",
                icon: Icons.lock,
              ),
              onChanged: (value) {
                // change password text
                password = value;
              },
            ),
          ),
          Container(
            child: SizedBox(
              height: 50,
              width: 336,
              child: TextButton(
                style: TextButton.styleFrom(
                    primary: Colors.black,
                    padding: EdgeInsets.fromLTRB(25, 10, 25, 10),
                    textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    backgroundColor: Color(0xFFA56E57)),
                onPressed: () {
                  setState(() {
                    //show progress indicator on click
                    showprogress = true;
                  });
                  startLogin();
                },
                child: showprogress
                    ? SizedBox(
                        height: 30,
                        width: 30,
                        child: CircularProgressIndicator(
                          backgroundColor: Color(0xFFFFFFFF),
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.deepOrangeAccent),
                        ),
                      )
                    : Text(
                        "Login",
                        style: TextStyle(fontSize: 14),
                      ),
                // if showprogress == true then show progress indicator
                // else show "LOGIN NOW" text
                /* shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)
                    //button corner radius
                    ), */
              ),
            ),
          ),
        ]),
      )),
    );
  }
}

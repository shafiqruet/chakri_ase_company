import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:chakri_ase_company/pages/homePage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chakri_ase_company/navigationDrawer/memberNavigationDrawer.dart';
import 'package:chakri_ase_company/helper/globals.dart';

class LogoutPage extends StatefulWidget {
  static const String routeName = '/logoutPage';

  @override
  State<StatefulWidget> createState() {
    return _LogoutPage();
  }
}

class _LogoutPage extends State<LogoutPage> {
  late String errormsg;
  late bool error, showprogress, responseTypeStatus = true;

  late SharedPreferences logindata;
  late bool isLoggedIn;

  startLogin() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.remove('isLoggedIn');
    preferences.setBool('isLoggedIn', false);
    await preferences.clear();

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
    );
  }

  @override
  void initState() {
    errormsg = "";
    error = false;
    showprogress = false;
    responseTypeStatus = true;

    super.initState();
  }

  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.transparent
        //color set to transperent or set your own color
        ));

    return Scaffold(
      appBar: AppBar(
        title: Text('Logout Page'),
      ),
      drawer: MemberNavigationDrawer(),
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
          Container(
            color: Color(0xFFa56e57),
            margin: EdgeInsets.only(top: 20),
            padding: EdgeInsets.all(10),
            child: Text(
              "Please click logout button for logout from this apps, after logout you can not see your personal information.",
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
            child: SizedBox(
              height: 50,
              width: 300,
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
                        "Logout",
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

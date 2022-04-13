import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:chakri_ase_company/navigationDrawer/homeNavigationDrawer.dart';
import 'package:chakri_ase_company/pages/dashboardPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  static const String routeName = '/HomePage';

  @override
  State<StatefulWidget> createState() {
    return _HomePage();
  }
}

class _HomePage extends State<HomePage> {
  late bool isUserLoginIn;

  late SharedPreferences logindata;

  @override
  void initState() {
    super.initState();
    checkIfAlreadyLogin();
  }

  void checkIfAlreadyLogin() async {
    logindata = await SharedPreferences.getInstance();
    if (logindata.getBool('isLoggedIn') != null) {
      isUserLoginIn = true;
    } else {
      isUserLoginIn = false;
    }
    //isUserLoginIn = logindata.getBool('isLoggedIn')!;

    if (isUserLoginIn != false) {
      Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context) => DashboardPage()));
    }
  }

  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.transparent
        //color set to transperent or set your own color
        ));

    return Scaffold(
        appBar: AppBar(
          title: Text('Home Page'),
        ),
        drawer: HomeNavigationDrawer(),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Welcome to Chakri Dibo App'),
            ],
          ),
        ));
  }
}

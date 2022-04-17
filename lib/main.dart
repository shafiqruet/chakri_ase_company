import 'package:flutter/material.dart';
import 'package:chakri_ase_company/pages/addJobPage.dart';
import 'package:chakri_ase_company/pages/editProfilePage.dart';
import 'package:chakri_ase_company/pages/jobDetailsPage.dart';
import 'package:chakri_ase_company/pages/jobListPage.dart';
import 'package:chakri_ase_company/pages/logoutPage.dart';
import 'package:chakri_ase_company/pages/profilePage.dart';
import 'package:chakri_ase_company/pages/homePage.dart';
import 'package:chakri_ase_company/pages/loginPage.dart';
import 'package:chakri_ase_company/pages/registerPage.dart';
import 'package:chakri_ase_company/pages/dashboardPage.dart';
import 'package:chakri_ase_company/pages/jobPortalPage.dart';
import 'package:chakri_ase_company/routes/pageRoutes.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(highlightColor: Color(0xFFFFFFFF), primaryColor: Color(0xFF191629)),
      home: HomePage(),
      routes: {
        PageRoutes.home: (context) => HomePage(),
        PageRoutes.login: (context) => LoginPage(),
        PageRoutes.register: (context) => RegisterPage(),
        PageRoutes.dashboard: (context) => DashboardPage(),
        PageRoutes.profile: (context) => ProfilePage(),
        PageRoutes.logout: (context) => LogoutPage(),
        PageRoutes.editProfile: (context) => EditProfilePage(),
        PageRoutes.jobPortal: (context) => JobPortalPage(),
        PageRoutes.jobList: (context) => JobListPage(),
        "/jobDetails": (context) => JobDetailsPage(),
        PageRoutes.addJob: (context) => AddJobPage(),
      },
    );
  }
}

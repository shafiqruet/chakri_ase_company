import 'package:flutter/material.dart';
import 'package:chakri_ase_company/widgets/createDrawerBodyItem.dart';
import 'package:chakri_ase_company/routes/pageRoutes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chakri_ase_company/pages/homePage.dart';

class MemberNavigationDrawer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MemberNavigatePage();
  }
}

class _MemberNavigatePage extends State<MemberNavigationDrawer> {
  late SharedPreferences logindata;
  late bool isUserLoginIn;

  @override
  void initState() {
    super.initState();
    checkIfAlreadyLogin();
  }

  void checkIfAlreadyLogin() async {
    logindata = await SharedPreferences.getInstance();
    //print(logindata);
    //isUserLoginIn = logindata.getBool('isLoggedIn')!;
    if (logindata.getBool('isLoggedIn') != null) {
      isUserLoginIn = true;
    } else {
      isUserLoginIn = false;
    }
    //print(isUserLoginIn);
    if (isUserLoginIn == false) {
      Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context) => HomePage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        /*  padding: EdgeInsets.fromLTRB(10, 50, 0, 0), */
        children: <Widget>[
          /* createDrawerHeader(), */
          createDrawerBodyItem(
            icon: Icons.home,
            text: 'Dashboard',
            onTap: () => Navigator.pushReplacementNamed(context, PageRoutes.dashboard),
          ),
          createDrawerBodyItem(
            icon: Icons.account_box,
            text: 'View Profile',
            onTap: () => Navigator.pushReplacementNamed(context, PageRoutes.profile),
          ),
          createDrawerBodyItem(
            icon: Icons.manage_accounts_rounded,
            text: 'Edit Profile',
            onTap: () => Navigator.pushReplacementNamed(context, PageRoutes.editProfile),
          ),
          createDrawerBodyItem(
            icon: Icons.manage_accounts_rounded,
            text: 'Job Lists',
            onTap: () => Navigator.pushReplacementNamed(context, PageRoutes.jobList),
          ),
          createDrawerBodyItem(
            icon: Icons.manage_accounts_rounded,
            text: 'Add Job',
            onTap: () => Navigator.pushReplacementNamed(context, PageRoutes.addJob),
          ),
          ExpansionTile(
            title: Row(
              children: <Widget>[
                Icon(Icons.settings),
                Padding(
                  padding: EdgeInsets.only(left: 12.0),
                  child: Text("Manage Resume"),
                )
              ],
            ),
            children: <Widget>[
              createDrawerBodyItem(
                icon: Icons.account_box_outlined,
                text: 'View Resume',
                onTap: () => Navigator.pushReplacementNamed(context, PageRoutes.viewResume),
                paddingValue: 40.0,
              ),
              createDrawerBodyItem(
                icon: Icons.account_box_outlined,
                text: 'Personal Info',
                onTap: () => Navigator.pushReplacementNamed(context, PageRoutes.jobPortal),
                paddingValue: 40.0,
              ),
              createDrawerBodyItem(
                icon: Icons.work,
                text: 'Job Experience',
                onTap: () => Navigator.pushReplacementNamed(context, PageRoutes.jobExperience),
                paddingValue: 40.0,
              ),
              createDrawerBodyItem(
                icon: Icons.add_business,
                text: 'Job Skills',
                onTap: () => Navigator.pushReplacementNamed(context, PageRoutes.jobSkills),
                paddingValue: 40.0,
              ),
            ],
          ),
          createDrawerBodyItem(
            icon: Icons.logout,
            text: 'Logout',
            onTap: () => Navigator.pushReplacementNamed(context, PageRoutes.logout),
          ),
          ListTile(
            title: Text('App version 1.0.0'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

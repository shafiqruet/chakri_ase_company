import 'package:flutter/material.dart';
import 'package:chakri_ase_company/widgets/createDrawerBodyItem.dart';
import 'package:chakri_ase_company/routes/pageRoutes.dart';

class HomeNavigationDrawer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeNavigatePage();
  }
}

class _HomeNavigatePage extends State<HomeNavigationDrawer> {
  @override
  void initState() {
    super.initState();
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
            text: 'Home',
            onTap: () => Navigator.pushReplacementNamed(context, PageRoutes.home),
          ),
          createDrawerBodyItem(
            icon: Icons.login,
            text: 'Login',
            onTap: () => Navigator.pushReplacementNamed(context, PageRoutes.login),
          ),
          createDrawerBodyItem(
            icon: Icons.app_registration_rounded,
            text: 'Sign Up',
            onTap: () => Navigator.pushReplacementNamed(context, PageRoutes.register),
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

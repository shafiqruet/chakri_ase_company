import 'dart:convert';
import 'package:chakri_ase_company/navigationDrawer/memberNavigationDrawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chakri_ase_company/helper/globals.dart';

class EditProfilePage extends StatefulWidget {
  static const String routeName = '/EditProfilePage';

  @override
  State<StatefulWidget> createState() {
    return _EditProfilePage();
  }
}

class _EditProfilePage extends State<EditProfilePage> {
  final formGlobalKey = GlobalKey<FormState>();

  late String errormsg, tokenValue, phone, password, uid, name, email, address;
  late bool error, showprogress, isUserLoginIn, responseTypeStatus = false;

  late SharedPreferences logindata;

  var _phone = TextEditingController();
  var _email = TextEditingController();
  var _name = TextEditingController();
  var _address = TextEditingController();

  // ignore: missing_return
  Future<void> updateProfile() async {
    logindata = await SharedPreferences.getInstance();
    uid = logindata.getString('memberUid')!;

    String apiurl = apiBaseUrl + "member.php"; //api url
    var requestData = {'phone': _phone.text, 'name': _name.text, 'email': _email.text, 'address': _address.text, 'action': 'update_profile', 'uid': uid};

    var response = await http.post(Uri.parse(apiurl), body: requestData);

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
        showprogress = false; //don't show progress indicator
        error = true;
        errormsg = jsondata["errorCode"];
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
    errormsg = "";
    error = false;
    showprogress = false;
    tokenValue = "";
    email = "";
    phone = "";
    name = "";
    address = "";
    responseTypeStatus = false;

    super.initState();

    getUserInformation();
  }

  void getUserInformation() async {
    logindata = await SharedPreferences.getInstance();

    uid = logindata.getString('memberUid')!;

    String apiurl = apiBaseUrl + "member.php"; //api url

    var response = await http.post(Uri.parse(apiurl), body: {'uid': uid, 'action': 'get_profile'});

    if (response.statusCode == 200) {
      var jsondata = json.decode(response.body);

      if (jsondata["errorCode"] == 0) {
        Map<String, dynamic> userMap = jsonDecode(jsondata["response_data"]);
        setState(() {
          error = false;
          showprogress = false;
          _email.text = userMap['email'] != null ? userMap['email'] : '';
          _phone.text = userMap['phone'];
          _name.text = userMap['name'] != null ? userMap['name'] : '';
          _address.text = userMap['address'] != null ? userMap['address'] : '';
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

  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.transparent
        //color set to transperent or set your own color
        ));

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile Page'),
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
              "Please make sure there are no blank spaces before, after or in between your phone and password. Please also be aware of capital and small letters regarding your password. Do NOT copy and paste your password, but type it in manually.",
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
            //padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            margin: EdgeInsets.only(top: 20),
            child: TextField(
              controller: _name, //set phone controller
              style: TextStyle(color: Color(0xFF000000), fontSize: 10),
              decoration: myInputDecoration(
                label: "Name",
                icon: Icons.person,
              ),
              onChanged: (value) {
                //set phone  text on change
                name = value;
              },
            ),
          ),
          Container(
            //padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            margin: EdgeInsets.only(top: 20),
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
            //padding: EdgeInsets.all(10),
            margin: EdgeInsets.only(top: 20),
            child: TextField(
              controller: _email, //set phone controller
              style: TextStyle(color: Color(0xFF000000), fontSize: 10),
              decoration: myInputDecoration(
                label: "Email",
                icon: Icons.email,
              ),
              onChanged: (value) {
                //set phone  text on change
                email = value;
              },
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
            child: TextField(
              controller: _address, //set phone controller
              style: TextStyle(color: Color(0xFF000000), fontSize: 10),
              decoration: myInputDecoration(
                label: "Address",
                icon: Icons.add_business,
              ),
              onChanged: (value) {
                //set phone  text on change
                address = value;
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
                  updateProfile();
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
                        "Update",
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

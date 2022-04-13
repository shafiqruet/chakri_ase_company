import 'dart:convert';
import 'package:chakri_ase_company/navigationDrawer/memberNavigationDrawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chakri_ase_company/helper/globals.dart';

class JobPortalPage extends StatefulWidget {
  static const String routeName = '/JobPortalPage';

  @override
  State<StatefulWidget> createState() {
    return _JobPortalPage();
  }
}

class _JobPortalPage extends State<JobPortalPage> {
  final formGlobalKey = GlobalKey<FormState>();

  late String errormsg,
      uid,
      fatherName,
      motherName,
      birthday,
      gender,
      maritalStatus,
      presentAddress,
      permanentAddress,
      education,
      actionType = 'register_personal',
      actionText = 'Register';
  late bool error, showprogress, isUserLoginIn, responseTypeStatus = false;

  late SharedPreferences logindata;

  var _fatherName = TextEditingController();
  var _motherName = TextEditingController();
  var _birthday = TextEditingController();
  var _gender = TextEditingController();
  var _maritalStatus = TextEditingController();
  var _presentAddress = TextEditingController();
  var _permanentAddress = TextEditingController();
  var _education = TextEditingController();

  // ignore: missing_return
  Future<void> updateProfile() async {
    logindata = await SharedPreferences.getInstance();
    uid = logindata.getString('memberUid')!;

    String apiurl = apiBaseUrl + "job_personal.php"; //api url
    var requestData = {
      'father_name': _fatherName.text,
      'mother_name': _motherName.text,
      'birthday': _birthday.text,
      'gender': _gender.text,
      'marital_status': _maritalStatus.text,
      'present_address': _presentAddress.text,
      'permanent_address': _permanentAddress.text,
      'education': _education.text,
      'uid': uid,
      'action': actionType,
    };

    var response = await http.post(Uri.parse(apiurl), body: requestData);

    if (response.statusCode == 200) {
      var jsondata = json.decode(response.body);

      if (jsondata["errorCode"] == 0) {
        setState(() {
          error = true;
          errormsg = jsondata["message"];
          showprogress = false;
          responseTypeStatus = true;
          actionType = 'update_personal';
          actionText = 'Update';
        });

        /*  Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DashboardPage()),
          ); */
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
  void initState() {
    errormsg = "";
    error = false;
    showprogress = false;
    fatherName = "";
    motherName = "";
    birthday = "";
    gender = "";
    maritalStatus = '';
    education = "";
    presentAddress = "";
    permanentAddress = "";
    responseTypeStatus = false;
    actionType = 'register_personal';
    actionText = 'Register';

    super.initState();

    getUserInformation();
  }

  void getUserInformation() async {
    logindata = await SharedPreferences.getInstance();

    uid = logindata.getString('memberUid')!;

    String apiurl = apiBaseUrl + "job_personal.php"; //api url

    var response = await http.post(Uri.parse(apiurl), body: {'uid': uid, 'action': 'get_personal'});

    if (response.statusCode == 200) {
      var jsondata = json.decode(response.body);

      if (jsondata["errorCode"] == 0) {
        Map<String, dynamic> userMap = jsonDecode(jsondata["response_data"]);
        setState(() {
          error = false;
          showprogress = false;
          _fatherName.text = userMap['father_name'] != null ? userMap['father_name'] : '';
          _motherName.text = userMap['mother_name'] != null ? userMap['mother_name'] : '';
          _birthday.text = userMap['birthday'] != null ? userMap['birthday'] : '';
          _gender.text = userMap['gender'] != null ? userMap['gender'] : '';
          _maritalStatus.text = userMap['marital_status'] != null ? userMap['marital_status'] : '';
          _presentAddress.text = userMap['present_address'] != null ? userMap['present_address'] : '';
          _permanentAddress.text = userMap['permanent_address'] != null ? userMap['permanent_address'] : '';
          _education.text = userMap['education'] != null ? userMap['education'] : '';
          responseTypeStatus = true;
          actionType = 'update_personal';
          actionText = 'Update';
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
        title: Text('Personal Information'),
      ),
      drawer: MemberNavigationDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
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

              padding: EdgeInsets.all(10),
              child: Column(children: <Widget>[
                Container(
                  color: Color(0xFFa56e57),
                  margin: EdgeInsets.only(top: 10),
                  padding: EdgeInsets.all(10),
                  child: Text(
                    "Please fill your job information to manage easy and find match job. From this you can also update your information from here",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      height: 1.4,
                    ),
                  ), //subtitle text
                ),
                Container(
                  //show error message here
                  margin: EdgeInsets.only(top: 10),
                  padding: EdgeInsets.all(10),
                  child: error ? showMessage(errormsg, responseTypeStatus) : Container(),
                  //if error == true then show error message
                  //else set empty container as child
                ),
                Container(
                  //padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  margin: EdgeInsets.only(top: 0),
                  child: TextField(
                    controller: _fatherName, //set phone controller
                    style: TextStyle(color: Color(0xFF000000), fontSize: 12),
                    decoration: myInputDecorationWithoutIcon(label: "Father's Name"),
                    onChanged: (value) {
                      //set phone  text on change
                      fatherName = value;
                    },
                  ),
                ),
                Container(
                  //padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  margin: EdgeInsets.only(top: 20),
                  child: TextField(
                    controller: _motherName, //set phone controller
                    style: TextStyle(color: Color(0xFF000000), fontSize: 12),
                    decoration: myInputDecorationWithoutIcon(label: "Mother's Name"),
                    onChanged: (value) {
                      //set phone  text on change
                      motherName = value;
                    },
                  ),
                ),
                Container(
                  //padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  margin: EdgeInsets.only(top: 20),
                  child: TextField(
                    controller: _birthday, //set phone controller
                    style: TextStyle(color: Color(0xFF000000), fontSize: 12),
                    decoration: myInputDecorationWithoutIcon(label: "Birthday (Format: Year-Month-Day)"),
                    onChanged: (value) {
                      //set phone  text on change
                      birthday = value;
                    },
                  ),
                ),
                Container(
                  //padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  margin: EdgeInsets.only(top: 20),
                  child: TextField(
                    controller: _gender, //set phone controller
                    style: TextStyle(color: Color(0xFF000000), fontSize: 12),
                    decoration: myInputDecorationWithoutIcon(label: "Gender"),
                    onChanged: (value) {
                      //set phone  text on change
                      gender = value;
                    },
                  ),
                ),
                Container(
                  //padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  margin: EdgeInsets.only(top: 20),
                  child: TextField(
                    controller: _maritalStatus, //set phone controller
                    style: TextStyle(color: Color(0xFF000000), fontSize: 12),
                    decoration: myInputDecorationWithoutIcon(label: "Marital status"),
                    onChanged: (value) {
                      //set phone  text on change
                      maritalStatus = value;
                    },
                  ),
                ),
                Container(
                  //padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  margin: EdgeInsets.only(top: 20),
                  child: TextField(
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    minLines: 2,
                    controller: _presentAddress, //set phone controller
                    style: TextStyle(color: Color(0xFF000000), fontSize: 12),
                    decoration: myInputDecorationWithoutIcon(label: "Present Address"),
                    onChanged: (value) {
                      //set phone  text on change
                      presentAddress = value;
                    },
                  ),
                ),
                Container(
                  //padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  margin: EdgeInsets.only(top: 20),
                  child: TextField(
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    minLines: 2,
                    controller: _permanentAddress, //set phone controller
                    style: TextStyle(color: Color(0xFF000000), fontSize: 12),
                    decoration: myInputDecorationWithoutIcon(label: "Permanent Address"),
                    onChanged: (value) {
                      //set phone  text on change
                      permanentAddress = value;
                    },
                  ),
                ),
                Container(
                  //padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  margin: EdgeInsets.only(top: 20),
                  child: TextField(
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    minLines: 2,
                    controller: _education, //set phone controller
                    style: TextStyle(color: Color(0xFF000000), fontSize: 12),
                    decoration: myInputDecorationWithoutIcon(label: "Education Ssc/Hsc/Hons."),
                    onChanged: (value) {
                      //set phone  text on change
                      education = value;
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20),
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
                              actionText,
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
            )
          ],
        ),
      ),
    );
  }
}

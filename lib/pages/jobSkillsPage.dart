import 'dart:convert';
import 'package:chakri_ase_company/navigationDrawer/memberNavigationDrawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chakri_ase_company/helper/globals.dart';

class JobSkillsPage extends StatefulWidget {
  static const String routeName = '/JobSkillsPage';

  @override
  State<StatefulWidget> createState() {
    return _JobSkillsPage();
  }
}

class _JobSkillsPage extends State<JobSkillsPage> {
  final formGlobalKey = GlobalKey<FormState>();

  late String errormsg,
      uid,
      skills1,
      skills2,
      skills3,
      skills4,
      skills5,
      skills6,
      skills7,
      skills8,
      presentSalary,
      expectedSalary,
      actionType = 'register_skills',
      actionText = 'Register';
  late bool error, showprogress, isUserLoginIn, responseTypeStatus = false;

  late SharedPreferences logindata;

  var _skills1 = TextEditingController();
  var _skills2 = TextEditingController();
  var _skills3 = TextEditingController();
  var _skills4 = TextEditingController();
  var _skills5 = TextEditingController();
  var _skills6 = TextEditingController();
  var _skills7 = TextEditingController();
  var _skills8 = TextEditingController();
  var _presentSalary = TextEditingController();
  var _expectedSalary = TextEditingController();

  // ignore: missing_return
  Future<void> updateProfile() async {
    logindata = await SharedPreferences.getInstance();
    uid = logindata.getString('memberUid')!;

    String apiurl = apiBaseUrl + "job_skills.php"; //api url
    var requestData = {
      'skills1': _skills1.text,
      'skills2': _skills2.text,
      'skills3': _skills3.text,
      'skills4': _skills4.text,
      'skills5': _skills5.text,
      'skills6': _skills6.text,
      'skills7': _skills7.text,
      'skills8': _skills8.text,
      'present_salary': _presentSalary.text,
      'expected_salary': _expectedSalary.text,
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
          actionType = 'update_skills';
          actionText = 'Update';
        });

        /*  Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DashboardPage()),
          ); */
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
    skills1 = "";
    skills2 = "";
    skills3 = "";
    skills4 = "";
    skills5 = "";
    skills6 = "";
    skills7 = "";
    skills8 = "";
    presentSalary = "";
    expectedSalary = "";

    responseTypeStatus = false;
    actionType = 'register_skills';
    actionText = 'Register';

    super.initState();

    getUserInformation();
  }

  void getUserInformation() async {
    logindata = await SharedPreferences.getInstance();

    uid = logindata.getString('memberUid')!;

    String apiurl = apiBaseUrl + "job_skills.php"; //api url

    var response = await http.post(Uri.parse(apiurl), body: {'uid': uid, 'action': 'get_skills'});

    if (response.statusCode == 200) {
      var jsondata = json.decode(response.body);

      if (jsondata["errorCode"] == 0) {
        Map<String, dynamic> userMap = jsonDecode(jsondata["response_data"]);
        setState(() {
          error = false;
          showprogress = false;
          _skills1.text = userMap['skills1'] != null ? userMap['skills1'] : '';
          _skills2.text = userMap['skills2'] != null ? userMap['skills2'] : '';
          _skills3.text = userMap['skills3'] != null ? userMap['skills3'] : '';
          _skills4.text = userMap['skills4'] != null ? userMap['skills4'] : '';
          _skills5.text = userMap['skills5'] != null ? userMap['skills5'] : '';
          _skills6.text = userMap['skills6'] != null ? userMap['skills6'] : '';
          _skills7.text = userMap['skills7'] != null ? userMap['skills7'] : '';
          _skills8.text = userMap['skills8'] != null ? userMap['skills8'] : '';
          _expectedSalary.text = userMap['expected_salary'] != null ? userMap['expected_salary'] : '';
          _presentSalary.text = userMap['present_salary'] != null ? userMap['present_salary'] : '';
          responseTypeStatus = true;
          actionType = 'update_skills';
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
        title: Text('Manage Job Skills'),
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
                  margin: EdgeInsets.only(top: 20),
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      new Flexible(
                        child: new TextField(
                          keyboardType: TextInputType.number,
                          controller: _presentSalary, //set phone controller
                          style: TextStyle(color: Color(0xFF000000), fontSize: 12),
                          decoration: myInputDecorationWithoutIcon(label: "Present Salary"),
                          onChanged: (value) {
                            //set phone  text on change
                            presentSalary = value;
                          },
                        ),
                      ),
                      SizedBox(
                        width: 20.0,
                      ),
                      new Flexible(
                        child: new TextField(
                          keyboardType: TextInputType.number,
                          controller: _expectedSalary, //set phone controller
                          style: TextStyle(color: Color(0xFF000000), fontSize: 12),
                          decoration: myInputDecorationWithoutIcon(label: "Expected Salary"),
                          onChanged: (value) {
                            //set phone  text on change
                            expectedSalary = value;
                          },
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20),
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      new Flexible(
                        child: new TextField(
                          controller: _skills1, //set phone controller
                          style: TextStyle(color: Color(0xFF000000), fontSize: 12),
                          decoration: myInputDecorationWithoutIcon(label: "Skills 1"),
                          onChanged: (value) {
                            //set phone  text on change
                            skills1 = value;
                          },
                        ),
                      ),
                      SizedBox(
                        width: 20.0,
                      ),
                      new Flexible(
                        child: new TextField(
                          controller: _skills2, //set phone controller
                          style: TextStyle(color: Color(0xFF000000), fontSize: 12),
                          decoration: myInputDecorationWithoutIcon(label: "Skills 2"),
                          onChanged: (value) {
                            //set phone  text on change
                            skills2 = value;
                          },
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20),
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      new Flexible(
                        child: new TextField(
                          controller: _skills3, //set phone controller
                          style: TextStyle(color: Color(0xFF000000), fontSize: 12),
                          decoration: myInputDecorationWithoutIcon(label: "Skills 3"),
                          onChanged: (value) {
                            //set phone  text on change
                            skills3 = value;
                          },
                        ),
                      ),
                      SizedBox(
                        width: 20.0,
                      ),
                      new Flexible(
                        child: new TextField(
                          controller: _skills4, //set phone controller
                          style: TextStyle(color: Color(0xFF000000), fontSize: 12),
                          decoration: myInputDecorationWithoutIcon(label: "Skills 4"),
                          onChanged: (value) {
                            //set phone  text on change
                            skills4 = value;
                          },
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20),
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      new Flexible(
                        child: new TextField(
                          controller: _skills5, //set phone controller
                          style: TextStyle(color: Color(0xFF000000), fontSize: 12),
                          decoration: myInputDecorationWithoutIcon(label: "Skills 5"),
                          onChanged: (value) {
                            //set phone  text on change
                            skills5 = value;
                          },
                        ),
                      ),
                      SizedBox(
                        width: 20.0,
                      ),
                      new Flexible(
                        child: new TextField(
                          controller: _skills6, //set phone controller
                          style: TextStyle(color: Color(0xFF000000), fontSize: 12),
                          decoration: myInputDecorationWithoutIcon(label: "Skills 6"),
                          onChanged: (value) {
                            //set phone  text on change
                            skills6 = value;
                          },
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20),
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      new Flexible(
                        child: new TextField(
                          controller: _skills7, //set phone controller
                          style: TextStyle(color: Color(0xFF000000), fontSize: 12),
                          decoration: myInputDecorationWithoutIcon(label: "Skills 7"),
                          onChanged: (value) {
                            //set phone  text on change
                            skills7 = value;
                          },
                        ),
                      ),
                      SizedBox(
                        width: 20.0,
                      ),
                      new Flexible(
                        child: new TextField(
                          controller: _skills8, //set phone controller
                          style: TextStyle(color: Color(0xFF000000), fontSize: 12),
                          decoration: myInputDecorationWithoutIcon(label: "Skills 8"),
                          onChanged: (value) {
                            //set phone  text on change
                            skills8 = value;
                          },
                        ),
                      )
                    ],
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

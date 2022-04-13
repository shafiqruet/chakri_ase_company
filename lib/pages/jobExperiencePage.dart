import 'dart:convert';
import 'package:chakri_ase_company/navigationDrawer/memberNavigationDrawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chakri_ase_company/helper/globals.dart';

class JobExperiencePage extends StatefulWidget {
  static const String routeName = '/JobExperiencePage';

  @override
  State<StatefulWidget> createState() {
    return _JobExperiencePage();
  }
}

class _JobExperiencePage extends State<JobExperiencePage> {
  final formGlobalKey = GlobalKey<FormState>();

  late String errormsg, uid, experience1, experience2, experience3, jobType, position, actionType = 'register_experience', actionText = 'Register';
  late bool error, showprogress, isUserLoginIn, responseTypeStatus = false;

  late SharedPreferences logindata;

  var _experience1 = TextEditingController();
  var _experience2 = TextEditingController();
  var _experience3 = TextEditingController();
  var _position = TextEditingController();
  var _jobType = TextEditingController();

  // ignore: missing_return
  Future<void> updateProfile() async {
    logindata = await SharedPreferences.getInstance();
    uid = logindata.getString('memberUid')!;

    String apiurl = apiBaseUrl + "job_experience.php"; //api url
    var requestData = {
      'experience1': _experience1.text,
      'experience2': _experience2.text,
      'experience3': _experience3.text,
      'position': _position.text,
      'job_type': _jobType.text,
      'uid': uid,
      'action': actionType,
    };

    var response = await http.post(Uri.parse(apiurl), body: requestData);
    print(response);

    if (response.statusCode == 200) {
      var jsondata = json.decode(response.body);

      if (jsondata["errorCode"] == 0) {
        setState(() {
          error = true;
          errormsg = jsondata["message"];
          showprogress = false;
          responseTypeStatus = true;
          actionType = 'update_experience';
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
    experience1 = "";
    experience2 = "";
    experience3 = "";
    position = "";
    jobType = "";
    responseTypeStatus = false;
    actionType = 'register_experience';
    actionText = 'Register';

    super.initState();

    getUserInformation();
  }

  void getUserInformation() async {
    logindata = await SharedPreferences.getInstance();

    uid = logindata.getString('memberUid')!;

    String apiurl = apiBaseUrl + "job_experience.php"; //api url

    var response = await http.post(Uri.parse(apiurl), body: {'uid': uid, 'action': 'get_experience'});

    if (response.statusCode == 200) {
      var jsondata = json.decode(response.body);
      // print(jsondata);

      if (jsondata["errorCode"] == 0) {
        Map<String, dynamic> userMap = jsonDecode(jsondata["response_data"]);
        setState(() {
          error = false;
          showprogress = false;
          _experience1.text = userMap['experience1'] != null ? userMap['experience1'] : '';
          _experience2.text = userMap['experience2'] != null ? userMap['experience2'] : '';
          _experience3.text = userMap['experience3'] != null ? userMap['experience3'] : '';
          _jobType.text = userMap['job_type'] != null ? userMap['job_type'] : '';
          _position.text = userMap['position'] != null ? userMap['position'] : '';
          responseTypeStatus = true;
          actionType = 'update_experience';
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
        error = false;
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
        title: Text('Manage Job Portal'),
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
                    "Please fill your job experience to manage easy and find match job. From this you can also update your information from here",
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
                  margin: EdgeInsets.only(top: 10),
                  child: TextField(
                    controller: _position, //set phone controller
                    style: TextStyle(color: Color(0xFF000000), fontSize: 12),
                    decoration: myInputDecorationWithoutIcon(label: "Job Position"),
                    onChanged: (value) {
                      //set phone  text on change
                      position = value;
                    },
                  ),
                ),
                Container(
                  //padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  margin: EdgeInsets.only(top: 20),
                  child: TextField(
                    controller: _jobType, //set phone controller
                    style: TextStyle(color: Color(0xFF000000), fontSize: 12),
                    decoration: myInputDecorationWithoutIcon(label: "Job Type"),
                    onChanged: (value) {
                      //set phone  text on change
                      jobType = value;
                    },
                  ),
                ),
                Container(
                  //padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  margin: EdgeInsets.only(top: 10),
                  child: TextField(
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    minLines: 2,
                    controller: _experience1, //set phone controller
                    style: TextStyle(color: Color(0xFF000000), fontSize: 12),
                    decoration: myInputDecorationWithoutIcon(label: "Experience 1"),
                    onChanged: (value) {
                      //set phone  text on change
                      experience1 = value;
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
                    controller: _experience2, //set phone controller
                    style: TextStyle(color: Color(0xFF000000), fontSize: 12),
                    decoration: myInputDecorationWithoutIcon(label: "Experience 2"),
                    onChanged: (value) {
                      //set phone  text on change
                      experience2 = value;
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
                    controller: _experience3, //set phone controller
                    style: TextStyle(color: Color(0xFF000000), fontSize: 12),
                    decoration: myInputDecorationWithoutIcon(label: "Experience 3"),
                    onChanged: (value) {
                      //set phone  text on change
                      experience3 = value;
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

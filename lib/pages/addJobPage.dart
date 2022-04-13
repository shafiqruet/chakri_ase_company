import 'dart:convert';
import 'package:chakri_ase_company/navigationDrawer/memberNavigationDrawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chakri_ase_company/helper/globals.dart';

class AddJobPage extends StatefulWidget {
  static const String routeName = '/AddJobPage';

  @override
  State<StatefulWidget> createState() {
    return _AddJobPage();
  }
}

class _AddJobPage extends State<AddJobPage> {
  final formGlobalKey = GlobalKey<FormState>();

  late String errormsg,
      uid,
      jobPosition,
      company,
      vacancy,
      jobType,
      educationalRequirements,
      experience,
      responsibilities,
      additionalRequirements,
      location,
      salary,
      benefits,
      age,
      gender,
      deadline,
      actionType = 'register_job',
      actionText = 'Register';
  late bool error, showprogress, isUserLoginIn, responseTypeStatus = false;

  late SharedPreferences logindata;

  var _jobPosition = TextEditingController();
  var _company = TextEditingController();
  var _responsibilities = TextEditingController();
  var _vacancy = TextEditingController();
  var _jobType = TextEditingController();
  var _educationalRequirements = TextEditingController();
  var _experience = TextEditingController();
  var _additionalRequirements = TextEditingController();
  var _location = TextEditingController();
  var _salary = TextEditingController();
  var _benefits = TextEditingController();
  var _age = TextEditingController();
  var _gender = TextEditingController();
  var _deadline = TextEditingController();

  // ignore: missing_return
  Future<void> updateProfile() async {
    logindata = await SharedPreferences.getInstance();
    uid = logindata.getString('memberUid')!;

    String apiurl = apiBaseUrl + "job.php"; //api url

    var requestData = {
      'responsibilities': _responsibilities.text,
      'jobPosition': _jobPosition.text,
      'company': _company.text,
      'vacancy': _vacancy.text,
      'jobType': _jobType.text,
      'educationalRequirements': _educationalRequirements.text,
      'experience': _experience.text,
      'additionalRequirements': _additionalRequirements.text,
      'location': _location.text,
      'salary': _salary.text,
      'benefits': _benefits.text,
      'age': _age.text,
      'gender': _gender.text,
      'deadline': _deadline.text,
      'uid': uid,
      'action': actionType,
    };

    //print(requestData);

    var response = await http.post(Uri.parse(apiurl), body: requestData);

    if (response.statusCode == 200) {
      var jsondata = json.decode(response.body);

      if (jsondata["errorCode"] == 0) {
        setState(() {
          error = true;
          errormsg = jsondata["message"];
          showprogress = false;
          responseTypeStatus = true;
          actionType = 'update_job';
          actionText = 'Update';
        });
      } else {
        setState(() {
          showprogress = false; //don't show progress indicator
          error = true;
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
    errormsg = "";
    error = false;
    showprogress = false;
    jobPosition = "";
    company = "";
    vacancy = "";
    jobType = "";
    educationalRequirements = "";
    experience = "";
    responsibilities = "";
    additionalRequirements = "";

    responseTypeStatus = false;
    actionType = 'register_job';
    actionText = 'Register';

    super.initState();

    //getUserInformation();
  }

  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.transparent
        //color set to transperent or set your own color
        ));

    //QuillController controller = QuillController.basic();

    return Scaffold(
      appBar: AppBar(
        title: Text('Add Job'),
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
                    "Please fill your job information to manage easy and find match job checker. From this you can also update your information from here",
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
                          controller: _jobPosition, //set phone controller
                          style: TextStyle(color: Color(0xFF000000), fontSize: 12),
                          decoration: myInputDecorationWithoutIcon(label: "Position"),
                          onChanged: (value) {
                            //set phone  text on change
                            jobPosition = value;
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
                          controller: _responsibilities, //set phone controller
                          style: TextStyle(color: Color(0xFF000000), fontSize: 12),
                          minLines: 6, // any number you need (It works as the rows for the textarea)
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          decoration: myInputDecorationWithoutIcon(label: "Responsibilities"),
                          onChanged: (value) {
                            //set phone  text on change
                            responsibilities = value;
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
                          controller: _company, //set phone controller
                          style: TextStyle(color: Color(0xFF000000), fontSize: 12),
                          decoration: myInputDecorationWithoutIcon(label: "Company"),
                          onChanged: (value) {
                            //set phone  text on change
                            company = value;
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
                          controller: _vacancy, //set phone controller
                          style: TextStyle(color: Color(0xFF000000), fontSize: 12),
                          keyboardType: TextInputType.number,
                          decoration: myInputDecorationWithoutIcon(label: "Vacancy"),
                          onChanged: (value) {
                            //set phone  text on change
                            vacancy = value;
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
                          controller: _jobType, //set phone controller
                          style: TextStyle(color: Color(0xFF000000), fontSize: 12),
                          decoration: myInputDecorationWithoutIcon(label: "Job Type"),
                          onChanged: (value) {
                            //set phone  text on change
                            jobType = value;
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
                          controller: _educationalRequirements, //set phone controller
                          style: TextStyle(color: Color(0xFF000000), fontSize: 12),
                          decoration: myInputDecorationWithoutIcon(label: "Educational Requirements"),
                          onChanged: (value) {
                            //set phone  text on change
                            educationalRequirements = value;
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
                          controller: _experience, //set phone controller
                          style: TextStyle(color: Color(0xFF000000), fontSize: 12),
                          decoration: myInputDecorationWithoutIcon(label: "Experience Requirements"),
                          onChanged: (value) {
                            //set phone  text on change
                            experience = value;
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
                          controller: _additionalRequirements, //set phone controller
                          style: TextStyle(color: Color(0xFF000000), fontSize: 12),
                          minLines: 6, // any number you need (It works as the rows for the textarea)
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          decoration: myInputDecorationWithoutIcon(label: "Additional Requirements"),
                          onChanged: (value) {
                            //set phone  text on change
                            additionalRequirements = value;
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
                          controller: _location, //set phone controller
                          style: TextStyle(color: Color(0xFF000000), fontSize: 12),
                          decoration: myInputDecorationWithoutIcon(label: "Location"),
                          onChanged: (value) {
                            //set phone  text on change
                            location = value;
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
                          controller: _salary, //set phone controller
                          style: TextStyle(color: Color(0xFF000000), fontSize: 12),
                          decoration: myInputDecorationWithoutIcon(label: "Salary"),
                          onChanged: (value) {
                            //set phone  text on change
                            salary = value;
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
                          controller: _benefits, //set phone controller
                          style: TextStyle(color: Color(0xFF000000), fontSize: 12),
                          decoration: myInputDecorationWithoutIcon(label: "Benefits"),
                          onChanged: (value) {
                            //set phone  text on change
                            benefits = value;
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
                          controller: _age, //set phone controller
                          style: TextStyle(color: Color(0xFF000000), fontSize: 12),
                          decoration: myInputDecorationWithoutIcon(label: "Age Limit"),
                          onChanged: (value) {
                            //set phone  text on change
                            age = value;
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
                          controller: _gender, //set phone controller
                          style: TextStyle(color: Color(0xFF000000), fontSize: 12),
                          decoration: myInputDecorationWithoutIcon(label: "gender"),
                          onChanged: (value) {
                            //set phone  text on change
                            gender = value;
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
                          controller: _deadline, //set phone controller
                          style: TextStyle(color: Color(0xFF000000), fontSize: 12),
                          decoration: myInputDecorationWithoutIcon(label: "Deadline (Ex: 2022-01-01"),
                          onChanged: (value) {
                            //set phone  text on change
                            deadline = value;
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

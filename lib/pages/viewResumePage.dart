import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:chakri_ase_company/navigationDrawer/memberNavigationDrawer.dart';
import 'package:chakri_ase_company/pages/homePage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:chakri_ase_company/helper/globals.dart';
import 'package:intl/intl.dart';

class ViewResumePage extends StatefulWidget {
  static const String routeName = '/ViewResumePage';
  @override
  State<StatefulWidget> createState() {
    return _ViewResumePage();
  }
}

class _ViewResumePage extends State<ViewResumePage> {
  late String errormsg,
      uid,
      experience1,
      experience2,
      experience3,
      jobPosition,
      jobType,
      skill1,
      skill2,
      skill3,
      skill4,
      skill5,
      skill6,
      skill7,
      skill8,
      expectedSalary,
      presentSalary,
      fatherName,
      motherName,
      birthday,
      dateTime,
      gender,
      maritalStatus,
      education,
      permanentAddress,
      presentAddress;

  late bool error, showprogress;

  late SharedPreferences logindata;
  late bool isUserLoginIn;
  var dateFormat;

  @override
  void initState() {
    errormsg = "";
    error = false;
    showprogress = false;
    experience1 = "";
    experience2 = "";
    experience3 = "";
    jobPosition = "";
    jobType = "";
    skill1 = "";
    skill2 = "";
    skill3 = "";
    skill4 = "";
    skill5 = "";
    skill6 = "";
    skill7 = "";
    skill8 = "";
    expectedSalary = "";
    presentSalary = "";
    fatherName = "";
    motherName = "";
    birthday = "";
    dateTime = "";
    gender = "";
    maritalStatus = "";
    education = "";
    permanentAddress = "";
    presentAddress = "";

    super.initState();
    checkIfAlreadyLogin();
    getUserInfo();
  }

  void checkIfAlreadyLogin() async {
    logindata = await SharedPreferences.getInstance();
    //sUserLoginIn = logindata.getBool('isLoggedIn')!;
    if (logindata.getBool('isLoggedIn') != null) {
      isUserLoginIn = true;
    } else {
      isUserLoginIn = false;
    }

    if (isUserLoginIn == false) {
      Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context) => HomePage()));
    }
  }

  void getUserInfo() async {
    logindata = await SharedPreferences.getInstance();

    uid = logindata.getString('memberUid')!;

    String apiurl = apiBaseUrl + "view_resume.php"; //api url

    var response = await http.post(Uri.parse(apiurl), body: {'uid': uid, 'action': 'view_resume'});

    if (response.statusCode == 200) {
      var jsondata = json.decode(response.body);

      if (jsondata["errorCode"] == 0) {
        Map<String, dynamic> userMap = jsonDecode(jsondata["response_data"]);
        /* print(userMap); */
        setState(() {
          error = false;
          showprogress = false;
          experience1 = userMap['experience1'] != null ? userMap['experience1'] : '';
          experience2 = userMap['experience2'] != null ? userMap['experience2'] : '';
          experience3 = userMap['experience3'] != null ? userMap['experience3'] : '';
          jobPosition = userMap['position'] != null ? userMap['position'] : '';
          jobType = userMap['job_type'] != null ? userMap['job_type'] : '';
          skill1 = userMap['skills1'] != null ? userMap['skills1'] : '';
          skill2 = userMap['skills2'] != null ? userMap['skills2'] : '';
          skill3 = userMap['skills3'] != null ? userMap['skills3'] : '';
          skill4 = userMap['skills4'] != null ? userMap['skills4'] : '';
          skill5 = userMap['skills5'] != null ? userMap['skills5'] : '';
          skill6 = userMap['skills6'] != null ? userMap['skills6'] : '';
          skill7 = userMap['skills7'] != null ? userMap['skills7'] : '';
          skill8 = userMap['skills8'] != null ? userMap['skills8'] : '';
          expectedSalary = userMap['expected_salary'] != null ? userMap['expected_salary'] : '';
          presentSalary = userMap['present_salary'] != null ? userMap['present_salary'] : '';
          fatherName = userMap['father_name'] != null ? userMap['father_name'] : '';
          motherName = userMap['mother_name'] != null ? userMap['mother_name'] : '';
          dateFormat = userMap['birthday'] != null ? userMap['birthday'] : '';
          dateFormat = DateTime.parse(dateFormat);
          birthday = DateFormat.yMMMd().format(dateFormat);
          gender = userMap['gender'] != null ? userMap['gender'] : '';
          maritalStatus = userMap['marital_status'] != null ? userMap['marital_status'] : '';
          education = userMap['education'] != null ? userMap['education'] : '';
          permanentAddress = userMap['permanent_address'] != null ? userMap['permanent_address'] : '';
          presentAddress = userMap['present_address'] != null ? userMap['present_address'] : '';
        });
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Resume'),
      ),
      drawer: MemberNavigationDrawer(),
      body: SingleChildScrollView(
          child: Column(children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(25, 10, 25, 10),
          child: Table(
            /*  columnWidths: {0: FixedColumnWidth(30), 1: FlexColumnWidth()}, */
            children: [
              TableRow(children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Experience-1'),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(experience1),
                )
              ]),
              TableRow(children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Experience-2'),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(experience2),
                )
              ]),
              TableRow(children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Experience-3'),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(experience3),
                )
              ]),
              TableRow(children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Job Position'),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(jobPosition),
                )
              ]),
              TableRow(children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Job Type'),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(jobType),
                )
              ]),
            ],
            border: TableBorder.all(width: 1, color: Colors.purple),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(25, 10, 25, 10),
          child: Table(
            /*  columnWidths: {0: FixedColumnWidth(30), 1: FlexColumnWidth()}, */
            children: [
              TableRow(children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Skill-1'),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(skill1),
                )
              ]),
              TableRow(children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Skill-2'),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(skill2),
                )
              ]),
              TableRow(children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Skill-3'),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(skill3),
                )
              ]),
              TableRow(children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Skill-4'),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(skill4),
                )
              ]),
              TableRow(children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Skill-5'),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(skill5),
                )
              ]),
              TableRow(children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Skill-6'),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(skill6),
                )
              ]),
              TableRow(children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Skill-7'),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(skill7),
                )
              ]),
              TableRow(children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Skill-8'),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(skill8),
                )
              ]),
              TableRow(children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Expected Salary'),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(expectedSalary),
                )
              ]),
              TableRow(children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Present Salary'),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(presentSalary),
                )
              ]),
            ],
            border: TableBorder.all(width: 1, color: Colors.purple),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(25, 10, 25, 10),
          child: Table(
            /*  columnWidths: {0: FixedColumnWidth(30), 1: FlexColumnWidth()}, */
            children: [
              TableRow(children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Father Name'),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(fatherName),
                )
              ]),
              TableRow(children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Mother Name'),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(motherName),
                )
              ]),
              TableRow(children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Birthday'),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(birthday),
                )
              ]),
              TableRow(children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Gender'),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(gender),
                )
              ]),
              TableRow(children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Marital Status'),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(maritalStatus),
                )
              ]),
              TableRow(children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Education'),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(education),
                )
              ]),
              TableRow(children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Permanent Address'),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(permanentAddress),
                )
              ]),
              TableRow(children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Present Address'),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(presentAddress),
                )
              ]),
            ],
            border: TableBorder.all(width: 1, color: Colors.purple),
          ),
        )
      ])),
    );
  }
}

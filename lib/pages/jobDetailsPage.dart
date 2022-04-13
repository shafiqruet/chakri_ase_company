import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:chakri_ase_company/navigationDrawer/memberNavigationDrawer.dart';
import 'package:chakri_ase_company/pages/homePage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:chakri_ase_company/helper/globals.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';

class JobDetailsPage extends StatefulWidget {
  static const String routeName = '/JobDetailsPage';

  @override
  State<StatefulWidget> createState() {
    return _JobDetailsPage();
  }
}

class _JobDetailsPage extends State<JobDetailsPage> {
  late String errormsg,
      uid,
      jobId,
      position,
      company,
      vacancy,
      jobContext,
      employmentStatus,
      responsibilities,
      workplace,
      educationalRequirements,
      experienceRequirements,
      additionalRequirements,
      location,
      salary,
      benefits,
      age,
      gender,
      applicationDeadLine;

  late bool error, showprogress, responseTypeStatus = false;

  late SharedPreferences logindata;
  late bool isUserLoginIn;
  var argumentsValue, dateTime;

  @override
  void initState() {
    errormsg = "";
    error = false;
    showprogress = false;
    position = "";
    company = "";
    vacancy = "";
    jobContext = "";
    employmentStatus = "";
    responsibilities = "";
    workplace = "";
    educationalRequirements = "";
    experienceRequirements = "";
    additionalRequirements = "";
    location = "";
    salary = "";
    benefits = "";
    age = "";
    gender = "";
    applicationDeadLine = "";
    responseTypeStatus = false;

    Future.delayed(Duration.zero, () {
      setState(() {
        argumentsValue = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      });
      _getUserInfo(argumentsValue['id']);
    });

    checkIfAlreadyLogin();
    super.initState();
  }

  void applyJob() async {
    logindata = await SharedPreferences.getInstance();

    uid = logindata.getString('memberUid')!;
    jobId = argumentsValue['id'];

    String apiurl = apiBaseUrl + "job_apply.php"; //api url

    var response = await http.post(Uri.parse(apiurl), body: {'uid': uid, 'jobId': jobId, 'action': 'job_apply'});

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
        setState(() {
          error = true;
          showprogress = false;
          errormsg = jsondata["message"];
          responseTypeStatus = true;
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

  void checkIfAlreadyLogin() async {
    logindata = await SharedPreferences.getInstance();
    //isUserLoginIn = logindata.getBool('isLoggedIn')!;
    if (logindata.getBool('isLoggedIn') != null) {
      isUserLoginIn = true;
    } else {
      isUserLoginIn = false;
    }

    if (isUserLoginIn == false) {
      Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context) => HomePage()));
    }
  }

  void _getUserInfo(String jobId) async {
    String apiurl = apiBaseUrl + "job_list.php"; //api url

    var response = await http.post(Uri.parse(apiurl), body: {'JobId': jobId, 'action': 'get_job_details'});

    if (response.statusCode == 200) {
      var jsondata = json.decode(response.body);
      //print(jsondata["response_data"]);
      if (jsondata["errorCode"] == 0) {
        setState(() {
          Map<String, dynamic> userMap = jsonDecode(jsondata["response_data"]);
          position = userMap['position'] != null ? userMap['position'] : '';
          company = userMap['company'] != null ? userMap['company'] : '';
          responsibilities = userMap['responsibilities'] != null ? userMap['responsibilities'] : '';
          vacancy = userMap['vacancy'] != null ? userMap['vacancy'] : '';
          jobContext = userMap['context'] != null ? userMap['context'] : '';
          employmentStatus = userMap['employment_status'] != null ? userMap['employment_status'] : '';
          workplace = userMap['workplace'] != null ? userMap['workplace'] : '';
          educationalRequirements = userMap['educational_requirements'] != null ? userMap['educational_requirements'] : '';
          experienceRequirements = userMap['experience_requirements'] != null ? userMap['experience_requirements'] : '';
          additionalRequirements = userMap['additional_requirements'] != null ? userMap['additional_requirements'] : '';
          location = userMap['location'] != null ? userMap['location'] : '';
          salary = userMap['salary'] != null ? userMap['salary'] : '';
          benefits = userMap['benefits'] != null ? userMap['benefits'] : '';
          age = userMap['age'] != null ? userMap['age'] : '';
          gender = userMap['gender'] != null ? userMap['gender'] : '';
          dateTime = userMap['deadline'] != null ? userMap['deadline'] : '';
          dateTime = DateTime.parse(dateTime);
          applicationDeadLine = DateFormat.yMMMd().format(dateTime);
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
        title: Text('Job Details'),
      ),
      drawer: MemberNavigationDrawer(),
      body: SingleChildScrollView(
          child: Column(children: <Widget>[
        Container(
          //show error message here
          margin: EdgeInsets.only(top: 0),
          padding: EdgeInsets.all(10),
          child: error ? showMessage(errormsg, responseTypeStatus) : Container(),
          //if error == true then show error message
          //else set empty container as child
        ),
        Html(data: "<b>Job Position: </b>" + position + "<br><br><b>Company Name: </b> " + company, style: {
          // some other granular customizations are also possible
          "b": Style(padding: EdgeInsets.fromLTRB(5, 2, 5, 2), margin: EdgeInsets.fromLTRB(0, 10, 0, 10)),
          "h2": Style(),
        }),
        Html(
          data: "<b>Vacancy: </b>" + vacancy,
        ),
        Html(data: "<b>Job Responsibilites:</b><br><div>" + responsibilities + "</div>", style: {
          "li": Style(
            padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
          ),
          "div": Style(
              border: Border.all(
                color: Color.fromARGB(251, 114, 113, 113),
                width: 1,
              ),
              padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
              margin: EdgeInsets.fromLTRB(0, 10, 0, 0)),
        } /* style: {"div": Style(fontFamily: 'RaleWay', padding: EdgeInsets.fromLTRB(0, 5, 0, 5), border: Border.all(color: Colors.blueAccent))} */
            ),
        Html(
          data: "<b>Employment Status: </b>" + employmentStatus,
        ),
        Html(
          data: "<b>Workplace: </b>" + workplace,
        ),
        Html(
          data: "<b>Educational Requirements: </b><br>" + educationalRequirements,
        ),
        Html(
          data: "<b>Experience Requirements: </b><br>" + experienceRequirements,
        ),
        Html(data: "<b>Additional Requirements: </b><br><div>" + additionalRequirements + "</div>", style: {
          "li": Style(
            padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
          ),
          "div": Style(
              border: Border.all(
                color: Color.fromARGB(251, 114, 113, 113),
                width: 1,
              ),
              padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
              margin: EdgeInsets.fromLTRB(0, 10, 0, 0)),
        }),
        Html(
          data: "<b>Job Location: </b>" + location,
        ),
        Html(
          data: "<b>Salary: </b><br>" + salary,
        ),
        Html(data: "<b>Compensation & Other Benefits: </b><br><div>" + benefits + "</div>", style: {
          "li": Style(
            padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
          ),
          "div": Style(
              border: Border.all(
                color: Color.fromARGB(251, 114, 113, 113),
                width: 1,
              ),
              padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
              margin: EdgeInsets.fromLTRB(0, 10, 0, 0)),
        }),
        Html(
          data: "<b>Application Deadline: </b>" + applicationDeadLine,
        ),
        Html(
          data: "&nbsp;",
        ),
        TextButton(
          style: TextButton.styleFrom(
              primary: Colors.black,
              padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
              textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              backgroundColor: Color(0xFFA56E57)),
          onPressed: () {
            applyJob();
          },
          child: Text('Apply This Job'),
        ),
        Html(
          data: "&nbsp;",
        ),
      ])),
    );
  }
}

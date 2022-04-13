import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:chakri_ase_company/helper/globals.dart';
import 'package:chakri_ase_company/navigationDrawer/memberNavigationDrawer.dart';
import 'package:flutter_html/flutter_html.dart';

class JobListPageOld extends StatefulWidget {
  static const String routeName = '/JobListPage';
  @override
  State<StatefulWidget> createState() => new _JobListPage();
}

class _JobListPage extends State<JobListPageOld> {
  int page = 0;
  ScrollController _sc = new ScrollController();
  bool isLoading = false;
  List users = [];
  final dio = new Dio();
  @override
  void initState() {
    this._getMoreData(page);
    super.initState();
    _sc.addListener(() {
      if (_sc.position.pixels == _sc.position.maxScrollExtent) {
        _getMoreData(page);
      }
    });
  }

  @override
  void dispose() {
    _sc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Job Lists"),
      ),
      drawer: MemberNavigationDrawer(),
      body: Center(
        child: _buildList(),
      ),
      resizeToAvoidBottomInset: false,
    );
  }

  Widget _buildList() {
    return ListView.builder(
      itemCount: users.length + 1, // Add one more item for progress indicator
      padding: EdgeInsets.symmetric(vertical: 8.0),
      itemBuilder: (BuildContext context, int index) {
        if (index == users.length) {
          return _buildProgressIndicator();
        } else {
          return Container(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
            margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
            child: new ListTile(
              title: Html(
                data: "<h3>" +
                    users[index]['position'] +
                    "</h3>" +
                    "<span><b>" +
                    users[index]['company'] +
                    "</span>" +
                    "<span>, " +
                    users[index]['location'] +
                    "</span></b>" +
                    "<p>" +
                    users[index]['educational_requirements'] +
                    "</p>",
              ),
              onTap: () {
                /*  Navigator.of(context).pushNamed('/jobDetails', arguments: "1"); */
                Navigator.pushNamed(context, "/jobDetails", arguments: users[index]);
              },
            ),
            decoration: BoxDecoration(
              border: Border.all(
                color: Color(0xFF958888),
                style: BorderStyle.solid,
                width: 1.0,
              ),
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(10.0),
            ),
          );
        }
      },
      controller: _sc,
    );
  }

  void _getMoreData(int index) async {
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });
      var url = apiBaseUrl + "job_list.php?page=" + index.toString() + "&results=10&action=get_job_lists";
      final response = await dio.get(url);
      //print(response.data['response_data']);
      List tList = [];
      for (int i = 0; i < response.data['response_data'].length; i++) {
        tList.add(response.data['response_data'][i]);
      }

      setState(() {
        isLoading = false;
        users.addAll(tList);
        page++;
      });
    }
  }

  Widget _buildProgressIndicator() {
    return new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Center(
        child: new Opacity(
          opacity: isLoading ? 1.0 : 00,
          child: new CircularProgressIndicator(),
        ),
      ),
    );
  }
}

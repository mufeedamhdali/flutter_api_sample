import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mufeeda_test_api/models/User.dart';
import 'package:http/http.dart' as http;

class UsersScreen extends StatefulWidget {

  @override
  _UsersScreenState createState() => _UsersScreenState();

}

class _UsersScreenState extends State<UsersScreen> {
  late List data = []; // JSON returned by api
  List<User> userList = [];// List of user objects
  bool isLoading  = true;

  // api call
  // the given api returns a list of users
  Future<String> getData() async {
    await new Future.delayed(const Duration(seconds: 2));
    var response = await http.get(
        Uri.parse("https://reqres.in/api/users?page=2"),
        headers: {"Accept": "application/json"});

    setState(() {
      data = json.decode(response.body)["data"];
      isLoading  = false;
    });
    return "Success";
  }

  // method to convert JSON data into list of user objects
  getUsers() {
    userList.clear();
    for (var item in data) {
      User temp = User(
          id: item['id'].toString(),
          email: item['email'],
          name: item['first_name'] + " " + item['last_name'],
          avatar: item['avatar']);
      userList.add(temp);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    getData();
    getUsers();
    return Scaffold(
      appBar: AppBar(
        title: Text("Api Sample"),
      ),
      body: isLoading ? Center(
        child: CircularProgressIndicator(),
      ) : Center(
        child: getList(),
      ),
    );
  }

  // listview builder
  Widget getList() {
    if (data.length < 1) {
      return Container(
        child: Center(
          child: Text("No data Found"),
        ),
      );
    }
    return ListView.separated(
      itemCount: data.length,
      itemBuilder: (BuildContext context, int index) {
        return getListItem(index);
      },
      separatorBuilder: (context, index) {
        return Divider();
      },
    );
  }

  // this widget returns details of each user one by one
  Widget getListItem(int i) {
    if (data.length < 1) return Center(
      child: Text('No data'),
    );

    if (i == 0) {
      return Container(
          margin: EdgeInsets.all(4),
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Text(
              "All Students",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20
              ),
            ),
          ));
    }

    return Column(
      children: [
        Container(
          child: Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(20.0),
              margin: EdgeInsets.only(left: 10, right: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      offset: Offset(2, 2),
                      spreadRadius: 2,
                      blurRadius: 3.0,
                    ),
                  ]),
              child: Row(
                children: [
                  Image.network(userList[i].avatar ?? ''),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          userList[i].name ?? ' ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left:10, right: 10),
                        child: Text(
                          "Student",
                          style: TextStyle(
                              fontSize: 16
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          userList[i].email ?? '',
                          style: TextStyle(
                              fontSize: 14
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              )),
        ),
      ],
    );
  }

}

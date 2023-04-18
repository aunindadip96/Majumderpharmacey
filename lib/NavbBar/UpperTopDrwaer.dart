import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class myprofildrwaer extends StatefulWidget {
  const myprofildrwaer({Key? key}) : super(key: key);

  @override
  _myprofildrwaerState createState() => _myprofildrwaerState();
}

class _myprofildrwaerState extends State<myprofildrwaer> {
  var Userdata;

  @override
  void initState() {
    _getuserinfo();
    super.initState();
  }

  void _getuserinfo() async {
    SharedPreferences localstorage = await SharedPreferences.getInstance();
    var userJson = localstorage.getString('user');
    var user = jsonDecode(userJson!);

    setState(() {
      Userdata = user;
      print(user.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blueAccent,
      width: double.infinity,
      height: 290,
      padding: const EdgeInsets.only(top: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            height: 70,
          ),
          Text(
            Userdata != null ? '${Userdata['username']}' : " No Name",
            style: const TextStyle(color: Colors.white, fontSize: 20),
          ),
          Text(
            Userdata != null ? '${Userdata['email']}' : " No Name",
            style: TextStyle(
              color: Colors.grey[200],
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

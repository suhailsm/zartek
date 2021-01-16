
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zartektest/authentication_service.dart';
import 'package:zartektest/home.dart';
import 'package:zartektest/main.dart';

class AppDrawer extends StatelessWidget {
  String customer_id;
  String uid = "0000000000";
  getUid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    uid = prefs.getString('uid');
    return uid;
  }
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
              margin: EdgeInsets.zero,
              padding: EdgeInsets.zero,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage('assets/1.jpg'))),
              child: Stack(children: <Widget>[
                Text(uid)
              ])),
          ListTile(
              title: Text("Home"),
              leading: new Icon(Icons.home),
              onTap: () {
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => new Home())).then(
                      (result) {
                    Navigator.of(context).pop();
                  },
                );
              }),
          Container(
            // This align moves the children to the bottom
              child: Align(
                  alignment: FractionalOffset.bottomCenter,
                  // This container holds all the children that will be aligned
                  // on the bottom and should not scroll with the above ListView
                  child: Container(
                      child: Column(
                        children: <Widget>[
                          Divider(),
                          RaisedButton(
                            onPressed: () =>signOutUser().then((value) {
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(builder: (context) => HomePage()),
                                    (Route<dynamic> route) => false);
                          }),
                            child: Text("Sign out"),
                          ),
                        ],
                      ))))
        ],
      ),
    );
  }
}

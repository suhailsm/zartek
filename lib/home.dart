import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:connectivity/connectivity.dart';
import 'package:zartektest/appdrawer.dart';
class Home extends StatefulWidget {
  final String uid;

  Home({Key key, @required this.uid}) : super(key: key);

  @override
  _HomeState createState() => _HomeState(uid);
}

class _HomeState extends State<Home> {
  final String uid;
  _HomeState(this.uid);
  PageController _pageController;
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  List cat_news,catNews;
  List img = new List();
  var  cat_data,menu_list;

  Uint8List dist;
  bool _progressBarActive = true;

//check Internet
  _checkInternet() async {
    var result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.none) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: new Text("Error"),
            content: new Text("Please Check your Internet Connection"),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              new FlatButton(
                child: new Text("OK"),
                onPressed: () {
                  SystemNavigator.pop();
                },
              ),
            ],
          );
        },
      );
    } else if (result == ConnectivityResult.wifi) {
      setState(() {
        getCategoryNews();
      });
    } else if (result == ConnectivityResult.mobile) {
      setState(() {
        getCategoryNews();
      });
    }
  }

  Future<String> getCategoryNews() async {
    http.Response response = await http.get(
      Uri.encodeFull(
          "https://www.mocky.io/v2/5dfccffc310000efc8d2c1ad"),
    );

    setState(() {
      cat_data = json.decode(response.body);
      menu_list = cat_data["table_menu_list"];
      print(cat_data);
        //initially loaded items
        var _a = menu_list[0];

        _onSelectedCat(_a["menu_category_id"].toString());

        _progressBarActive = false;

    });
    return "Success";
  }

  @override
  void initState() {
    // TODO: implement initState
    //getData();
    _checkInternet();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0.0,
        title: Text("Zartek"),
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              _scaffoldKey.currentState.openDrawer();
            }),
      ),
      drawer: AppDrawer(),

      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: _pageController,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(10.0,0,10.0,0),
            child: ListView(
              children: <Widget>[
                SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "Category",
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 10.0),

                //Horizontal List here
                _progressBarActive == true? Center(
                  child: const CircularProgressIndicator(),
                )
                    :Container(
                  height: MediaQuery.of(context).size.height/6,
                  child: ListView.builder(
                    primary: false,
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: menu_list == null ? 0:menu_list.length,
                    itemBuilder: (BuildContext context, int index) {
                      Map cat_pro = menu_list[index];
                      String cat_id = cat_pro['menu_category_id'].toString();


                      return Padding(
                        padding: EdgeInsets.only(right: 10.0),
                        child: GestureDetector(child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Stack(
                            children: <Widget>[
                          Image.network(menu_list.menu_category_image,
                                fit: BoxFit.fill,
                                height: MediaQuery.of(context).size.height/6,
                                width: MediaQuery.of(context).size.height/6,
                              ),

                              Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    // Add one stop for each color. Stops should increase from 0 to 1
                                    stops: [0.2, 0.7],
                                    colors: [
                                      Color.fromARGB(100, 0, 0, 0),
                                      Color.fromARGB(100, 0, 0, 0),
                                    ],
                                    // stops: [0.0, 0.1],
                                  ),
                                ),
                                height: MediaQuery.of(context).size.height/6,
                                width: MediaQuery.of(context).size.height/6,
                              ),


                              Center(

                                child: Container(
                                  height: MediaQuery.of(context).size.height/6,
                                  width: MediaQuery.of(context).size.height/6,
                                  padding: EdgeInsets.all(1),
                                  constraints: BoxConstraints(
                                    minWidth: 20,
                                    minHeight: 20,
                                  ),
                                  child: Center(
                                    child: Text(
                                      cat_pro["name"],
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),

                            ],
                          ),
                        ),
                          onTap: (){
                            _onSelectedCat(cat_id);
                          },
                        ),
                      );
                    },
                  ),
                ),

                SizedBox(height: 20.0),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "Items",
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.w800,
                      ),
                    ),

                  ],
                ),

                SizedBox(height: 10.0),

                //Horizontal List here
                Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: ListView.builder(
                    primary: false,
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: catNews == null ? 0 :catNews.length,
                    itemBuilder: (BuildContext context, int index) {
                      Map _catNews = catNews[index];
                      String id = _catNews['id'].toString();

                      return Padding(
                          padding: EdgeInsets.only(right: 10.0),
                          child: GestureDetector(child: Padding(
                            padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                            child: Container(
                              height: MediaQuery.of(context).size.height / 2.4,
                              width: MediaQuery.of(context).size.width / 1.2,
                              child: Card(
                                shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(10.0)),
                                elevation: 3.0,
                                child: Column(
                                  children: <Widget>[
                                    Stack(
                                      children: <Widget>[
                                        Container(
                                          height: MediaQuery.of(context).size.height/3.7,
                                          width: MediaQuery.of(context).size.width,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(10),
                                              topRight: Radius.circular(10),
                                            ),
                                            child: Image.memory(
                                              base64.decode(_catNews["image"]),
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          top: 6.0,
                                          right: 6.0,
                                          child: Card(

                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius.circular(4.0)),
                                            child: Padding(
                                              padding: EdgeInsets.all(2.0),
                                              child: Row(
                                                children: <Widget>[
                                                  Text(
                                                    _catNews["created_at"].toString(),
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),

                                    SizedBox(height: 7.0),

                                    Padding(
                                      padding: EdgeInsets.only(left: 15.0),
                                      child: Container(
                                        width: MediaQuery.of(context).size.width,
                                        child: Text(
                                          _catNews['headlines'],
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w800,
                                          ),
                                          textAlign: TextAlign.left,
                                        ),
                                      ),
                                    ),

                                    SizedBox(height: 7.0),

                                    Padding(
                                      padding: EdgeInsets.only(left: 15.0),
                                      child: Container(
                                        width: MediaQuery.of(context).size.width,
                                        child: Text(
                                          _catNews['detail_news'],
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                      ),
                                    ),

                                    SizedBox(height: 10.0),

                                  ],
                                ),
                              ),
                            ),
                          ),
                            onTap: () {

                            },
                          )
                      );
                    },
                  ),
                ),

                SizedBox(height: 10.0),


              ],
            ),
          ),
        ],
      ),
    );
  }
  // On Tap in category
  void _onSelectedCat(String cat_id) {

    setState(() {
      for (var cat in menu_list) {
        String category = cat["menu_category_id"].toString();
        if (category == cat_id) {
          catNews = cat["category_dishes"];
        }
      }
    });

  }
}

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
// import 'package:latlong/latlong.dart' as ll;

class HomePage extends StatefulWidget {
  HomePage();

  @override
  _HomePageState createState() => _HomePageState();
}

GoogleMapController mapController;

class _HomePageState extends State<HomePage> {
  _HomePageState();

  var currentLocation = LocationData;
  var location = new Location();
  var lat, long, accuracy;

  Map<String, dynamic> levelData = {};
  List<dynamic> leaderboard;

  var userToken =
      "334b88e4be964a1dec398cac9c5c9699841750b1b6bac8be82c745041aa4c277";

  final _answerFieldController = TextEditingController();

  final _fieldFocusNode = new FocusNode();

  Future getLevelData() async {
    http.Response response = await http.get(
        Uri.encodeFull("http://10.0.2.2:8000/api/getlevel/"),
        headers: {"Authorization": "Token $userToken"});
    levelData = json.decode(response.body);
  }

  Future getScoreboard() async {
    http.Response response = await http.get(
        Uri.encodeFull("http://10.0.2.2:8000/api/scoreboard/"),
        headers: {"Authorization": "Token $userToken"});
    leaderboard = json.decode(response.body);
  }

  Future submitLevelAnswer(answer) async {
    http.Response response = await http.post(
      Uri.encodeFull("http://10.0.2.2:8000/api/submit/ans/"),
      headers: {
        "Authorization": "Token $userToken",
        "Content-Type": "application/json"
      },
      body: json.encode({
        "answer": answer,
        "level_no": levelData["level_no"],
      }),
    );
    var data = json.decode(response.body);

    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(data["success"] == false ? "try again" : "correct answer"),
      duration: Duration(seconds: 1),
    ));
    setState(() {
      _answerFieldController.clear();
      getLevelData();
    });
  }

  Future submitLocation() async {
    http.Response response = await http.post(
      Uri.encodeFull("http://10.0.2.2:8000/api/submit/location/"),
      headers: {
        "Authorization": "Token $userToken",
        "Content-Type": "application/json"
      },
      body: json.encode({
        "lat": lat,
        "long": long,
        "level_no": levelData["level_no"],
      }),
    );
    var data = json.decode(response.body);
    print(data);

    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content:
          Text(data["success"] == false ? "try again" : "correct location"),
      duration: Duration(seconds: 1),
    ));
    setState(() {
      getLevelData();
    });
  }

  @override
  void dispose() {
    _answerFieldController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    {
      getLevelData();
      getScoreboard();
      location.changeSettings(accuracy: LocationAccuracy.HIGH);
      location.onLocationChanged().listen((LocationData currentLocation) {
        setState(() {
          lat = currentLocation.latitude;
          long = currentLocation.longitude;
          accuracy = currentLocation.accuracy;
          // print(lat);
          // print(long);
        });
      });
    }
  }

  bool _isUp = true;
  bool _isOpen = false;

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;

    double bottom = _isUp ? 55.0 : (deviceSize.height / 2);
    double top = _isUp
        ? (_isOpen ? deviceSize.height / 3 : (deviceSize.height - 145))
        : bottom;

    double top2 =
        _isUp ? (deviceSize.height - 35) : ((deviceSize.height) / 2) + 10;

    var bottom3 = _isUp ? deviceSize.height : ((deviceSize.height) / 2) + 10;

    var bottom4 = _isUp ? 10.0 : deviceSize.height - 80;
    var right4 = 20.0;

    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomPadding: true,
      drawer: Drawer(
        child: Text("drawer"),
      ),
      // appBar: AppBar(
      //   title: Text("Home"),
      //   backgroundColor: Colors.black,
      // ),
      body: Stack(
        children: <Widget>[
          GameMap(),
          AnimatedPositioned(
            bottom: bottom3,
            right: 0.0,
            left: 0.0,
            top: -15.0,
            duration: Duration(milliseconds: 900),
            curve: Curves.easeOutQuart,
            child: Center(
              child: AnimatedOpacity(
                duration: Duration(milliseconds: 900),
                curve: Curves.easeOutQuart,
                opacity: _isUp ? 0.5 : 0.8,
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    // gradient: LinearGradient(
                    //   begin: Alignment.topCenter,
                    //   end: Alignment.bottomCenter,
                    //   stops: [0.5, 1.0],
                    //   colors: [Colors.green, Colors.lightGreen],
                    // ),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: [0.7, 1.0],
                      colors: [Colors.black, Colors.grey],
                    ),
                    // color: Colors.black,
                    borderRadius: BorderRadius.circular(17),
                  ),
                  child: Container(
                    padding: EdgeInsets.fromLTRB(10, 25, 10, 10),
                    alignment: Alignment.topLeft,
                    child: Text(
                      "INSTRUCTIONS",
                      style:
                          TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),
          ),
          AnimatedPositioned(
            bottom: bottom,
            right: 10.0,
            left: 10.0,
            top: top,
            duration: Duration(milliseconds: 900),
            curve: Curves.bounceOut,
            child: Center(
              child: AnimatedOpacity(
                duration: Duration(milliseconds: 900),
                curve: Curves.easeOutQuart,
                opacity: _isUp ? (_isOpen ? 0.9 : 0.7) : 0.0,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _isOpen = !_isOpen;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(17),
                    ),
                    child: Stack(
                      children: <Widget>[
                        Positioned(
                          top: 0.0,
                          left: 0.0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Text(
                                levelData["title"] == null
                                    ? "please wait"
                                    : levelData["title"],
                                style: TextStyle(
                                  color: _isOpen
                                      ? Color(0xFF0059B3)
                                      : Colors.white,
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                width: 20.0,
                              ),
                              levelData["title"] == null
                                  ? FlatButton(
                                      child: Icon(
                                        Icons.refresh,
                                        color:
                                            Color(0xFF0091FF).withOpacity(0.7),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          getLevelData();
                                        });
                                      },
                                    )
                                  : levelData["map_hint"]
                                      ? Row(
                                          children: <Widget>[
                                            Icon(
                                              Icons.location_on,
                                              size: 28,
                                            ),
                                            SizedBox(
                                              width: 50.0,
                                            ),
                                            Text(
                                              "location hint",
                                              style: TextStyle(
                                                  color: Color(0xFF0091FF)
                                                      .withOpacity(0.7)),
                                            )
                                          ],
                                        )
                                      : Row(
                                          children: <Widget>[
                                            Icon(
                                              Icons.assistant_photo,
                                              size: 28,
                                            ),
                                            SizedBox(
                                              width: 50.0,
                                            ),
                                            Text(
                                              "main question",
                                              style: TextStyle(
                                                  color: Color(0xFF0091FF)
                                                      .withOpacity(0.7)),
                                            )
                                          ],
                                        ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          levelData["title"] == null
              ? Container()
              : AnimatedPositioned(
                  top: _isOpen && _isUp
                      ? deviceSize.height / 3 + 60.0
                      : deviceSize.height + 5.0,
                  bottom: _isOpen && _isUp ? 75.0 : -5.0,
                  left: 20.0,
                  right: 20.0,
                  duration: Duration(milliseconds: 900),
                  curve: Curves.easeOutQuart,
                  child: GestureDetector(
                    onTap: () {
                      FocusScope.of(context).requestFocus(new FocusNode());
                    },
                    child: Container(
                      child: Center(
                        child: ScrollConfiguration(
                          behavior: MyBehavior(),
                          child: ListView(
                            children: <Widget>[
                              ListTile(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 3, horizontal: 7),
                                leading: levelData["map_hint"]
                                    ? Text("LOCATION HINT")
                                    : Text("QUESTION"),
                              ),
                              ListTile(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 7, horizontal: 7),
                                title: Text(
                                  levelData["ques"],
                                  style: TextStyle(
                                      color: _isOpen
                                          ? Color(0xFF0091CC)
                                          : Colors.white,
                                      fontSize: 17,
                                      fontStyle: FontStyle.italic),
                                ),
                              ),
                              ListTile(
                                title: levelData["map_hint"]
                                    ? Text(
                                        "LATITUDE: $lat                                        LONGITUDE: $long")
                                    : TextField(
                                        focusNode: _fieldFocusNode,
                                        controller: _answerFieldController,
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                        decoration: InputDecoration(
                                          filled: false,
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0xFF0091CC),
                                              width: 3.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color:
                                                  Colors.white.withOpacity(0.5),
                                              width: 3.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          labelText: 'answer here',
                                          labelStyle: TextStyle(
                                              color:
                                                  Colors.white.withOpacity(0.5),
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                //
                              ),
                              ListTile(
                                title: FlatButton(
                                  child: Text("SUBMIT"),
                                  onPressed: () {
                                    setState(() {
                                      levelData["map_hint"]
                                          ? submitLocation()
                                          : submitLevelAnswer(
                                              _answerFieldController.text);
                                    });
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
          AnimatedPositioned(
            bottom: -15.0,
            right: 0.0,
            left: 0.0,
            top: top2,
            duration: Duration(milliseconds: 900),
            curve: Curves.easeOutQuart,
            child: Center(
              child: AnimatedOpacity(
                duration: Duration(milliseconds: 900),
                curve: Curves.easeOutQuart,
                opacity: _isUp ? 0.5 : 0.8,
                child: GestureDetector(
                  onVerticalDragStart: (context) {
                    setState(() {
                      _isUp = !_isUp;
                      getScoreboard();
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 50, horizontal: 20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: [0.5, 1.0],
                        colors: [Color(0xFF0091FF), Color(0xFF0059FF)],
                      ),
                      borderRadius: BorderRadius.circular(17),
                    ),
                    child: Center(
                      child: ListView.builder(
                        itemCount: leaderboard == null ? 0 : leaderboard.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "$index",
                                    style: TextStyle(
                                        fontSize: 23,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Text(
                                    leaderboard[index]["name"],
                                    style: TextStyle(
                                        fontSize: 23,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              Text(
                                "${leaderboard[index]["score"]}",
                                style: TextStyle(
                                    fontSize: 23, fontWeight: FontWeight.bold),
                              )
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          AnimatedPositioned(
            bottom: deviceSize.height - top2 - 25,
            left: 20,
            top: top2 - 35,
            duration: Duration(milliseconds: 1200),
            curve: Curves.easeOutQuart,
            child: GestureDetector(
              onVerticalDragStart: (context) {
                setState(() {
                  _isUp = !_isUp;
                  getScoreboard();
                });
              },
              child: Image.asset("assets/leaderboard.png"),
            ),
          ),
          AnimatedPositioned(
            bottom: bottom4,
            right: right4,
            duration: Duration(milliseconds: 1200),
            curve: Curves.easeOutQuart,
            child: GestureDetector(
              onVerticalDragStart: (context) {
                setState(() {
                  _isUp = !_isUp;
                  getScoreboard();
                });
              },
              child: Icon(
                Icons.info,
                size: 70,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GameMap extends StatefulWidget {
  @override
  _GameMapState createState() => _GameMapState();
}

class _GameMapState extends State<GameMap> {
  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      myLocationButtonEnabled: true,
      initialCameraPosition: CameraPosition(
        target: LatLng(23.554079, 87.278687),
        zoom: 13,
      ),
      onMapCreated: _onMapCreated,
      myLocationEnabled: true,
      //mapType: MapType.hybrid,
      compassEnabled: true,
    );
  }

  _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}

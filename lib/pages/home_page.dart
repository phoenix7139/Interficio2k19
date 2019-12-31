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

  Map<String, dynamic> levelData = {
    "pause_bool": false,
    "map_hint": false,
    "level_no": 0,
    "title": "",
    "ques": "",
    "map_bool": false
  };

  Future getLevelData() async {
    http.Response response = await http
        .get(Uri.encodeFull("http://10.0.2.2:8000/api/getlevel/"), headers: {
      "Authorization":
          "Token 57e8b2723840343502eda398c6b5c1522ffe5e54fe26151b82518bf884419925"
    });
    levelData = json.decode(response.body);
    print(levelData);
  }

  Future submitLevelAnswer() async {}

  Future getScoreboard() async {
    http.Response response = await http
        .get(Uri.encodeFull("http://10.0.2.2:8000/api/scoreboard/"), headers: {
      "Authorization":
          "Token 57e8b2723840343502eda398c6b5c1522ffe5e54fe26151b82518bf884419925"
    });
    print(json.decode(response.body));
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

  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;

    double bottom = _isUp ? 55.0 : (deviceSize.height / 2);
    double top = _isUp
        ? (_isOpen ? deviceSize.height / 2 : (deviceSize.height - 145))
        : bottom;

    double top2 =
        _isUp ? (deviceSize.height - 35) : ((deviceSize.height) / 2) + 10;

    var bottom3 = _isUp ? deviceSize.height : ((deviceSize.height) / 2) + 10;

    var bottom4 = _isUp ? 10.0 : deviceSize.height - 80;
    var right4 = 20.0;

    return Scaffold(
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
                    _isOpen = !_isOpen;
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
                          left: 115.0,
                          child: Text(
                            levelData["title"] == null
                                ? "please wait"
                                : levelData["title"],
                            style: TextStyle(
                              color: _isOpen ? Color(0xFF0059B3) : Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          AnimatedPositioned(
            top: _isOpen
                ? deviceSize.height / 2 + 60.0
                : deviceSize.height + 5.0,
            bottom: _isOpen ? 65.0 : -5.0,
            left: 20.0,
            right: 20.0,
            duration: Duration(milliseconds: 900),
            curve: Curves.easeOutQuart,
            child: Container(
              child: Center(
                child: ScrollConfiguration(
                  behavior: MyBehavior(),
                  child: ListView(
                    children: <Widget>[
                      ListTile(
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 7, horizontal: 7),
                        title: Text(
                          levelData["ques"],
                          style: TextStyle(
                              color: _isOpen ? Color(0xFF0091CC) : Colors.white,
                              fontSize: 17,
                              fontStyle: FontStyle.italic),
                        ),
                      ),
                      ListTile(
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 7),
                        title: TextField(
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          decoration: InputDecoration(
                            suffixIcon: Icon(Icons.question_answer),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.5),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            labelText: 'answer here',
                            // filled: true,
                            // fillColor: Colors.white.withOpacity(0.2),
                          ),
                        ),
                      ),
                    ],
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
                      child: ScrollConfiguration(
                        behavior: MyBehavior(),
                        child: ListView(
                          children: <Widget>[
                            ListTile(
                              leading: Text("LATITUDE: $lat"),
                            ),
                            ListTile(
                              leading: Text("LONGITUDE: $long"),
                            ),
                            ListTile(
                              leading: Text("ACCURACY: $accuracy"),
                            )
                          ],
                        ),
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
